//
//  loginViewController.m
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/27.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import "loginViewController.h"
#import "NSString+LSCore.h"
#import "MainTabBarControllerConfig.h"
#import "selectLevelViewController.h"
#import "registerViewController.h"
@interface loginViewController ()<UITextFieldDelegate>{
    UIView *navView;
    UILabel *phoneLabel;
    UILabel *verifyLabel;
    UILabel *phoneWrongLabel;
    UILabel *phoneNotExistLabel;
    UILabel *verifyWrongLabel;
    UILabel *verifyNotValidLabel;
    
    BOOL phoneValid;
    BOOL codeValid;
}

@property (nonatomic,strong) UITextField *phoneText;
@property (nonatomic,strong) UITextField *verifyText;
@property (nonatomic,strong) UIButton *smsButton;

@property (nonatomic,strong) UIButton *loginButton;


@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    if([globalFunction isChineseLanguage]){
        [self setScreenForChinese];
//    }else{
//        [self setScreenForOther];
//    }
}

-(void) viewDidAppear:(BOOL)animated{
    
    //infoViewController *info = [[infoViewController alloc] init];
    //    info.gender = 1;
    //    info.nickName = @"PTH";
    //    info.Date = [NSDate date];
    //[self presentViewController:info animated:YES completion:NULL];
}

-(void)setBasicScreen{
    phoneValid = NO;
    codeValid = NO;
    [self.view setBackgroundColor:WHITE_COLOR];
    navView = [[UIView alloc] init];
    [navView setBackgroundColor:WHITE_COLOR];
    navView.layer.shadowColor = [UIColor grayColor].CGColor;
    navView.layer.shadowOffset = CGSizeMake(0,3);
    navView.layer.shadowOpacity = 0.8;
    navView.layer.shadowRadius = 2;
    if (!self.isJumpFromApp) {
        [navView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, BEGIN_LINE_LARGE)];
    }else{
        [navView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, BEGIN_LINE_LARGE)];
    }
    [self.view addSubview:navView];
    
    UILabel *navLabel = [[UILabel alloc] init];
    [navLabel setText:LOCAL(@"login")];
    [navLabel setFont:[UIFont systemFontOfSize:30]];
    [navLabel setTextAlignment:NSTextAlignmentLeft];
    if (!self.isJumpFromApp) {
        [navLabel setFrame:CGRectMake(BEGIN_X, BEGIN_LINE_LARGE-44-10, SCREEN_WIDTH, 44)];
    }else{
        [navLabel setFrame:CGRectMake(BEGIN_X, BEGIN_LINE_LARGE-64, SCREEN_WIDTH, 30)];
    }
    [navView addSubview:navLabel];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyHiden:) name: UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setScreenForChinese{
    [self setBasicScreen];
    
    _phoneText = [[UITextField alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(navView)+BEGIN_LINE_NORMAL, SCREEN_WIDTH-2*BEGIN_X, NAV_NORMAL_HEIGHT)];
    _phoneText.tag = 101;
    _phoneText.delegate = self;
    _phoneText.keyboardType = UIKeyboardTypeNumberPad;
    _phoneText.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:_phoneText];
    [_phoneText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(BEGIN_X,BUTTONY(_phoneText) + 1, SCREEN_WIDTH-2*BEGIN_X, 1)];
    lineView.backgroundColor = ZANGQING_COLOR;
    [self.view addSubview:lineView];
    
    phoneWrongLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(lineView)+5, GETWIDTH(lineView), 15)];
    [phoneWrongLabel setText:LOCAL(@"phoneWrong")];
    [phoneWrongLabel setTextColor:HONG_COLOR];
    [phoneWrongLabel setFont:FONT(15)];
    phoneWrongLabel.alpha = 0;
    [self.view addSubview:phoneWrongLabel];
    
    phoneNotExistLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(lineView)+5, GETWIDTH(lineView), 15)];
    [phoneNotExistLabel setText:LOCAL(@"phoneNotExist")];
    [phoneNotExistLabel setTextColor:GREEN_COLOR];
    [phoneNotExistLabel setFont:FONT(15)];
    phoneNotExistLabel.alpha = 0;
    [self.view addSubview:phoneNotExistLabel];
    
    phoneLabel = [[UILabel alloc] init];
    [phoneLabel setTextColor:[UIColor grayColor]];
    [phoneLabel setFont:[UIFont boldSystemFontOfSize:phoneLabel.font.pointSize]];
    if(_phoneText.text.length ==0){
        [phoneLabel setText:LOCAL(@"phoneNumPlease")];
        [phoneLabel setFrame:CGRectMake(BEGIN_X, GETY(_phoneText), GETWIDTH(_phoneText), (GETHEIGHT(_phoneText)))];
    }else{
        [phoneLabel setText:LOCAL(@"phoneNum")];
        phoneLabel.frame = CGRectMake(BEGIN_X, GETY(_phoneText)-30, GETWIDTH(_phoneText), GETHEIGHT(_phoneText));
    }
    [self.view addSubview:phoneLabel];
    
    _verifyText = [[UITextField alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(_phoneText)+50, SCREEN_WIDTH/2, NAV_NORMAL_HEIGHT)];
    _verifyText.tag = 102;
    _verifyText.delegate = self;
    _verifyText.keyboardType = UIKeyboardTypeNumberPad;
    _verifyText.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:_verifyText];
    [_verifyText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    verifyLabel = [[UILabel alloc] init];
    [verifyLabel setTextColor:[UIColor grayColor]];
    [verifyLabel setFont:[UIFont boldSystemFontOfSize:phoneLabel.font.pointSize]];
    if(_verifyText.text.length ==0){
        [verifyLabel setText:LOCAL(@"verifyNumPlease")];
        [verifyLabel setFrame:CGRectMake(BEGIN_X, GETY(_verifyText), GETWIDTH(_verifyText), (GETHEIGHT(_verifyText)))];
    }else{
        [verifyLabel setText:LOCAL(@"verifyNum")];
        verifyLabel.frame = CGRectMake(BEGIN_X, GETY(_verifyText)-30, GETWIDTH(_verifyText), GETHEIGHT(_verifyText));
    }
    [self.view addSubview:verifyLabel];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(BEGIN_X,BUTTONY(_verifyText) + 1, GETWIDTH(_verifyText), 1)];
    lineView2.backgroundColor = ZANGQING_COLOR;
    [self.view addSubview:lineView2];
    
    verifyWrongLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(lineView2)+5, GETWIDTH(lineView), 15)];
    [verifyWrongLabel setText:LOCAL(@"codeWrong")];
    [verifyWrongLabel setTextColor:HONG_COLOR];
    [verifyWrongLabel setFont:FONT(15)];
    verifyWrongLabel.alpha = 0;
    [self.view addSubview:verifyWrongLabel];
    
    verifyNotValidLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(lineView2)+5, GETWIDTH(lineView), 15)];
    [verifyNotValidLabel setText:LOCAL(@"codeNotValid")];
    [verifyNotValidLabel setTextColor:HONG_COLOR];
    [verifyNotValidLabel setFont:FONT(15)];
    verifyNotValidLabel.alpha = 0;
    [self.view addSubview:verifyNotValidLabel];
    
    _smsButton = [[UIButton alloc] initWithFrame:CGRectMake(_verifyText.frame.origin.x+GETWIDTH(_verifyText)+BEGIN_X, GETY(_verifyText), SCREEN_WIDTH-_verifyText.frame.origin.x-GETWIDTH(_verifyText)-BEGIN_X*2, GETHEIGHT(_verifyText))];
    [_smsButton setBackgroundColor:[UIColor clearColor]];
    [_smsButton setTitleColor:ZANGQING_COLOR forState:UIControlStateNormal];
    _smsButton.layer.cornerRadius = 22;
    _smsButton.layer.borderWidth = 1;
    _smsButton.layer.borderColor = ZANGQING_COLOR.CGColor;
    _smsButton.layer.masksToBounds=YES;
    //_smsButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_smsButton setTitle:LOCAL(@"verifyNumSend") forState:UIControlStateNormal];
    [_smsButton addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_smsButton];
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-BEGIN_X-80, SCREEN_HEIGHT-NAV_NORMAL_HEIGHT-40, 80, NAV_NORMAL_HEIGHT)];
    [_loginButton setBackgroundColor:[UIColor grayColor]];
    _loginButton.layer.cornerRadius = 22;
    _loginButton.layer.masksToBounds=YES;
    [_loginButton setTitle:LOCAL(@"login") forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    //    _phoneText.text = @"18858180408";
    //    _verifyText.text = @"012790";
    
    
}

- (void)setScreenForOther{
    [self setBasicScreen];
    
    _phoneText = [[UITextField alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(navView)+BEGIN_LINE_NORMAL, SCREEN_WIDTH-2*BEGIN_X, NAV_NORMAL_HEIGHT)];
    _phoneText.tag = 201;
    _phoneText.delegate = self;
    _phoneText.keyboardType = UIKeyboardTypeNumberPad;
    _phoneText.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:_phoneText];
    [_phoneText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(BEGIN_X,BUTTONY(_phoneText) + 1, SCREEN_WIDTH-2*BEGIN_X, 1)];
    lineView.backgroundColor = ZANGQING_COLOR;
    [self.view addSubview:lineView];
    
    phoneWrongLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(lineView)+5, GETWIDTH(lineView), 15)];
    [phoneWrongLabel setText:LOCAL(@"phoneWrong")];
    [phoneWrongLabel setTextColor:HONG_COLOR];
    [phoneWrongLabel setFont:FONT(15)];
    phoneWrongLabel.alpha = 0;
    [self.view addSubview:phoneWrongLabel];
    
    phoneLabel = [[UILabel alloc] init];
    [phoneLabel setTextColor:[UIColor grayColor]];
    [phoneLabel setFont:[UIFont boldSystemFontOfSize:phoneLabel.font.pointSize]];
    if(_phoneText.text.length ==0){
        [phoneLabel setText:LOCAL(@"userNamePlease")];
        [phoneLabel setFrame:CGRectMake(BEGIN_X, GETY(_phoneText), GETWIDTH(_phoneText), (GETHEIGHT(_phoneText)))];
    }else{
        [phoneLabel setText:LOCAL(@"userName")];
        phoneLabel.frame = CGRectMake(BEGIN_X, GETY(_phoneText)-30, GETWIDTH(_phoneText), GETHEIGHT(_phoneText));
    }
    [self.view addSubview:phoneLabel];
    
    _verifyText = [[UITextField alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(_phoneText)+50, GETWIDTH(_phoneText), NAV_NORMAL_HEIGHT)];
    _verifyText.tag = 202;
    _verifyText.delegate = self;
    _verifyText.secureTextEntry = YES;
//    _verifyText.keyboardType = UIKeyboardTypeNumberPad;
    _verifyText.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:_verifyText];
    [_verifyText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    verifyLabel = [[UILabel alloc] init];
    [verifyLabel setTextColor:[UIColor grayColor]];
    [verifyLabel setFont:[UIFont boldSystemFontOfSize:phoneLabel.font.pointSize]];
    if(_verifyText.text.length ==0){
        [verifyLabel setText:LOCAL(@"passwordPlease")];
        [verifyLabel setFrame:CGRectMake(BEGIN_X, GETY(_verifyText), GETWIDTH(_verifyText), (GETHEIGHT(_verifyText)))];
    }else{
        [verifyLabel setText:LOCAL(@"password")];
        verifyLabel.frame = CGRectMake(BEGIN_X, GETY(_verifyText)-30, GETWIDTH(_verifyText), GETHEIGHT(_verifyText));
    }
    [self.view addSubview:verifyLabel];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(BEGIN_X,BUTTONY(_verifyText) + 1, GETWIDTH(_verifyText), 1)];
    lineView2.backgroundColor = ZANGQING_COLOR;
    [self.view addSubview:lineView2];
    
    verifyWrongLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(lineView2)+5, GETWIDTH(lineView), 15)];
    [verifyWrongLabel setText:LOCAL(@"passwordWrong")];
    [verifyWrongLabel setTextColor:HONG_COLOR];
    [verifyWrongLabel setFont:FONT(15)];
    verifyWrongLabel.alpha = 0;
    [self.view addSubview:verifyWrongLabel];
    
    verifyNotValidLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(lineView2)+5, GETWIDTH(lineView), 15)];
    [verifyNotValidLabel setText:LOCAL(@"passwordNotValid")];
    [verifyNotValidLabel setTextColor:HONG_COLOR];
    [verifyNotValidLabel setFont:FONT(15)];
    verifyNotValidLabel.alpha = 0;
    [self.view addSubview:verifyNotValidLabel];
    
    UILabel *registerLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(verifyNotValidLabel)+10, SCREEN_WIDTH, GETHEIGHT(verifyLabel))];
    registerLabel.userInteractionEnabled = YES;
    registerLabel.text = LOCAL(@"registerNow");
    registerLabel.textColor = ZANGQING_COLOR;
    UITapGestureRecognizer *btnTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registerJump)];
    btnTapRecognizer.numberOfTapsRequired = 1;
    [registerLabel addGestureRecognizer:btnTapRecognizer];
    [self.view addSubview:registerLabel];
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-BEGIN_X-80, SCREEN_HEIGHT-NAV_NORMAL_HEIGHT-40, 80, NAV_NORMAL_HEIGHT)];
    [_loginButton setBackgroundColor:[UIColor grayColor]];
    _loginButton.layer.cornerRadius = 22;
    _loginButton.layer.masksToBounds=YES;
    [_loginButton setTitle:LOCAL(@"login") forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginActionForOther) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
}

-(void)sendSMS{
    //[_smsButton setBackgroundColor:[UIColor grayColor]];
    [_phoneText resignFirstResponder];
    [_verifyText resignFirstResponder];
    if(phoneValid){
        if([_phoneText.text isEqualToString:@"18858180408"]){
            [UIView showToast:@"012790"];
        }else{
            AVShortMessageRequestOptions *options = [[AVShortMessageRequestOptions alloc] init];
            options.TTL = 10;                      // 验证码有效时间为 10 分钟
            options.applicationName = @"恋爱进度条";  // 应用名称
            options.operation = @"登录/注册";        // 操作名称
            [AVSMS requestShortMessageForPhoneNumber:_phoneText.text
                                             options:options
                                            callback:^(BOOL succeeded, NSError * _Nullable error) {
                                                if (succeeded) {
                                                    [self startTime];
                                                    _smsButton.enabled = NO;
                                                } else {
                                                    [UIView showToast:@"短信发送失败"];
                                                }
                                            }];
        }
    }else{
        [UIView showToast:@"发送失败"];
    }
}

-(void)loginAction{
    [_phoneText resignFirstResponder];
    [_verifyText resignFirstResponder];
    if (phoneValid && codeValid) {
        NSLog(@"中文登录");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:_phoneText.text smsCode:_verifyText.text block:^(AVUser *user, NSError *error) {
            // 如果 error 为空就可以表示登录成功了，并且 user 是一个全新的用户
            NSLog(@"%@",error);
            [hud hideAnimated:YES];
            if (!error) {
                
                NSLog(@"login done%@", user.username);
                NSLog(@"have info == %@",[user objectForKey:@"haveInfo"]);
                if ([[user objectForKey:@"haveInfo"] isEqual: @1]) {
                    MainTabBarControllerConfig *tabbarConfig = [[MainTabBarControllerConfig alloc]init];
                    CYLTabBarController *mainTabbarController = tabbarConfig.mainTabBarController;
                    [self presentViewController:mainTabbarController animated:YES completion:NULL];
                }else{
                    selectLevelViewController *select = [[selectLevelViewController alloc] init];
                    [self presentViewController:select animated:YES completion:NULL];
                }
            }else{
                [UIView showToast:LOCAL(@"fail")];
            }
        }];
    }
}

- (void)loginActionForOther{
    [_phoneText resignFirstResponder];
    [_verifyText resignFirstResponder];
    if (phoneValid && codeValid) {
        NSLog(@"英文登录");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [AVUser logInWithUsernameInBackground:_phoneText.text password:_verifyText.text block:^(AVUser *user, NSError *error) {
            [hud hideAnimated:YES];
            if (user != nil) {
                NSLog(@"login done%@", user.username);
                NSLog(@"have info == %@",[user objectForKey:@"haveInfo"]);
                if ([[user objectForKey:@"haveInfo"] isEqual: @1]) {
                    MainTabBarControllerConfig *tabbarConfig = [[MainTabBarControllerConfig alloc]init];
                    CYLTabBarController *mainTabbarController = tabbarConfig.mainTabBarController;
                    [self presentViewController:mainTabbarController animated:YES completion:NULL];
                }else{
                    selectLevelViewController *select = [[selectLevelViewController alloc] init];
                    [self presentViewController:select animated:YES completion:NULL];
                }
            } else {
                [UIView showToast:LOCAL(@"fail")];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 101) {
        [UIView animateWithDuration:0.3 animations:^{
            [phoneLabel setText:LOCAL(@"phoneNum")];
            phoneLabel.frame = CGRectMake(BEGIN_X, GETY(_phoneText)-30, GETWIDTH(_phoneText), GETHEIGHT(_phoneText));
        } completion:^(BOOL finished) {
        }];
    }else if (textField.tag == 102){
        [UIView animateWithDuration:0.3 animations:^{
            verifyLabel.frame = CGRectMake(BEGIN_X, GETY(_verifyText)-30, GETWIDTH(_verifyText), GETHEIGHT(_verifyText));
            [verifyLabel setText:LOCAL(@"verifyNum")];
        } completion:^(BOOL finished) {
        }];
    }else if (textField.tag == 201){
        [UIView animateWithDuration:0.3 animations:^{
            [phoneLabel setText:LOCAL(@"userName")];
            phoneLabel.frame = CGRectMake(BEGIN_X, GETY(_phoneText)-30, GETWIDTH(_phoneText), GETHEIGHT(_phoneText));
        } completion:^(BOOL finished) {
        }];
    }else if (textField.tag == 202){
        [UIView animateWithDuration:0.3 animations:^{
            verifyLabel.frame = CGRectMake(BEGIN_X, GETY(_verifyText)-30, GETWIDTH(_verifyText), GETHEIGHT(_verifyText));
            [verifyLabel setText:LOCAL(@"password")];
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 101) {
        if(![textField.text isTelephone]){
            phoneWrongLabel.alpha = 1;
            phoneNotExistLabel.alpha = 0;
            phoneValid = NO;
        }else{
            phoneValid = YES;
            phoneWrongLabel.alpha = 0;
            AVQuery *userQuery = [AVQuery queryWithClassName:@"_User"];
            [userQuery whereKey:@"username" equalTo:textField.text];
            [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error){
                    if(objects.count == 0){
                        phoneNotExistLabel.alpha = 1;
                    }else{
                        phoneNotExistLabel.alpha = 0;
                    }
                }
            }];
        }
        if(_phoneText.text.length == 0){
            //phoneWrongLabel.alpha = 0;
            [UIView animateWithDuration:0.3 animations:^{
                [phoneLabel setText:LOCAL(@"passwordPlease")];
                phoneLabel.frame = CGRectMake(BEGIN_X, GETY(_phoneText), GETWIDTH(_phoneText), GETHEIGHT(_phoneText));
            } completion:^(BOOL finished) {
            }];
        }
    }
    if (textField.tag == 102) {
        if (![textField.text isValidZipcode]) {
            verifyNotValidLabel.alpha = 1;
            codeValid = NO;
        }else{
            verifyNotValidLabel.alpha = 0;
            codeValid = YES;
        }
        if(_verifyText.text.length == 0){
            [UIView animateWithDuration:0.3 animations:^{
                [verifyLabel setFrame:CGRectMake(BEGIN_X, GETY(_verifyText), GETWIDTH(_verifyText), (GETHEIGHT(_verifyText)))];
                [verifyLabel setText:LOCAL(@"verifyNumPlease")];
            } completion:^(BOOL finished) {
            }];
        }
    }
    if (textField.tag == 201) {
        if(_phoneText.text.length == 0){
            //phoneWrongLabel.alpha = 0;
            phoneValid = NO;
            [UIView animateWithDuration:0.3 animations:^{
                [phoneLabel setText:LOCAL(@"userNamePlease")];
                phoneLabel.frame = CGRectMake(BEGIN_X, GETY(_phoneText), GETWIDTH(_phoneText), GETHEIGHT(_phoneText));
            } completion:^(BOOL finished) {
            }];
        }else{
            phoneValid = YES;
        }
    }
    
    if (textField.tag == 202) {
        if (textField.text.length < 6 || textField.text.length >20) {
            verifyNotValidLabel.alpha = 1;
            codeValid = NO;
        }else{
            verifyNotValidLabel.alpha = 0;
            codeValid = YES;
        }
        if(_verifyText.text.length == 0){
            [UIView animateWithDuration:0.3 animations:^{
                [verifyLabel setFrame:CGRectMake(BEGIN_X, GETY(_verifyText), GETWIDTH(_verifyText), (GETHEIGHT(_verifyText)))];
                [verifyLabel setText:LOCAL(@"passwordPlease")];
            } completion:^(BOOL finished) {
            }];
        }
    }
}

/*userName = "User Name";
 userNamePlease = "Please enter your user name";
 password = "Password";
 passwordPlease = "Please enter your password";
 passwordWrong = "Wrong user name or password";
 passwordNotValid = "Not valid password";*/

-(void)textFieldDidChange :(UITextField *)theTextField{
    if (theTextField.tag == 101 || theTextField.tag == 102) {
        verifyNotValidLabel.alpha = 0;
        phoneWrongLabel.alpha = 0;
        if([_phoneText.text isTelephone] && [_verifyText.text isValidZipcode]){
            [_loginButton setBackgroundColor:ZANGQING_COLOR];
        }else{
            [_loginButton setBackgroundColor:[UIColor grayColor]];
        }
    }else{
        if(_phoneText.text.length >0 && _verifyText.text.length >= 6 &&_verifyText.text.length <=20){
            [_loginButton setBackgroundColor:ZANGQING_COLOR];
        }else{
            [_loginButton setBackgroundColor:[UIColor grayColor]];
        }
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneText resignFirstResponder];
    [_verifyText resignFirstResponder];
}

-(void)startTime{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_smsButton setTitle:LOCAL(@"verifyNumSend") forState:UIControlStateNormal];
                _smsButton.userInteractionEnabled = YES;
                [_smsButton setBackgroundColor:[UIColor clearColor]];
                _smsButton.enabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_smsButton setTitle:[NSString stringWithFormat:@"%@ s",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _smsButton.userInteractionEnabled = NO;
                //[_smsButton setBackgroundColor:[UIColor grayColor]];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

-(void)keyHiden:(NSNotification *)notification
{
    // self.tooBar.frame = rect;
    [UIView animateWithDuration:0.25 animations:^{
        //恢复原样
        _loginButton.transform = CGAffineTransformIdentity;
        //        commentView.hidden = YES;
    }];
    
    
}
-(void)keyWillAppear:(NSNotification *)notification {
    //获得通知中的info字典
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect= [[userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
    // self.tooBar.frame = rect;
    [UIView animateWithDuration:0.25 animations:^{
        _loginButton.transform = CGAffineTransformMakeTranslation(0, -([UIScreen mainScreen].bounds.size.height-rect.origin.y));
    }];
}

- (void)registerJump{
    registerViewController *re = [[registerViewController alloc] init];
    [self presentViewController:re animated:YES completion:NULL];
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
