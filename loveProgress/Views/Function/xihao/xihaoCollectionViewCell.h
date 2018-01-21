//
//  xihaoCollectionViewCell.h
//  loveProgress
//
//  Created by 彭天浩 on 2018/1/2.
//  Copyright © 2018年 彭天浩. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface xihaoCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) NSString *avid;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) NSString *nameText;
@property (nonatomic,assign) float cellHeight;
@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,assign) int like;
@property (nonatomic,assign) int scene;

- (void)update;
@end
