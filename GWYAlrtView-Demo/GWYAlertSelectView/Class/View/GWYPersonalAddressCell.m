//
//  GWYPersonalAddressCell.m
//  GenWoYou
//
//  Created by 智捷科技 on 16/4/14.
//  Copyright © 2016年 智捷科技. All rights reserved.
//

#import "GWYPersonalAddressCell.h"
#import "GWYAddressModel.h"
#import "GWYTextSize.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define GWYTextFont(a) [UIFont systemFontOfSize:a]
#define GWYCELLBorderW 10

@interface GWYPersonalAddressCell ()

/** 姓名 */
@property (nonatomic, strong) UILabel  * addressName;
/** 手机号 */
@property (nonatomic, strong) UILabel  * addressPhone;
/** 地址*/
@property (nonatomic, strong) UILabel  * address;
/** view */
@property (nonatomic, strong) UIView   * addressView;
@property (nonatomic, strong) UIButton * editButton;


@end

@implementation GWYPersonalAddressCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.userInteractionEnabled = YES;
        [self setUpLabel];
    }
    return self;
}

- (void)setUpLabel {
    
    self.addressView = [[UIView alloc] init];
    self.addressView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.addressView];
    
    
    self.addressName = [[UILabel alloc] init];
    self.addressName.font = GWYTextFont(16);
    [self.addressView addSubview:self.addressName];
    
    
    self.addressPhone = [[UILabel alloc] init];
    self.addressPhone.font = GWYTextFont(13);
    [self.addressView addSubview:self.addressPhone];
    
    self.address = [[UILabel alloc] init];
    self.address.font = GWYTextFont(13);
    self.address.numberOfLines = 0;
    [self.addressView addSubview:self.address];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editButton setImage:[UIImage imageNamed:@"edit_l"] forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(editBtnclink:) forControlEvents:UIControlEventTouchUpInside];
    [self.addressView addSubview:self.editButton];
}

- (void)editBtnclink:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(personalAddressCell:editClink:)]) {
        [self.delegate personalAddressCell:self editClink:btn];
    }
}

- (void)setAddressModel:(GWYAddressModel *)addressModel {
    _addressModel = addressModel;
    
    CGFloat addressNameX = GWYCELLBorderW;
    CGFloat addressMax = SCREENWIDTH - 40;
    CGFloat addressNameY = GWYCELLBorderW;
    CGSize addressNameSize = [GWYTextSize sizeWithText:addressModel.name font:GWYTextFont(16) maxW:0];
    self.addressName.frame = CGRectMake(addressNameX, addressNameY, addressNameSize.width, addressNameSize.height);
    self.addressName.text = addressModel.name;
    
    self.addressPhone.frame = CGRectMake(CGRectGetMaxX(self.addressName.frame) + GWYCELLBorderW, GWYCELLBorderW, SCREENWIDTH - CGRectGetMaxX(self.addressName.frame) - GWYCELLBorderW, addressNameSize.height);
    self.addressPhone.text = addressModel.phone;
    
    NSString * address = [NSString stringWithFormat:@"%@%@(邮编%@)", addressModel.area, addressModel.address, addressModel.postcode];
    CGSize addressSize = [GWYTextSize sizeWithText:address font:GWYTextFont(13) maxW:addressMax];
    self.address.text = address;
    self.address.frame = CGRectMake(addressNameX, CGRectGetMaxY(self.addressName.frame)+ GWYCELLBorderW, addressSize.width, addressSize.height);
    self.addressView.frame = CGRectMake(0, 0, SCREENWIDTH, CGRectGetMaxY(self.address.frame));
    self.editButton.frame = CGRectMake(SCREENWIDTH - 30, CGRectGetMidY(self.addressView.frame)- 10, 20, 20);
}

+ (CGFloat)getPersonalAddressCellHightWithModel:(GWYAddressModel *)model {
    CGFloat addressMax = SCREENWIDTH - 4 * GWYCELLBorderW;
    NSString * address = [NSString stringWithFormat:@"%@%@(邮编%@)", model.area, model.address, model.postcode];
    CGSize addressNameSize = [GWYTextSize sizeWithText:model.name font:GWYTextFont(16) maxW:0];
    CGSize addressSize = [GWYTextSize sizeWithText:address font:GWYTextFont(13) maxW:addressMax];
    return (3 * GWYCELLBorderW + addressNameSize.height + addressSize.height);
}

+ (instancetype)cellWithAddressTableView:(UITableView *)tableView model:(GWYAddressModel *)model {
    static NSString *ID = @"addressIdentifier";
    GWYPersonalAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[GWYPersonalAddressCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];  
    }
    cell.addressModel = model;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
