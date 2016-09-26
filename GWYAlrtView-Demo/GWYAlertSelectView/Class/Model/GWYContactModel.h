//
//  GWYContactModel.h
//  GenWoYou
//
//  Created by 智捷科技 on 16/5/24.
//  Copyright © 2016年 智捷科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSONModel.h"

typedef void(^ModelRequestFinished)(id results);

@interface GWYContactModel : JSONModel

/** 证件号码 */
@property (nonatomic, copy) NSString * id_number;
/** 证件类型 ：//idType: 0:学生，1:身份证，2:其他*/
@property (nonatomic, copy) NSString * id_type;
/** 用户名称 */
@property (nonatomic, copy) NSString * name;
/** 联系人ID */
@property (nonatomic, copy) NSString * id;

@property (nonatomic, copy) NSString * user_id;

/**
 *  获取所有联系人信息
 *
 *  @param complection 回调
 */
+ (void)requestGetPersonalContactDataWithView:(UIView *)view Complection:(ModelRequestFinished)complection;
@end
