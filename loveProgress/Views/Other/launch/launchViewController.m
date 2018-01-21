//
//  launchViewController.m
//  loveProgress
//
//  Created by 彭天浩 on 2018/1/8.
//  Copyright © 2018年 彭天浩. All rights reserved.
//

#import "launchViewController.h"
#import "MainTabBarControllerConfig.h"
#import "loginViewController.h"
#import <UIImageView+WebCache.h>
#import "selectLevelViewController.h"
@interface launchViewController (){
    UIImageView *img;
}

@end

@implementation launchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    // Do any additional setup after loading the view.
}

- (void)getData{
    [self.view setBackgroundColor:RGBA(243, 249, 253, 1)];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(jump) userInfo:nil repeats:NO];
    img = [[UIImageView alloc] initWithFrame:self.view.bounds];
    img.alpha = 0;
    [self.view addSubview:img];
    AVQuery *query = [AVQuery queryWithClassName:@"launchImage"];
    if ([globalFunction isChineseLanguage]) {
        [query whereKey:@"isChinese" equalTo:@YES];
    }else{
//        [self jump];
        [query whereKey:@"isChinese" equalTo:@NO];
    }
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error){
        if (!error) {
            AVFile *file = [object objectForKey:@"img"];
            AVFile *files2 = [AVFile fileWithURL:file.url];
            
            [files2 getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                if(!error){
                    [img setImage:[globalFunction scaleToSize:[UIImage imageWithData:data] size:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)]];
                    [UIView animateWithDuration:0.3 animations:^{
                        img.alpha = 1;
                    } completion:^(BOOL finished) {
                    }];
                }else{
                    [self jump];
                }
            }];
            
        }else{
            [self jump];
        }
    }];
    
    //    UIImageView *imgView = [[UIImageView alloc] init];
    //    [imgView setFrame:self.view.bounds];
    //    imgView
}
- (void)jump{
    [UIView animateWithDuration:0.5 animations:^{
        img.alpha = 0;
    } completion:^(BOOL finished) {
        MainTabBarControllerConfig *tabbarConfig = [[MainTabBarControllerConfig alloc]init];
        CYLTabBarController *mainTabbarController = tabbarConfig.mainTabBarController;
        if(![AVUser currentUser]) {
            [self presentViewController:[[loginViewController alloc] init] animated:NO completion:NULL];
        }else{
            if ([[[AVUser currentUser] objectForKey:@"haveInfo"] isEqual: @1]) {
                [self presentViewController:mainTabbarController animated:NO completion:NULL];
            }else{
                selectLevelViewController *select = [[selectLevelViewController alloc] init];
                [self presentViewController:select animated:YES completion:NULL];
            }
        }
    }];
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
