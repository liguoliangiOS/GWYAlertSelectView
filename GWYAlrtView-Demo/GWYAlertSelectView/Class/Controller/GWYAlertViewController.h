//
//  GWYAlertViewController.h
//  自定义AlertView
//
//  Created by 李国良 on 2016/9/22.
//  Copyright © 2016年 郑卓青. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GWYAlertViewControllerTypeContact,
    GWYAlertViewControllerTypeAddress,
    
}GWYAlertViewControllerType;

@class GWYAlertViewController;

@protocol GWYAlertViewControllerDelegate <NSObject>

- (void)alertViewController:(GWYAlertViewController *)alertController cancelBtnClink:(UIButton *)cancelButton;
- (void)alertViewController:(GWYAlertViewController *)alertController okBtnClink:(UIButton *)okButton dataArray:(NSMutableArray *)data;

@end

@interface GWYAlertViewController : UIViewController

@property (nonatomic, weak) id<GWYAlertViewControllerDelegate>delegate;
@property (nonatomic, strong) NSMutableArray * editData;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) GWYAlertViewControllerType alertType;

@end
