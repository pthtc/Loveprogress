//
//  jinianDetailViewController.h
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/30.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jinianViewController.h"
@interface jinianDetailViewController : UIViewController
@property(nonatomic,strong) NSString *jinianName;
@property(nonatomic,strong) NSDate *Date;
@property (nonatomic,strong) NSString *avID;
@property (nonatomic,strong) jinianViewController *vc;
@end
