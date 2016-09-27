//
//  GWYTextSize.m
//  GenWoYou
//
//  Created by 智捷科技 on 16/3/23.
//  Copyright © 2016年 智捷科技. All rights reserved.
//============================================================================
//  欢迎各位提宝贵的意见给我  185226139 感谢大家的支持
// https://github.com/liguoliangiOS/GWYAlertSelectView.git
//=============================================================================

#import "GWYTextSize.h"

@implementation GWYTextSize
//计算文字的大小 maxW限制最大宽度 maxW 传MAXFLOAT，没有限制最大的宽度
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (UIImage *)changeImageSize:(NSString *)imageName scale:(CGFloat)scale {
    NSData *imgData = UIImagePNGRepresentation([UIImage imageNamed:imageName]);
    UIImage * image = [UIImage imageWithData:imgData scale:scale];
    //声明使用自定义的图片
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}
@end
