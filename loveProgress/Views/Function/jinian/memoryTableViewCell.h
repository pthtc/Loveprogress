//
//  memoryTableViewCell.h
//  moai
//
//  Created by 彭天浩 on 2017/9/6.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface memoryTableViewCell : UITableViewCell
@property (nonatomic,strong) NSString *avid;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) NSDate *nextDate;
@property (nonatomic,assign) int isTop;
-(void)update;
@end
