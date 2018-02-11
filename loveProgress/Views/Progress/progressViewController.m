//
//  progressViewController.m
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/25.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import "progressViewController.h"
#import "MJRefresh.h"
#import "navTableViewCell.h"
#import "progressTableViewCell.h"
#import "taskModel.h"
#import "okModel.h"
#import "taskTableViewCell.h"

#import "xihaoViewController.h"
#import "jinianViewController.h"
#import "jiluViewController.h"
#import "xingdongViewController.h"
#import "achievementViewController.h"
@interface progressViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,taskTableViewCellDelegate,UIScrollViewDelegate,progressTableViewCellDelegate>{
    UIView *navView;
    UILabel *navLabel;
    
    UIView *detailBackPlaceHolderView;
    UIView *detailBackView;
    UILabel *detailLabel;
    
    
    NSArray *hArray;
    
    NSMutableArray *cellArray;
    NSMutableArray *taskArray;
    NSMutableArray *okArray;
    
    navTableViewCell *navCell;
    progressTableViewCell *proCell;
    
    
    
    int readyFlag;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIScrollView *detailView;
@end

@implementation progressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshUser];
    [self setScreen];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    // Do any additional setup after loading the view.
}

- (void)refreshUser{
    [[AVUser currentUser] refreshInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        [AVUser changeCurrentUser:(AVUser *)object save:YES];
    }];
}

-(void)getData{
    readyFlag = 0;
    [cellArray removeAllObjects];
    [okArray removeAllObjects];
    [taskArray removeAllObjects];
    
    [self getNavData];
    [self getTaskData];
    [self getMyData];
    
}

- (void)getNavData{
    AVQuery *query = [AVQuery queryWithClassName:@"jitang"];
    if ([globalFunction isChineseLanguage]) {
        [query whereKey:@"isChinese" equalTo:@YES];
    }else{
        [query whereKey:@"isChinese" equalTo:@NO];
    }
    [query countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (!error) {
            // 查询成功，输出计数
            AVQuery *query = [AVQuery queryWithClassName:@"jitang"];
            if ([globalFunction isChineseLanguage]) {
                [query whereKey:@"isChinese" equalTo:@YES];
            }else{
                [query whereKey:@"isChinese" equalTo:@NO];
            }
            query.limit = 1;
            query.skip = (arc4random() % (number));
            [query selectKeys:@[@"content"]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (error) {
                    navCell.text = LOCAL(@"welcomeDefault");
                    [navCell update];
                    [self.tableView reloadData];
                }else{
                    navCell.text = [((AVObject *)objects[0]) objectForKey:@"content"];
                    [navCell update];
                    [self.tableView reloadData];
                }
            }];
        } else {
            // 查询失败
            navCell.text = LOCAL(@"welcomeDefault");
            [navCell update];
            [self.tableView reloadData];
        }
    }];
    
    
}

- (void)getTaskData{
    AVQuery *query = [AVQuery queryWithClassName:@"taskList"];
    if ([globalFunction isChineseLanguage]) {
        [query whereKey:@"isChinese" equalTo:@YES];
    }else{
        [query whereKey:@"isChinese" equalTo:@NO];
    }
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"relationship" equalTo:[[AVUser currentUser] objectForKey:@"relationship"]];
    query.limit = 1000;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"[taskList]%@",error);
            [self.tableView.mj_header endRefreshing];
        }else{
            NSLog(@"[taskList]%@",objects);
            for(AVObject *avObject in objects){
                NSString *objectId = avObject[@"objectId"];
                BOOL isCount =  [((NSNumber *)avObject[@"isCount"]) boolValue];
                NSString *countName = avObject[@"countName"];
                NSString *detail = avObject[@"detail"];
                NSString *content = avObject[@"content"];
                int relationship = [((NSNumber *)avObject[@"relationship"]) intValue];
                int countOrder = [((NSNumber *)avObject[@"countOrder"]) intValue];
                
                taskModel *task = [[taskModel alloc] init];
                task.objectId = objectId;
                task.isCount = isCount;
                task.countName = countName;
                task.detail = detail;
                task.content = content;
                task.relationship = relationship;
                task.countOrder = countOrder;
                
                
                [taskArray addObject:task];
            }
            readyFlag +=1;
            if (readyFlag==2) {
                [self showTable];
            }
        }
    }];
}

- (void)getMyData{
    AVQuery *query = [AVQuery queryWithClassName:@"okList"];
    
    [query orderByDescending:@"createdAt"];
    if ([globalFunction isChineseLanguage]) {
        [query whereKey:@"isChinese" equalTo:@YES];
    }else{
        [query whereKey:@"isChinese" equalTo:@NO];
    }
    [query whereKey:@"owner" equalTo:[AVUser currentUser]];
    [query whereKey:@"level" equalTo:[[AVUser currentUser] objectForKey:@"relationship"]];
    NSLog(@"relation == %@",[[AVUser currentUser] objectForKey:@"relationship"]);
    query.limit = 1000;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            //NSLog(@"[okList]%@",error);
            [self.tableView.mj_header endRefreshing];
        }else{
            NSLog(@"[okList]%@",objects);
            for(AVObject *avObject in objects){
                NSString *objectId = avObject[@"objectId"];
                NSString *taskId = avObject[@"taskId"];
                okModel *ok = [[okModel alloc] init];
                ok.objectId = objectId;
                ok.taskId = taskId;
                [okArray addObject:ok];
            }
            readyFlag +=1;
            if (readyFlag==2) {
                [self showTable];
            }
        }
    }];
}

-(void)showTable{
    if (taskArray.count!=0) {
        NSMutableArray *noFinishArray = [NSMutableArray array];
        NSMutableArray *finishArray = [NSMutableArray array];
        NSLog(@"showTable");
        int addFlag = 0;
        for (int i = 0; i< taskArray.count; i++) {
            addFlag = 0;
            for (int j = 0; j<okArray.count; j++) {
                if ([((taskModel *)taskArray[i]).objectId isEqualToString:((okModel *)okArray[j]).taskId]) {
                    [finishArray addObject:taskArray[i]];
                    addFlag++;
                }
            }
            if (addFlag == 0) {
                [noFinishArray addObject:taskArray[i]];
            }
        }
        
        proCell.loveLevel = [((NSNumber *)[[AVUser currentUser] objectForKey:@"relationship"]) intValue];
        proCell.done = (int)okArray.count;
        proCell.all = (int)taskArray.count;
        [proCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [proCell update];
        [self.tableView reloadData];
        
        for (int i = 0; i<noFinishArray.count; i++) {
            taskTableViewCell *taskCell = [[taskTableViewCell alloc] init];
            taskCell.delegate =self;
            taskCell.isFinish = NO;
            taskCell.model = noFinishArray[i];
            [taskCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [taskCell update];
            [cellArray addObject:taskCell];
        }
        [_tableView reloadData];
        
        
        for (int i = 0; i<finishArray.count; i++) {
            taskTableViewCell *taskCell = [[taskTableViewCell alloc] init];
            taskCell.isFinish = YES;
            taskCell.model = finishArray[i];
            [taskCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [taskCell update];
            [cellArray addObject:taskCell];
        }
        [_tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        
//        NSLog(@"task: %@\nok:%@\nfinish :%@\nlast:%@",taskArray,okArray,finishArray,noFinishArray);
    }else{
        proCell.loveLevel = [((NSNumber *)[[AVUser currentUser] objectForKey:@"relationship"]) intValue];
        proCell.done = 0;
        proCell.all = 999;
        [proCell update];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }
}

-(void)setScreen{
    readyFlag = 0;
    self.title = LOCAL(@"tab_progress");
    [self.view setBackgroundColor:WHITE_COLOR];
    //self.navigationController.navigationBar.hidden = YES;
    
    cellArray = [[NSMutableArray alloc] init];
    taskArray = [[NSMutableArray alloc] init];
    okArray = [[NSMutableArray alloc] init];
    
    navCell = [[navTableViewCell alloc] init];
    [navCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    proCell = [[progressTableViewCell alloc] init];
    proCell.delegate = self;
    [proCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:PLACEHODER_COLOR];
    _tableView.userInteractionEnabled=YES;
    self.tableView.mj_footer.automaticallyHidden = YES;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedRowHeight = 0;
    }
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [cellArray removeAllObjects];
        [weakSelf getData];
    }];
    [cellArray removeAllObjects];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUS_HEIGHT)];
    navView.backgroundColor = WHITE_COLOR;
    [self.view addSubview:navView];
    
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
    
//    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(GETWIDTH(_detailView)/2-10, BUTTONY(_detailView), 30, 30)];
//    [closeButton setImage:[globalFunction scaleToSize:[UIImage imageNamed:@"close"] size:CGSizeMake(30, 30)] forState:UIControlStateNormal];
//    [closeButton addTarget:self action:@selector(closeTip) forControlEvents:UIControlEventTouchUpInside];
//    [detailBackView addSubview:closeButton];
//
    
    [self getData];
}

//告诉tableView一共有多少组数据
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//告诉tableView每一组有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellArray.count+2;
}

//告诉tableView每一行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return navCell;
    }else if(indexPath.row == 1){
        return proCell;
    }else{
        return cellArray[indexPath.row-2];
    }
}

//高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return navCell.navHeight;
    }else if (indexPath.row == 1){
        return 200;
    }else{
        return 100;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    [AVAnalytics endLogPageView:@"progressPage"];
}

- (void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [self getNavData];
    [AVAnalytics beginLogPageView:@"progressPage"];
}

-(void)jumpToPage:(NSString *)pageName{
    if ([pageName isEqualToString:@"likeAndDislike"]) {
        xihaoViewController *xihao = [[xihaoViewController alloc] init];
        [self.navigationController pushViewController:xihao animated:YES];
    }else if ([pageName isEqualToString:@"jilu"]){
        jiluViewController *jilu = [[jiluViewController alloc] init];
        [self.navigationController pushViewController:jilu animated:YES];
    }else if ([pageName isEqualToString:@"memory"]){
        jinianViewController *jinian = [[jinianViewController alloc] init];
        [self.navigationController pushViewController:jinian animated:YES];
    }else if ([pageName isEqualToString:@"things"]){
        xingdongViewController *xingdong = [[xingdongViewController alloc] init];
        [self.navigationController pushViewController:xingdong animated:YES];
    }
}

-(void)finishTaskAction:(taskModel *)finishModel{
    AVObject *dateObject = [[AVObject alloc] initWithClassName:@"okList"];
    if ([globalFunction isChineseLanguage]) {
        [dateObject setObject:@YES forKey:@"isChinese"];
    }else{
        [dateObject setObject:@NO forKey:@"isChinese"];
    }
    [dateObject setObject:[[AVUser currentUser] objectForKey:@"relationship"] forKey:@"level"];
    [dateObject setObject:[AVUser currentUser] forKey:@"owner"];
    [dateObject setObject:finishModel.objectId forKey:@"taskId"];
    [dateObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"finish Task");
            [self getData];
        }else{
            [UIView showToast:LOCAL(@"fail")];
        }
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > (300-(BEGIN_LINE_NORMAL))) {
        [UIView animateWithDuration:0.25 animations:^{
            self.navigationController.navigationBar.hidden = NO;
        } completion:^(BOOL finished) {
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.navigationController.navigationBar.hidden = YES;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)jumpToAchievePage{
    [UIView showToast:LOCAL(@"waitPlease")];
    //    achievementViewController *achi = [[achievementViewController alloc] init];
    //    [self.navigationController pushViewController:achi animated:YES];
}

-(void)updateLevel{
    AVUser *user = [AVUser currentUser];
    NSNumber *relationLevel = (NSNumber *)[user objectForKey:@"relationship"];
    
    if(relationLevel <[[NSNumber alloc] initWithInt:4]){
        NSString *restring = LOCAL(@"sureToUpdate");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:restring message:nil preferredStyle:UIAlertControllerStyleAlert];
        //取消style:UIAlertActionStyleDefault
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCAL(@"cancel") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        
        //简直废话:style:UIAlertActionStyleDestructive
        UIAlertAction *rubbishAction = [UIAlertAction actionWithTitle:LOCAL(@"OK") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            NSNumber *reTemp =[NSNumber numberWithInt:[relationLevel intValue]+1];
            [user setObject:reTemp forKey:@"relationship"];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded){
                    //[UIView showToast:@"关系更改成功"];
                    [self getData];
                }else{
                    [UIView showToast:LOCAL(@"fail")];
                }
            }];
        }];
        [alertController addAction:rubbishAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [UIView showToast:LOCAL(@"noNext")];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select at %@",indexPath);
    if (indexPath.row >1) {
        NSString *detail = ((taskTableViewCell *)cellArray[indexPath.row-2]).model.detail;
        detailLabel.text = detail;
        CGSize size = [detailLabel sizeThatFits:CGSizeMake(GETWIDTH(_detailView), MAXFLOAT)];

        [detailLabel setFrame:CGRectMake(0,0 , GETWIDTH(_detailView), size.height)];
        
        _detailView.contentSize = CGSizeMake(0, GETHEIGHT(detailLabel));
        [UIView animateWithDuration:0.4 animations:^{
            detailBackPlaceHolderView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
        
    }
}

- (void)closeTip{
    [UIView animateWithDuration:0.4 animations:^{
        detailBackPlaceHolderView.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:detailBackView]) {
        return NO;
    }
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
