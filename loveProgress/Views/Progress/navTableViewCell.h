//
//  navTableViewCell.h
//  loveProgress
//
//  Created by 彭天浩 on 2018/1/5.
//  Copyright © 2018年 彭天浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface navTableViewCell : UITableViewCell
@property (nonatomic,strong) NSString *text;
@property (nonatomic,assign) float navHeight;
-(void)update;
@end
