//
//  GWYAddressModel.h
//  GenWoYou
//
//  Created by 智捷科技 on 16/5/24.
//  Copyright © 2016年 智捷科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSONModel.h"

typedef void(^ModelRequestFinished)(id results);

@interface GWYAddressModel : JSONModel


@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * area;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * postcode;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * user_id;

/**
 *  获取所有收货地址信息
 *
 *  @param complection 回调
 */
+ (void)requestGetPersonalAddressDataWithView:(UIView *)view  Complection:(ModelRequestFinished)complection;

@end
