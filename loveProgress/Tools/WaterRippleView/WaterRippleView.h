//
//  WaterRippleView.h
//  WaterRipple
//
//  Created by Liyn on 2017/5/24.
//  Copyright © 2017年 Liyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterRippleView : UIView
@property (nonatomic, strong)UIColor *mainRippleColor;//主波填充颜色
@property (nonatomic, strong)UIColor *minorRippleColor;//次波填充颜色
@property (nonatomic, assign)CGFloat mainRippleoffsetX;//主波偏移量
@property (nonatomic, assign)CGFloat minorRippleoffsetX;//次波偏移量
@property (nonatomic, assign)CGFloat rippleSpeed;//波浪速度
@property (nonatomic, assign)CGFloat ripplePosition;//波浪Y轴位置
@property (nonatomic, assign)float rippleAmplitude;//波浪振幅
//设置frame 主波填充颜色  次波填充颜色
- (instancetype)initWithFrame:(CGRect)frame mainRippleColor:(UIColor *)mainRippleColor minorRippleColor:(UIColor *)minorRippleColor;
//设置frame 主波填充颜色  次波填充颜色 主波偏移量 次波偏移量 波浪速度 波浪Y轴位置 波浪振幅
- (instancetype)initWithFrame:(CGRect)frame mainRippleColor:(UIColor *)mainRippleColor minorRippleColor:(UIColor *)minorRippleColor mainRippleoffsetX:(float)mainRippleoffsetX minorRippleoffsetX:(float)minorRippleoffsetX rippleSpeed:(float)rippleSpeed ripplePosition:(float)ripplePosition rippleAmplitude:(float)rippleAmplitude;
@end
/*
 self.backgroundColor = [UIColor redColor];
 self.mainRippleColor = [UIColor colorWithRed:255/255.0f green:127/255.0f blue:80/255.0f alpha:1];
 self.minorRippleColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
 self.mainRippleoffsetX = 1;
 self.minorRippleoffsetX = 2;
 self.rippleSpeed = 1.0f;
 self.ripplePosition = 190.0f;
 self.rippleAmplitude = 5;
 */
