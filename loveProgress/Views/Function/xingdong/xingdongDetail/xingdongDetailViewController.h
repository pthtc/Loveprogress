//
//  xingdongDetailViewController.h
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/30.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xingdongViewController.h"
@interface xingdongDetailViewController : UIViewController
@property(nonatomic,strong) NSString *jinianName;
@property(nonatomic,strong) NSDate *Date;
@property(nonatomic,strong) NSString *jinianContent;

@property (nonatomic,strong) NSString *avID;
@property (nonatomic,strong) xingdongViewController *vc;
@end
