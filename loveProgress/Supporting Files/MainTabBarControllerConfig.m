//
//  MainTabBarControllerConfig.m
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/25.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import "MainTabBarControllerConfig.h"

#import "progressViewController.h"
#import "functionViewController.h"
#import "meViewController.h"

@implementation MainTabBarControllerConfig
- (CYLTabBarController *)mainTabBarController{
    if (!_mainTabBarController) {
        UIEdgeInsets imageInsets = UIEdgeInsetsZero;
        UIOffset titlePositionAdjustment = UIOffsetZero;
        _mainTabBarController = [CYLTabBarController tabBarControllerWithViewControllers:[self arrayViewControllerItem] tabBarItemsAttributes:[self arrayAttributesItem] imageInsets:imageInsets titlePositionAdjustment:titlePositionAdjustment];
        [self customizeTabBarAppearance:_mainTabBarController];
    }
    return _mainTabBarController;
}

- (NSArray *)arrayViewControllerItem{
    //设置title颜色
    UIColor * color = [UIColor blackColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    progressViewController *progress = [[progressViewController alloc] init];
    functionViewController *function = [[functionViewController alloc] init];
    meViewController *me = [[meViewController alloc] init];
    ///返回需要加载的模块
    UINavigationController *navFirst = [[UINavigationController alloc] initWithRootViewController:progress];
    navFirst.navigationBar.barTintColor = [UIColor whiteColor];
    navFirst.navigationBar.titleTextAttributes = dict;
    UINavigationController *navSecond = [[UINavigationController alloc] initWithRootViewController:function];
    navSecond.navigationBar.barTintColor = [UIColor whiteColor];
    navSecond.navigationBar.titleTextAttributes = dict;
    UINavigationController *navThird = [[UINavigationController alloc]initWithRootViewController:me];
    navThird.navigationBar.barTintColor = [UIColor whiteColor];
    navThird.navigationBar.titleTextAttributes = dict;
    
    return @[navFirst,navSecond,navThird];
}

- (NSArray *)arrayAttributesItem{
    NSDictionary *bookcaseItemsAttributes =@{CYLTabBarItemTitle : LOCAL(@"tab_progress"),
                                             CYLTabBarItemImage : @"progress_icon",
                                             /* NSString and UIImage are supported*/
                                             CYLTabBarItemSelectedImage : @"progress_icon_selected",};
    
    NSDictionary *discoverItemsAttributes = @{CYLTabBarItemTitle : LOCAL(@"tab_function"),
                                              CYLTabBarItemImage : @"love_icon",
                                              CYLTabBarItemSelectedImage : @"love_icon_selected",};

    NSArray *array = @[LOCAL(@"tab_he"),LOCAL(@"tab_she"),LOCAL(@"tab_ze"),];
    NSDictionary *askklItemsAttributes;
    if ([AVUser currentUser]) {
        if ([[[AVUser currentUser] objectForKey:@"haveInfo"] isEqual: @1]){
            int gender =[((NSNumber *) [[AVUser currentUser] objectForKey:@"gender"]) intValue];
           askklItemsAttributes = @{CYLTabBarItemTitle : array[gender],
                                                   CYLTabBarItemImage : @"me_icon",
                                                   CYLTabBarItemSelectedImage : @"me_icon_selected",};
        }else{
            askklItemsAttributes = @{CYLTabBarItemTitle : LOCAL(@"tab_me"),
                                     CYLTabBarItemImage : @"me_icon",
                                     CYLTabBarItemSelectedImage : @"me_icon_selected",};
        }
    }else{
        NSLog(@"user not login");

        askklItemsAttributes = @{CYLTabBarItemTitle : LOCAL(@"tab_me"),
                                 CYLTabBarItemImage : @"me_icon",
                                 CYLTabBarItemSelectedImage : @"me_icon_selected",};
    }

    
    NSArray *tabBarItemsAttributes = @[bookcaseItemsAttributes,
                                       discoverItemsAttributes,
                                       askklItemsAttributes];
    return tabBarItemsAttributes;
}


/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
    // Customize UITabBar height
    // 自定义 TabBar 高度
    //     tabBarController.tabBarHeight = CYLTabBarControllerHeight;
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = TABICON_COLOR;
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    // [self customizeTabBarSelectionIndicatorImage];
    
    // update TabBar when TabBarItem width did update
    // If your app need support UIDeviceOrientationLandscapeLeft or UIDeviceOrientationLandscapeRight，
    // remove the comment '//'
    // 如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
    // [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
    
    // set the bar background image
    // 设置背景图片
    //     UITabBar *tabBarAppearance = [UITabBar appearance];
    //     [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tab_bar"]];
    
    // remove the bar system shadow image
    // 去除 TabBar 自带的顶部阴影
    // [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}
@end
