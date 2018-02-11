//
//  guanxiEditViewController.m
//  loveProgress
//
//  Created by 彭天浩 on 2018/2/11.
//  Copyright © 2018年 彭天浩. All rights reserved.
//

#import "guanxiEditViewController.h"
#define realLength (SCREEN_WIDTH-2*BEGIN_X)
#define realHeight 30
@interface guanxiEditViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>{
    UILabel *jinianNameWrongLabel;
    UILabel *jinianNameLabel;
    UILabel *detailLabel;
    UILabel *detailWrongLabel;
    
    UILabel *dateShowLabel;
    
    UIView *likeBackView;
    
    int likeFlag;
}
@property(nonatomic,strong) NSString *jinianName;
@property(nonatomic,strong) NSString *detail;

@property (nonatomic,strong) NSString *avID;
@property(nonatomic,strong) UITextField *jinianNameText;
@property(nonatomic,strong) UITextField *detailText;

@property (nonatomic,strong) UIButton *saveButton;
@property(nonatomic,strong) UILabel *DateLabel;

@end

@implementation guanxiEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScreen];
    // Do any additional setup after loading the view.
}

-(void)setScreen{
    //self.title = LOCAL(@"jinian");
    [self.view setBackgroundColor:WHITE_COLOR];
    likeFlag = 0;
    NSLog(@"like === %d",_like);
    _jinianNameText = [[UITextField alloc] initWithFrame:CGRectMake(BEGIN_X, BEGIN_LINE_NORMAL*2, SCREEN_WIDTH-2*BEGIN_X, NAV_NORMAL_HEIGHT)];
    _jinianNameText.tag = 301;
    _jinianNameText.delegate = self;
    _jinianNameText.keyboardType = UIKeyboardTypeDefault;
    _jinianNameText.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:_jinianNameText];
    [_jinianNameText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(BEGIN_X,BUTTONY(_jinianNameText) + 1, SCREEN_WIDTH-2*BEGIN_X, 1.2)];
    lineView.backgroundColor = ZANGQING_COLOR;
    
    jinianNameLabel = [[UILabel alloc] init];
    [jinianNameLabel setTextColor:[UIColor grayColor]];
    [jinianNameLabel setFont:[UIFont boldSystemFontOfSize:jinianNameLabel.font.pointSize]];
    [jinianNameLabel setText:[NSString stringWithFormat:@"%@",LOCAL(@"guanxiNamePlease")]];
    [jinianNameLabel setFrame:CGRectMake(BEGIN_X, GETY(_jinianNameText), GETWIDTH(_jinianNameText), (GETHEIGHT(_jinianNameText)))];
    [self.view addSubview:jinianNameLabel];
    
    jinianNameWrongLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(lineView)+5, GETWIDTH(lineView), 15)];
    [jinianNameWrongLabel setText:LOCAL(@"guanxiNameWrong")];
    [jinianNameWrongLabel setTextColor:MEIHONG_COLOR];
    [jinianNameWrongLabel setFont:FONT(15)];
    jinianNameWrongLabel.alpha = 0;
    [self.view addSubview:jinianNameWrongLabel];
    
    /**/
    _detailText = [[UITextField alloc] initWithFrame:CGRectMake(BEGIN_X,  BUTTONY(jinianNameWrongLabel)+10, SCREEN_WIDTH-2*BEGIN_X, NAV_NORMAL_HEIGHT)];
    _detailText.tag = 302;
    _detailText.delegate = self;
    _detailText.keyboardType = UIKeyboardTypeDefault;
    _detailText.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:_detailText];
    [_detailText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(BEGIN_X,BUTTONY(_detailText) + 1, SCREEN_WIDTH-2*BEGIN_X, 1.2)];
    lineView2.backgroundColor = ZANGQING_COLOR;
    
    detailLabel = [[UILabel alloc] init];
    [detailLabel setTextColor:[UIColor grayColor]];
    [detailLabel setFont:[UIFont boldSystemFontOfSize:jinianNameLabel.font.pointSize]];
    [detailLabel setText:[NSString stringWithFormat:@"%@",LOCAL(@"guanxidetailPlease")]];
    [detailLabel setFrame:CGRectMake(BEGIN_X, GETY(_detailText), GETWIDTH(_detailText), (GETHEIGHT(_detailText)))];
    [self.view addSubview:detailLabel];
    
    detailWrongLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(lineView2)+5, GETWIDTH(lineView2), 15)];
    [detailWrongLabel setText:LOCAL(@"guanxidetailWrong")];
    [detailWrongLabel setTextColor:MEIHONG_COLOR];
    [detailWrongLabel setFont:FONT(15)];
    detailWrongLabel.alpha = 0;
    [self.view addSubview:detailWrongLabel];
    
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, BUTTONY(detailWrongLabel), SCREEN_WIDTH, 2*NAV_NORMAL_HEIGHT)];
    [buttonView setBackgroundColor:WHITE_COLOR];
    [buttonView setUserInteractionEnabled:YES];
    [self.view addSubview:buttonView];
    
    UIView *likeBackGround = [[UIView alloc] initWithFrame:CGRectMake(BEGIN_X, 7, realLength, realHeight)];
    [likeBackGround setUserInteractionEnabled:YES];
    likeBackGround.backgroundColor = WHITE_COLOR;
    likeBackGround.layer.cornerRadius = 15;
    likeBackGround.layer.borderColor = ZANGQING_COLOR.CGColor;
    likeBackGround.layer.borderWidth = 1;
    likeBackGround.layer.masksToBounds= YES;
    [buttonView addSubview:likeBackGround];
    
    likeBackView = [[UIView alloc] initWithFrame:CGRectMake(likeFlag*realLength/2, 0 , realLength/2, realHeight)];
    [likeBackView setUserInteractionEnabled:YES];
    [likeBackView setBackgroundColor:ZANGQING_COLOR];
    likeBackView.layer.cornerRadius = 15;
    likeBackView.layer.masksToBounds= YES;
    [likeBackGround addSubview:likeBackView];
    
    NSArray *nameArr = @[LOCAL(@"friendRelation"),LOCAL(@"relativeRelation")];
    for (int i = 0; i<2; i++) {
        UILabel *likeBtn = [[UILabel alloc] initWithFrame:CGRectMake(i*realLength/2, 0, realLength/2, realHeight)];
        UITapGestureRecognizer *btnTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeButton:)];
        btnTapRecognizer.numberOfTapsRequired = 1;
        btnTapRecognizer.delegate = self;
        [likeBtn addGestureRecognizer:btnTapRecognizer];
        [likeBtn setText:nameArr[i]];
        [likeBtn setTextColor:ZANGQING_COLOR];
        likeBtn.userInteractionEnabled = YES;
        likeBtn.tag = 100+i;
        likeBtn.textAlignment = NSTextAlignmentCenter;
        if (i == likeFlag) {
            [likeBtn setTextColor:WHITE_COLOR];
        }
        [likeBackGround addSubview:likeBtn];
    }
    
    
    
    
    [self.view addSubview:lineView];
    [self.view addSubview:lineView2];
    
    [self.view addSubview:jinianNameWrongLabel];
    
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
    if (theTextField.tag == 301) {
        if (theTextField.text.length!=0) {
            jinianNameWrongLabel.alpha = 0;
            _jinianName = theTextField.text;
        }else{
            _jinianName = nil;
        }
    }
    if (theTextField.tag == 302) {
        if (theTextField.text.length!=0) {
            jinianNameWrongLabel.alpha = 0;
            _detail = theTextField.text;
        }else{
            _detail = nil;
        }
    }
    
    [self checkFunction];
}


-(void)likeButton:(id)sender{
    [_jinianNameText resignFirstResponder];
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UILabel *button =(UILabel *)tap.view;
    likeFlag = (int)button.tag-100;
    NSLog(@"likeFlag = %d",likeFlag);
    
    for (int i = 0; i<2; i++) {
        if (i !=likeFlag) {
            [( (UILabel *)[self.view viewWithTag:100+i]) setTextColor:ZANGQING_COLOR];
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [likeBackView setFrame:CGRectMake(likeFlag*realLength/2, 0, realLength/2, realHeight)];
        [button setTextColor:WHITE_COLOR];
    } completion:^(BOOL finished) {
    }];
}

-(void)checkFunction{
    if (_jinianName != nil) {
        [_saveButton setBackgroundColor:ZANGQING_COLOR];
    }else{
        [_saveButton setBackgroundColor:[UIColor grayColor]];
    }
}

-(void)saveAction{
    [_jinianNameText resignFirstResponder];
    [_detailText resignFirstResponder];
    if (_jinianName!= nil) {
        if (_jinianName.length >4) {
            [UIView showToast:LOCAL(@"lessfour")];
        }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [_saveButton setEnabled:NO];
        AVObject *likeObject =[AVObject objectWithClassName:@"friends" objectId:_avID];
        [likeObject setObject:[NSNumber numberWithInt:likeFlag]  forKey:@"type"];
        [likeObject setObject:[AVUser currentUser] forKey:@"owner"];
        [likeObject setObject:_jinianName forKey:@"name"];
        [likeObject setObject:_detail forKey:@"detail"];
        [likeObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [hud hideAnimated:YES];
            if (succeeded) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [UIView showToast:LOCAL(@"fail")];
                [_saveButton setEnabled:YES];
            }
        }];
        }
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 301) {
        [UIView animateWithDuration:0.3 animations:^{
            [jinianNameLabel setText:LOCAL(@"guanxiName")];
            jinianNameLabel.frame = CGRectMake(BEGIN_X, GETY(_jinianNameText)-30, GETWIDTH(_jinianNameText), GETHEIGHT(_jinianNameText));
        } completion:^(BOOL finished) {
        }];
    }else if (textField.tag == 302){
        [UIView animateWithDuration:0.3 animations:^{
            [detailLabel setText:LOCAL(@"guanxidetail")];
            detailLabel.frame = CGRectMake(BEGIN_X, GETY(_detailText)-30, GETWIDTH(_detailText), GETHEIGHT(_detailText));
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 301) {
        if(textField.text.length == 0){
            jinianNameWrongLabel.alpha = 1;
        }else{
            jinianNameWrongLabel.alpha = 0;
        }
        if(textField.text.length == 0){
            [jinianNameLabel setText:[NSString stringWithFormat:@"%@",LOCAL(@"guanxiNamePlease")]];
            [UIView animateWithDuration:0.3 animations:^{
                jinianNameLabel.frame = CGRectMake(BEGIN_X, GETY(_jinianNameText), GETWIDTH(_jinianNameText), GETHEIGHT(_jinianNameText));
            } completion:^(BOOL finished) {
            }];
        }
    }else if (textField.tag == 302){
//        if(textField.text.length == 0){
//            detailWrongLabel.alpha = 1;
//        }else{
//            detailWrongLabel.alpha = 0;
//        }
        if(textField.text.length == 0){
            [detailLabel setText:[NSString stringWithFormat:@"%@",LOCAL(@"guanxidetailPlease")]];
            [UIView animateWithDuration:0.3 animations:^{
                detailLabel.frame = CGRectMake(BEGIN_X, GETY(_detailText), GETWIDTH(_detailText), GETHEIGHT(_detailText));
            } completion:^(BOOL finished) {
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_jinianNameText resignFirstResponder];
    [_detailText resignFirstResponder];
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
