//
//  xingdongDetailViewController.m
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/30.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import "xingdongDetailViewController.h"
#import "WSDatePickerView.h"
@interface xingdongDetailViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,UITextViewDelegate>{
    UILabel *jinianNameWrongLabel;
    UILabel *jinianNameLabel;
    
    UILabel *dateShowLabel;
    UILabel *contentLabel;
    BOOL isUpLoad;
}

@property(nonatomic,strong) UITextField *jinianNameText;
@property (nonatomic,strong) UIButton *saveButton;
@property(nonatomic,strong) UILabel *DateLabel;
@property(nonatomic,strong) UITextView *contentTextView;

@end

@implementation xingdongDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScreen];
    // Do any additional setup after loading the view.
}

-(void)setScreen{
    isUpLoad = NO;
    //self.title = LOCAL(@"jinian");
    [self.view setBackgroundColor:WHITE_COLOR];
    
    _jinianNameText = [[UITextField alloc] initWithFrame:CGRectMake(BEGIN_X, BEGIN_LINE_NORMAL*2, SCREEN_WIDTH-2*BEGIN_X, NAV_NORMAL_HEIGHT)];
    _jinianNameText.tag = 201;
    _jinianNameText.delegate = self;
    _jinianNameText.keyboardType = UIKeyboardTypeDefault;
    _jinianNameText.autocorrectionType = UITextAutocorrectionTypeNo;
    if (_jinianName) {
        [_jinianNameText setText:_jinianName];
    }
    [self.view addSubview:_jinianNameText];
    [_jinianNameText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(BEGIN_X,BUTTONY(_jinianNameText) + 1, SCREEN_WIDTH-2*BEGIN_X, 1.2)];
    lineView.backgroundColor = ZANGQING_COLOR;
    [self.view addSubview:lineView];
    /*
     actionDatePlease = "请选择日期";
     actionNameWrong = "行动名称不能为空";
     actionContent = "行动内容";
     ContentPlease = "请输入行动内容";*/
    jinianNameLabel = [[UILabel alloc] init];
    [jinianNameLabel setTextColor:[UIColor grayColor]];
    [jinianNameLabel setFont:[UIFont boldSystemFontOfSize:jinianNameLabel.font.pointSize]];
    if(!_jinianName){
        [jinianNameLabel setText:[NSString stringWithFormat:@"%@",LOCAL(@"actionNamePlease")]];
        [jinianNameLabel setFrame:CGRectMake(BEGIN_X, GETY(_jinianNameText), GETWIDTH(_jinianNameText), (GETHEIGHT(_jinianNameText)))];
    }else{
        [jinianNameLabel setText:LOCAL(@"actionName")];
        jinianNameLabel.frame = CGRectMake(BEGIN_X, GETY(_jinianNameText)-30, GETWIDTH(_jinianNameText), GETHEIGHT(_jinianNameText));
    }
    [self.view addSubview:jinianNameLabel];
    
    jinianNameWrongLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(lineView)+5, GETWIDTH(lineView), 15)];
    [jinianNameWrongLabel setText:LOCAL(@"actionNameWrong")];
    [jinianNameWrongLabel setTextColor:MEIHONG_COLOR];
    [jinianNameWrongLabel setFont:FONT(15)];
    jinianNameWrongLabel.alpha = 0;
    [self.view addSubview:jinianNameWrongLabel];
    
    dateShowLabel = [[UILabel alloc] init];
    [dateShowLabel setTextColor:[UIColor grayColor]];
    [dateShowLabel setFont:[UIFont boldSystemFontOfSize:dateShowLabel.font.pointSize]];
    if(!_Date){
        [dateShowLabel setText:LOCAL(@"actionDatePlease")];
        [dateShowLabel setFrame:CGRectMake(BEGIN_X, BUTTONY(_jinianNameText)+50, GETWIDTH(_jinianNameText), (GETHEIGHT(_jinianNameText)))];
    }else{
        [dateShowLabel setText:LOCAL(@"actionDate")];
        dateShowLabel.frame = CGRectMake(BEGIN_X, BUTTONY(_jinianNameText)+20, GETWIDTH(_jinianNameText), GETHEIGHT(_jinianNameText));
    }
    [self.view addSubview:dateShowLabel];
    
    _DateLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(_jinianNameText)+50, SCREEN_WIDTH-2*BEGIN_X, NAV_NORMAL_HEIGHT)];
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
    
    contentLabel = [[UILabel alloc] init];
    [contentLabel setTextColor:[UIColor grayColor]];
    [contentLabel setFont:[UIFont boldSystemFontOfSize:contentLabel.font.pointSize]];
    if(!_jinianContent){
        [contentLabel setText:LOCAL(@"ContentPlease")];
        [contentLabel setFrame:CGRectMake(BEGIN_X+5, BUTTONY(_DateLabel)+50, GETWIDTH(_DateLabel), (GETHEIGHT(_DateLabel)))];
    }else{
        [contentLabel setText:LOCAL(@"actionContent")];
        contentLabel.frame = CGRectMake(BEGIN_X, BUTTONY(_DateLabel)+20, GETWIDTH(_DateLabel), GETHEIGHT(_DateLabel));
    }
    contentLabel.numberOfLines = 0; ///相当于不限制行数
    [contentLabel sizeToFit];
    [self.view addSubview:contentLabel];
    
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(BEGIN_X,BUTTONY(_DateLabel)+50 , SCREEN_WIDTH-2*BEGIN_X, SCREEN_HEIGHT-(BUTTONY(_DateLabel)+50)-(NAV_NORMAL_HEIGHT+BEGIN_X+10))];
    _contentTextView.backgroundColor = [UIColor clearColor];
    _contentTextView.layer.borderColor = ZANGQING_COLOR.CGColor;
    _contentTextView.layer.borderWidth = 1.2;
    _contentTextView.delegate = self;
    [self.view addSubview:_contentTextView];
    
    if (_jinianContent) {
        _contentTextView.text = _jinianContent;
    }
    
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-BEGIN_X-80, SCREEN_HEIGHT-NAV_NORMAL_HEIGHT-BEGIN_X, 80, NAV_NORMAL_HEIGHT)];
    [_saveButton setBackgroundColor:[UIColor grayColor]];
    _saveButton.layer.cornerRadius = 22;
    _saveButton.layer.masksToBounds=YES;
    [_saveButton setTitle:LOCAL(@"save") forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
    [self checkFunction];
    
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    if (theTextField.text.length!=0) {
        jinianNameWrongLabel.alpha = 0;
        _jinianName = theTextField.text;
    }else{
        _jinianName = nil;
    }
    [self checkFunction];
}

-(void)checkFunction{
    if (_jinianName != nil && _Date!= nil) {
        [_saveButton setBackgroundColor:ZANGQING_COLOR];
    }else{
        [_saveButton setBackgroundColor:[UIColor grayColor]];
    }
}

-(void)saveAction{
    [_jinianNameText resignFirstResponder];
    [_contentTextView resignFirstResponder];
    [_saveButton setEnabled:NO];
    if (_Date!= nil && _jinianName!= nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        if(_avID){
            AVObject *dateObject =[AVObject objectWithClassName:@"things" objectId:_avID];
            [dateObject setObject:_Date forKey:@"date"];
            [dateObject setObject:_jinianName forKey:@"name"];
            [dateObject setObject:_jinianContent forKey:@"remark"];
            [dateObject setObject:[AVUser currentUser] forKey:@"owner"];
            [dateObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [hud hideAnimated:YES];
                if (succeeded) {
                    _avID =dateObject.objectId;
                    isUpLoad = YES;
                    [self.navigationController popViewControllerAnimated:YES];
                    //[UIView showToast:LOCAL(@"succeed")];
                }else{
                    [UIView showToast:LOCAL(@"fail")];
                }
                [_saveButton setEnabled:YES];
            }];
            
        }else{
            AVObject *dateObject = [[AVObject alloc] initWithClassName:@"things"];
            [dateObject setObject:_Date forKey:@"date"];
            [dateObject setObject:_jinianName forKey:@"name"];
            [dateObject setObject:_jinianContent forKey:@"remark"];
            [dateObject setObject:[AVUser currentUser] forKey:@"owner"];
            [dateObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [hud hideAnimated:YES];
                if (succeeded) {
                    _avID =dateObject.objectId;
                    [self.navigationController popViewControllerAnimated:YES];
                    isUpLoad = YES;
                    //[UIView showToast:LOCAL(@"succeed")];
                }else{
                    [UIView showToast:LOCAL(@"fail")];
                }
                [_saveButton setEnabled:YES];
            }];
        }
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 201) {
        [UIView animateWithDuration:0.3 animations:^{
            [jinianNameLabel setText:LOCAL(@"actionName")];
            jinianNameLabel.frame = CGRectMake(BEGIN_X, GETY(_jinianNameText)-30, GETWIDTH(_jinianNameText), GETHEIGHT(_jinianNameText));
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 201) {
        if(textField.text.length == 0){
            jinianNameWrongLabel.alpha = 1;
        }else{
            jinianNameWrongLabel.alpha = 0;
        }
        if(textField.text.length == 0){
            [jinianNameLabel setText:[NSString stringWithFormat:@"%@",LOCAL(@"actionNamePlease")]];
            [UIView animateWithDuration:0.3 animations:^{
                jinianNameLabel.frame = CGRectMake(BEGIN_X, GETY(_jinianNameText), GETWIDTH(_jinianNameText), GETHEIGHT(_jinianNameText));
            } completion:^(BOOL finished) {
            }];
        }
    }
}

-(void)dateAction{
    [_jinianNameText resignFirstResponder];
    if (!_Date) {
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
            _Date = selectDate;
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            NSLog(@"选择的年月日：%@",date);
            [_DateLabel setText:date];
            [self checkFunction];
            [UIView animateWithDuration:0.25 animations:^{
                dateShowLabel.frame = CGRectMake(BEGIN_X, BUTTONY(_jinianNameText)+20, GETWIDTH(_jinianNameText), GETHEIGHT(_jinianNameText));
                [dateShowLabel setText:LOCAL(@"actionDate")];
            } completion:^(BOOL finished) {
            }];
        }];
        datepicker.minLimitDate = [NSDate date];
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
        datepicker.minLimitDate = [NSDate date];
        datepicker.dateLabelColor = ZANGQING_COLOR;
        datepicker.datePickerColor = ZANGQING_COLOR;//滚轮日期颜色
        datepicker.doneButtonColor = ZANGQING_COLOR;//确定按钮的颜色
        datepicker.yearLabelColor = [UIColor clearColor];//大号年份字体颜色
        [datepicker show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_jinianNameText resignFirstResponder];
    [_contentTextView resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    if (_vc) {
        if (isUpLoad) {
            NSLog(@"[upload]_jinianName = %@, _Date = %@, _avID = %@",_jinianName,_Date,_avID);
            NSLog(@"isUpLoad");
            _vc.myDate = _Date;
            _vc.myName = _jinianName;
            _vc.avid = _avID;
            _vc.myContent = _jinianContent;
        }else{
            _vc.avid = nil;
        }
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.3 animations:^{
        [contentLabel setText:LOCAL(@"actionContent")];
        contentLabel.frame = CGRectMake(BEGIN_X, GETY(_contentTextView)-35, GETWIDTH(_contentTextView), GETHEIGHT(contentLabel));
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
            [contentLabel setText:LOCAL(@"ContentPlease")];
            [contentLabel setFrame:CGRectMake(BEGIN_X+5, BUTTONY(_DateLabel)+50, GETWIDTH(_DateLabel), (GETHEIGHT(_DateLabel)))];
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    _jinianContent = textView.text;
    if (_jinianContent.length == 0) {
        _jinianContent = nil;
    }
    [self checkFunction];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
    
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
