//
//  taskTableViewCell.h
//  loveProgress
//
//  Created by 彭天浩 on 2018/1/6.
//  Copyright © 2018年 彭天浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "taskModel.h"
@protocol taskTableViewCellDelegate <NSObject>
- (void)jumpToPage:(NSString *)pageName;
- (void)finishTaskAction:(taskModel *)finishModel;
@end
@interface taskTableViewCell : UITableViewCell
@property (nonatomic,strong) taskModel *model;
@property (nonatomic,assign) BOOL isFinish;
@property (assign, nonatomic) id<taskTableViewCellDelegate> delegate;
-(void)update;
@end
