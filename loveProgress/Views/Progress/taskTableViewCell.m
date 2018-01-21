//
//  taskTableViewCell.m
//  loveProgress
//
//  Created by 彭天浩 on 2018/1/6.
//  Copyright © 2018年 彭天浩. All rights reserved.
//

#import "taskTableViewCell.h"

@implementation taskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBanner{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView setBackgroundColor:PLACEHODER_COLOR];
    
    UIView *backView= [[UIView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 95)];
    backView.backgroundColor = WHITE_COLOR;
    [self.contentView addSubview:backView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, 10, SCREEN_WIDTH-BEGIN_X, 50)];
    label.text = _model.content;
    [label setFont:FONT(20)];
    [self.contentView addSubview:label];
    
    __block NSString *countString;
    __block NSArray *resultArray;
    if (_model.isCount) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            resultArray = [self getCount];
            countString = resultArray[0];
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(label), 120, 30)];
                countLabel.text = countString;
                countLabel.font = FONT(20);
                [self.contentView addSubview: countLabel];
                if (_isFinish) {
                    UILabel *toFinishLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120-BEGIN_X, BUTTONY(label), 120, 30)];
                    toFinishLabel.userInteractionEnabled = YES;
                    toFinishLabel.textAlignment = NSTextAlignmentCenter;
                    toFinishLabel.layer.cornerRadius = 15;
                    toFinishLabel.layer.borderColor = [UIColor grayColor].CGColor;
                    toFinishLabel.layer.borderWidth = 1;
                    toFinishLabel.layer.masksToBounds = YES;
                    toFinishLabel.text = LOCAL(@"finished");
                    toFinishLabel.textColor = [UIColor grayColor];
                    [self.contentView addSubview:toFinishLabel];
                }else{
                    if (_model.isCount && ([resultArray[1] intValue] < _model.countOrder)) {
                        UILabel *toFinishLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120-BEGIN_X, BUTTONY(label), 120, 30)];
                        toFinishLabel.userInteractionEnabled = YES;
                        toFinishLabel.textAlignment = NSTextAlignmentCenter;
                        toFinishLabel.layer.cornerRadius = 15;
                        toFinishLabel.layer.borderColor = HONG_COLOR.CGColor;
                        toFinishLabel.layer.borderWidth = 1;
                        toFinishLabel.layer.masksToBounds = YES;
                        toFinishLabel.text = LOCAL(@"goFinish");
                        toFinishLabel.textColor = HONG_COLOR;
                        UITapGestureRecognizer *finishTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goAction:)];
                        finishTapRecognizer.numberOfTapsRequired = 1;
                        finishTapRecognizer.delegate = self;
                        [toFinishLabel addGestureRecognizer:finishTapRecognizer];
                        [self.contentView addSubview:toFinishLabel];
                    }else{
                        UILabel *toFinishLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120-BEGIN_X, BUTTONY(label), 120, 30)];
                        toFinishLabel.userInteractionEnabled = YES;
                        toFinishLabel.textAlignment = NSTextAlignmentCenter;
                        toFinishLabel.layer.cornerRadius = 15;
                        toFinishLabel.layer.borderColor = GREEN_COLOR.CGColor;
                        toFinishLabel.layer.borderWidth = 1;
                        toFinishLabel.layer.masksToBounds = YES;
                        toFinishLabel.text = LOCAL(@"toFinish");
                        toFinishLabel.textColor = GREEN_COLOR;
                        UITapGestureRecognizer *finishTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(finishAction:)];
                        finishTapRecognizer.numberOfTapsRequired = 1;
                        finishTapRecognizer.delegate = self;
                        [toFinishLabel addGestureRecognizer:finishTapRecognizer];
                        [self.contentView addSubview:toFinishLabel];
                        NSLog(@"cellheight == %f",BUTTONY(toFinishLabel));
                    }
                }
            });
        });
    }else{
        if (_isFinish) {
            UILabel *toFinishLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120-BEGIN_X, BUTTONY(label), 120, 30)];
            toFinishLabel.userInteractionEnabled = YES;
            toFinishLabel.textAlignment = NSTextAlignmentCenter;
            toFinishLabel.layer.cornerRadius = 15;
            toFinishLabel.layer.borderColor = [UIColor grayColor].CGColor;
            toFinishLabel.layer.borderWidth = 1;
            toFinishLabel.layer.masksToBounds = YES;
            toFinishLabel.textColor = [UIColor grayColor];
            toFinishLabel.text = LOCAL(@"finished");
            [self.contentView addSubview:toFinishLabel];
        }else{
            UILabel *toFinishLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120-BEGIN_X, BUTTONY(label), 120, 30)];
            toFinishLabel.userInteractionEnabled = YES;
            toFinishLabel.textAlignment = NSTextAlignmentCenter;
            toFinishLabel.layer.cornerRadius = 15;
            toFinishLabel.layer.borderColor = GREEN_COLOR.CGColor;
            toFinishLabel.layer.borderWidth = 1;
            toFinishLabel.layer.masksToBounds = YES;
            toFinishLabel.textColor = GREEN_COLOR;
            toFinishLabel.text = LOCAL(@"toFinish");
            UITapGestureRecognizer *finishTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(finishAction:)];
            finishTapRecognizer.numberOfTapsRequired = 1;
            finishTapRecognizer.delegate = self;
            [toFinishLabel addGestureRecognizer:finishTapRecognizer];
            [self.contentView addSubview:toFinishLabel];
            NSLog(@"cellheight == %f",BUTTONY(toFinishLabel));
        }
    }

}

-(NSArray *)getCount{
    __block NSString *returnString;
    __block NSInteger num;
    AVQuery *query = [AVQuery queryWithClassName:_model.countName];
    [query whereKey:@"owner" equalTo:[AVUser currentUser]];
    [query countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (!error) {
            // 查询成功，输出计数
            returnString= [NSString stringWithFormat:@"%ld/%d",(long)number,_model.countOrder];
            num = number;
        } else {
            // 查询失败
            returnString=  LOCAL(@"fail");
        }
    }];
    
    while (!returnString) {
        usleep(500);
    }
    
    return @[returnString,[NSNumber numberWithInteger:num]];
    
}

- (void)finishAction:(id)sender{
    [self.delegate finishTaskAction:_model];
}

-(void)goAction:(id)sender{
    [self.delegate jumpToPage:_model.countName];
}

-(void)update{
    [self setBanner];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
