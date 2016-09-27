# GWYAlertSelectView

1. 按照下面的方法使用即可
2. 可以自行更改cell的布局
3. 新增和修改都是在GWYAlertViewContronller里
4. 新增和修改的数据 处理是在GWYAlertViewContronller里的getTextModel 方法里， 可以对数据进行处理
5. model里面的字段也可以根据自身的项目进行修改
6. GWYAddAlertViewTypeGetContacts 选择联系人     GWYAddAlertViewTypeGetAddress 选择联系地址
7. self.alertView alertViewSelectedBlock:<#^(NSMutableArray *alertViewData)block#> 这里就是得到选择的数据
9. GWYAlertViewContronller里自行进行对电话号码等的判断

```
self.alertView = [[GWYAlertSelectView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
self.alertView.addAlertViewType = (button.tag == 1) ? GWYAlertSelectViewTypeGetContacts : GWYAlertSelectViewTypeGetAddress;
//block 选择的回调数据
__block typeof(self) weakSelf = self;
[self.alertView alertViewSelectedBlock:^(NSMutableArray *alertViewData) {
[weakSelf.dataSource addObjectsFromArray:alertViewData];
    // your code
}
}];
[self.alertView alertSelectViewshow];

```
