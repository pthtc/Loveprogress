//
//  functionViewController.m
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/25.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import "functionViewController.h"
#import "xihaoViewController.h"
#import "jiluViewController.h"
#import "jinianViewController.h"
#import "xingdongViewController.h"
#import "guanxiViewController.h"
@interface functionViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIScrollView *scrollerView;

@end

@implementation functionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScreen];
    //[self getDataTest];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [AVAnalytics beginLogPageView:@"functionPage"];
}

-(void)setScreen{
    self.title = LOCAL(@"function");
    float height = SCREEN_WIDTH/2.61;
    [self.view setBackgroundColor:PLACEHODER_COLOR];
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollerView.backgroundColor =PLACEHODER_COLOR;
    [_scrollerView flashScrollIndicators];
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    _scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, 5+5*(height+5));
    _scrollerView.directionalLockEnabled = YES;
    _scrollerView.bounces = YES;
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    [_scrollerView setDelaysContentTouches:NO];
    [_scrollerView setCanCancelContentTouches:YES];
    [self.view addSubview:_scrollerView];
    
    
    NSArray *imgArray;
//    if ([globalFunction isChineseLanguage]) {
        imgArray = @[@"jinian",@"xingdong",@"jilu",@"aihao",@"guanxi"];
//    }else{
//        imgArray = @[@"Memories",@"plans",@"moments",@"favorites"];
//    }

    for (int i = 0; i<5; i++) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5+i*(height+5), SCREEN_WIDTH, height)];
        view.tag = 100+i;
        view.userInteractionEnabled = YES;
        [view setImage:[globalFunction scaleToSize:[UIImage imageNamed:imgArray[i]] size:view.frame.size]];
        [self.scrollerView addSubview: view];
        UITapGestureRecognizer *btnTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonAction:)];
        btnTapRecognizer.numberOfTapsRequired = 1;
        btnTapRecognizer.delegate = self;
        [view addGestureRecognizer:btnTapRecognizer];
    }
}

-(void)buttonAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIImageView *view =(UIImageView *)tap.view;
    if (view.tag == 100) {
        jinianViewController *jinian = [[jinianViewController alloc] init];
        [self.navigationController pushViewController:jinian animated:YES];
    }else if (view.tag == 101){
        xingdongViewController *xingdong = [[xingdongViewController alloc] init];
        [self.navigationController pushViewController:xingdong animated:YES];
    }else if (view.tag == 102){
        jiluViewController *jilu = [[jiluViewController alloc] init];
        [self.navigationController pushViewController:jilu animated:YES];
    }else if (view.tag == 103){
        xihaoViewController *xihao = [[xihaoViewController alloc] init];
        [self.navigationController pushViewController:xihao animated:YES];
    }else if (view.tag == 104){
        guanxiViewController *guanxi = [[guanxiViewController alloc] init];
        [self.navigationController pushViewController:guanxi animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"functionPage"];
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
