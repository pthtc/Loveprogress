//
//  guanxiViewController.m
//  loveProgress
//
//  Created by 彭天浩 on 2018/2/10.
//  Copyright © 2018年 彭天浩. All rights reserved.
//

#import "guanxiViewController.h"
#import "ZYQSphereView.h"
#import "guanxiViewController.h"
#import "guanxiModel.h"
#import "guanxiEditViewController.h"
#define realLength (SCREEN_WIDTH-2*BEGIN_X)
#define realHeight 30
@interface guanxiViewController ()<UIGestureRecognizerDelegate,UIActionSheetDelegate>{
    ZYQSphereView *sphereView;
    UIView *likeBackView;
    UIView *likeBackGround;
    
    int likeFlag;
    NSMutableArray *cellArray;
    
    MBProgressHUD *hud;
    
    UIImageView *arrow;
    
    int tagFlag;
    
    UIView *detailBackPlaceHolderView;
    UIView *detailBackView;
    UILabel *detailLabel;
}
@property (nonatomic,strong) UIButton *jinianDetailButton;
@property (nonatomic,strong) UIScrollView *detailView;

@end

@implementation guanxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScreen];
    cellArray = [[NSMutableArray alloc] init];
    likeFlag=0;
    [self getData];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"guanxiPage"];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    self.tabBarController.tabBar.hidden = NO;
    [AVAnalytics endLogPageView:@"guanxiPage"];
}

- (void)getData{
    [cellArray removeAllObjects];
    AVQuery *query = [AVQuery queryWithClassName:@"friends"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"owner" equalTo:[AVUser currentUser]];
    [query whereKey:@"type" equalTo:[NSNumber numberWithInt:likeFlag]];
    [query selectKeys:@[@"objectId", @"name",@"detail"]];
    query.limit = 50;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self removeSphere];
        for(AVObject *avObject in objects){
            NSString *objectId = avObject[@"objectId"];
            NSString *name = avObject[@"name"];
            NSString *detail = avObject[@"detail"];
            guanxiModel *model = [[guanxiModel alloc] init];
            model.avID = objectId;
            model.name = name;
            model.detail = detail;
            [cellArray addObject:model];
        }
        if (cellArray.count == 0) {
            [self addArrow];
        }else{
            [self removeArrow];
        }
        [self setSphere];
        [hud hideAnimated:YES];
    }];
}

- (void)setScreen{
    self.tabBarController.tabBar.hidden = YES;
    self.title = LOCAL(@"guanxi");
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.view.backgroundColor =WHITE_COLOR;
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, BEGIN_LINE_NORMAL, SCREEN_WIDTH, NAV_NORMAL_HEIGHT)];
    buttonView.layer.shadowColor = [UIColor grayColor].CGColor;
    buttonView.layer.shadowOffset = CGSizeMake(0,1);
    buttonView.layer.shadowOpacity = 0.5;
    buttonView.layer.shadowRadius = 1;
    [buttonView setBackgroundColor:WHITE_COLOR];
    [buttonView setUserInteractionEnabled:YES];
    [self.view addSubview:buttonView];
    
    likeBackGround = [[UIView alloc] initWithFrame:CGRectMake(BEGIN_X, 7, realLength, realHeight)];
    [likeBackGround setUserInteractionEnabled:YES];
    likeBackGround.backgroundColor = WHITE_COLOR;
    likeBackGround.layer.cornerRadius = 15;
    likeBackGround.layer.borderColor = ZANGQING_COLOR.CGColor;
    likeBackGround.layer.borderWidth = 1;
    likeBackGround.layer.masksToBounds= YES;
    [buttonView addSubview:likeBackGround];
    
    likeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , realLength/2, realHeight)];
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
        if (i == 0) {
            [likeBtn setTextColor:WHITE_COLOR];
        }
        [likeBackGround addSubview:likeBtn];
    }
    
    _jinianDetailButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-BEGIN_X-NAV_NORMAL_HEIGHT, SCREEN_HEIGHT-NAV_NORMAL_HEIGHT-BEGIN_X, NAV_NORMAL_HEIGHT, NAV_NORMAL_HEIGHT)];
    _jinianDetailButton.layer.cornerRadius = NAV_NORMAL_HEIGHT/2;
    _jinianDetailButton.layer.shadowColor = [UIColor grayColor].CGColor;
    _jinianDetailButton.layer.shadowOffset = CGSizeMake(2,2);
    _jinianDetailButton.layer.shadowOpacity = 0.6;
    _jinianDetailButton.layer.shadowRadius = 1;
    [_jinianDetailButton setBackgroundColor:ZANGQING_COLOR];
    [_jinianDetailButton setBackgroundImage:[globalFunction scaleToSize:[UIImage imageNamed:@"add"] size:_jinianDetailButton.frame.size] forState:UIControlStateNormal];
    [_jinianDetailButton addTarget:self action:@selector(jinianAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_jinianDetailButton];
    
    arrow = [[UIImageView alloc] initWithFrame:CGRectMake(_jinianDetailButton.frame.origin.x-70+GETWIDTH(_jinianDetailButton)/3, GETY(_jinianDetailButton)-65, 70, 60)];
    [arrow setImage:[globalFunction scaleToSize:[UIImage imageNamed:@"arrow_down"] size:CGSizeMake(70, 60)] ];
    [self.view addSubview:arrow];
    
    detailBackPlaceHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    detailBackPlaceHolderView.alpha = 0;
    detailBackPlaceHolderView.backgroundColor = RGBA(14, 14, 14, 0.5);
    UITapGestureRecognizer *btnTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeTip)];
    btnTapRecognizer.numberOfTapsRequired = 1;
    btnTapRecognizer.delegate = self;
    [detailBackPlaceHolderView addGestureRecognizer:btnTapRecognizer];
    [self.view addSubview:detailBackPlaceHolderView];
    
    detailBackView = [[UIView alloc] initWithFrame:CGRectMake(BEGIN_X*3, SCREEN_HEIGHT/3, SCREEN_WIDTH-6*BEGIN_X, SCREEN_HEIGHT/3)];
    //    detailBackView.alpha = 0;
    detailBackView.backgroundColor = WHITE_COLOR;
    detailBackView.layer.cornerRadius = 10;
    [detailBackPlaceHolderView addSubview:detailBackView];
    
    _detailView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, GETWIDTH(detailBackView)-20, GETHEIGHT(detailBackView)-20)];
    _detailView.backgroundColor =WHITE_COLOR;
    [_detailView flashScrollIndicators];
    _detailView.scrollEnabled = YES;
    //    _detailView.delegate = self;
    _detailView.contentSize = CGSizeMake(0,GETHEIGHT(detailBackView)-20);
    _detailView.directionalLockEnabled = YES;
    _detailView.bounces = YES;
    _detailView.showsVerticalScrollIndicator = YES;
    _detailView.showsHorizontalScrollIndicator = NO;
    [_detailView setDelaysContentTouches:NO];
    [_detailView setCanCancelContentTouches:YES];
    [detailBackView addSubview:_detailView];
    
    detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , GETWIDTH(_detailView), 0)];
    detailLabel.numberOfLines = 0;
    detailLabel.backgroundColor = WHITE_COLOR;
    [_detailView addSubview:detailLabel];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)setSphere{
    sphereView = [[ZYQSphereView alloc] initWithFrame:CGRectMake(BEGIN_X/2, BEGIN_LINE_LARGE+2*NAV_NORMAL_HEIGHT, SCREEN_WIDTH-BEGIN_X, SCREEN_WIDTH-BEGIN_X)];
    sphereView.center=CGPointMake(self.view.center.x, self.view.center.y);
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (int i = 0; i < cellArray.count; i++) {
        guanxiModel *model =(guanxiModel *)cellArray[i];
        UIButton *subV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        //        subV.tag=500+i;
        subV.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100. green:arc4random_uniform(100)/100. blue:arc4random_uniform(100)/100. alpha:1];
        [subV setTitle:model.name forState:UIControlStateNormal];
        CGSize titleSize = [model.name sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:subV.titleLabel.font.fontName size:subV.titleLabel.font.pointSize]}];
        
        titleSize.height = 30;
        titleSize.width += 10;
        
        subV.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
        subV.layer.masksToBounds=YES;
        subV.layer.cornerRadius=3;
        [subV addTarget:self action:@selector(subVClick:) forControlEvents:UIControlEventTouchUpInside];
        [views addObject:subV];
    }
    
    [sphereView setItems:views];
    
    sphereView.isPanTimerStart=NO;
    
    [self.view addSubview:sphereView];
    [sphereView timerStop];
    [self.view bringSubviewToFront:likeBackGround];
}

-(void)subVClick:(UIButton*)sender{
    NSLog(@"%@",sender.titleLabel.text);
    [UIView animateWithDuration:0.3 animations:^{
        sender.transform=CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            sender.transform=CGAffineTransformMakeScale(1, 1);
        }];
    }];
    NSLog(@"tag == %ld",(long)sender.tag);
    guanxiModel *modeltemp = (guanxiModel *)cellArray[sender.tag];
    NSLog(@"cell == %@",modeltemp.name);
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:modeltemp.name delegate:self cancelButtonTitle:LOCAL(@"cancel") destructiveButtonTitle:LOCAL(@"Delete") otherButtonTitles:LOCAL(@"seedetail"), nil ,nil];
    //actionSheet样式
    sheet.actionSheetStyle = UIActionSheetStyleDefault;
    //显示
    [sheet showInView:self.view];
    sheet.delegate = self;
    tagFlag =(int)sender.tag;
    //    NSLog(@"detail == %@\ntag == %ld",modeltemp.detail,(long)sender.tag);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString *restring = LOCAL(@"sureToDelete");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:restring message:nil preferredStyle:UIAlertControllerStyleAlert];
        //取消style:UIAlertActionStyleDefault
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCAL(@"cancel") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        
        //简直废话:style:UIAlertActionStyleDestructive
        UIAlertAction *rubbishAction = [UIAlertAction actionWithTitle:LOCAL(@"Delete") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            guanxiModel *modeltemp = (guanxiModel *)cellArray[tagFlag];
            
            AVObject *todo =[AVObject objectWithClassName:@"friends" objectId:modeltemp.avID];
            [todo deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded){
                    [cellArray removeObjectAtIndex:tagFlag];
                    [self removeSphere];
                    [self setSphere];
                }else{
                    NSLog(@"%@",error);
                    [UIView showToast:LOCAL(@"fail")];
                }
            }];
            
        }];
        [alertController addAction:rubbishAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        guanxiModel *modeltemp = (guanxiModel *)cellArray[tagFlag];
        NSLog(@"cell == %@",modeltemp.name);
        NSLog(@"detail === %@",modeltemp.detail);
        
        NSString *detail = modeltemp.detail;
        if ([detail isEqualToString:@""] || detail == nil) {
            [UIView showToast:LOCAL(@"nodetail")];
        }else{
            detailLabel.text = detail;
            CGSize size = [detailLabel sizeThatFits:CGSizeMake(GETWIDTH(_detailView), MAXFLOAT)];
            
            [detailLabel setFrame:CGRectMake(0,0 , GETWIDTH(_detailView), size.height)];
            
            _detailView.contentSize = CGSizeMake(0, GETHEIGHT(detailLabel));
            [UIView animateWithDuration:0.4 animations:^{
                [self.view bringSubviewToFront:detailBackPlaceHolderView];
                detailBackPlaceHolderView.alpha = 1;
            } completion:^(BOOL finished) {
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)likeButton:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UILabel *button =(UILabel *)tap.view;
    likeFlag = (int)button.tag-100;
    
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
    [self getData];
}

- (void)removeSphere{
    NSMutableArray *itemesToRemove = [NSMutableArray array];
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[sphereView class]]) {
            [itemesToRemove addObject:subview];
        }
    }
    [itemesToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void)jinianAction{
    guanxiEditViewController *vc= [[guanxiEditViewController alloc] init];
    //    vc.vc = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)removeArrow{
    arrow.alpha = 0;
}

- (void)addArrow{
    arrow.alpha = 1;
}

- (void)closeTip{
    [UIView animateWithDuration:0.4 animations:^{
        detailBackPlaceHolderView.alpha = 0;
    } completion:^(BOOL finished) {
    }];
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
