//
//  navTableViewCell.m
//  loveProgress
//
//  Created by 彭天浩 on 2018/1/5.
//  Copyright © 2018年 彭天浩. All rights reserved.
//

#import "navTableViewCell.h"

@implementation navTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setBanner{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, 20, SCREEN_WIDTH-BEGIN_X*2, 0)];
    label.text = _text;
    label.numberOfLines = 0;
    
    if (UI_IS_IPHONE5) {
        [label setFont:FONT(25)];
    }else if(UI_IS_IPHONE6){
        [label setFont:FONT(25)];
    }else{
        [label setFont:FONT(30)];
    }
    [label sizeToFit];
    [self.contentView addSubview:label];
    self.navHeight = BUTTONY(label)+20;
}

-(void)update{
    [self setBanner];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
