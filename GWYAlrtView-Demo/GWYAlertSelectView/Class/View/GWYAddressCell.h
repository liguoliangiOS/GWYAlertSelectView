//
//  GWYPersonalAddressCell.h
//  GenWoYou
//
//  Created by 智捷科技 on 16/4/14.
//  Copyright © 2016年 智捷科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GWYAddressModel;
@class GWYAddressCell;

@protocol GWYAddressCellDelegate <NSObject>

- (void)personalAddressCell:(GWYAddressCell *)cell editClink:(UIButton *)btn;

@end


@interface GWYAddressCell : UITableViewCell

@property (nonatomic, strong) GWYAddressModel * addressModel;
@property (nonatomic, strong) UIButton        * selectButton;
@property (nonatomic, assign) BOOL isSelcet;
@property (nonatomic, weak) id<GWYAddressCellDelegate> delegate;

+ (CGFloat)getPersonalAddressCellHightWithModel:(GWYAddressModel *)model;
+ (instancetype)cellWithAddressTableView:(UITableView *)tableView model:(GWYAddressModel *)model;

@end
