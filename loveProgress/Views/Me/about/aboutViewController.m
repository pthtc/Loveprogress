//
//  aboutViewController.m
//  loveProgress
//
//  Created by 彭天浩 on 2018/1/4.
//  Copyright © 2018年 彭天浩. All rights reserved.
//

#import "aboutViewController.h"
#import "XWScanImage.h"
#import <MessageUI/MessageUI.h>
@interface aboutViewController ()<UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate>
@property (strong, nonatomic)  UIImageView *logo;
@property (strong, nonatomic)  UILabel *versionLabel;
@end

@implementation aboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScreen];
    // Do any additional setup after loading the view.
    
}

-(void)setScreen{
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.tabBarController.tabBar.hidden = YES;
    self.title =LOCAL(@"about");
    [self.view setBackgroundColor:WHITE_COLOR];
    _logo = [[UIImageView alloc] initWithImage:[globalFunction scaleToSize:[UIImage imageNamed:@"icon.png"] size:CGSizeMake(SCREEN_WIDTH/4, SCREEN_WIDTH/4)]];
    [self.view addSubview:_logo];
//    _logo.layer.cornerRadius=_logo.frame.size.width/8;//裁成圆角
//    _logo.layer.masksToBounds=YES;//隐藏裁剪掉的部分
//    _logo.layer.borderWidth = 1.5f;//边框宽度
//    _logo.layer.borderColor = [UIColor blackColor].CGColor;//边框颜色
    
    _logo.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4);
    _logo.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/4.6);
    
    
    _versionLabel = [[UILabel alloc] init];
    _versionLabel.text = @"V1.0";
    _versionLabel.numberOfLines = 3;
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    _versionLabel.textColor = ZANGQING_COLOR;
    _versionLabel.font =[UIFont systemFontOfSize:30];
    _versionLabel.font = BOLDFONT(_versionLabel);
    _versionLabel.frame = CGRectMake(0, _logo.frame.origin.y+_logo.frame.size.height*1.1, SCREEN_WIDTH, SCREEN_WIDTH/6);
    _versionLabel.center = CGPointMake(SCREEN_WIDTH/2, _versionLabel.center.y);
    [self.view addSubview:_versionLabel];
    
    NSArray *btnArray;
    if ([globalFunction isChineseLanguage]) {
        btnArray = @[LOCAL(@"emailme"),LOCAL(@"donate")];
    }else{
        btnArray = @[LOCAL(@"emailme")];
    }
    
    for (int i = 0; i<btnArray.count; i++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, BUTTONY(_versionLabel)+5+(5+BEGIN_LINE_NORMAL)*i, SCREEN_WIDTH, BEGIN_LINE_NORMAL)];
        backView.backgroundColor = WHITE_COLOR;
        backView.tag =200+i;
        UITapGestureRecognizer *buttonTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonAction:)];
        buttonTapRecognizer.numberOfTapsRequired = 1;
        buttonTapRecognizer.delegate = self;
        [backView addGestureRecognizer:buttonTapRecognizer];
        [self.view addSubview:backView];
        
        UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BEGIN_LINE_NORMAL)];
        buttonLabel.text = btnArray[i];
        buttonLabel.textColor = ZANGQING_COLOR;
        [buttonLabel setFont:FONT(20)];
        [buttonLabel setFont:BOLDFONT(buttonLabel)];
        buttonLabel.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:buttonLabel];
    }
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.textColor = [UIColor grayColor];
    phoneLabel.font = [UIFont systemFontOfSize:10];
    phoneLabel.text = [NSString stringWithFormat:@"For ZiQiu"];
    [self.view addSubview:phoneLabel];
}

-(void)buttonAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UILabel *btnview =(UILabel *)tap.view;
    if (btnview.tag == 200) {
        
        if ([MFMailComposeViewController canSendMail]) {
            [self sendEmailAction]; // 调用发送邮件的代码
        }else{
            //给出提示,设备未开启邮件服务
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = @"pengtianhao48@gmail.com";
            [UIView showToast:LOCAL(@"emailFail")];
        }
    }else if (btnview.tag == 201){
        [XWScanImage scanBigImageWithImage:[UIImage imageNamed:@"donate"] frame:self.view.bounds];
    }
}

-(void)sendEmailAction{
    // 创建邮件发送界面
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置收件人
    [mailCompose setToRecipients:@[@"pengtianhao48@gmail.com"]];
    // 设置邮件主题
    [mailCompose setSubject:@"[Love Progress] "];
    //设置邮件的正文内容
    NSString *emailContent = @"";
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];

    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [self dismissModalViewControllerAnimated:YES];
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
