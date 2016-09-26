//
//  GWYTextModel.h
//  GenWoYou
//
//  Created by 智捷科技 on 16/4/15.
//  Copyright © 2016年 智捷科技. All rights reserved.
//

#import "JSONModel.h"

@interface GWYTextModel : JSONModel
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *content; // 内容


+ (GWYTextModel *)modelWithTextTitle:(NSString *)title andContent:(NSString *)content andArray:(NSMutableArray *)manArray;
@end
