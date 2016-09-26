//
//  GWYAlertSelectView.h
//  GWYAlrtView-Demo
//
//  Created by 李国良 on 2016/9/26.
//  Copyright © 2016年 李国良. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^alertViewSelectedBlock)(NSMutableArray * alertViewData);
typedef enum {
    
    GWYAlertSelectViewTypeGetContacts, //联系人
    GWYAlertSelectViewTypeGetAddress // 收货地址
    
}GWYAlertSelectViewType;

@interface GWYAlertSelectView : UIView

@property (nonatomic, assign) GWYAlertSelectViewType addAlertViewType;
@property (nonatomic, copy) alertViewSelectedBlock block;

- (void)alertSelectViewshow;
- (void)alertSelectViewClose;
- (void)alertViewSelectedBlock:(alertViewSelectedBlock)block;  // 回调数据

@end
