//
//  xihaoEditViewController.h
//  loveProgress
//
//  Created by 彭天浩 on 2018/1/4.
//  Copyright © 2018年 彭天浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xihaoViewController.h"
@interface xihaoEditViewController : UIViewController
@property (nonatomic,strong) xihaoViewController *vc;
@property (nonatomic,assign) int like;
@property (nonatomic,assign) int scene;
@property (nonatomic,assign) BOOL isJump;
@end
