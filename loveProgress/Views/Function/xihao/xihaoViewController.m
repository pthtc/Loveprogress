//
//  xihaoViewController.m
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/29.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import "xihaoViewController.h"
#import "xihaoCollectionViewCell.h"
#import "xihaoModel.h"
#import "MJRefresh.h"
#import "xihaoEditViewController.h"

#define realLength (SCREEN_WIDTH-2*BEGIN_X)
#define realHeight 30

@interface xihaoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>{
    int likeFlag;
    int skitFlag;
    int sceneFlag;
    int addFlag;
    NSMutableArray *cellArray;
    UIView *likeBackView;
    UIView *sceneBackView;
        
    MBProgressHUD *hud;
}
@property(nonatomic,strong) UIButton *xihaoDetailButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation xihaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScreen];
    // Do any additional setup after loading the view.
}

-(void)setScreen{
    addFlag = 0;
    self.tabBarController.tabBar.hidden = YES;
    self.title = LOCAL(@"xihao");
    [self.view setBackgroundColor:PLACEHODER_COLOR];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    likeFlag = 0;
    sceneFlag = -1;
    cellArray = [NSMutableArray array];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize =CGSizeMake((SCREEN_HEIGHT-3*BEGIN_X)/2, 150);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, BEGIN_LINE_NORMAL+ 2*NAV_NORMAL_HEIGHT, SCREEN_WIDTH,SCREEN_HEIGHT-3*NAV_NORMAL_HEIGHT-BEGIN_LINE_NORMAL) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = WHITE_COLOR;
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.collectionView registerClass:[xihaoCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
    //4.设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        skitFlag = 0;
        [cellArray removeAllObjects];
        [weakSelf getData];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        skitFlag+=20;
        [weakSelf getData];
    }];
    skitFlag = 0;
    [cellArray removeAllObjects];
    //[self getData];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, BEGIN_LINE_NORMAL, SCREEN_WIDTH, 2*NAV_NORMAL_HEIGHT)];
    buttonView.layer.shadowColor = [UIColor grayColor].CGColor;
    buttonView.layer.shadowOffset = CGSizeMake(0,1);
    buttonView.layer.shadowOpacity = 0.5;
    buttonView.layer.shadowRadius = 1;
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
    
    likeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , realLength/2, realHeight)];
    [likeBackView setUserInteractionEnabled:YES];
    [likeBackView setBackgroundColor:ZANGQING_COLOR];
    likeBackView.layer.cornerRadius = 15;
    likeBackView.layer.masksToBounds= YES;
    [likeBackGround addSubview:likeBackView];
    
    NSArray *nameArr = @[LOCAL(@"xihuan"),LOCAL(@"taoyan")];
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
    
    UIView *sceneBackGround = [[UIView alloc] initWithFrame:CGRectMake(BEGIN_X, BUTTONY(likeBackView)+14, realLength, realHeight)];
    [sceneBackGround setUserInteractionEnabled:YES];
    sceneBackGround.backgroundColor = WHITE_COLOR;
    sceneBackGround.layer.cornerRadius = 15;
    sceneBackGround.layer.borderColor = ZANGQING_COLOR.CGColor;
    sceneBackGround.layer.borderWidth = 1;
    sceneBackGround.layer.masksToBounds= YES;
    [buttonView addSubview:sceneBackGround];
    
    sceneBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , realLength/6, realHeight)];
    [sceneBackView setUserInteractionEnabled:YES];
    [sceneBackView setBackgroundColor:ZANGQING_COLOR];
    sceneBackView.layer.cornerRadius = 15;
    sceneBackView.layer.masksToBounds= YES;
    [sceneBackGround addSubview:sceneBackView];
    
    NSArray *nameArr2 = @[LOCAL(@"quanbu"),LOCAL(@"xiaofei"),LOCAL(@"eat"),LOCAL(@"entertain"),LOCAL(@"chat"),LOCAL(@"other")];
    for (int i = 0; i<6; i++) {
        UILabel *sceneBtn = [[UILabel alloc] initWithFrame:CGRectMake(i*realLength/6, 0, realLength/6, realHeight)];
        UITapGestureRecognizer *btnTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sceneButton:)];
        btnTapRecognizer.numberOfTapsRequired = 1;
        btnTapRecognizer.delegate = self;
        [sceneBtn addGestureRecognizer:btnTapRecognizer];
        [sceneBtn setText:nameArr2[i]];
        [sceneBtn setTextColor:ZANGQING_COLOR];
        sceneBtn.userInteractionEnabled = YES;
        sceneBtn.tag = 200+i;
        sceneBtn.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            [sceneBtn setTextColor:WHITE_COLOR];
        }
        [sceneBackGround addSubview:sceneBtn];
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    _xihaoDetailButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-BEGIN_X-NAV_NORMAL_HEIGHT, SCREEN_HEIGHT-NAV_NORMAL_HEIGHT-BEGIN_X, NAV_NORMAL_HEIGHT, NAV_NORMAL_HEIGHT)];
//    _xihaoDetailButton.layer.cornerRadius = NAV_NORMAL_HEIGHT/2;
//    _xihaoDetailButton.layer.shadowColor = [UIColor grayColor].CGColor;
//    _xihaoDetailButton.layer.shadowOffset = CGSizeMake(2,2);
//    _xihaoDetailButton.layer.shadowOpacity = 0.6;
//    _xihaoDetailButton.layer.shadowRadius = 1;
//    [_xihaoDetailButton setBackgroundColor:ZANGQING_COLOR];
//    [_xihaoDetailButton setBackgroundImage:[globalFunction scaleToSize:[UIImage imageNamed:@"add"] size:_xihaoDetailButton.frame.size] forState:UIControlStateNormal];
//    [_xihaoDetailButton addTarget:self action:@selector(xihaoAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_xihaoDetailButton];
}

-(void)getData{
    addFlag = 0;
    AVQuery *query = [AVQuery queryWithClassName:@"likeAndDislike"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"owner" equalTo:[AVUser currentUser]];
    [query whereKey:@"type" equalTo:[NSNumber numberWithInt:likeFlag]];
    
    if(sceneFlag != -1){
        [query whereKey:@"scene" equalTo:[NSNumber numberWithInt:sceneFlag]];
    }
    
    [query selectKeys:@[@"objectId", @"name"]];
    query.limit = 20;
    query.skip = skitFlag;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(AVObject *avObject in objects){
            NSString *objectId = avObject[@"objectId"];// 读取 title
            NSString *name = avObject[@"name"]; // 读取 content
            xihaoModel *model = [[xihaoModel alloc] init];
            model.name = name;
            model.avid = objectId;
            [cellArray addObject:model];
        }
        //NSLog(@"%@",objects);
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [hud hideAnimated:YES];
    }];
}

-(void)sceneButton:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UILabel *button =(UILabel *)tap.view;
    sceneFlag = (int)button.tag-201;
    
    for (int i = -1; i<5; i++) {
        if (i !=sceneFlag) {
            [( (UILabel *)[self.view viewWithTag:201+i]) setTextColor:ZANGQING_COLOR];
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [sceneBackView setFrame:CGRectMake((sceneFlag+1)*realLength/6, 0, realLength/6, realHeight)];
        [button setTextColor:WHITE_COLOR];
    } completion:^(BOOL finished) {
    }];
    skitFlag = 0;
    [cellArray removeAllObjects];
    [self getData];
    
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
    skitFlag = 0;
    [cellArray removeAllObjects];
    [self getData];
}

-(void)xihaoAction{
    xihaoEditViewController *xihao = [[xihaoEditViewController alloc] init];
    xihao.vc = self;
    [self.navigationController pushViewController:xihao animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return cellArray.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *colorArray = @[RGBA(52, 152, 219,1),RGBA(227, 100, 91,1),RGBA(243, 156, 18,1),RGBA(46, 204, 113,1),RGBA(145, 142, 195,1),RGBA(172, 196, 108,1),RGBA(240, 160, 167,1),RGBA(127, 140, 141,1)];
    xihaoCollectionViewCell *cell = (xihaoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    if (indexPath.item == 0) {
        NSLog(@"addFlagup == %d for item == %ld",addFlag,(long)indexPath.item);
        cell.isFirst = YES;
        [cell update];
    }else{
        NSLog(@"addFlagdown == %d for item == %ld",addFlag,(long)indexPath.item);
        cell.isFirst = NO;
        cell.nameText =( (xihaoModel *)cellArray[indexPath.item-1]).name;
        cell.avid=( (xihaoModel *)cellArray[indexPath.item-1]).avid;
        [cell update];
    }
    addFlag+=1;
    cell.backgroundColor = colorArray[(indexPath.item % 8)];
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH-3*10)/2, 130);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item != 0) {
        NSString *restring = LOCAL(@"sureToDelete");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:restring message:nil preferredStyle:UIAlertControllerStyleAlert];
        //取消style:UIAlertActionStyleDefault
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCAL(@"cancel") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        
        //简直废话:style:UIAlertActionStyleDestructive
        UIAlertAction *rubbishAction = [UIAlertAction actionWithTitle:LOCAL(@"Delete") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            xihaoCollectionViewCell *cell = (xihaoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            
            AVObject *todo =[AVObject objectWithClassName:@"likeAndDislike" objectId:cell.avid];
            [todo deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded){
                    [cellArray removeObjectAtIndex:indexPath.item-1];
                    [self.collectionView reloadData];
                }else{
                    [UIView showToast:LOCAL(@"fail")];
                }
            }];
            
        }];
        [alertController addAction:rubbishAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self addXihao:likeFlag scene:sceneFlag];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    skitFlag = 0;
    [cellArray removeAllObjects];
    [self getData];
}
- (void)addXihao:(int)like scene:(int)scene{
    xihaoEditViewController *detail = [[xihaoEditViewController alloc] init];
    detail.like = like;
    if (scene <0) {
        detail.scene = 0;
    }else{
        detail.scene = scene;
    }
    detail.isJump = YES;
    [self.navigationController pushViewController:detail animated:YES];
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
