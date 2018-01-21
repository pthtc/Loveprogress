//
//  jinianDetailViewController.m
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/30.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import "jinianDetailViewController.h"
#import "WSDatePickerView.h"

@interface jinianDetailViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>{
    UILabel *jinianNameWrongLabel;
    UILabel *jinianNameLabel;

    UILabel *dateShowLabel;
    BOOL isUpLoad;
}

@property(nonatomic,strong) UITextField *jinianNameText;
@property (nonatomic,strong) UIButton *saveButton;
@property(nonatomic,strong) UILabel *DateLabel;

@end

@implementation jinianDetailViewController

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
    
    jinianNameLabel = [[UILabel alloc] init];
    [jinianNameLabel setTextColor:[UIColor grayColor]];
    [jinianNameLabel setFont:[UIFont boldSystemFontOfSize:jinianNameLabel.font.pointSize]];
    if(!_jinianName){
        [jinianNameLabel setText:[NSString stringWithFormat:@"%@",LOCAL(@"jinnianNamePlease")]];
        [jinianNameLabel setFrame:CGRectMake(BEGIN_X, GETY(_jinianNameText), GETWIDTH(_jinianNameText), (GETHEIGHT(_jinianNameText)))];
    }else{
        [jinianNameLabel setText:LOCAL(@"jinnianName")];
        jinianNameLabel.frame = CGRectMake(BEGIN_X, GETY(_jinianNameText)-30, GETWIDTH(_jinianNameText), GETHEIGHT(_jinianNameText));
    }
    [self.view addSubview:jinianNameLabel];
    
    jinianNameWrongLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(lineView)+5, GETWIDTH(lineView), 15)];
    [jinianNameWrongLabel setText:LOCAL(@"jinnianNameWrong")];
    [jinianNameWrongLabel setTextColor:MEIHONG_COLOR];
    [jinianNameWrongLabel setFont:FONT(15)];
    jinianNameWrongLabel.alpha = 0;
    [self.view addSubview:jinianNameWrongLabel];
    
    dateShowLabel = [[UILabel alloc] init];
    [dateShowLabel setTextColor:[UIColor grayColor]];
    [dateShowLabel setFont:[UIFont boldSystemFontOfSize:dateShowLabel.font.pointSize]];
    if(!_Date){
        [dateShowLabel setText:LOCAL(@"jinnianDatePlease")];
        [dateShowLabel setFrame:CGRectMake(BEGIN_X, BUTTONY(_jinianNameText)+50, GETWIDTH(_jinianNameText), (GETHEIGHT(_jinianNameText)))];
    }else{
        [dateShowLabel setText:LOCAL(@"jinnianDate")];
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
    [_saveButton setEnabled:NO];
    if (_Date!= nil && _jinianName!= nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        if(_avID){
            AVObject *dateObject =[AVObject objectWithClassName:@"memory" objectId:_avID];
            [dateObject setObject:_Date forKey:@"date"];
            [dateObject setObject:_jinianName forKey:@"name"];
            [dateObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [hud hideAnimated:YES];
                if (succeeded) {
                    _avID =dateObject.objectId;
                    isUpLoad = YES;
                    //[UIView showToast:LOCAL(@"succeed")];
                    [self.navigationController popViewControllerAnimated:YES];

                }else{
                    [UIView showToast:LOCAL(@"fail")];
                }
                [_saveButton setEnabled:YES];
            }];
            
        }else{
            AVObject *dateObject = [[AVObject alloc] initWithClassName:@"memory"];
            [dateObject setObject:_Date forKey:@"date"];
            [dateObject setObject:_jinianName forKey:@"name"];
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
            [jinianNameLabel setText:LOCAL(@"jinnianName")];
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
            [jinianNameLabel setText:[NSString stringWithFormat:@"%@",LOCAL(@"jinnianNamePlease")]];
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
                [dateShowLabel setText:LOCAL(@"jinnianDate")];
            } completion:^(BOOL finished) {
            }];
        }];
        datepicker.maxLimitDate = [NSDate date];
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
        datepicker.maxLimitDate = [NSDate date];
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
}

-(void)viewWillDisappear:(BOOL)animated{
    if (_vc) {
        if (isUpLoad) {
            NSLog(@"[upload]_jinianName = %@, _Date = %@, _avID = %@",_jinianName,_Date,_avID);

            NSLog(@"isUpLoad");
            _vc.myDate = _Date;
            _vc.myName = _jinianName;
            _vc.avid = _avID;
        }else{
            _vc.avid = nil;
        }
    }
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
