//
//  ViewController.m
//  GWYAlrtView-Demo
//
//  Created by 李国良 on 2016/9/26.
//  Copyright © 2016年 李国良. All rights reserved.
//  欢迎各位提宝贵的意见给我  185226139 感谢大家的支持

#import "ViewController.h"
#import "GWYAlertSelectView.h"
#import "GWYAddressModel.h"
#import "GWYContactModel.h"
#import "GWYAddressCell.h"
#import "GWYContactCell.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GWYAlertSelectView * alertView;
@property (nonatomic, strong) UITableView        * tableView;
@property (nonatomic, strong) NSMutableArray     * dataSource; //回调的数据
@property (nonatomic, strong) NSMutableArray     * addressSource;
@property (nonatomic, strong) NSMutableArray     * contactSource;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self addData];
    [self setTable];
}

- (void)setNav {
    self.title = @"alertSelctView 示例";
    self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
}

- (void)setTable {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

# pragma mrk ====   UITableViewDataSource =====

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? self.contactSource.count : self.addressSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GWYContactModel * model = (GWYContactModel *)self.contactSource[indexPath.row];
        GWYContactCell * cell = [GWYContactCell cellWithContactTableView:tableView model:model];
        return cell;
    }
    GWYAddressModel * adressModel = (GWYAddressModel *)self.addressSource[indexPath.row];
    GWYAddressCell * cell = [GWYAddressCell cellWithAddressTableView:tableView model:adressModel];
    return cell;
}

#pragma mark === UITableViewDelegate =====

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [GWYContactCell getPersonalContactCellHight];
    }
    GWYAddressModel * adressModel = (GWYAddressModel *)self.addressSource[indexPath.row];
    
    return [GWYAddressCell getPersonalAddressCellHightWithModel:adressModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return (section == 0) ? [self titlleViewWithTitle:@"选择联系人" btnTag:1] : [self titlleViewWithTitle:@"选择收货地址" btnTag:2];
}

- (UIView *)titlleViewWithTitle:(NSString *)title btnTag:(NSInteger)tag {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    view.backgroundColor = [UIColor grayColor];
    UIButton * titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBtn setTitle:title forState:UIControlStateNormal];
    titleBtn.frame = view.frame;
    [titleBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    titleBtn.tag = tag;
    [titleBtn addTarget:self action:@selector(selectPersonalContact:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:titleBtn];
    return view;
}

//==================================================== 开始使用 ===========================================================================================

/*(1) 按照下面的方法使用即可
 *(2) 可以自行更改cell的布局
 *(3) 新增和修改都是在GWYAlertViewContronller里
 *(4) 新增和修改的数据 处理是在GWYAlertViewContronller里的getTextModel 方法里， 可以对数据进行处理
 *(5) model里面的字段也可以根据自身的项目进行修改
 *(6) GWYAddAlertViewTypeGetContacts 选择联系人     GWYAddAlertViewTypeGetAddress 选择联系地址
 *(7) self.alertView alertViewSelectedBlock:<#^(NSMutableArray *alertViewData)block#> 这里就是得到选择的数据
 *(8) GWYAlertViewContronller里自行进行对电话号码等的判断
 */

- (void)selectPersonalContact:(UIButton *)button {
    
    self.alertView = [[GWYAlertSelectView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.alertView.addAlertViewType = (button.tag == 1) ? GWYAlertSelectViewTypeGetContacts : GWYAlertSelectViewTypeGetAddress;
    //block 选择的回调数据
    __block typeof(self) weakSelf = self;
    [self.alertView alertViewSelectedBlock:^(NSMutableArray *alertViewData) {
        [weakSelf.dataSource addObjectsFromArray:alertViewData];
        if (button.tag == 1) {
            [weakSelf.contactSource addObjectsFromArray:alertViewData];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationTop ];
        } else {
            [weakSelf.addressSource removeAllObjects];
            [weakSelf.addressSource addObjectsFromArray:alertViewData];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationTop ];
        }
    }];
    [self.alertView alertSelectViewshow];

}
//================================================ 结束  ================================================================================================
#pragma mark ====  这个只是为了数据的操作， 正式使用当中需要移除 ======

- (void)addData {
    
    //增加收货地址
    NSMutableArray * dataArray = [NSMutableArray array];
    for (NSInteger i = 1; i < 6; i++) {
        NSMutableDictionary * dataDic = [NSMutableDictionary dictionary];
        [dataDic setValue:@(i) forKey:@"id"];
        [dataDic setValue:[NSString stringWithFormat:@"麻雀%ld", i] forKey:@"name"];
        [dataDic setValue:[NSString stringWithFormat:@"1388888888%ld", i] forKey:@"phone"];
        [dataDic setValue:[NSString stringWithFormat:@"674110"] forKey:@"postcode"];
        [dataDic setValue:@"云南省丽江市古城区" forKey:@"area"];
        [dataDic setValue:[NSString stringWithFormat:@"福慧路%ld号",444+ i] forKey:@"address"];
        [dataDic setValue:@1 forKey:@"user_id"];
        
        [dataArray addObject:dataDic];
    }
    
    //增加联系人数据
    NSMutableArray * cantactArray = [NSMutableArray array];
    for (NSInteger j = 1; j < 6; j++) {
        NSMutableDictionary * dataDic = [NSMutableDictionary dictionary];
        NSString * idNumber = [NSString stringWithFormat:@"53322119900213423%ld", j];
        [dataDic setValue:idNumber forKey:@"id_number"];
        [dataDic setValue:@(j) forKey:@"id"];
        [dataDic setValue:[NSString stringWithFormat:@"麻雀%ld", j] forKey:@"name"];
        [dataDic setValue:@"1" forKey:@"id_type"];
        [dataDic setValue:@1 forKey:@"user_id"];
        [cantactArray addObject:dataDic];
    }
    //[[NSUserDefaults standardUserDefaults]setObject:dataArray forKey:@"data"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    //获取本地沙盒路径
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString * documentsPath = [path objectAtIndex:0];
    NSString * plistPath = [documentsPath stringByAppendingPathComponent:@"addressList.plist"];
    NSString * contactplistPath = [documentsPath stringByAppendingPathComponent:@"contactList.plist"];
    NSMutableDictionary * addressDic = [[NSMutableDictionary alloc ] init];
    NSMutableDictionary * contactDic = [[NSMutableDictionary alloc ] init];
    //设置属性值
    [addressDic setObject:dataArray forKey:@"data"];
    [contactDic setObject:cantactArray forKey:@"data"];
    //写入文件
    [addressDic writeToFile:plistPath atomically:YES];
    [contactDic writeToFile:contactplistPath atomically:YES];
    
}

#pragma mark ==== 懒加载 ======

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

@end
