//
//  GWYAlertSelectViewController.m
//  自定义AlertView
//
//  Created by 李国良 on 2016/9/23.
//


#import "GWYAlertSelectViewController.h"
#import "GWYPersonalAddressCell.h"
#import "GWYPersonalContactCell.h"
#import "GWYAddressModel.h"
#import "GWYContactModel.h"
#import "GWYTextSize.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface GWYAlertSelectViewController ()<UITableViewDelegate, UITableViewDataSource, GWYPersonalContactCellDelegate, GWYPersonalAddressCellDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * addressSource;
@property (nonatomic, strong) NSMutableArray * contactSource;
@property (nonatomic, strong) NSMutableArray * addressSelectSource;
@property (nonatomic, strong) NSMutableArray * contactSelectSource;
@property (nonatomic, strong) UIView * titltView;
@property (nonatomic, strong) UIButton * addBtn;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * okBtn;
@property (nonatomic, strong) NSMutableArray * selectArray; //记录选择客人名单的数组，主要为了解决cell的复用

@end

@implementation GWYAlertSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self addTitltView];
    [self setTable];
    [self getData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedit) name:@"finishedit"object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"finishedit" object:nil];
}

- (void)finishedit {
    [self getData];
    [self.tableView reloadData];
}

- (void)setTable {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,40, SCREENWIDTH, SCREENHEIGHT /2 - 40) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}

#pragma mark ==== 获取数据 ======

- (void)getData {
    if (self.alertSelectType == GWYAlertSelectViewControllerTypeContact) {
        [GWYContactModel requestGetPersonalContactDataWithView:self.view Complection:^(id results) {
            [self.contactSource removeAllObjects];
            [self.contactSource addObjectsFromArray:results];
            [self.tableView reloadData];
        }];
    }
    if (self.alertSelectType == GWYAlertSelectViewControllerTypeAddress){
        [GWYAddressModel requestGetPersonalAddressDataWithView:self.view Complection:^(id results) {
            [self.addressSource removeAllObjects];
            [self.addressSource addObjectsFromArray:results];
            [self.tableView reloadData];
        }];
    }
}

- (void)addTitltView {
    self.titltView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    self.titltView.backgroundColor = [UIColor orangeColor];
    self.titltView.userInteractionEnabled = YES;
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame = CGRectMake(SCREENWIDTH / 2 - 50, 0, 100, 40);
    [self.addBtn setTitle:@"新增" forState:UIControlStateNormal];
    [self.addBtn setImage:[GWYTextSize changeImageSize:@"alert_add" scale:1.3] forState:UIControlStateNormal];
    [self.addBtn setImage:[GWYTextSize changeImageSize:@"alert_add" scale:1.3] forState:UIControlStateHighlighted];
    [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addbtnClink:) forControlEvents:UIControlEventTouchUpInside];
    [self.titltView addSubview: self.addBtn];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(10, 0, 70, 40);
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelClink:) forControlEvents:UIControlEventTouchUpInside];
    [self.titltView addSubview:self.cancelBtn];
    
    if (self.alertSelectType == GWYAlertSelectViewControllerTypeContact) {
        self.okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.okBtn.frame = CGRectMake(SCREENWIDTH - 80, 0, 70, 40);
        [self.okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.okBtn addTarget:self action:@selector(okBtnClink:) forControlEvents:UIControlEventTouchUpInside];
        [self.titltView addSubview:self.okBtn];
    }
    [self.view addSubview:self.titltView];
}

- (void)addbtnClink:(UIButton *)addButton {
    if ([self.delegate respondsToSelector:@selector(alertSelectView:clinkAddBtn:)]) {
        [self.delegate alertSelectView:self clinkAddBtn:addButton];
    }
}

- (void)cancelClink:(UIButton *)cancelButton {
    if ([self.delegate respondsToSelector:@selector(alertSelectView:clinkCancelBtn:)]) {
        [self.delegate alertSelectView:self clinkCancelBtn:cancelButton];
    }
}

- (void)okBtnClink:(UIButton *)okButton {
    self.selectedBlock(self.contactSelectSource);
    if ([self.delegate respondsToSelector:@selector(alertSelectView:clinkOkBtn:)]) {
        [self.delegate alertSelectView:self clinkOkBtn:okButton];
    }
}

#pragma Mark ==== UITableViewDataSource ============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.alertSelectType == GWYAlertSelectViewControllerTypeContact) {
        return self.contactSource.count;
    }
    if (self.alertSelectType == GWYAlertSelectViewControllerTypeAddress) {
        return self.addressSource.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.alertSelectType == GWYAlertSelectViewControllerTypeContact) {
        GWYContactModel * model = self.contactSource[indexPath.row];
        GWYPersonalContactCell * cell = [GWYPersonalContactCell cellWithContactTableView:tableView model:model];
        //解决复用问题
        cell.selectButton.tag = 100 + indexPath.row;
        cell.selectButton.selected = NO;
        cell.delegate = self;
        if (self.selectArray.count) {
            for (NSIndexPath * index in self.selectArray) {
                if (indexPath == index) {
                    cell.selectButton.selected = YES;
                }
            }

        }
        return cell;
    }
    if (self.alertSelectType == GWYAlertSelectViewControllerTypeAddress){
        GWYAddressModel * model = self.addressSource[indexPath.row];
        GWYPersonalAddressCell * cell = [GWYPersonalAddressCell cellWithAddressTableView:tableView model:model];
        cell.delegate = self;
        return cell;
    }
    return nil;
}
#pragma Mark ==== UITableViewDeleagte ==============

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.alertSelectType == GWYAlertSelectViewControllerTypeContact) {
        return [GWYPersonalContactCell getPersonalContactCellHight];
    }
    GWYAddressModel * model = self.addressSource[indexPath.row];
    return [GWYPersonalAddressCell getPersonalAddressCellHightWithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.alertSelectType == GWYAlertSelectViewControllerTypeContact) {
        GWYContactModel * model = self.contactSource[indexPath.row];
        GWYPersonalContactCell *cell = (GWYPersonalContactCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.selectButton.selected = YES;
        [self.selectArray addObject:indexPath];
        if (self.contactSelectSource.count > 1) {
            for (GWYContactModel *contantModel in self.contactSelectSource) {
                NSUInteger index = [self.contactSelectSource indexOfObject:contantModel];
                if ([contantModel.id integerValue]  == [model.id integerValue]) {
                    cell.selectButton.selected = NO;
                   [self.selectArray removeObject:indexPath];
                    [self.contactSelectSource removeObject:contantModel];
                    break;
                }else {
                    if (index == self.contactSelectSource.count - 1) {
                        cell.selectButton.selected = YES;
                        [self.selectArray addObject:indexPath];
                        [self.contactSelectSource addObject:model];
                        break;
                    }
                }
            }
        }else
        {
            [self.contactSelectSource addObject:model];
        }

    } else {
        GWYAddressModel * model = self.addressSource[indexPath.row];
        [self.addressSelectSource addObject: model];
        self.selectedBlock(self.addressSelectSource);
    }
}

#pragma mark ==== Block ======

- (void)alertSelectViewEditBlock:(EditBlock)block {
    self.editBlock = block;
}

- (void)alertSelectViewSelectedBlock:(SelectedBlock)block {
    self.selectedBlock = block;
}
#pragma mark ==== GWYPersonalAddressCellDelegate======

- (void)personalAddressCell:(GWYPersonalAddressCell *)cell editClink:(UIButton *)btn {
    NSMutableArray * dataArray = [NSMutableArray arrayWithObject:cell.addressModel];
    self.editBlock(dataArray);
    NSLog(@"编辑 收货地址 - %@",cell.addressModel);
}

#pragma mark ==== GWYPersonalContactCellDelegate======

- (void)personalcontactCell:(GWYPersonalContactCell *)cell editClink:(UIButton *)btn {
    NSMutableArray * dataArray = [NSMutableArray arrayWithObject:cell.contactModel];
    self.editBlock(dataArray);
    NSLog(@"编辑 联系人-- %@", cell.contactModel);
}

#pragma mark ==== 懒加载 ====

- (NSMutableArray *)addressSource {
    if (!_addressSource) {
        _addressSource = [NSMutableArray array];
    }
    return _addressSource;
}

- (NSMutableArray *)contactSource {
    if (!_contactSource) {
        _contactSource = [NSMutableArray array];
    }
    return _contactSource;
}

- (NSMutableArray *)contactSelectSource {
    if (!_contactSelectSource) {
        _contactSelectSource = [NSMutableArray array];
    }
    return _contactSelectSource;
}

- (NSMutableArray *)addressSelectSource {
    if (!_addressSelectSource) {
        _addressSelectSource = [NSMutableArray array];
    }
    return _addressSelectSource;
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
