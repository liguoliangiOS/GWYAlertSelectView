//
//  GWYTextFiledCell.h
//  GenWoYou
//
//  Created by 智捷科技 on 16/4/15.
//  Copyright © 2016年 智捷科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GWYTextModel;
@interface GWYTextFiledCell : UITableViewCell
/** 内容 */
@property (nonatomic, strong) UITextField *content;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** view */
@property (nonatomic, strong) UIView *cellView;

@property (nonatomic, strong) GWYTextModel *model;
+ (GWYTextFiledCell *)textFieldWithTableView:(UITableView *)tableView andModel:(GWYTextModel *)model;
@end
