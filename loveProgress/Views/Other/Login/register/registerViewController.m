//
//  registerViewController.m
//  loveProgress
//
//  Created by 彭天浩 on 2018/1/9.
//  Copyright © 2018年 彭天浩. All rights reserved.
//

#import "registerViewController.h"
#import "MainTabBarControllerConfig.h"
#import "selectLevelViewController.h"

@interface registerViewController ()<UITextFieldDelegate>{
    UIView *navView;
    UILabel *phoneLabel;
    UILabel *verifyLabel;
    UILabel *phoneWrongLabel;
    UILabel *phoneNotExistLabel;
    UILabel *verifyWrongLabel;
    UILabel *verifyNotValidLabel;
    
    UILabel *verifyLabel2;
    UILabel *verifyWrongLabel2;
    UILabel *verifyNotValidLabel2;
    
    BOOL phoneValid;
    BOOL codeValid;
    BOOL codeValid2;
    BOOL same;
    BOOL exist;
}

@property (nonatomic,strong) UITextField *phoneText;
@property (nonatomic,strong) UITextField *verifyText;
@property (nonatomic,strong) UITextField *verifyText2;

@property (nonatomic,strong) UIButton *loginButton;

@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScreen];
    // Do any additional setup after loading the view.
}
-(void)setBasicScreen{
    phoneValid = NO;
    codeValid = NO;
    codeValid2 = NO;
    same = NO;
    exist = NO;
    [self.view setBackgroundColor:WHITE_COLOR];
    navView = [[UIView alloc] init];
    [navView setBackgroundColor:WHITE_COLOR];
    navView.layer.shadowColor = [UIColor grayColor].CGColor;
    navView.layer.shadowOffset = CGSizeMake(0,3);
    navView.layer.shadowOpacity = 0.8;
    navView.layer.shadowRadius = 2;
    [navView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, BEGIN_LINE_LARGE)];
    
    [self.view addSubview:navView];
    
    UILabel *navLabel = [[UILabel alloc] init];
    [navLabel setText:LOCAL(@"register")];
    [navLabel setFont:[UIFont systemFontOfSize:30]];
    [navLabel setTextAlignment:NSTextAlignmentLeft];
    [navLabel setFrame:CGRectMake(BEGIN_X, BEGIN_LINE_LARGE-44-10, SCREEN_WIDTH, 44)];
    
    [navView addSubview:navLabel];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyHiden:) name: UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)setScreen{
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
    
    phoneNotExistLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(lineView)+5, GETWIDTH(lineView), 15)];
    [phoneNotExistLabel setText:LOCAL(@"userNameExist")];
    [phoneNotExistLabel setTextColor:HONG_COLOR];
    [phoneNotExistLabel setFont:FONT(15)];
    phoneNotExistLabel.alpha = 0;
    [self.view addSubview:phoneNotExistLabel];
    
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
    _verifyText.keyboardType = UIKeyboardTypeNumberPad;
    _verifyText.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:_verifyText];
    [_verifyText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    verifyLabel = [[UILabel alloc] init];
    [verifyLabel setTextColor:[UIColor grayColor]];
    [verifyLabel setFont:[UIFont boldSystemFontOfSize:phoneLabel.font.pointSize]];
    if(_verifyText.text.length ==0){
        [verifyLabel setText:LOCAL(@"passwordPlease2")];
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
    
    
    _verifyText2 = [[UITextField alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(_verifyText)+50, GETWIDTH(_phoneText), NAV_NORMAL_HEIGHT)];
    _verifyText2.tag = 203;
    _verifyText2.delegate = self;
    _verifyText2.keyboardType = UIKeyboardTypeNumberPad;
    _verifyText2.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:_verifyText2];
    [_verifyText2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    verifyLabel2 = [[UILabel alloc] init];
    [verifyLabel2 setTextColor:[UIColor grayColor]];
    [verifyLabel2 setFont:[UIFont boldSystemFontOfSize:phoneLabel.font.pointSize]];
    if(_verifyText2.text.length ==0){
        [verifyLabel2 setText:LOCAL(@"passwordPleaseAgain")];
        [verifyLabel2 setFrame:CGRectMake(BEGIN_X, GETY(_verifyText2), GETWIDTH(_verifyText2), (GETHEIGHT(_verifyText2)))];
    }else{
        [verifyLabel2 setText:LOCAL(@"password")];
        verifyLabel2.frame = CGRectMake(BEGIN_X, GETY(_verifyText2)-30, GETWIDTH(_verifyText2), GETHEIGHT(_verifyText2));
    }
    [self.view addSubview:verifyLabel2];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(BEGIN_X,BUTTONY(_verifyText2) + 1, GETWIDTH(_verifyText2), 1)];
    lineView3.backgroundColor = ZANGQING_COLOR;
    [self.view addSubview:lineView3];
    

    verifyNotValidLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(lineView3)+5, GETWIDTH(lineView), 15)];
    [verifyNotValidLabel2 setText:LOCAL(@"passwordNotValid")];
    [verifyNotValidLabel2 setTextColor:HONG_COLOR];
    [verifyNotValidLabel2 setFont:FONT(15)];
    verifyNotValidLabel2.alpha = 0;
    [self.view addSubview:verifyNotValidLabel2];
    
    UILabel *registerLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(verifyNotValidLabel2)+10, SCREEN_WIDTH, GETHEIGHT(verifyLabel))];
    registerLabel.userInteractionEnabled = YES;
    registerLabel.text = LOCAL(@"loginNow");
    registerLabel.textColor = ZANGQING_COLOR;
    UITapGestureRecognizer *btnTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registerJump)];
    btnTapRecognizer.numberOfTapsRequired = 1;
    [registerLabel addGestureRecognizer:btnTapRecognizer];
    [self.view addSubview:registerLabel];
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-BEGIN_X-80, SCREEN_HEIGHT-NAV_NORMAL_HEIGHT-40, 80, NAV_NORMAL_HEIGHT)];
    [_loginButton setBackgroundColor:[UIColor grayColor]];
    _loginButton.layer.cornerRadius = 22;
    _loginButton.layer.masksToBounds=YES;
    [_loginButton setTitle:LOCAL(@"register") forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    verifyWrongLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(_loginButton.frame.origin.x-BEGIN_X-GETWIDTH(lineView3), GETY(_loginButton), GETWIDTH(lineView3), GETHEIGHT(_loginButton))];
    [verifyWrongLabel2 setText:LOCAL(@"inconsistent")];
    [verifyWrongLabel2 setTextColor:HONG_COLOR];
    [verifyWrongLabel2 setFont:FONT(15)];
    
    verifyWrongLabel2.textAlignment = NSTextAlignmentRight;
    verifyWrongLabel2.alpha = 0;
    [self.view addSubview:verifyWrongLabel2];
}

- (void)registerAction{
    [_phoneText resignFirstResponder];
    [_verifyText resignFirstResponder];
    [_verifyText2 resignFirstResponder];
    if (phoneValid && codeValid && codeValid2 && same) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AVUser *user = [AVUser user];
        user.username = _phoneText.text;
        user.password = _verifyText.text;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [hud hideAnimated:YES];
            if (succeeded) {
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

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 201){
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
    }else if(textField.tag == 203){
        [UIView animateWithDuration:0.3 animations:^{
            verifyLabel2.frame = CGRectMake(BEGIN_X, GETY(_verifyText2)-30, GETWIDTH(_verifyText2), GETHEIGHT(_verifyText2));
            [verifyLabel2 setText:LOCAL(@"password")];
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 201) {
        if(_phoneText.text.length == 0){
            //phoneWrongLabel.alpha = 0;
            phoneNotExistLabel.alpha = 0;
            phoneValid = NO;
            exist = NO;
            [UIView animateWithDuration:0.3 animations:^{
                [phoneLabel setText:LOCAL(@"userNamePlease")];
                phoneLabel.frame = CGRectMake(BEGIN_X, GETY(_phoneText), GETWIDTH(_phoneText), GETHEIGHT(_phoneText));
            } completion:^(BOOL finished) {
            }];
        }else{
            AVQuery *userQuery = [AVQuery queryWithClassName:@"_User"];
            [userQuery whereKey:@"username" equalTo:textField.text];
            [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error){
                    if(objects.count == 0){
                        phoneValid = YES;
                        exist = NO;
                        phoneNotExistLabel.alpha = 0;
                    }else{
                        phoneValid = NO;
                        exist = YES;
                        phoneNotExistLabel.alpha = 1;
                    }
                     [self checkAction];
                }
            }];
        }
    }
    
    if (textField.tag == 202) {
        if (textField.text.length < 6 || textField.text.length >20) {
            verifyNotValidLabel.alpha = 1;
            codeValid = NO;
        }else{
            verifyNotValidLabel.alpha = 0;
            codeValid = YES;
            if ([_verifyText.text isEqualToString:_verifyText2.text]) {
                verifyWrongLabel2.alpha = 0;
                same = YES;
            }else{
                verifyWrongLabel2.alpha = 1;
                same = NO;
            }
        }
        if(_verifyText.text.length == 0){
            [UIView animateWithDuration:0.3 animations:^{
                [verifyLabel setFrame:CGRectMake(BEGIN_X, GETY(_verifyText), GETWIDTH(_verifyText), (GETHEIGHT(_verifyText)))];
                [verifyLabel setText:LOCAL(@"passwordPlease2")];
            } completion:^(BOOL finished) {
            }];
        }
    }
    
    if (textField.tag == 203) {
        if (textField.text.length < 6 || textField.text.length >20) {
            verifyNotValidLabel2.alpha = 1;
            codeValid2 = NO;
        }else{
            verifyNotValidLabel2.alpha = 0;
            codeValid2 = YES;
            if ([_verifyText.text isEqualToString:_verifyText2.text]) {
                verifyWrongLabel2.alpha = 0;
                same = YES;
            }else{
                verifyWrongLabel2.alpha = 1;
                same = NO;
            }
        }
        
        if(_verifyText2.text.length == 0){
            [UIView animateWithDuration:0.3 animations:^{
                [verifyLabel2 setFrame:CGRectMake(BEGIN_X, GETY(_verifyText2), GETWIDTH(_verifyText2), (GETHEIGHT(_verifyText2)))];
                [verifyLabel2 setText:LOCAL(@"passwordPleaseAgain")];
            } completion:^(BOOL finished) {
            }];
        }
    }
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    [self checkAction];
}

- (void)checkAction{
    if(_phoneText.text.length >0 && _verifyText.text.length >= 6 &&_verifyText2.text.length <=20 && exist == NO){
        [_loginButton setBackgroundColor:ZANGQING_COLOR];
    }else{
        [_loginButton setBackgroundColor:[UIColor grayColor]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyHiden:(NSNotification *)notification {
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneText resignFirstResponder];
    [_verifyText resignFirstResponder];
    [_verifyText2 resignFirstResponder];
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
