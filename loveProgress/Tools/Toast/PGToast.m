//
//  PGToast.m
//  OVE
//
//  Created by 张毅杰 on 15/7/24.
//  Copyright (c) 2015年 张毅杰. All rights reserved.
//

#import "PGToast.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#define bottomPadding 100
#define startDisappearSecond 0
#define disappeartDurationSecond 1

const CGFloat pgToastTextPadding = 8;
const CGFloat pgToastLabelWidth = 180;
const CGFloat pgToastLabelHeight = 60;
const CGFloat pgToastLabelWidth_PAD = 360;
const CGFloat pgToastLabelHeight_PAD = 100;

@interface PGToast() {
    BOOL showInNormal;
}

@property (nonatomic, retain) UILabel *pgLabel;
@property (nonatomic, copy) NSString *pgLabelText;

- (id)initWithText:(NSString *)text;
- (void)deviceOrientationChange;

@end

@implementation PGToast

@synthesize pgLabel;
@synthesize pgLabelText;

- (id)initWithText:(NSString *)text {
    if (self = [super init]) {
        self.pgLabelText = text;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

+ (PGToast *)makeToast:(NSString *)text {
    PGToast *pgToast = [[PGToast alloc] initWithText:text];
    return pgToast;
}

- (void)show {
    UIFont *font;
    CGSize textSize;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        font = [UIFont systemFontOfSize:16];
        textSize = [pgLabelText sizeWithFont:font constrainedToSize:CGSizeMake(pgToastLabelWidth, pgToastLabelHeight)];
    }else{
        font = [UIFont systemFontOfSize:30];
        textSize = [pgLabelText sizeWithFont:font constrainedToSize:CGSizeMake(pgToastLabelWidth_PAD, pgToastLabelHeight_PAD)];
    }
    
    self.pgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, textSize.width + 2 * pgToastTextPadding, textSize.height + 2 * pgToastTextPadding)];
    
    pgLabel.backgroundColor = [UIColor colorWithRed:0.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:1];
    pgLabel.textColor = [UIColor whiteColor];
    pgLabel.layer.masksToBounds = YES;
    pgLabel.layer.cornerRadius = 5;
    pgLabel.layer.borderWidth = 2;
    pgLabel.numberOfLines = 2;
    pgLabel.font = font;
    pgLabel.textAlignment = NSTextAlignmentCenter;
    pgLabel.text = self.pgLabelText;
    
    [NSTimer scheduledTimerWithTimeInterval:startDisappearSecond target:self selector:@selector(toastDisappear:) userInfo:nil repeats:NO];
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0]; //如果是0会被键盘覆盖
    
    [window addSubview:self.pgLabel];
    [self deviceOrientationChange];
}

- (void)deviceOrientationChange {
    CGFloat centerX, centerY;
    CGFloat windowCenterX = [[UIScreen mainScreen] bounds].size.width * 0.5;
    CGFloat windowCenterY = [[UIScreen mainScreen] bounds].size.height * 0.5;
    CGFloat windowWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat windowHeight = [[UIScreen mainScreen] bounds].size.height;
    
    UIInterfaceOrientation currentOrient = [UIApplication sharedApplication].statusBarOrientation;
    
    if (currentOrient == UIInterfaceOrientationLandscapeRight) {
        CGAffineTransform rightTransform = CGAffineTransformMake(0.0, 1.0, -1.0, 0.0, 0.0, 0.0);
        self.pgLabel.transform = rightTransform;
        centerX = bottomPadding;
        centerY = windowCenterY;
        self.pgLabel.center = CGPointMake(centerX, centerY);
    } else if(currentOrient == UIInterfaceOrientationLandscapeLeft) {
        CGAffineTransform leftTransform = CGAffineTransformMake(0.0, -1.0, 1.0, 0.0, 0.0, 0.0);
        pgLabel.transform = leftTransform;
        centerX = windowWidth - bottomPadding;
        centerY = windowCenterY;
        self.pgLabel.center = CGPointMake(centerX, centerY);
    } else if(currentOrient == UIInterfaceOrientationPortraitUpsideDown) {
        CGAffineTransform upsideDownTransform = CGAffineTransformMake(-1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
        pgLabel.transform = upsideDownTransform;
        centerX = windowCenterX;
        centerY = bottomPadding;
        self.pgLabel.center = CGPointMake(centerX, centerY);
    } else if(currentOrient == UIInterfaceOrientationPortrait) {
        CGAffineTransform portraitTransform = CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
        pgLabel.transform = portraitTransform;
        centerX = windowCenterX;
        centerY = windowHeight - bottomPadding;
        self.pgLabel.center = CGPointMake(centerX, centerY);
    }
    showInNormal = YES;
}

- (void)toastDisappear:(NSTimer *)timer {
    [timer invalidate];
    [NSTimer scheduledTimerWithTimeInterval:1 / 60.0 target:self selector:@selector(startDisappear:) userInfo:nil repeats:YES];
}

- (void)startDisappear:(NSTimer *)timer {
    static int timeCount = 60 * disappeartDurationSecond;

    if (timeCount >= 1) {
        [self.pgLabel setAlpha:timeCount / 60.0];
        if (timeCount == 1) {
            [self.pgLabel setAlpha:0];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }
        timeCount--;
    } else {
        [timer invalidate];
        timeCount = 60 * disappeartDurationSecond;
    }
}

@end