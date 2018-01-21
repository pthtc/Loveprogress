//
//  xingdongTableViewCell.h
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/30.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xingdongTableViewCell : UITableViewCell
@property (nonatomic,strong) NSString *avid;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,assign) int isTop;
-(void)update;
@end
