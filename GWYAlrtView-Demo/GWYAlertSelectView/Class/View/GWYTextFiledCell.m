//
//  GWYTextFiledCell.m
//  GenWoYou
//
//  Created by 智捷科技 on 16/4/15.
//  Copyright © 2016年 智捷科技. All rights reserved.
//

#import "GWYTextFiledCell.h"
#import "GWYTextModel.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
@implementation GWYTextFiledCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpTextCell];
        [self setTextCellFrame];
    }
    return self;
}

- (void)setUpTextCell {
    self.cellView = [[UIView alloc] init];
    self.cellView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.cellView];
    /** 内容 */
    self.content = [[UITextField alloc] init];
    self.content.borderStyle = UITextBorderStyleRoundedRect;
    self.content.font = [UIFont systemFontOfSize:14];
    self.content.backgroundColor = [UIColor whiteColor];
    [self.cellView addSubview:self.content];
    /** 标题 */
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.cellView addSubview:self.titleLabel];
}

- (void)setTextCellFrame {
    CGFloat  titleLabelX = 10;
    CGFloat  titleLabelY = 10;
    CGFloat  titleLabelW = 65;
    CGFloat  titleLabelH = 30;
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    self.content.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 10, 10, SCREENWIDTH - CGRectGetMaxX(self.titleLabel.frame)-2 * 10, titleLabelH);
    self.cellView.frame = CGRectMake(0, 0, SCREENWIDTH, CGRectGetMaxY(self.titleLabel.frame) + 10);
}

- (void)setModel:(GWYTextModel *)model {
    _model = model;
    
    [self.titleLabel setText:model.title];
    [self.content setText:model.content.length ? model.content : @""];
    [self.content setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.content addTarget:self action:@selector(saveContent) forControlEvents:UIControlEventEditingChanged];
}

- (void)saveContent {
    self.model.content = self.content.text;
}

+ (GWYTextFiledCell *)textFieldWithTableView:(UITableView *)tableView andModel:(GWYTextModel *)model {
    static NSString *ID = @"textFieldIdentifier";
    
    GWYTextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
       tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[GWYTextFiledCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.model = model;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
