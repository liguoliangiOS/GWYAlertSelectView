//
//  GWYAlertSelectViewController.h
//  自定义AlertView
//
//  Created by 李国良 on 2016/9/23.
//  Copyright © 2016年 郑卓青. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditBlock)(NSMutableArray * eidtArray);
typedef void(^SelectedBlock)(NSMutableArray * selectedArray);

typedef enum {
    GWYAlertSelectViewControllerTypeContact,
    GWYAlertSelectViewControllerTypeAddress
    
}GWYAlertSelectViewControllerType;

@class GWYAlertSelectViewController;

@protocol GWYAlertSelectViewControllerDelegate <NSObject>

- (void)alertSelectView:(GWYAlertSelectViewController *)alertSelctController clinkAddBtn:(UIButton *)addButton;
- (void)alertSelectView:(GWYAlertSelectViewController *)alertSelctController clinkCancelBtn:(UIButton *)cancelButton;
- (void)alertSelectView:(GWYAlertSelectViewController *)alertSelctController clinkOkBtn:(UIButton *)okButton;

@end

@interface GWYAlertSelectViewController : UIViewController

@property (nonatomic, weak) id<GWYAlertSelectViewControllerDelegate>delegate;
@property (nonatomic, copy) EditBlock editBlock;
@property (nonatomic, copy) SelectedBlock selectedBlock;
@property (nonatomic, assign) GWYAlertSelectViewControllerType alertSelectType;

- (void)alertSelectViewEditBlock:(EditBlock)block;
- (void)alertSelectViewSelectedBlock:(SelectedBlock)block;
@end
