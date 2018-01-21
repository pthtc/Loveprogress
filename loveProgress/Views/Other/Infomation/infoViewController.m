//
//  infoViewController.m
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/28.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import "infoViewController.h"
#import "WSDatePickerView.h"
#import "MainTabBarControllerConfig.h"

@interface infoViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,UITextViewDelegate>{
    UIView *navView;
    UIView *genderBackView;
    UILabel *navLabel;
    NSArray *hArray;
    NSArray *hArray2;
    
    UILabel *nickNameWrongLabel;
    UILabel *nickNameLabel;
    
    UILabel *dateShowLabel;
    UILabel *heartLabel;
    
}

@property(nonatomic,strong) UITextField *nickNameText;
@property(nonatomic,strong) UILabel *DateLabel;
@property(nonatomic,strong) UITextView *heartTextView;

@property (nonatomic,strong) UIButton *saveButton;


@end

@implementation infoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScreen];
    // Do any additional setup after loading the view.
}

-(void)setScreen{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.view setBackgroundColor:WHITE_COLOR];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyHiden:) name: UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    if (!_gender) {
        _gender = 0;
    }
    if (!_isJumpFromApp) {
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
        
        hArray = @[LOCAL(@"His"),LOCAL(@"Her"),LOCAL(@"Zir")];
        hArray2 = @[LOCAL(@"hiss"),LOCAL(@"hers"),LOCAL(@"zirs")];
        navLabel = [[UILabel alloc] init];
        
        [navLabel setText:[NSString stringWithFormat:@"%@%@",hArray[_gender],LOCAL(@"ziliao")]];
        
        [navLabel setFont:[UIFont systemFontOfSize:30]];
        [navLabel setTextAlignment:NSTextAlignmentLeft];
        if (!self.isJumpFromApp) {
            [navLabel setFrame:CGRectMake(BEGIN_X, BEGIN_LINE_LARGE-44-10, SCREEN_WIDTH, 44)];
        }else{
            [navLabel setFrame:CGRectMake(BEGIN_X, BEGIN_LINE_LARGE-64, SCREEN_WIDTH, 30)];
        }
        [navView addSubview:navLabel];
    }
    
    
    UILabel *genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BEGIN_LINE_LARGE+20, SCREEN_WIDTH, NAV_NORMAL_HEIGHT)];
    if (_isJumpFromApp) {
        [genderLabel setFrame:CGRectMake(BEGIN_X, BEGIN_LINE_NORMAL+20, SCREEN_WIDTH, NAV_NORMAL_HEIGHT)];
    }
    genderLabel.text = LOCAL(@"gender");
    [genderLabel setFont:BOLDFONT(genderLabel)];
    [genderLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:genderLabel];
    
    UIView *genderView = [[UIView alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(genderLabel), SCREEN_WIDTH-2*BEGIN_X, 30)];
    genderView.layer.cornerRadius = 15;
    genderView.layer.borderWidth = 1;
    genderView.layer.borderColor = ZANGQING_COLOR.CGColor;
    genderView.layer.masksToBounds = YES;
    [self.view addSubview:genderView];
    
    genderBackView = [[UIView alloc] init];
    [genderBackView setBackgroundColor:ZANGQING_COLOR];
    genderBackView.layer.cornerRadius = 15;
    genderBackView.layer.masksToBounds= YES;
    if(!_gender){
        [genderBackView setFrame:CGRectMake(BEGIN_X, GETY(genderView), GETWIDTH(genderView)/3, GETHEIGHT(genderView))];
    }else{
        [genderBackView setFrame:CGRectMake(BEGIN_X+_gender*GETWIDTH(genderView)/3, GETY(genderView), GETWIDTH(genderView)/3, GETHEIGHT(genderView))];
    }
    [self.view addSubview:genderBackView];
    
    
    NSArray *nameArr = @[LOCAL(@"Male"),LOCAL(@"Female"),LOCAL(@"LGBT")];
    for (int i = 0; i<3; i++) {
        UILabel *genderBtn = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X+i*GETWIDTH(genderView)/3, GETY(genderView), GETWIDTH(genderView)/3, GETHEIGHT(genderView))];
        UITapGestureRecognizer *btnTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(genderButton:)];
        btnTapRecognizer.numberOfTapsRequired = 1;
        btnTapRecognizer.delegate = self;
        [genderBtn addGestureRecognizer:btnTapRecognizer];
        [genderBtn setText:nameArr[i]];
        [genderBtn setTextColor:ZANGQING_COLOR];
        genderBtn.userInteractionEnabled = YES;
        genderBtn.tag = 100+i;
        genderBtn.textAlignment = NSTextAlignmentCenter;
        if (_gender == i) {
            [genderBtn setTextColor:WHITE_COLOR];
        }
        [self.view addSubview:genderBtn];
    }
    
    _nickNameText = [[UITextField alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(genderView)+30, SCREEN_WIDTH-2*BEGIN_X, NAV_NORMAL_HEIGHT)];
    _nickNameText.tag = 201;
    _nickNameText.delegate = self;
    _nickNameText.keyboardType = UIKeyboardTypeDefault;
    _nickNameText.autocorrectionType = UITextAutocorrectionTypeNo;
    if (_nickName) {
        [_nickNameText setText:_nickName];
    }
    [self.view addSubview:_nickNameText];
    [_nickNameText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(BEGIN_X,BUTTONY(_nickNameText) + 1, SCREEN_WIDTH-2*BEGIN_X, 1.2)];
    lineView.backgroundColor = ZANGQING_COLOR;
    
    [self.view addSubview:lineView];
    
    nickNameWrongLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(lineView)+5, GETWIDTH(lineView), 15)];
    [nickNameWrongLabel setText:LOCAL(@"nickWrong")];
    [nickNameWrongLabel setTextColor:MEIHONG_COLOR];
    [nickNameWrongLabel setFont:FONT(15)];
    nickNameWrongLabel.alpha = 0;
    [self.view addSubview:nickNameWrongLabel];
    
    nickNameLabel = [[UILabel alloc] init];
    [nickNameLabel setTextColor:[UIColor grayColor]];
    [nickNameLabel setFont:[UIFont boldSystemFontOfSize:nickNameLabel.font.pointSize]];
    if(!_nickName){
        [nickNameLabel setText:[NSString stringWithFormat:@"%@%@%@",LOCAL(@"nickNamePlease1"),LOCAL(@"hiss"),LOCAL(@"nickNamePlease2")]];
        [nickNameLabel setFrame:CGRectMake(BEGIN_X, GETY(_nickNameText), GETWIDTH(_nickNameText), (GETHEIGHT(_nickNameText)))];
    }else{
        [nickNameLabel setText:LOCAL(@"nickName")];
        nickNameLabel.frame = CGRectMake(BEGIN_X, GETY(_nickNameText)-30, GETWIDTH(_nickNameText), GETHEIGHT(_nickNameText));
    }
    [self.view addSubview:nickNameLabel];
    
    dateShowLabel = [[UILabel alloc] init];
    [dateShowLabel setTextColor:[UIColor grayColor]];
    [dateShowLabel setFont:[UIFont boldSystemFontOfSize:dateShowLabel.font.pointSize]];
    if(!_Date){
        [dateShowLabel setText:[NSString stringWithFormat:@"%@%@%@",LOCAL(@"birthdayPlease1"),LOCAL(@"hiss"),LOCAL(@"birthdayPlease2")]];
        [dateShowLabel setFrame:CGRectMake(BEGIN_X, BUTTONY(_nickNameText)+50, GETWIDTH(_nickNameText), (GETHEIGHT(_nickNameText)))];
    }else{
        [dateShowLabel setText:LOCAL(@"birthday")];
        dateShowLabel.frame = CGRectMake(BEGIN_X, BUTTONY(_nickNameText)+20, GETWIDTH(_nickNameText), GETHEIGHT(_nickNameText));
    }
    [self.view addSubview:dateShowLabel];
    
    _DateLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(_nickNameText)+50, SCREEN_WIDTH-2*BEGIN_X, NAV_NORMAL_HEIGHT)];
    _DateLabel.tag = 202;
    [self.view addSubview:_DateLabel];
    [_DateLabel setBackgroundColor:[UIColor clearColor]];
    _DateLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *dateTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateAction)];
    dateTapRecognizer.numberOfTapsRequired = 1;
    dateTapRecognizer.delegate = self;
    [_DateLabel addGestureRecognizer:dateTapRecognizer];
    if (_Date) {
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"yyyy-MM-dd"];//此处使用的formater格式要与字符串格式完全一致，否则转换失败
        //[formatter1 setTimeZone:[NSTimeZone localTimeZone]];
        [_DateLabel setText:[formatter1 stringFromDate:_Date]];
    }
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(BEGIN_X,BUTTONY(_DateLabel) + 1, SCREEN_WIDTH-2*BEGIN_X ,1.5)];
    lineView2.backgroundColor = ZANGQING_COLOR;
    [self.view addSubview:lineView2];
    
    heartLabel = [[UILabel alloc] init];
    heartLabel.numberOfLines = 2;
    [heartLabel setTextColor:[UIColor grayColor]];
    [heartLabel setFont:[UIFont boldSystemFontOfSize:heartLabel.font.pointSize]];
    if(!_Date){
        [heartLabel setText:LOCAL(@"firstReasonContent")];
        [heartLabel setFrame:CGRectMake(BEGIN_X+5, BUTTONY(_DateLabel)+50, GETWIDTH(_DateLabel), (GETHEIGHT(_DateLabel)))];
    }else{
        [_heartTextView setEditable:NO];
        [heartLabel setText:LOCAL(@"firstReason")];
        heartLabel.frame = CGRectMake(BEGIN_X, BUTTONY(_DateLabel)+20, GETWIDTH(_DateLabel), GETHEIGHT(_DateLabel));
    }
    heartLabel.numberOfLines = 0; ///相当于不限制行数
    [heartLabel sizeToFit];
    [self.view addSubview:heartLabel];
    
    _heartTextView = [[UITextView alloc] initWithFrame:CGRectMake(BEGIN_X,BUTTONY(_DateLabel)+50 , SCREEN_WIDTH-2*BEGIN_X, SCREEN_HEIGHT-(BUTTONY(_DateLabel)+50)-(NAV_NORMAL_HEIGHT+BEGIN_X+10))];
    _heartTextView.backgroundColor = [UIColor clearColor];
    _heartTextView.layer.borderColor = ZANGQING_COLOR.CGColor;
    _heartTextView.layer.borderWidth = 1.2;
    _heartTextView.delegate = self;
    [self.view addSubview:_heartTextView];
    if (_isJumpFromApp) {
        [_heartTextView setUserInteractionEnabled:NO];
    }
    if (_heart) {
        _heartTextView.text = _heart;
    }
    
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-BEGIN_X-80, SCREEN_HEIGHT-NAV_NORMAL_HEIGHT-BEGIN_X, 80, NAV_NORMAL_HEIGHT)];
    [_saveButton setBackgroundColor:[UIColor grayColor]];
    _saveButton.layer.cornerRadius = 22;
    _saveButton.layer.masksToBounds=YES;
    [_saveButton setTitle:LOCAL(@"save") forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
    
    [self checkFunction];
    //[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkFunction) userInfo:nil repeats:YES];
}

-(void)genderButton:(id)sender{
    [_heartTextView resignFirstResponder];
    [_nickNameText resignFirstResponder];
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UILabel *button =(UILabel *)tap.view;
    _gender = (int)button.tag-100;
    
    if (_nickNameText.text.length == 0) {
        [nickNameLabel setText:[NSString stringWithFormat:@"%@%@%@",LOCAL(@"nickNamePlease1"),hArray2[_gender],LOCAL(@"nickNamePlease2")]];
    }
    if (!_Date) {
        [dateShowLabel setText:[NSString stringWithFormat:@"%@%@%@",LOCAL(@"birthdayPlease1"),hArray2[_gender],LOCAL(@"birthdayPlease2")]];
    }
    for (int i = 0; i<3; i++) {
        if (i !=_gender) {
            [( (UILabel *)[self.view viewWithTag:100+i]) setTextColor:ZANGQING_COLOR];
        }
    }
    if ([globalFunction isChineseLanguage]) {
        [navLabel setText:[NSString stringWithFormat:@"%@%@",hArray[_gender],LOCAL(@"ziliao")]];
    }else{
        [navLabel setText:[NSString stringWithFormat:@"%@ %@",hArray[_gender],LOCAL(@"ziliao")]];
    }
    [self checkFunction];
    [UIView animateWithDuration:0.25 animations:^{
        [genderBackView setFrame:CGRectMake(BEGIN_X+_gender*GETWIDTH(button), GETY(button), GETWIDTH(button), GETHEIGHT(button))];
        [button setTextColor:WHITE_COLOR];
    } completion:^(BOOL finished) {
    }];
}

-(void)dateAction{
    [_heartTextView resignFirstResponder];
    [_nickNameText resignFirstResponder];
    if (!_Date) {
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
            _Date = selectDate;
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            NSLog(@"选择的年月日：%@",date);
            [_DateLabel setText:date];
            [self checkFunction];
            [UIView animateWithDuration:0.25 animations:^{
                dateShowLabel.frame = CGRectMake(BEGIN_X, BUTTONY(_nickNameText)+20, GETWIDTH(_nickNameText), GETHEIGHT(_nickNameText));
                [dateShowLabel setText:LOCAL(@"birthday")];
            } completion:^(BOOL finished) {
            }];
        }];
        datepicker.dateLabelColor = ZANGQING_COLOR;
        datepicker.datePickerColor = ZANGQING_COLOR;//滚轮日期颜色
        datepicker.doneButtonColor = ZANGQING_COLOR;//确定按钮的颜色
        datepicker.yearLabelColor = [UIColor clearColor];//大号年份字体颜色
        [datepicker show];
    }else{
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:@"yyyy-MM-dd"];
        NSDate *scrollToDate = _Date;
        
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            _Date = selectDate;
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            NSLog(@"选择的日期：%@",date);
            [_DateLabel setText:date];
            [self checkFunction];
        }];
        datepicker.dateLabelColor = ZANGQING_COLOR;
        datepicker.datePickerColor = ZANGQING_COLOR;//滚轮日期颜色
        datepicker.doneButtonColor = ZANGQING_COLOR;//确定按钮的颜色
        datepicker.yearLabelColor = [UIColor clearColor];//大号年份字体颜色
        [datepicker show];
    }
}

-(void)saveAction{
    [_nickNameText resignFirstResponder];
    [_heartTextView resignFirstResponder];
    
    if (_heart != nil && _Date!= nil &&_nickName!= nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AVUser *user = [AVUser currentUser];
        [user setObject:_nickName forKey:@"nickName"];
        [user setObject:_Date forKey:@"birthday"];
        [user setObject:@(YES) forKey:@"haveInfo"];
        [user setObject: [NSNumber numberWithInt:_gender] forKey:@"gender"];
        [user setObject:_heart forKey:@"chuxin"];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                if (_isJumpFromApp) {
                    [hud hideAnimated:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    AVObject *dateObject = [[AVObject alloc] initWithClassName:@"memory"];
                    [dateObject setObject:_Date forKey:@"date"];
                    [dateObject setObject:[NSString stringWithFormat:@"%@%@",_nickName,LOCAL(@"sbirthday")]  forKey:@"name"];
                    [dateObject setObject:[AVUser currentUser] forKey:@"owner"];
                    [dateObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSLog(@"生日保存成功");
                            [hud hideAnimated:YES];
                            [_saveButton setEnabled:YES];
                            MainTabBarControllerConfig *tabbarConfig = [[MainTabBarControllerConfig alloc]init];
                            CYLTabBarController *mainTabbarController = tabbarConfig.mainTabBarController;
                            [self presentViewController:mainTabbarController animated:YES completion:NULL];
                        }else{
                            NSLog(@"生日保存失败");
                            [hud hideAnimated:YES];
                            [_saveButton setEnabled:YES];
                            MainTabBarControllerConfig *tabbarConfig = [[MainTabBarControllerConfig alloc]init];
                            CYLTabBarController *mainTabbarController = tabbarConfig.mainTabBarController;
                            [self presentViewController:mainTabbarController animated:YES completion:NULL];
                        }
                    }];
                }
            }else{
                //[UIView showToast:@"资料保存失败"];
                [hud hideAnimated:YES];
                [_saveButton setEnabled:YES];
            }
        }];
        
    }
}

-(void)checkFunction{
    if (_heart != nil && _Date!= nil &&_nickName!= nil) {
        [_saveButton setBackgroundColor:ZANGQING_COLOR];
    }else{
        [_saveButton setBackgroundColor:[UIColor grayColor]];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 201) {
        [UIView animateWithDuration:0.3 animations:^{
            [nickNameLabel setText:LOCAL(@"nickName")];
            nickNameLabel.frame = CGRectMake(BEGIN_X, GETY(_nickNameText)-30, GETWIDTH(_nickNameText), GETHEIGHT(_nickNameText));
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 201) {
        if(textField.text.length == 0){
            nickNameWrongLabel.alpha = 1;
        }else{
            nickNameWrongLabel.alpha = 0;
        }
        if(textField.text.length == 0){
            [nickNameLabel setText:[NSString stringWithFormat:@"%@%@%@",LOCAL(@"nickNamePlease1"),hArray2[_gender],LOCAL(@"nickNamePlease2")]];
            [UIView animateWithDuration:0.3 animations:^{
                nickNameLabel.frame = CGRectMake(BEGIN_X, GETY(_nickNameText), GETWIDTH(_nickNameText), GETHEIGHT(_nickNameText));
            } completion:^(BOOL finished) {
            }];
        }
    }
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    if (theTextField.text.length!=0) {
        nickNameWrongLabel.alpha = 0;
        _nickName = theTextField.text;
    }else{
        _nickName = nil;
    }
    [self checkFunction];
}



-(void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.3 animations:^{
        [heartLabel setText:LOCAL(@"firstReason")];
        heartLabel.frame = CGRectMake(BEGIN_X, GETY(_heartTextView)-35, GETWIDTH(_heartTextView), GETHEIGHT(heartLabel));
    } completion:^(BOOL finished) {
    }];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if(textView.text.length == 0){
        //nickNameWrongLabel.alpha = 1;
    }else{
        //nickNameWrongLabel.alpha = 0;
    }
    if(textView.text.length == 0){
        [UIView animateWithDuration:0.3 animations:^{
            [heartLabel setText:LOCAL(@"firstReasonContent")];
            [heartLabel setFrame:CGRectMake(BEGIN_X+5, BUTTONY(_DateLabel)+50, GETWIDTH(_DateLabel), (GETHEIGHT(_DateLabel)))];
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    _heart = textView.text;
    if (_heart.length == 0) {
        _heart = nil;
    }
    [self checkFunction];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_nickNameText resignFirstResponder];
    [_heartTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyHiden:(NSNotification *)notification {
    // self.tooBar.frame = rect;
    if (_nickNameText.isFirstResponder == NO) {
        [UIView animateWithDuration:0.25 animations:^{
            //恢复原样
            self.view.transform = CGAffineTransformIdentity;
            //        commentView.hidden = YES;
        }];
    }
}

-(void)keyWillAppear:(NSNotification *)notification {
    //获得通知中的info字典
    if (_nickNameText.isFirstResponder == NO) {
        NSDictionary *userInfo = [notification userInfo];
        CGRect rect= [[userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
        // self.tooBar.frame = rect;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -([UIScreen mainScreen].bounds.size.height-rect.origin.y));
        }];
    }
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
