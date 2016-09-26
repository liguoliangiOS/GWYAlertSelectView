//
//  GWYPersonalContactCell.m
//  GenWoYou
//
//  Created by 智捷科技 on 16/4/14.
//  Copyright © 2016年 智捷科技. All rights reserved.
//

#import "GWYPersonalContactCell.h"
#import "GWYContactModel.h"
#import "GWYTextSize.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define GWYTextFont(a) [UIFont systemFontOfSize:a]
#define GWYCELLBorderW 10


@interface GWYPersonalContactCell ()
/** 姓名 */
@property (nonatomic, strong) UILabel         * nameLabel;
/** 身份证*/
@property (nonatomic, strong) UILabel         * IDLabel;
/** 证件类型*/
@property (nonatomic, strong) UILabel         * IDKind;
/** view */
@property (nonatomic, strong) UIView          * contactView;
@property (nonatomic, strong) UIButton        * editButton;

@end

@implementation GWYPersonalContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpLabel];
    }
    return self;
}

- (void)setUpLabel {
    self.contactView = [[UIView alloc] init];
    self.contactView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.contactView];
  
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = GWYTextFont(16);
    [self.contactView addSubview:self.nameLabel];
    
    self.IDKind = [[UILabel alloc] init];
    self.IDKind.font = GWYTextFont(13);
    [self.contactView addSubview:self.IDKind];
    
    self.IDLabel = [[UILabel alloc] init];
    self.IDLabel.font = GWYTextFont(13);
    [self.contactView addSubview:self.IDLabel];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editButton setImage:[UIImage imageNamed:@"edit_l"] forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(editBtnclink:) forControlEvents:UIControlEventTouchUpInside];
    [self.contactView addSubview:self.editButton];
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"select_l"] forState:UIControlStateSelected];
    [self.contactView addSubview:self.selectButton];
}

- (void)editBtnclink:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(personalcontactCell:editClink:)]) {
        [self.delegate personalcontactCell:self editClink:btn];
    }
}

- (void)setContactModel:(GWYContactModel *)contactModel {
    
    _contactModel = contactModel;
    CGFloat nameLabelX = 4 * GWYCELLBorderW;
    CGFloat nameLabelY = GWYCELLBorderW;
    CGFloat nameLabelW = SCREENWIDTH - 2 * GWYCELLBorderW;
    CGFloat nameLabelH = 2 * GWYCELLBorderW;
  
   
    self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
    self.nameLabel.text = contactModel.name;
    
    self.IDKind.frame = CGRectMake(nameLabelX, CGRectGetMaxY(self.nameLabel.frame)+ GWYCELLBorderW, nameLabelW, nameLabelH);
    //idType: 0:学生，1:身份证，2:其他
    if ([contactModel.id_type integerValue] == 0) {
        self.IDKind.text = @"证件类型:  学生证";
    } else if ([contactModel.id_type integerValue] == 1) {
        self.IDKind.text = @"证件类型:  身份证";
    } else {
        self.IDKind.text = @"证件类型:  其他";
    }
    self.IDLabel.frame = CGRectMake(nameLabelX, CGRectGetMaxY(self.IDKind.frame)+ GWYCELLBorderW, nameLabelW, nameLabelH);
    self.IDLabel.text = [NSString stringWithFormat:@"证件号:  %@", contactModel.id_number];
    
    self.contactView.frame = CGRectMake(0, 0, SCREENWIDTH, CGRectGetMaxY(self.IDLabel.frame) + GWYCELLBorderW);
    
    self.editButton.frame = CGRectMake(SCREENWIDTH - 3 * GWYCELLBorderW, CGRectGetMidY(self.contactView.frame)- GWYCELLBorderW, 2 * GWYCELLBorderW, 2 * GWYCELLBorderW);
    
    self.selectButton.frame = CGRectMake(GWYCELLBorderW,CGRectGetMidY(self.contactView.frame)- GWYCELLBorderW, 2 * GWYCELLBorderW, 2 * GWYCELLBorderW);

}

+ (CGFloat)getPersonalContactCellHight {
    return 10 * GWYCELLBorderW;
}


+ (instancetype)cellWithContactTableView:(UITableView *)tableView model:(GWYContactModel *)contactModel {
    static NSString *ID = @"contactIdentifier";
    GWYPersonalContactCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[GWYPersonalContactCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.contactModel = contactModel;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
