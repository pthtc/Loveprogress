//
//  infoViewController.h
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/28.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface infoViewController : UIViewController
@property(nonatomic,assign) BOOL isJumpFromApp;
@property(nonatomic,assign) int gender;
@property(nonatomic,strong) NSString *nickName;
@property(nonatomic,strong) NSDate *Date;
@property(nonatomic,strong) NSString *heart;

@end
