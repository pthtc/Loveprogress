//
//  xihaoCollectionViewCell.m
//  loveProgress
//
//  Created by 彭天浩 on 2018/1/2.
//  Copyright © 2018年 彭天浩. All rights reserved.
//

#import "xihaoCollectionViewCell.h"

@implementation xihaoCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
//    if (self) {
//        if (!_isFirst) {
//            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//            _nameLabel.numberOfLines = 0;
//            _nameLabel.textAlignment = NSTextAlignmentCenter;
//            _nameLabel.textColor = WHITE_COLOR;
//            _nameLabel.font = [UIFont systemFontOfSize:15];
//            [self.contentView addSubview:_nameLabel];
//        }else{
//            UIImageView *addImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
//            addImage.userInteractionEnabled = YES;
//            [addImage setImage:[globalFunction scaleToSize:[UIImage imageNamed:@"addxihao"] size:CGSizeMake(frame.size.height, frame.size.height)]];
//            UITapGestureRecognizer *imgTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgAction)];
//            imgTapRecognizer.numberOfTapsRequired = 1;
//            [addImage addGestureRecognizer:imgTapRecognizer];
//            [self.contentView addSubview:addImage];
//        }
//    }
    return self;
}

- (void)update{
    for(UIView *view in [self.contentView subviews]) {
        [view removeFromSuperview];
    }
    if (!_isFirst) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-self.frame.size.height)/2, 0, self.frame.size.height, self.frame.size.height)];
        _nameLabel.text = _nameText;
        _nameLabel.numberOfLines = 0;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = WHITE_COLOR;
        _nameLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_nameLabel];
    }else{
        UIImageView *addImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-self.frame.size.height)/2, 0, 30, 30)];
        addImage.userInteractionEnabled = YES;
        [addImage setImage:[globalFunction scaleToSize:[UIImage imageNamed:@"addxihao"] size:CGSizeMake(self.frame.size.height, self.frame.size.height)]];
        [self.contentView addSubview:addImage];
        [addImage setCenter:self.contentView.center];
    }
}
@end
