//
//  GWYAlertViewController.m
//  自定义AlertView
//
//  Created by 李国良 on 2016/9/22.
//


#import "GWYAlertViewController.h"
#import "GWYTextModel.h"
#import "GWYTextFiledCell.h"
#import "GWYAddressModel.h"
#import "GWYContactModel.h"
#import "STPickerArea.h"
#import "STPickerSingle.h"
#import "MBProgressHUD+YS.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define TABCEllHEIGHT 44.0
@interface GWYAlertViewController ()<UITableViewDelegate, UITableViewDataSource, STPickerAreaDelegate,STPickerSingleDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIView         * titltView;
@property (nonatomic, strong) UIButton       * cancelBtn;
@property (nonatomic, strong) UIButton       * okBtn;
@property (nonatomic, strong) UITableView    * tableView;
@property (nonatomic, strong) NSMutableArray * addressSource;
@property (nonatomic, strong) NSMutableArray * contactSource;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, copy)   NSString       * selectArea;
@property (nonatomic, copy)   NSString       * selectCarType;


@end

@implementation GWYAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitltView];
    [self setTable];
}

- (void)addTitltView {
    self.titltView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    self.titltView.backgroundColor = [UIColor orangeColor];
    self.titltView.userInteractionEnabled = YES;
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(10, 0, 70, 40);
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelClink:) forControlEvents:UIControlEventTouchUpInside];
    [self.titltView addSubview:self.cancelBtn];
    self.okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.okBtn.frame = CGRectMake(SCREENWIDTH - 80, 0, 70, 40);
    [self.okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okBtn addTarget:self action:@selector(okBtnClink:) forControlEvents:UIControlEventTouchUpInside];
    [self.titltView addSubview:self.okBtn];
    [self.view addSubview:self.titltView];
}

- (void)cancelClink:(UIButton *)cancel {
    if ([self.delegate respondsToSelector:@selector(alertViewController:cancelBtnClink:)]) {
        [self.delegate alertViewController:self cancelBtnClink:cancel];
    }
}

- (void)okBtnClink:(UIButton *)ok {
    [self getTextModel];
    if ([self.delegate respondsToSelector:@selector(alertViewController:okBtnClink:dataArray:)]) {
        [self.delegate alertViewController:self okBtnClink:ok dataArray:self.dataSource];
    }
}

- (void)setTable {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,40, SCREENWIDTH, ((self.alertType == GWYAlertViewControllerTypeContact) ? 140 : 240)) style:UITableViewStylePlain];
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma Mark ==== UITableViewDataSource ============
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.alertType == GWYAlertViewControllerTypeContact) {
        return self.contactSource.count;
    }
    return self.addressSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.alertType == GWYAlertViewControllerTypeContact) {
        return [self.contactSource[section] count];
    }
    return [self.addressSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GWYTextModel * model = (self.alertType == GWYAlertViewControllerTypeContact) ? (self.contactSource[indexPath.section][indexPath.row]) : (self.addressSource[indexPath.section][indexPath.row]);
    GWYTextFiledCell * cell = [GWYTextFiledCell textFieldWithTableView:tableView andModel:model];
    cell.content.returnKeyType = UIReturnKeyDone;
    cell.content.delegate = self;
    (self.alertType == GWYAlertViewControllerTypeContact) ? [self setAddContactPlaceholderWithCell:cell] : [self setAddAddressPlaceholderWithCell:cell];
    if (self.alertType == GWYAlertViewControllerTypeContact) {
        if ([cell.titleLabel.text isEqualToString:@"证件类型:"]) {
            cell.content.placeholder = @"请选择";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = cell.content.frame;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(contactBtnClink) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            NSString * cartitle = nil;
            if (self.editData.count) {
                GWYContactModel * model = [self.editData firstObject];
                cartitle = ([model.id_type integerValue] == 0) ? @"学生证" : (([model.id_type integerValue] == 1) ? @"身份证" : @"其他");
            }
            cell.content.text = cartitle ? (self.selectCarType.length ? self.selectCarType : cartitle) : (self.selectCarType.length ? self.selectCarType : @"");
        }

    } else {
        if ([cell.titleLabel.text isEqualToString:@"地区选择:"]) {
            cell.content.placeholder = @"请选择";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = cell.content.frame;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(BtnClink) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            cell.content.text = self.editData.count ? (self.selectArea.length ? self.selectArea : ((GWYAddressModel *)[self.editData firstObject]).area) : (self.selectArea.length ? self.selectArea : @"");
        }
    }
    return cell;
}

#pragma Mark ==== UITableViewDeleagte ==============

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TABCEllHEIGHT;
}

#pragma mark ===== 地区选择 ===== 

- (void)BtnClink {
     self.view.hidden = YES;
    [self.view endEditing:YES];
    [[[STPickerArea alloc]initWithDelegate:self]show];
}

- (void)contactBtnClink {
    self.view.hidden = YES;
    [self.view endEditing:YES];
    NSArray *arr = @[@"学生证", @"身份证",@"其他"]; //idType: 0:学生，1:身份证，2:其他
    STPickerSingle *single = [[STPickerSingle alloc]init];
    [single setArrayData:[NSMutableArray arrayWithArray:arr]];
    [single setTitle:@"请选择证件类型"];
    [single setDelegate:self];

    [single show];
}
#pragma mark ======STPickerAreaDelegate
- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    self.view.hidden = NO;
    NSString *selectedArea = [NSString stringWithFormat:@"%@%@%@",province,city, area];
    GWYTextModel *model = self.addressSource[0][3];
    model.content = selectedArea;
    self.selectArea = selectedArea;
    [self .tableView reloadData];
}

- (void)pickerAreaRemove:(STPickerArea *)pickerArea
{
    self.view.hidden = NO;
}

#pragma mark ======STPickerSingleDelegate
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    self.view.hidden = NO;
     //idType: 0:学生，1:身份证，2:其他
    self.selectCarType = selectedTitle;
    GWYTextModel *model = self.contactSource[0][1];
    model.content = selectedTitle;
    [self.tableView reloadData];
}

- (void)pickerSingleRemove:(STPickerSingle *)pickerSingle
{
    self.view.hidden = NO;
}

#pragma mark ===== UITextFieldDelegate ========

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}
#pragma mark =======  获取修改后数据
- (void)getTextModel {
    //获取Documents目录
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    if (self.alertType == GWYAlertViewControllerTypeContact ) { // 联系人
        GWYTextModel * contactModel1 = self.contactSource[0][0];
        GWYTextModel * contactModel2 = self.contactSource[0][1];
        GWYTextModel * contactModel3 = self.contactSource[0][2];
        NSString * idtype = nil;
        if ([contactModel2.content isEqualToString:@"学生证"]) {
            idtype = @"0";
        } else  if ([contactModel2.content isEqualToString:@"身份证"]){
            idtype = @"1";
        } else {
            idtype = @"2";
        }
        //还要指定存储文件的文件名称,仍然使用字符串拼接
        NSString * contactPath = [docPath stringByAppendingPathComponent:@"contactList.plist"];
        NSMutableDictionary * contactDiction = [[NSMutableDictionary alloc]initWithContentsOfFile:contactPath];
        if (self.editData.count) { // 修改联系人
            GWYContactModel * model = [self.editData firstObject];
            for (NSMutableDictionary * dic in contactDiction[@"data"]) {
                if ([model.id integerValue] == [dic[@"id"] integerValue]) {
                    [dic setValue:contactModel1.content forKey:@"name"];
                    [dic setValue:idtype forKey:@"id_type"];
                    [dic setValue:contactModel3.content forKey:@"id_number"];
                    [contactDiction setObject:contactDiction[@"data"] forKey:@"data"];
                    //写入文件
                    [contactDiction writeToFile:contactPath atomically:YES];
                    break;
                }
            }
            [MBProgressHUD showSuccess:@"修改联系人成功!"];
        } else { //增加联系人
            NSMutableDictionary * addDic = [NSMutableDictionary dictionary];
            [addDic setValue:idtype forKey:@"id_type"];
            [addDic setValue:[NSString stringWithFormat:@"%ld", [contactDiction[@"data"] count] + 1] forKey:@"id"];
            [addDic setValue:contactModel3.content forKey:@"id_number"];
            [addDic setValue:contactModel1.content forKey:@"name"];
            [addDic setValue:@"1" forKey:@"user_id"];
            [contactDiction[@"data"] insertObject:addDic atIndex:0];
            [contactDiction setObject:contactDiction[@"data"] forKey:@"data"];
            [contactDiction writeToFile:contactPath atomically:YES];
            [MBProgressHUD showSuccess:@"新增联系人成功!"];
        }
    } else {  // 收货地址
        
        GWYTextModel *addressModel1 = self.addressSource[0][0];
        GWYTextModel *addressModel2 = self.addressSource[0][1];
        GWYTextModel *addressModel3 = self.addressSource[0][2];
        GWYTextModel *addressModel4 = self.addressSource[0][3];
        GWYTextModel *addressModel5 = self.addressSource[0][4];
        
        //还要指定存储文件的文件名称,仍然使用字符串拼接
        NSString * addressPath = [docPath stringByAppendingPathComponent:@"addressList.plist"];
        NSMutableDictionary * addressDiction = [[NSMutableDictionary alloc]initWithContentsOfFile:addressPath];
        if (self.editData.count) { //修改
            GWYAddressModel * addressModel = [self.editData firstObject];
            for (NSMutableDictionary * dic in addressDiction[@"data"]) {
                if ([addressModel.id integerValue] == [dic[@"id"] integerValue]) {
                    [dic setValue:addressModel1.content forKey:@"name"];
                    [dic setValue:addressModel2.content forKey:@"phone"];
                    [dic setValue:addressModel3.content forKey:@"postcode"];
                    [dic setValue:addressModel4.content forKey:@"address"];
                    [dic setValue:addressModel5.content forKey:@"area"];
                    [addressDiction setObject:addressDiction[@"data"] forKey:@"data"];
                    //写入文件
                    [addressDiction writeToFile:addressPath atomically:YES];
                    break;
                }
            }
            [MBProgressHUD showSuccess:@"修改地址成功!"];
        } else {
            NSMutableDictionary * addDic = [NSMutableDictionary dictionary];
            [addDic setValue:addressModel1.content forKey:@"name"];
            [addDic setValue:addressModel2.content forKey:@"phone"];
            [addDic setValue:addressModel3.content forKey:@"postcode"];
            [addDic setValue:addressModel4.content forKey:@"area"];
            [addDic setValue:addressModel5.content forKey:@"address"];
            [addDic setValue:[NSString stringWithFormat:@"%ld", [addressDiction[@"data"] count] + 1] forKey:@"id"];
            [addDic setValue:@"1" forKey:@"user_id"];
            [addressDiction[@"data"] insertObject:addDic atIndex:0];
            [addressDiction setObject:addressDiction[@"data"] forKey:@"data"];
             [addressDiction writeToFile:addressPath atomically:YES];
            [MBProgressHUD showSuccess:@"新增地址成功!"];
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"finishedit" object:nil];
}

#pragma mark ==== 提示语 ========= 

- (void)setAddAddressPlaceholderWithCell:(GWYTextFiledCell *)cell
{
    
    if ([cell.titleLabel.text isEqualToString:@"收货人:"]) {
        cell.content.placeholder = @"请输入你的姓名";
    }else if ([cell.titleLabel.text isEqualToString:@"手机号码:"])
    {
        cell.content.placeholder = @"请输入手机号";
    }else if ([cell.titleLabel.text isEqualToString:@"邮政编码:"])
    {
        cell.content.placeholder = @"请输入邮政编码";
    }else if ([cell.titleLabel.text isEqualToString:@"详细地址:"])
    {
        cell.content.placeholder = @"请输入详细地址";
    }
}

- (void)setAddContactPlaceholderWithCell:(GWYTextFiledCell *)cell
{
    if ([cell.titleLabel.text isEqualToString:@"姓名:"]) {
        cell.content.placeholder = @"请输入姓名";
    }else if ([cell.titleLabel.text isEqualToString:@"证件类型:"])
    {
        cell.content.placeholder = @"请输入手机号";
    }else if ([cell.titleLabel.text isEqualToString:@"证件号码:"])
    {
        cell.content.placeholder = @"请输入证件号码";
    }else if ([cell.titleLabel.text isEqualToString:@"联系电话:"])
    {
        cell.content.placeholder = @"请输入联系电话";
    }
}

#pragma mark ====  懒加载 ===========================
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)addressSource {
    if (!_addressSource) {
        _addressSource = [NSMutableArray array];
        GWYTextModel *model1 = [GWYTextModel modelWithTextTitle:@"收货人:" andContent:(self.editData.count ? ((GWYAddressModel *)self.editData[0]).name : @"") andArray:nil];
        GWYTextModel *model2 = [GWYTextModel modelWithTextTitle:@"手机号码:" andContent:(self.editData.count ? ((GWYAddressModel *)self.editData[0]).phone : @"") andArray:nil];
        GWYTextModel *model3 = [GWYTextModel modelWithTextTitle:@"邮政编码:" andContent:(self.editData.count ? ((GWYAddressModel *)self.editData[0]).postcode : @"") andArray:nil];
        GWYTextModel *model4 = [GWYTextModel modelWithTextTitle:@"地区选择:" andContent:(self.editData.count ? ((GWYAddressModel *)self.editData[0]).area : @"") andArray:nil];
        GWYTextModel *model5 = [GWYTextModel modelWithTextTitle:@"详细地址:" andContent:(self.editData.count ? ((GWYAddressModel *)self.editData[0]).address : @"") andArray:nil];
        
        [_addressSource addObject:[NSArray arrayWithObjects:model1,model2,model3,model4,model5, nil]];
    }
    return _addressSource;
}

- (NSMutableArray *)contactSource
{
    if (!_contactSource) {
        _contactSource = [NSMutableArray array];
        GWYTextModel *model1 = [GWYTextModel modelWithTextTitle:@"姓名:" andContent:(self.editData.count ? ((GWYContactModel *)self.editData[0]).name : @"") andArray:nil];
        GWYTextModel *model2 = [GWYTextModel modelWithTextTitle:@"证件类型:" andContent:(self.editData.count ? ((GWYContactModel *)self.editData[0]).id_type : @"") andArray:nil];
        GWYTextModel *model3 = [GWYTextModel modelWithTextTitle:@"证件号码:" andContent:(self.editData.count ? ((GWYContactModel *)self.editData[0]).id_number : @"") andArray:nil];
        [_contactSource addObject:[NSArray arrayWithObjects:model1,model2,model3, nil]];
    }
    return _contactSource;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
