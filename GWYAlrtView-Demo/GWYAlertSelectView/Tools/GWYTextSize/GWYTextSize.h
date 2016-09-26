//
//  GWYTextSize.h
//  GenWoYou
//
//  Created by 智捷科技 on 16/3/23.
//  Copyright © 2016年 智捷科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GWYTextSize : NSObject
/**
 * 判断字符串的最大长度
 * @param text label需要自适应的文字
 * @param font label字体的样式和大小 [UIFont systemFontOfSize:14]
 * @param maxW label的最大宽度
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW;


/**
 * 传入一个images字符串进行图片的缩放
 * @param time 创建时间
 * @param scale 需要缩放的比例
 */
+ (UIImage *)changeImageSize:(NSString *)imageName scale:(CGFloat)scale;
@end
