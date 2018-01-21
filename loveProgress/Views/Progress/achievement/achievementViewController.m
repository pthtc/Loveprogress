//
//  achievementViewController.m
//  loveProgress
//
//  Created by 彭天浩 on 2018/1/6.
//  Copyright © 2018年 彭天浩. All rights reserved.
//

#import "achievementViewController.h"

@interface achievementViewController ()

@end

@implementation achievementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScreen];
    // Do any additional setup after loading the view.
}

- (void)setScreen{
    [self.view setBackgroundColor:PLACEHODER_COLOR];
    self.tabBarController.tabBar.hidden = YES;
    self.title = LOCAL(@"achievementTitle");
    
    UIView *bigNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, BEGIN_LINE_NORMAL+5, SCREEN_WIDTH, 300)];
    bigNumberView.backgroundColor = WHITE_COLOR;
    bigNumberView.userInteractionEnabled = YES;
    [self.view addSubview:bigNumberView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
