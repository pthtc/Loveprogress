//
//  selectLevelViewController.m
//  loveProgress
//
//  Created by 彭天浩 on 2018/1/6.
//  Copyright © 2018年 彭天浩. All rights reserved.
//

#import "selectLevelViewController.h"
#import "infoViewController.h"
#define labelHeight 100
@interface selectLevelViewController ()<UIGestureRecognizerDelegate>{
    int levelFlag;
    
    UIView *navView;
    UILabel *navLabel;
}
@property (nonatomic,strong) UIButton *saveButton;

@end

@implementation selectLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScreen];
    // Do any additional setup after loading the view.
}

- (void)setScreen{
    [self.view setBackgroundColor:WHITE_COLOR];
    float place = (SCREEN_WIDTH-2*labelHeight)/3;
    float xPo = place;
    float yPo = BEGIN_LINE_LARGE+place*2;
    levelFlag = 0;
    
    navView = [[UIView alloc] init];
    [navView setBackgroundColor:WHITE_COLOR];
    navView.layer.shadowColor = [UIColor grayColor].CGColor;
    navView.layer.shadowOffset = CGSizeMake(0,3);
    navView.layer.shadowOpacity = 0.8;
    navView.layer.shadowRadius = 2;
    [navView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, BEGIN_LINE_LARGE)];
    
    [self.view addSubview:navView];
    
    
    navLabel = [[UILabel alloc] init];
    
    [navLabel setText:LOCAL(@"whereRelation")];
    
    [navLabel setFont:[UIFont systemFontOfSize:30]];
    [navLabel setTextAlignment:NSTextAlignmentLeft];
    [navLabel setFrame:CGRectMake(BEGIN_X, BEGIN_LINE_LARGE-44-10, SCREEN_WIDTH, 44)];
    [navView addSubview:navLabel];
    
    
    NSArray *nameArray = @[[NSString stringWithFormat:@"1.%@",LOCAL(@"dating")] ,[NSString stringWithFormat:@"2.%@",LOCAL(@"inlove")],[NSString stringWithFormat:@"3.%@",LOCAL(@"live")],[NSString stringWithFormat:@"4.%@",LOCAL(@"aboutToMarried")],[NSString stringWithFormat:@"5.%@",LOCAL(@"married")]];
    for (int i= 0; i<4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xPo, yPo, labelHeight, labelHeight)];
        label.tag = 100+i;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = WHITE_COLOR;
        label.userInteractionEnabled = YES;
        label.layer.cornerRadius = labelHeight/2;
        label.layer.borderColor = ZANGQING_COLOR.CGColor;
        label.layer.borderWidth = 1.5;
        label.layer.masksToBounds = YES;
        label.textColor = ZANGQING_COLOR;
        UITapGestureRecognizer *btnTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(levelButton:)];
        btnTapRecognizer.numberOfTapsRequired = 1;
        btnTapRecognizer.delegate = self;
        [label addGestureRecognizer:btnTapRecognizer];
        label.text = nameArray[i];
        [self.view addSubview:label];
        xPo+=place+labelHeight;
        if (i == 0) {
            label.textColor = WHITE_COLOR;
            label.backgroundColor = ZANGQING_COLOR;
        }
        if (i == 1) {
            xPo = place;
            yPo+= place+labelHeight;
        }
    }
    
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-BEGIN_X-80, SCREEN_HEIGHT-NAV_NORMAL_HEIGHT-BEGIN_X, 80, NAV_NORMAL_HEIGHT)];
    [_saveButton setBackgroundColor:ZANGQING_COLOR];
    _saveButton.layer.cornerRadius = 22;
    _saveButton.layer.masksToBounds=YES;
    [_saveButton setTitle:LOCAL(@"save") forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
    
}

- (void)saveAction{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AVUser *user = [AVUser currentUser];
    NSNumber *reTemp =[NSNumber numberWithInt:levelFlag];
    [user setObject:reTemp forKey:@"relationship"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [hud hideAnimated:YES];
        if(succeeded){
            infoViewController *info = [[infoViewController alloc] init];
            [self presentViewController:info animated:YES completion:NULL];
        }else{
            [UIView showToast:LOCAL(@"fail")];
        }
    }];
}

- (void)levelButton:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UILabel *button =(UILabel *)tap.view;
    levelFlag = (int)button.tag-100;
    
    for (int i = 0; i<4; i++) {
        if (i !=levelFlag) {
            [((UILabel *)[self.view viewWithTag:100+i]) setTextColor:ZANGQING_COLOR];
            [((UILabel *)[self.view viewWithTag:100+i]) setBackgroundColor:WHITE_COLOR];
        }
    }
    [button setTextColor:WHITE_COLOR];
    [button setBackgroundColor:ZANGQING_COLOR];
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

