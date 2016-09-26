//
//  GWYTextModel.m
//  GenWoYou
//
//  Created by 智捷科技 on 16/4/15.
//  Copyright © 2016年 智捷科技. All rights reserved.
//

#import "GWYTextModel.h"

@implementation GWYTextModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (GWYTextModel *)modelWithTextTitle:(NSString *)title andContent:(NSString *)content andArray:(NSMutableArray *)manArray
{
    GWYTextModel *model = [[GWYTextModel alloc] init];
    model.title = title;
    model.content = content;
    return model;
}

@end
