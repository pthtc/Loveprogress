
//
//  meViewController.m
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/25.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import "meViewController.h"
#import "WaterRippleView.h"
#import "ZLPhotoActionSheet.h"
#import "LeanCloudFeedback.h"
#import "infoViewController.h"
#import "aboutViewController.h"
#import "loginViewController.h"
#import <UIImageView+WebCache.h>
#define imgWidth 120

@interface meViewController ()<UIGestureRecognizerDelegate>{
    UIImageView *toolImgv ;
    NSString *oldObject;
    NSString *oldObject2;
    
    UIView *waterBackView;
}

@end

@implementation meViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScreen];

    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [waterBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    WaterRippleView *waterView = [[WaterRippleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)
                                                        mainRippleColor:RGBA(52, 152, 219, 1)
                                                       minorRippleColor:RGBA(18, 53, 85, 0.8)
                                                      mainRippleoffsetX:1.5f
                                                     minorRippleoffsetX:1.1f
                                                            rippleSpeed:0.8f
                                                         ripplePosition:30.0f
                                                        rippleAmplitude:13.0f];
    [waterBackView addSubview:waterView];
}

-(void)setScreen{
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake( 7, 7, 30, 30)];
    [addButton setImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(lougoutAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    NSArray *genderArray = @[LOCAL(@"tab_he"),LOCAL(@"tab_she"),LOCAL(@"tab_ze"),];
    if ([AVUser currentUser]) {
        if ([[[AVUser currentUser] objectForKey:@"haveInfo"] isEqual: @1]){
            int gender =[((NSNumber *) [[AVUser currentUser] objectForKey:@"gender"]) intValue];
            self.title = genderArray[gender];
        }else{
            self.title = LOCAL(@"tab_me");
        }
    }else{
        self.title = LOCAL(@"tab_me");

    }
    
    self.view.backgroundColor = PLACEHODER_COLOR;
    
    toolImgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, BEGIN_LINE_NORMAL, SCREEN_WIDTH, 240)];
    [self.view addSubview:toolImgv];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
    toolBar.barStyle = UIBarStyleDefault;
    [toolImgv addSubview:toolBar];
    
    waterBackView = [[UIView alloc] initWithFrame:CGRectMake(0, BEGIN_LINE_NORMAL, SCREEN_WIDTH, 240)];
    waterBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:waterBackView];
    
    float place = (SCREEN_WIDTH-2*imgWidth)/3;
    NSArray *nameArray = @[LOCAL(@"me"),[[AVUser currentUser] objectForKey:@"nickName"]];
    for (int i = 0; i<2; i++) {
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake((place+(place+120)*i), BEGIN_LINE_NORMAL+30, imgWidth, imgWidth)];
        [iconImage setImage:[globalFunction scaleToSize:[UIImage imageNamed:@"no_icon"] size:CGSizeMake(imgWidth, imgWidth)]];
        iconImage.userInteractionEnabled = YES;
        iconImage.tag = 100+i;
        iconImage.layer.masksToBounds = YES;
        iconImage.layer.cornerRadius = 60;
        UITapGestureRecognizer *imgTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconAction:)];
        imgTapRecognizer.numberOfTapsRequired = 1;
        imgTapRecognizer.delegate = self;
        [iconImage addGestureRecognizer:imgTapRecognizer];
        [self.view addSubview:iconImage];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((place+(place+120)*i), BUTTONY(iconImage)+10, imgWidth, 20)];
        nameLabel.tag = 300+i;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = nameArray[i];
        [nameLabel setFont:BOLDFONT(nameLabel)];
        [self.view addSubview:nameLabel];
    }
    
    NSArray *btnArray = @[LOCAL(@"ziliaoMe"),LOCAL(@"fankui"),LOCAL(@"about")];
    NSArray *imgArray = @[@"info",@"feedback",@"about"];
    for (int i = 0; i<3; i++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, BUTTONY(waterBackView)+5+(5+BEGIN_LINE_NORMAL)*i, SCREEN_WIDTH, BEGIN_LINE_NORMAL)];
        backView.backgroundColor = WHITE_COLOR;
        backView.tag =200+i;
        UITapGestureRecognizer *buttonTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonAction:)];
        buttonTapRecognizer.numberOfTapsRequired = 1;
        buttonTapRecognizer.delegate = self;
        [backView addGestureRecognizer:buttonTapRecognizer];
        [self.view addSubview:backView];
        
        UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, 0, 200, BEGIN_LINE_NORMAL)];
        buttonLabel.text = btnArray[i];
        buttonLabel.textColor = ZANGQING_COLOR;
        [buttonLabel setFont:FONT(20)];
        [buttonLabel setFont:BOLDFONT(buttonLabel)];
        [backView addSubview:buttonLabel];
        
        UIImageView *btnImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-BEGIN_X-30, (BEGIN_LINE_NORMAL-30)/2, 30, 30)];
        [btnImg setImage:[globalFunction scaleToSize:[UIImage imageNamed:imgArray[i]] size:CGSizeMake(30, 30)]];
        [backView addSubview:btnImg];
    }
    [self getData];
    
}

-(void)getData{
    AVUser *user = [AVUser currentUser];
    if(user){
        UILabel *namelabel = ((UILabel *)[self.view viewWithTag:301]);
        namelabel.text = [user objectForKey:@"nickName"];
        
        UIImageView *imgViewleft = ((UIImageView *)[self.view viewWithTag:100]);
        UIImageView *imgViewRight = ((UIImageView *)[self.view viewWithTag:101]);

        AVFile *file2 = [[AVUser currentUser] objectForKey:@"icon"];
        oldObject2 = file2.objectId;
//        NSLog(@"righticon url == %@",oldObject2);
        if (oldObject2) {
//            [imgViewRight sd_setImageWithURL:[NSURL URLWithString:file2.url]  placeholderImage:[self buttonImageFromColor:[UIColor grayColor]]];
            [imgViewRight sd_setImageWithURL:[NSURL URLWithString:file2.url]  placeholderImage:[self buttonImageFromColor:[UIColor grayColor]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [self setBackImage];
            }];
        }
//        AVFile *files2 = [AVFile fileWithURL:file2.url];
//        [files2 getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
//            if(!error){
//                NSLog(@"icon succeed");
//                [imgViewRight setImage:[UIImage imageWithData:data]];
//                [self setBackImage];
//            }else{
//                NSLog(@"error: %@",error);
//                //[UIView showToast:LOCAL(@"fail")];
//            }
//        }];
        
        AVFile *file = [[AVUser currentUser] objectForKey:@"icon1"];
        oldObject = file.objectId;
//        NSLog(@"lefticon url == %@",oldObject);
        if (oldObject) {
            [imgViewleft sd_setImageWithURL:[NSURL URLWithString:file.url]  placeholderImage:[self buttonImageFromColor:[UIColor grayColor]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [self setBackImage];
            }];
            
        }

//        AVFile *files = [AVFile fileWithURL:file.url];
//        [files getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
//            if(!error){
//                NSLog(@"icon succeed1");
//                [imgViewleft setImage:[UIImage imageWithData:data]];
//                [self setBackImage];
//            }else{
//                NSLog(@"error1: %@",error);
//                //[UIView showToast:LOCAL(@"fail")];
//            }
//        }];
    }
}

-(void)setBackImage{
    UIImage *left = ((UIImageView *)[self.view viewWithTag:100]).image;
    UIImage *right = ((UIImageView *)[self.view viewWithTag:101]).image;
    
    [toolImgv setImage:[self combineWithLeftImg:right rightImg:left withMargin:0]];
}

-(void)buttonAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UILabel *btnview =(UILabel *)tap.view;
    if (btnview.tag == 200) {
        infoViewController *info = [[infoViewController alloc] init];
        AVUser *user = [AVUser currentUser];
        info.isJumpFromApp = YES;
        info.gender = [(NSNumber *)[user objectForKey:@"gender"] intValue];
        info.nickName =[user objectForKey:@"nickName"];
        info.Date =[user objectForKey:@"birthday"];
        info.heart = [user objectForKey:@"chuxin"];
        [self.navigationController pushViewController:info animated:YES];
    }else if (btnview.tag == 201){
        LCUserFeedbackAgent *agent = [LCUserFeedbackAgent sharedInstance];
        /* title 传 nil 表示将第一条消息作为反馈的标题。 contact 也可以传入 nil，由用户来填写联系方式。*/
        [agent showConversations:self title:nil contact:[AVUser currentUser].username];
    }else if (btnview.tag == 202){
        aboutViewController *about = [[aboutViewController alloc] init];
        [self.navigationController pushViewController:about animated:YES];
    }
}

- (void)iconAction:(id)sender{
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
    
    //相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
    ac.configuration.maxSelectCount = 1;
    ac.configuration.maxPreviewCount = 10;
    ac.configuration.editAfterSelectThumbnailImage = YES;
    ac.configuration.clipRatios = @[GetClipRatio(1, 1)];
    //如调用的方法无sender参数，则该参数必传
    ac.sender = self;
    
    //选择回调
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
        UIImageView *imgview =(UIImageView *)tap.view;
        
        NSData *data = [globalFunction zipNSDataWithImage:[globalFunction scaleToSize:images[0] size:CGSizeMake(imgWidth, imgWidth)]];
        AVFile *file = [AVFile fileWithName:@"icon.png" data:data];
        
        if (imgview.tag == 101) {
           [[AVUser currentUser] setObject:file forKey:@"icon"];
        }else if (imgview.tag == 100){
            [[AVUser currentUser] setObject:file forKey:@"icon1"];
        }
        [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                [imgview setImage:images[0]];
                [self setBackImage];
                NSString *theold;
                AVFile *iconFile;
                
                if (imgview.tag == 101) {
                    theold = oldObject2;
                    iconFile = [[AVUser currentUser] objectForKey:@"icon"];
                    oldObject2 = iconFile.objectId;
                }else if (imgview.tag == 100){
                    theold = oldObject;
                    iconFile = [[AVUser currentUser] objectForKey:@"icon1"];
                    oldObject = iconFile.objectId;
                }
                
                if(theold != nil){
                    AVObject *todo =[AVObject objectWithClassName:@"_File" objectId:theold];
                    [todo deleteInBackgroundWithBlock:^(BOOL succeed,NSError *error){
                    }];
                }
            }else{
                [UIView showToast:LOCAL(@"fail")];
            }
        }];
    }];
    
    //调用相册
    [ac showPreviewAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *) combineWithLeftImg:(UIImage*)leftImage rightImg:(UIImage*)rightImage withMargin:(NSInteger)margin{
    if (rightImage == nil) {
        return leftImage;
    }
    CGFloat width = leftImage.size.width + rightImage.size.width + margin;
    CGFloat height = leftImage.size.height;
    CGSize offScreenSize = CGSizeMake(width, height);
    
    // UIGraphicsBeginImageContext(offScreenSize);用这个重绘图片会模糊
    UIGraphicsBeginImageContextWithOptions(offScreenSize, NO, [UIScreen mainScreen].scale);
    
    CGRect rectL = CGRectMake(0, 0, leftImage.size.width, height);
    [leftImage drawInRect:rectL];
    
    CGRect rectR = CGRectMake(rectL.origin.x + leftImage.size.width + margin, 0, rightImage.size.width, height);
    [rightImage drawInRect:rectR];
    
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imagez;
}
-(void)lougoutAction{
    NSString *restring = LOCAL(@"sureToLogout");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:restring message:nil preferredStyle:UIAlertControllerStyleAlert];
    //取消style:UIAlertActionStyleDefault
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCAL(@"cancel") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    
    //简直废话:style:UIAlertActionStyleDestructive
    UIAlertAction *rubbishAction = [UIAlertAction actionWithTitle:LOCAL(@"YES") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        [AVUser logOut];
        loginViewController *login = [[loginViewController alloc] init];
        [self presentViewController:login animated:YES completion:NULL];
    }];
    [alertController addAction:rubbishAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, 100, 100);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
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
