//
//  GWYAddressModel.m
//  GenWoYou
//
//  Created by 智捷科技 on 16/5/24.
//  Copyright © 2016年 智捷科技. All rights reserved.
//

#import "GWYAddressModel.h"

@implementation GWYAddressModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (void)requestGetPersonalAddressDataWithView:(UIView *)view  Complection:(ModelRequestFinished)complection {
    //获取Documents目录
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //还要指定存储文件的文件名称,仍然使用字符串拼接
    NSString *addressPath = [docPath stringByAppendingPathComponent:@"addressList.plist"];
    NSMutableDictionary * addressDiction = [[NSMutableDictionary alloc]initWithContentsOfFile:addressPath];
    NSMutableArray * dataSource = [NSMutableArray array];
    for (NSDictionary * dic in addressDiction[@"data"]) {
        GWYAddressModel * model = [[GWYAddressModel alloc] initWithDictionary:dic error:nil];
        [dataSource addObject:model];
    }
    complection(dataSource);
}

@end
