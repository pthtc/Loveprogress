//
//  jiluTableViewCell.h
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/31.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol showImgDelegate <NSObject>
- (void)show:(UIImageView *)img;
@end
@interface jiluTableViewCell : UITableViewCell
@property (nonatomic,strong) NSString *avid;
@property (nonatomic,strong) NSString *theTag;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSArray *imgArray;
@property (nonatomic,strong) NSArray *imgArrayReal;

@property (nonatomic,assign) float jiluHeight;
@property (nonatomic,assign) int isTop;
@property (assign, nonatomic) id<showImgDelegate> delegate;
-(void)update;
@end
