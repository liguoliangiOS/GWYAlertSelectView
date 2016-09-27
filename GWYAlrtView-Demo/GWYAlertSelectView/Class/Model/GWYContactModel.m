//
//  GWYContactModel.m
//  GenWoYou
//
//  Created by 智捷科技 on 16/5/24.
//  Copyright © 2016年 智捷科技. All rights reserved.
//============================================================================
//  欢迎各位提宝贵的意见给我  185226139 感谢大家的支持
// https://github.com/liguoliangiOS/GWYAlertSelectView.git
//=============================================================================

#import "GWYContactModel.h"

@implementation GWYContactModel


+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (void)requestGetPersonalContactDataWithView:(UIView *)view Complection:(ModelRequestFinished)complection {
    
    //获取Documents目录
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //还要指定存储文件的文件名称,仍然使用字符串拼接
    NSString * contactPath = [docPath stringByAppendingPathComponent:@"contactList.plist"];
    NSMutableDictionary * contactDiction = [[NSMutableDictionary alloc]initWithContentsOfFile:contactPath];
    NSMutableArray * dataSource = [NSMutableArray array];
    for (NSDictionary * dic in contactDiction[@"data"]) {
        GWYContactModel * model = [[GWYContactModel alloc] initWithDictionary:dic error:nil];
        [dataSource addObject:model];
    }
    complection(dataSource);
}

@end
