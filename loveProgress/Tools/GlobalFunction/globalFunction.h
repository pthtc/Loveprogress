//
//  globalFunction.h
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/27.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface globalFunction : NSObject
+(BOOL)isChineseLanguage;
+(BOOL)isLogin;
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
+(NSData *)zipNSDataWithImage:(UIImage *)sourceImage;
@end
