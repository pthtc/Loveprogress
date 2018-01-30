//
//  AppDelegate.m
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/24.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarControllerConfig.h"
#import "loginViewController.h"
#import "launchViewController.h"
#import "selectLevelViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    launchViewController *launch = [[launchViewController alloc] init];
    self.window.rootViewController = launch;
    [AVOSCloud setApplicationId:@"ApplicationId" clientKey:@"clientKey"];
    [AVOSCloud setAllLogsEnabled:NO];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)updateUser{
    // 然后调用刷新的方法，将数据从云端拉到本地

}

/** 创建引导页 */
//- (void)createGuideVC {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *firstKey = [NSString stringWithFormat:@"isFirst%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
//    NSString *isFirst = [defaults objectForKey:firstKey];
//
//    NSMutableArray *backgroundImageNames = [NSMutableArray arrayWithCapacity:4];
//    NSMutableArray *coverImageNames = [NSMutableArray arrayWithCapacity:4];
//    if (!isFirst.length) {
//        for (NSInteger i = 1; i < 5; i ++) {
//            NSString *temp1 = [NSString stringWithFormat:@"ggps_%ld_bg", i];
//            NSString *temp2 = [NSString stringWithFormat:@"ggps_%ld_text", i];
//            if ([[UIApplication sharedApplication] statusBarFrame].size.height > 20) {
//                temp1 = [NSString stringWithFormat:@"x_%@", temp1];
//                temp2 = [NSString stringWithFormat:@"x_%@", temp2];
//            }
//
//            [backgroundImageNames addObject:temp1];
//            [coverImageNames addObject:temp2];
//        }
//
//        // NO.1
//        //        self.introductionView = [[JhtGradientGuidePageVC alloc] initWithGuideImageNames:backgroundImageNames withLastRootViewController:[[ViewController alloc] init]];
//
//        // NO.2
//        //        self.introductionView = [[JhtGradientGuidePageVC alloc] initWithCoverImageNames:coverImageNames withBackgroundImageNames:backgroundImageNames withLastRootViewController:[[ViewController alloc] init]];
//
//        // NO.3
//        // case 1
//        UIButton *enterButton = [[UIButton alloc] init];
//        [enterButton setTitle:@"点击进入" forState:UIControlStateNormal];
//        [enterButton setBackgroundColor:[UIColor purpleColor]];
//        enterButton.layer.cornerRadius = 8.0;
//        // case 2
//        //        UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - 100) / 2, CGRectGetHeight([UIScreen mainScreen].bounds) - 30 - 50, 100, 30)];
//        //        [enterButton setBackgroundImage:[UIImage imageNamed:@"enter_btn"] forState:UIControlStateNormal];
//
//        MainTabBarControllerConfig *tabbarConfig = [[MainTabBarControllerConfig alloc]init];
//        CYLTabBarController *mainTabbarController = tabbarConfig.mainTabBarController;
//        if(![AVUser currentUser]) {
//            self.introductionView = [[JhtGradientGuidePageVC alloc] initWithCoverImageNames:coverImageNames withBackgroundImageNames:backgroundImageNames withEnterButton:enterButton withLastRootViewController:[[loginViewController alloc] init]];
//        }else{
//            if ([[[AVUser currentUser] objectForKey:@"haveInfo"] isEqual: @1]) {
//                self.introductionView = [[JhtGradientGuidePageVC alloc] initWithCoverImageNames:coverImageNames withBackgroundImageNames:backgroundImageNames withEnterButton:enterButton withLastRootViewController:mainTabbarController];
//            }else{
//                selectLevelViewController *select = [[selectLevelViewController alloc] init];
//                self.introductionView = [[JhtGradientGuidePageVC alloc] initWithCoverImageNames:coverImageNames withBackgroundImageNames:backgroundImageNames withEnterButton:enterButton withLastRootViewController:select];
//            }
//        }
//
//
//
//        // 添加《跳过》按钮
//        self.introductionView.isNeedSkipButton = NO;
//        /******** 更多个性化配置见《JhtGradientGuidePageVC.h》 ********/
//
//        self.window.rootViewController = self.introductionView;
//
//        __weak AppDelegate *weakSelf = self;
//        self.introductionView.didClickedEnter = ^() {
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            NSString *firstKey = [NSString stringWithFormat:@"isFirst%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
//            NSString *isFirst = [defaults objectForKey:firstKey];
//            if (!isFirst) {
//                [defaults setObject:@"notFirst" forKey:firstKey];
//                [defaults synchronize];
//            }
//            weakSelf.introductionView = nil;
//        };
//    }else{
//        launchViewController *launch = [[launchViewController alloc] init];
//        self.window.rootViewController = launch;
//    }
//}


@end
