//
//  progressTableViewCell.m
//  loveProgress
//
//  Created by 彭天浩 on 2018/1/5.
//  Copyright © 2018年 彭天浩. All rights reserved.
//

#import "progressTableViewCell.h"

@implementation progressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setBanner{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self.contentView setBackgroundColor:ZANGQING_COLOR];
    
    NSArray *loveArray = @[LOCAL(@"dating"),LOCAL(@"inlove"),LOCAL(@"live"),LOCAL(@"aboutToMarried"),LOCAL(@"married")];
    
    UILabel *nowLevelLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, 10, SCREEN_WIDTH-BEGIN_X, 100)];
    nowLevelLabel.text = loveArray[_loveLevel];
    if (UI_IS_IPHONE5) {
        [nowLevelLabel setFont:FONT(35)];
    }else if(UI_IS_IPHONE6){
        [nowLevelLabel setFont:FONT(45)];
    }else{
        [nowLevelLabel setFont:FONT(50)];
    }
    nowLevelLabel.textColor = WHITE_COLOR;
    [self.contentView addSubview:nowLevelLabel];
    
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-BEGIN_X-300, GETY(nowLevelLabel), 300, GETHEIGHT(nowLevelLabel))];
    if (_done < _all) {
        progressLabel.text = [NSString stringWithFormat:@"%d/%d",_done,_all];
        if (UI_IS_IPHONE5) {
            [progressLabel setFont:FONT(25)];
        }else if(UI_IS_IPHONE6){
            [progressLabel setFont:FONT(30)];
        }else{
            [progressLabel setFont:FONT(35)];
        }
        progressLabel.textAlignment = NSTextAlignmentRight;
        progressLabel.textColor = WHITE_COLOR;
    }else{
        if (_loveLevel<4) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:LOCAL(@"updateNow")];
            NSRange strRange = {0,[str length]};
            [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
            progressLabel.textAlignment = NSTextAlignmentRight;
            progressLabel.attributedText = str;
            if (UI_IS_IPHONE5) {
                [progressLabel setFont:FONT(25)];
            }else if(UI_IS_IPHONE6){
                [progressLabel setFont:FONT(30)];
            }else{
                [progressLabel setFont:FONT(35)];
            }
            progressLabel.userInteractionEnabled = YES;
            progressLabel.textColor = GREEN_COLOR;
            UITapGestureRecognizer *updateTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateAction)];
            updateTapRecognizer.numberOfTapsRequired = 1;
            updateTapRecognizer.delegate = self;
            [progressLabel addGestureRecognizer:updateTapRecognizer];
        }
    }
    
    [self.contentView addSubview:progressLabel];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(progressLabel)+5, SCREEN_WIDTH-2*BEGIN_X, 10)];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor =PLACEHODER_COLOR;
    [self.contentView addSubview:backView];
    
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(BEGIN_X, GETY(backView),  0, GETHEIGHT(backView))];
    progressView.layer.cornerRadius = 5;
    progressView.layer.masksToBounds = YES;
    progressView.backgroundColor = MEIHONG_COLOR;
    [self.contentView addSubview:progressView];
    
    UILabel *nextLevelLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(progressView)+20, SCREEN_WIDTH-BEGIN_X, 30)];
    if (UI_IS_IPHONE5) {
        [nextLevelLabel setFont:FONT(15)];
    }else if(UI_IS_IPHONE6){
        [nextLevelLabel setFont:FONT(20)];
    }else{
        [nextLevelLabel setFont:FONT(20)];
    }
    [nextLevelLabel setFont:BOLDFONT(nextLevelLabel)];
    if (_loveLevel == 4) {
        nextLevelLabel.text = LOCAL(@"noNext");
    }else{
        nextLevelLabel.text = [NSString stringWithFormat:@"%@%@",LOCAL(@"nextLevel"),loveArray[_loveLevel+1]];
    }
    nextLevelLabel.textColor = WHITE_COLOR;
    [self.contentView addSubview:nextLevelLabel];
    
    UILabel *achieveLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120-BEGIN_X, GETY(nextLevelLabel), 120, 30)];
    achieveLabel.userInteractionEnabled = YES;
    if (UI_IS_IPHONE5) {
        [achieveLabel setFont:FONT(15)];
    }else if(UI_IS_IPHONE6){
        [achieveLabel setFont:FONT(20)];
    }else{
        [achieveLabel setFont:FONT(20)];
    }
    achieveLabel.textAlignment = NSTextAlignmentCenter;
    achieveLabel.textColor = WHITE_COLOR;
    achieveLabel.layer.cornerRadius = 15;
    achieveLabel.layer.borderWidth = 1;
    achieveLabel.layer.borderColor = WHITE_COLOR.CGColor;
    achieveLabel.layer.masksToBounds = YES;
    achieveLabel.text = LOCAL(@"achievement");
    UITapGestureRecognizer *achiTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goAction)];
    achiTapRecognizer.numberOfTapsRequired = 1;
    achiTapRecognizer.delegate = self;
    [achieveLabel addGestureRecognizer:achiTapRecognizer];
    [self.contentView addSubview:achieveLabel];
    [UIView animateWithDuration:1.0 animations:^{
        [progressView setFrame:CGRectMake(BEGIN_X, GETY(backView), ((float)_done/(float)_all)*GETWIDTH(backView), GETHEIGHT(backView))];
    } completion:^(BOOL finished) {
    }];
}

- (void)updateAction{
    [self.delegate updateLevel];
}

-(void)goAction{
    [self.delegate jumpToAchievePage];
}

-(void)update{
    [self setBanner];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
