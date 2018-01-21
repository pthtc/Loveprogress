//
//  progressTableViewCell.h
//  loveProgress
//
//  Created by 彭天浩 on 2018/1/5.
//  Copyright © 2018年 彭天浩. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol progressTableViewCellDelegate <NSObject>
- (void)jumpToAchievePage;
- (void)updateLevel;

@end
@interface progressTableViewCell : UITableViewCell
@property (nonatomic,assign) int loveLevel;
@property (nonatomic,assign) int all;
@property (nonatomic,assign) int done;
@property (assign, nonatomic) id<progressTableViewCellDelegate> delegate;

-(void)update;
@end
