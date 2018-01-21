//
//  jiluEditViewController.m
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/31.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import "jiluEditViewController.h"
#import "UITextView+Placeholder.h"
#import "ZLPhotoActionSheet.h"
#import "XWScanImage.h"
#define imgHeight 80
#define closeHeight 30

@interface jiluEditViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,UITextViewDelegate>{
    
    NSMutableArray *tagLabelArray;
    UIView *imgView;
    NSArray *tagArray;
    BOOL isUpLoad;
    
    int tagFlag;
}

@property(nonatomic,strong) NSString *jiluContent;
@property(nonatomic,strong) NSMutableArray *imgArray;
@property (nonatomic,strong) NSString *avID;
@property (nonatomic,strong) UIButton *saveButton;
@property(nonatomic,strong) UITextView *contentTextView;
@property (nonatomic,strong) NSString *theTag;

@property(nonatomic,strong) UIScrollView *scrollerView;
@end

@implementation jiluEditViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setScreen];
    // Do any additional setup after loading the view.
}

-(void)setScreen{
    isUpLoad = NO;
    tagFlag = 999;
    //self.title = LOCAL(@"jinian");
    [self.view setBackgroundColor:WHITE_COLOR];
    
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, BEGIN_LINE_NORMAL, SCREEN_WIDTH-2*5, 200)];
    _contentTextView.delegate = self;
    [_contentTextView setFont:FONT(18)];
    _contentTextView.placeholder = LOCAL(@"jiluPlease");
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [_contentTextView addGestureRecognizer:recognizer];
    [self.view addSubview:_contentTextView];
    tagLabelArray = [NSMutableArray array];
    CGSize size = CGSizeMake(1000,30);
    tagArray =@[LOCAL(@"yousheng"),LOCAL(@"advantage"),LOCAL(@"daka"),LOCAL(@"eatSleep"),LOCAL(@"xiuse"),LOCAL(@"surprise")];
    float tagPosition = 10;
    for (int i = 0; i<tagArray.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.tag = 200+i;
        label.userInteractionEnabled = YES;
        [label setText: [NSString stringWithFormat:@"  #%@#  ",tagArray[i]] ];
        label.textColor = ZANGQING_COLOR;
        NSDictionary *attr3=@{NSFontAttributeName:label.font};
        CGSize labelsize4 =[label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attr3 context:nil].size;
        [label setFrame:CGRectMake(tagPosition,5, labelsize4.width, 30)];
        UITapGestureRecognizer *btnTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonAction:)];
        btnTapRecognizer.numberOfTapsRequired = 1;
        btnTapRecognizer.delegate = self;
        [label addGestureRecognizer:btnTapRecognizer];
        label.layer.cornerRadius = 15;
        label.layer.borderColor = ZANGQING_COLOR.CGColor;
        label.layer.borderWidth = 1.5;
        label.layer.masksToBounds = YES;
        [tagLabelArray addObject:label];
        tagPosition+=GETWIDTH(label)+10;
    }
    
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, BUTTONY(_contentTextView), SCREEN_WIDTH, 40)];
    //_scrollerView.backgroundColor =PLACEHODER_COLOR;
    [_scrollerView flashScrollIndicators];
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    _scrollerView.contentSize = CGSizeMake(tagPosition, 0);
    _scrollerView.directionalLockEnabled = YES;
    _scrollerView.bounces = YES;
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    [_scrollerView setDelaysContentTouches:NO];
    [_scrollerView setCanCancelContentTouches:YES];
    [self.view addSubview:_scrollerView];
    
    for (int i = 0; i<tagArray.count; i++) {
        [_scrollerView addSubview:tagLabelArray[i]];
    }
    
    _imgArray = [NSMutableArray array];
    imgView = [[UIView alloc] initWithFrame:CGRectMake(0, BUTTONY(_scrollerView), SCREEN_WIDTH, SCREEN_HEIGHT-BUTTONY(_scrollerView))];
    [imgView setUserInteractionEnabled:YES];
    [imgView setBackgroundColor:WHITE_COLOR];
    //[imgView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:imgView];
    
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-BEGIN_X-80, SCREEN_HEIGHT-NAV_NORMAL_HEIGHT-BEGIN_X, 80, NAV_NORMAL_HEIGHT)];
    [_saveButton setBackgroundColor:[UIColor grayColor]];
    _saveButton.layer.cornerRadius = 22;
    _saveButton.layer.masksToBounds=YES;
    [_saveButton setTitle:LOCAL(@"save") forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
    
    [self refreshImg];
    [self checkFunction];
    
}

-(void)buttonAction:(id)sender{
    [_contentTextView resignFirstResponder];
    NSLog(@"buttonAction");
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UILabel *label =(UILabel *)tap.view;
    int index = (int)label.tag-200;
    
    for (int i = 0; i<tagLabelArray.count; i++) {
        [(UILabel *)tagLabelArray[i] setBackgroundColor:WHITE_COLOR];
        [(UILabel *)tagLabelArray[i] setTextColor:ZANGQING_COLOR];
    }
    if (tagFlag == index) {
        tagFlag = 999;
    }else{
        [(UILabel *)tagLabelArray[index] setBackgroundColor:ZANGQING_COLOR];
        [(UILabel *)tagLabelArray[index] setTextColor:WHITE_COLOR];
        tagFlag = index;
    }
    
}

-(void)imgAction:(id)sender{
    [_contentTextView resignFirstResponder];
    
    NSLog(@"imgAction");
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIImageView *imgview =(UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:imgview];
}

-(void)addImgAction:(id)sender{
    [_contentTextView resignFirstResponder];
    
    NSLog(@"addImgAction");
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
    
    //相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
    ac.configuration.maxSelectCount = 6-_imgArray.count;
    ac.configuration.maxPreviewCount = 10;
    
    //如调用的方法无sender参数，则该参数必传
    ac.sender = self;
    
    //选择回调
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        //your codes
        [_imgArray addObjectsFromArray:images];
        [self refreshImg];
    }];
    
    //调用相册
    [ac showPreviewAnimated:YES];
}

-(void)checkFunction{
    if (_jiluContent) {
        [_saveButton setBackgroundColor:ZANGQING_COLOR];
    }else{
        [_saveButton setBackgroundColor:[UIColor grayColor]];
    }
}

-(void)saveAction{
    [_contentTextView resignFirstResponder];
    [_saveButton setEnabled:NO];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (_jiluContent) {
        if (_jiluContent.length <1000) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            if (_imgArray.count == 0) {
                AVObject *dateObject = [[AVObject alloc] initWithClassName:@"jilu"];
                [dateObject setObject:_jiluContent forKey:@"content"];
                if (tagFlag !=999) {
                    [dateObject setObject:tagArray[tagFlag] forKey:@"tag"];
                    _theTag =tagArray[tagFlag];
                }
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
            }else{
                for (int i = 0; i<_imgArray.count; i++) {
                    NSData *data = [globalFunction zipNSDataWithImage:_imgArray[i]];
                    AVFile *file = [AVFile fileWithName:@"jiluImg.png" data:data];
                    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        NSLog(@"url :%@", file.url);//返回一个唯一的 Url 地址
                        if (succeeded) {
                            [dic setObject:file.url forKey:[NSString stringWithFormat:@"%d",i]];
                            if (dic.count == _imgArray.count) {
                                
                                AVObject *dateObject = [[AVObject alloc] initWithClassName:@"jilu"];
                                [dateObject setObject:_jiluContent forKey:@"content"];
                                [dateObject setObject:dic forKey:@"imgArray"];
                                if (tagFlag !=999) {
                                    [dateObject setObject:tagArray[tagFlag] forKey:@"tag"];
                                    _theTag =tagArray[tagFlag];
                                }
                                [dateObject setObject:[AVUser currentUser] forKey:@"owner"];
                                [dateObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    [hud hideAnimated:YES];
                                    if (succeeded) {
                                        _avID =dateObject.objectId;
                                        [self.navigationController popViewControllerAnimated:YES];
                                        isUpLoad = YES;
                                        [UIView showToast:LOCAL(@"succeed")];
                                    }else{
                                        [UIView showToast:LOCAL(@"fail")];
                                    }
                                    [_saveButton setEnabled:YES];
                                }];
                                
                            }
                        }
                    }];
                }
                
            }
        }else{
            [UIView showToast:LOCAL(@"yiqian")];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_contentTextView resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    if (_vc) {
        if (isUpLoad) {
            _vc.myImageArray = _imgArray;
            _vc.avid = _avID;
            _vc.myContent = _jiluContent;
            if (_theTag) {
                _vc.myTag = _theTag;
            }
            _vc.myDate = [NSDate date];
        }else{
            _vc.avid = nil;
        }
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
}

- (void)textViewDidChange:(UITextView *)textView{
    _jiluContent = textView.text;
    if (_jiluContent.length == 0) {
        _jiluContent = nil;
    }
    [self checkFunction];
}

-(void)refreshImg{
    for(UIView *view in [imgView subviews]) {
        [view removeFromSuperview];
    }
    float xPosition = 10;
    float yPosition = 10;
    int i;
    for (i = 0; i<_imgArray.count; i++) {
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(xPosition, yPosition, imgHeight, imgHeight)];
        img.tag = 100+i;
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer *imgTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgAction:)];
        imgTapRecognizer.numberOfTapsRequired = 1;
        imgTapRecognizer.delegate = self;
        [img addGestureRecognizer:imgTapRecognizer];
        [img setImage:_imgArray[i]];
        xPosition+= 10+imgHeight;
        [imgView addSubview:img];
        
        UIImageView *closeImg = [[UIImageView alloc] initWithFrame:CGRectMake(img.frame.origin.x+(GETWIDTH(img)-closeHeight), GETY(img), closeHeight, closeHeight)];
        closeImg.userInteractionEnabled = YES;
        [closeImg setImage:[globalFunction scaleToSize:[UIImage imageNamed:@"closeimg"] size:CGSizeMake(closeHeight, closeHeight)]];
        closeImg.tag = 300+i;
        UITapGestureRecognizer *closeTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAction:)];
        closeTapRecognizer.numberOfTapsRequired = 1;
        closeTapRecognizer.delegate = self;
        [closeImg addGestureRecognizer:closeTapRecognizer];
        [imgView addSubview:closeImg];
        
        if (i == 2) {
            xPosition = 10;
            yPosition += imgHeight+10;
        }
    }
    if (_imgArray.count <6) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(xPosition, yPosition, imgHeight, imgHeight)];
        img.tag = 999;
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer *imgTapRecognizer2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImgAction:)];
        imgTapRecognizer2.numberOfTapsRequired = 1;
        imgTapRecognizer2.delegate = self;
        [img addGestureRecognizer:imgTapRecognizer2];
        [img setImage:[globalFunction scaleToSize:[UIImage imageNamed:@"addImg"] size:CGSizeMake(GETWIDTH(img), GETHEIGHT(img))]];
        //[img setBackgroundColor: [UIColor grayColor]];
        [imgView addSubview:img];
    }
}

-(void)closeAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIImageView *imgview =(UIImageView *)tap.view;
    NSLog(@"tag == %ld",imgview.tag-300);
    [_imgArray removeObjectAtIndex:imgview.tag-300];
    [self refreshImg];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
/**
 *恢复边缘返回
 */

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
    
}

- (void)handleSwipeFrom{
    [_contentTextView resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
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
