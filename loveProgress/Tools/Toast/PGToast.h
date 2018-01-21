//
//  PGToast.h
//  OVE
//
//  Created by 张毅杰 on 15/7/24.
//  Copyright (c) 2015年 张毅杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGToast : NSObject

- (void)show;
+ (PGToast *)makeToast:(NSString *)text;

@end
