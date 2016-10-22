//
//  GWYPersonalContactCell.h
//  GenWoYou
//
//  Created by 智捷科技 on 16/4/14.
//  Copyright © 2016年 智捷科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWYContactModel;
@class GWYContactCell;

@protocol GWYContactCellDelegate <NSObject>

- (void)personalcontactCell:(GWYContactCell *)cell editClink:(UIButton *)btn;

@end

@interface GWYContactCell : UITableViewCell

@property (nonatomic, strong) GWYContactModel * contactModel;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, assign) BOOL isSelcet;
@property (nonatomic, weak) id<GWYContactCellDelegate> delegate;

+ (CGFloat)getPersonalContactCellHight;
+ (instancetype)cellWithContactTableView:(UITableView *)tableView model:(GWYContactModel *)contactModel;

@end
