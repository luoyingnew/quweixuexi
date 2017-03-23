//
//  JJTopicViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJTopicViewController.h"
#import "JJTopicModel.h"
#import "JJTopicCell.h"
#import "JJOverHomeWorkViewController.h"
#import "JJWriteTestViewController.h"
#import "JJWordSpellingViewController.h"
#import "JJClozeProcedureViewController.h"
#import "JJReadTestViewController.h"
#import "JJListeningTestViewController.h"
#import "JJErrorCorrectionViewController.h"
#import "JJTransLateViewController.h"
#import "JJSingleChooseViewController.h"
#import "JJBilingualViewController.h"
#import "JJFollowReadViewController.h"
#import "JJReadAloudViewController.h"
#import "JJPlateModel.h"
#import "JJFunClassRoomViewController.h"
//#import "JJFunClassRoomViewController.h"
//#import "JJFunClassRoomViewController.h"

static NSString *topickCellIdentifier = @"JJTopickCellIdentifier";

@interface JJTopicViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

//作业模型
@property (nonatomic, strong) NSArray<JJTopicModel *> *topicModelArray;

//当前选中的第几个cell
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation JJTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //刷新列表通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chooseHomeworkORTest) name:TopicListRefreshNotificatiion object:nil];
    //修改错题再次跳转通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushToMatchVC) name:TopicListPushToMatchNotification object:nil];

    [self setUpBaseView];
    [self setUpCenter];
    
    if([self.name isEqualToString:@"最新测验"]) {
        if([User getUserInformation].class_type == 1) {
            //小学
            [self requestWithExamTopicListPrimarySchool];
        } else {
            //初中
            [self requestWithExamTopicList];
        }
    } else {
        if([User getUserInformation].class_type == 1) {
            //小学
            [self requestWithTopicListPrimarySchool];
        } else {
            //初中
            [self requestWithTopicList];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DebugLog(@"列表出现");
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    DebugLog(@"列表消失");
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = self.model.homework_title;
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    //    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
}
//设置中间视图
- (void)setUpCenter {
    //中部大背景
    UIView *centerBackView = [[UIView alloc]init];
    [self.view addSubview:centerBackView];
    [centerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(100 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(330 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(440 * KWIDTH_IPHONE6_SCALE);
    }];
    centerBackView.backgroundColor = RGBA(126, 251, 252, 1);
    //    centerBackView.userInteractionEnabled = YES;
    [centerBackView createBordersWithColor:RGBA(0, 164, 197, 1) withCornerRadius:10 andWidth:4];
    
    //Book  TableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor redColor];
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[JJTopicCell class] forCellReuseIdentifier:topickCellIdentifier];
    [centerBackView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackView);
        make.top.with.offset(56 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(275 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(340 * KWIDTH_IPHONE6_SCALE);
    }];
}

#pragma mark - 作业大题列表请求(初中)
- (void)requestWithTopicList {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_HOMEWORK_TOPIC_LIST];
    NSDictionary *params = nil;
    if(self.isSelfStudy) {
        //如果是自学用户
        params = @{@"fun_user_id" : [User getUserInformation].fun_user_id , @"sys_homework_id" : self.model.homework_id};
    } else {
        params = @{@"fun_user_id" : [User getUserInformation].fun_user_id , @"homework_id" : self.model.homework_id};
    }
  
    [JJHud showStatus:nil];
    [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
        [JJHud dismiss];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //详情数据加载失败
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            DebugLog(@"codeMessage = %@", codeMessage);
            [JJHud showToast:codeMessage];
            return ;
        }
        self.topicModelArray = [JJTopicModel mj_objectArrayWithKeyValuesArray:response[@"homework_topics_list"]];
        for(JJTopicModel *model in self.topicModelArray) {
            model.homework_id = self.model.homework_id;
            model.isSelfStudy = self.isSelfStudy;
        }
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}

#pragma mark - 作业大题列表请求(小学)
- (void)requestWithTopicListPrimarySchool {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_HOMEWORK_TOPIC_LIST];
    NSDictionary *params = nil;
    if(self.isSelfStudy) {
        //如果是自学用户
        params = @{@"fun_user_id" : [User getUserInformation].fun_user_id , @"sys_homework_id" : self.model.homework_id};
    } else {
        params = @{@"fun_user_id" : [User getUserInformation].fun_user_id , @"homework_id" : self.model.homework_id};
    }
    
    [JJHud showStatus:nil];
    [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
        [JJHud dismiss];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //详情数据加载失败
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            DebugLog(@"codeMessage = %@", codeMessage);
            [JJHud showToast:codeMessage];
            return ;
        }
        
        NSArray<JJPlateModel *> *plateModelArray =[JJPlateModel mj_objectArrayWithKeyValuesArray: [JJPlateModel plateModelArrayWithDictArray:response[@"homework_topics_list"]]];
        //        self.plateModelArray = plateModelArray;
        for(JJPlateModel *plateModel in plateModelArray) {
            plateModel.homework_id = self.model.homework_id;
            for(JJTopicModel *topicModel in plateModel.topicDictArray) {
            }
            if([plateModel.plate_name isEqualToString:self.model.homework_title]) {
                self.topicModelArray = plateModel.topicDictArray;
                break;
            }
            
        }
        //self.topicModelArray = [JJTopicModel mj_objectArrayWithKeyValuesArray:response[@"homework_topics_list"]];
        
        for(JJTopicModel *model in self.topicModelArray) {
            model.homework_id = self.model.homework_id;
            model.isSelfStudy = self.isSelfStudy;
        }
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}



#pragma mark - 测验大题列表请求(初中)
- (void)requestWithExamTopicList {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_EXAM_TOPIC_LIST];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id , @"exam_id" : self.model.homework_id};
    [JJHud showStatus:nil];
    [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
        [JJHud dismiss];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //详情数据加载失败
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            DebugLog(@"codeMessage = %@", codeMessage);
            [JJHud showToast:codeMessage];
            return ;
        }
        self.topicModelArray = [JJTopicModel mj_objectArrayWithKeyValuesArray:response[@"exam_topics_list"]];
        for(JJTopicModel *model in self.topicModelArray) {
            model.homework_id = self.model.homework_id;
        }
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}

#pragma mark - 测验大题列表请求(小学)
- (void)requestWithExamTopicListPrimarySchool {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_EXAM_TOPIC_LIST];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id , @"exam_id" : self.model.homework_id};
    [JJHud showStatus:nil];
    [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
        [JJHud dismiss];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //详情数据加载失败
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            DebugLog(@"codeMessage = %@", codeMessage);
            [JJHud showToast:codeMessage];
            return ;
        }
//        NSArray<JJPlateModel *> *plateModelArray =[JJPlateModel mj_objectArrayWithKeyValuesArray: [JJPlateModel plateModelArrayWithDictArray:response[@"exam_topics_list"]]];
//        //        self.plateModelArray = plateModelArray;
//        for(JJPlateModel *plateModel in plateModelArray) {
//            plateModel.homework_id = self.model.homework_id;
//            for(JJTopicModel *topicModel in plateModel.topicDictArray) {
//            }
//            if([plateModel.plate_name isEqualToString:self.model.homework_title]) {
//                self.topicModelArray = plateModel.topicDictArray;
//                break;
//            }
//        }
//        for(JJTopicModel *model in self.topicModelArray) {
//            model.homework_id = self.model.homework_id;
//        }
        self.topicModelArray = [JJTopicModel mj_objectArrayWithKeyValuesArray:response[@"exam_topics_list"]];
        for(JJTopicModel *model in self.topicModelArray) {
            model.homework_id = self.model.homework_id;
        }
        [self.tableView reloadData];
        
//        for(NSInteger i = 0; i<self.topicModelArray.count; i++) {
//            JJTopicModel *model = self.topicModelArray[i];
//            if(model.is_done == NO) break;
//            if(i == (self.topicModelArray.count - 1)) {
//                JJOverHomeWorkViewController *ov = [[JJOverHomeWorkViewController alloc]init];
//                weakSelf(weakSelf);
//                ov.overHomeworkBlock = ^{
//                    if(weakSelf.refeshHomeworkListBlock) {
//                        weakSelf.refeshHomeworkListBlock();
//                    }
//                    [weakSelf.navigationController popViewControllerAnimated:YES];
//                };
//                ov.homework_id = self.model.homework_id;
//                ov.name = self.name;
//                [self presentViewController:ov animated:YES completion:^{
//                }];
//            }
//        }

        
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}


#pragma mark -接收到刷新列表通知  选择是作业还是测验
- (void)chooseHomeworkORTest {
    if([self.name isEqualToString:@"最新测验"]) {//最新测验
        if([User getUserInformation].class_type == 1) {
            //小学
            [self observeToRefreshEXAMTableViewRequestPrimary];
        } else {
            //初中
            [self observeToRefreshEXAMTableViewRequest];
        }
        
    } else {//最新作业
        if([User getUserInformation].class_type == 1) {
            //小学
            [self observeToRefreshTableViewRequestPrimary];
        } else {
            //初中
            [self observeToRefreshTableViewRequest];
        }
    }
}

#pragma mark - 接收到刷新作业列表通知(初中)
- (void)observeToRefreshTableViewRequest {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_HOMEWORK_TOPIC_LIST];
    NSDictionary *params = nil;
    if(self.isSelfStudy) {
        //如果是自学用户
        params = @{@"fun_user_id" : [User getUserInformation].fun_user_id , @"sys_homework_id" : self.model.homework_id};
    } else {
        params = @{@"fun_user_id" : [User getUserInformation].fun_user_id , @"homework_id" : self.model.homework_id};
    }

    [JJHud showStatus:nil];
    [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
        [JJHud dismiss];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //详情数据加载失败
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            DebugLog(@"codeMessage = %@", codeMessage);
            [JJHud showToast:codeMessage];
            return ;
        }
        self.topicModelArray = [JJTopicModel mj_objectArrayWithKeyValuesArray:response[@"homework_topics_list"]];
        for(NSInteger i = 0; i<self.topicModelArray.count; i++) {
            JJTopicModel *model = self.topicModelArray[i];
            if(model.is_done == NO) break;
            if(i == (self.topicModelArray.count - 1)) {
                JJOverHomeWorkViewController *ov = [[JJOverHomeWorkViewController alloc]init];
                weakSelf(weakSelf);
                ov.overHomeworkBlock = ^{
                    if(weakSelf.refeshHomeworkListBlock) {
                        weakSelf.refeshHomeworkListBlock();
                    }
                    if(self.isSelfStudy) {
                        //如果是自学用户,则跳回本册书的单元选择页面
                        NSArray *viewControllers = weakSelf.navigationController.viewControllers;
                        for(UIViewController *vc in viewControllers) {
                            if([vc isKindOfClass:[JJFunClassRoomViewController class]]) {
                                [weakSelf.navigationController popToViewController:vc animated:YES];
                                break;
                            }
                        }
                    } else {//如果不是全部跳回首页
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    }
                    
                };
                ov.name = self.name;
                ov.homework_id = self.model.homework_id;
                [self presentViewController:ov animated:YES completion:^{
                }];
            }
        }
        for(JJTopicModel *model in self.topicModelArray) {
            model.homework_id = self.model.homework_id;
            model.isSelfStudy = self.isSelfStudy;
        }
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}

#pragma mark - 接收到刷新作业列表通知(小学)
- (void)observeToRefreshTableViewRequestPrimary {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_HOMEWORK_TOPIC_LIST];
    NSDictionary *params = nil;
    if(self.isSelfStudy) {
        //如果是自学用户
        params = @{@"fun_user_id" : [User getUserInformation].fun_user_id , @"sys_homework_id" : self.model.homework_id};
    } else {
        params = @{@"fun_user_id" : [User getUserInformation].fun_user_id , @"homework_id" : self.model.homework_id};
    }
    [JJHud showStatus:nil];
    [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
        [JJHud dismiss];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //详情数据加载失败
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            DebugLog(@"codeMessage = %@", codeMessage);
            [JJHud showToast:codeMessage];
            return ;
        }
        
        
        NSArray<JJPlateModel *> *plateModelArray =[JJPlateModel mj_objectArrayWithKeyValuesArray: [JJPlateModel plateModelArrayWithDictArray:response[@"homework_topics_list"]]];
        for(JJPlateModel *plateModel in plateModelArray) {
            plateModel.homework_id = self.model.homework_id;
            for(JJTopicModel *topicModel in plateModel.topicDictArray) {
            }
            if([plateModel.plate_name isEqualToString:self.model.homework_title]) {
                self.topicModelArray = plateModel.topicDictArray;
                break;
            }
            
        }
        for(JJTopicModel *model in self.topicModelArray) {
            model.homework_id = self.model.homework_id;
            model.isSelfStudy = self.isSelfStudy;
        }
        [self.tableView reloadData];
        
        NSArray<JJTopicModel *> *allTopicModelArray = [JJTopicModel mj_objectArrayWithKeyValuesArray:response[@"homework_topics_list"]];
        for(NSInteger i = 0; i<allTopicModelArray.count; i++) {
            JJTopicModel *model = allTopicModelArray[i];
            if(model.is_done == NO) break;
            if(i == (allTopicModelArray.count - 1)) {
                JJOverHomeWorkViewController *ov = [[JJOverHomeWorkViewController alloc]init];
                weakSelf(weakSelf);
                ov.overHomeworkBlock = ^{
                    if(weakSelf.refeshHomeworkListBlock) {
                        weakSelf.refeshHomeworkListBlock();
                    }
                    if(self.isSelfStudy) {
                        //如果是自学用户,则跳回本册书的单元选择页面
                        NSArray *viewControllers = weakSelf.navigationController.viewControllers;
                        for(UIViewController *vc in viewControllers) {
                            if([vc isKindOfClass:[JJFunClassRoomViewController class]]) {
                                [weakSelf.navigationController popToViewController:vc animated:YES];
                                break;
                            }
                        }
                    } else {//如果不是全部跳回首页
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    }

                };
                ov.name = self.name;
                ov.homework_id = self.model.homework_id;
                [self presentViewController:ov animated:YES completion:^{
                }];
            }
        }


    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}

#pragma mark - 接收到刷新测验列表通知(初中)
- (void)observeToRefreshEXAMTableViewRequest {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_EXAM_TOPIC_LIST];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id , @"exam_id" : self.model.homework_id};
    [JJHud showStatus:nil];
    [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
        [JJHud dismiss];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //详情数据加载失败
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            DebugLog(@"codeMessage = %@", codeMessage);
            [JJHud showToast:codeMessage];
            return ;
        }
        self.topicModelArray = [JJTopicModel mj_objectArrayWithKeyValuesArray:response[@"exam_topics_list"]];
        for(NSInteger i = 0; i<self.topicModelArray.count; i++) {
            JJTopicModel *model = self.topicModelArray[i];
            if(model.is_done == NO) break;
            if(i == (self.topicModelArray.count - 1)) {
                JJOverHomeWorkViewController *ov = [[JJOverHomeWorkViewController alloc]init];
                weakSelf(weakSelf);
                ov.overHomeworkBlock = ^{
                    if(weakSelf.refeshHomeworkListBlock) {
                        weakSelf.refeshHomeworkListBlock();
                    }
                    if(self.isSelfStudy) {
                        //如果是自学用户,则跳回本册书的单元选择页面
                        NSArray *viewControllers = weakSelf.navigationController.viewControllers;
                        for(UIViewController *vc in viewControllers) {
                            if([vc isKindOfClass:[JJFunClassRoomViewController class]]) {
                                [weakSelf.navigationController popToViewController:vc animated:YES];
                                break;
                            }
                        }
                    } else {//如果不是全部跳回首页
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    }
                };
                ov.homework_id = self.model.homework_id;
                ov.name = self.name;
                [self presentViewController:ov animated:YES completion:^{
                }];
            }
        }
        for(JJTopicModel *model in self.topicModelArray) {
            model.homework_id = self.model.homework_id;
        }
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}

#pragma mark - 接收到刷新测验列表通知(小学)
- (void)observeToRefreshEXAMTableViewRequestPrimary {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_EXAM_TOPIC_LIST];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id , @"exam_id" : self.model.homework_id};
    [JJHud showStatus:nil];
    [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
        [JJHud dismiss];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //详情数据加载失败
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            DebugLog(@"codeMessage = %@", codeMessage);
            [JJHud showToast:codeMessage];
            return ;
        }
        self.topicModelArray = [JJTopicModel mj_objectArrayWithKeyValuesArray:response[@"exam_topics_list"]];
        for(JJTopicModel *model in self.topicModelArray) {
            model.homework_id = self.model.homework_id;
        }
        [self.tableView reloadData];
        
        for(NSInteger i = 0; i<self.topicModelArray.count; i++) {
            JJTopicModel *model = self.topicModelArray[i];
            if(model.is_done == NO) break;
            if(i == (self.topicModelArray.count - 1)) {
                JJOverHomeWorkViewController *ov = [[JJOverHomeWorkViewController alloc]init];
                weakSelf(weakSelf);
                ov.overHomeworkBlock = ^{
                    if(weakSelf.refeshHomeworkListBlock) {
                        weakSelf.refeshHomeworkListBlock();
                    }
                    if(self.isSelfStudy) {
                        //如果是自学用户,则跳回本册书的单元选择页面
                        NSArray *viewControllers = weakSelf.navigationController.viewControllers;
                        for(UIViewController *vc in viewControllers) {
                            if([vc isKindOfClass:[JJFunClassRoomViewController class]]) {
                                [weakSelf.navigationController popToViewController:vc animated:YES];
                                break;
                            }
                        }
                    } else {//如果不是全部跳回首页
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    }

                };
                ov.homework_id = self.model.homework_id;
                ov.name = self.name;
                [self presentViewController:ov animated:YES completion:^{
                }];
            }
        }
        

        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];

}


#pragma mark - 接收到重做错题通知后自动跳转到题型
- (void)pushToMatchVC {
    [self tableView:self.tableView didSelectRowAtIndexPath:self.currentIndexPath];
}

#pragma mark - UItableViewDataSource&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.topicModelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJTopicCell *bookCell = [tableView dequeueReusableCellWithIdentifier:topickCellIdentifier forIndexPath:indexPath];
    JJTopicModel *model = self.topicModelArray[indexPath.section];
    model.index = indexPath.section + 1;
    bookCell.model = model;
    return bookCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46 * KWIDTH_IPHONE6_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20 * KWIDTH_IPHONE6_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    JJTopicModel *model = self.topicModelArray[indexPath.section];
    switch (model.type) {
        case ListenType://听力
        {
            JJListeningTestViewController *listeningTestViewController = [[JJListeningTestViewController alloc]init];
            listeningTestViewController.topicModel = model;
            listeningTestViewController.name = self.name;
            listeningTestViewController.navigationTitleName = @"听力题";
            [self.navigationController pushViewController:listeningTestViewController animated:YES];
            break;
        }
        case SingleChooseType://单项选择
        {
            JJSingleChooseViewController *singleChooseVC = [[JJSingleChooseViewController alloc]init];
            singleChooseVC.topicModel = model;
            singleChooseVC.name = self.name;
            singleChooseVC.navigationTitleName = @"单项选择";
            [self.navigationController pushViewController:singleChooseVC animated:YES];
            break;
        }
        case ClozeProcedureType://完型填空
        {
            JJClozeProcedureViewController *clozeProcedureViewController = [[JJClozeProcedureViewController alloc]init];
            clozeProcedureViewController.topicModel = model;
            clozeProcedureViewController.name = self.name;
            clozeProcedureViewController.navigationTitleName = @"完型填空";
            [self.navigationController pushViewController:clozeProcedureViewController animated:YES];            break;
        }
        case ReadType://阅读理解
        {
            JJReadTestViewController *readTestViewController = [[JJReadTestViewController alloc]init];
            readTestViewController.topicModel = model;
            readTestViewController.name = self.name;
            readTestViewController.navigationTitleName = @"阅读理解";
            [self.navigationController pushViewController:readTestViewController animated:YES];
            break;
        }
        case TranslateType://翻译
        {
            JJTransLateViewController *transLateViewController = [[JJTransLateViewController alloc]init];
            transLateViewController.topicModel = model;
            transLateViewController.name = self.name;
            transLateViewController.navigationTitleName = @"翻译题";
            [self.navigationController pushViewController:transLateViewController animated:YES];
            break;
        }
        case ErrorCorrectType://改错
        {
            JJErrorCorrectionViewController *errorCorrectionViewController = [[JJErrorCorrectionViewController alloc]init];
            errorCorrectionViewController.topicModel = model;
            errorCorrectionViewController.name = self.name;
            errorCorrectionViewController.navigationTitleName = @"改错题";
            [self.navigationController pushViewController:errorCorrectionViewController animated:YES];            break;
        }
        case WriteType://作文
        {
            JJWriteTestViewController *writeTestViewController = [[JJWriteTestViewController alloc]init];
            writeTestViewController.topicModel = model;
            writeTestViewController.name = self.name;
            writeTestViewController.navigationTitleName = @"作文题";
            [self.navigationController pushViewController:writeTestViewController animated:YES];
            break;
        }
        case WordSpellingType://单词拼写
        {
            JJWordSpellingViewController *wordSpellingViewController = [[JJWordSpellingViewController alloc]init];
            wordSpellingViewController.topicModel = model;
            wordSpellingViewController.name = self.name;
            wordSpellingViewController.navigationTitleName = @"单词拼写";
            [self.navigationController pushViewController:wordSpellingViewController animated:YES];
            break;
        }
        case FollowReadType://跟读
        {
            JJFollowReadViewController *followReadViewController = [[JJFollowReadViewController alloc]init];
            followReadViewController.topicModel = model;
            followReadViewController.name = self.name;
            followReadViewController.navigationTitleName = @"跟读题";
            [self.navigationController pushViewController:followReadViewController animated:YES];
            break;
        }
        case ReadWordType://朗读
        {
            JJReadAloudViewController *readAloudViewController = [[JJReadAloudViewController alloc]init];
            readAloudViewController.topicModel = model;
            readAloudViewController.name = self.name;
            readAloudViewController.navigationTitleName = @"朗读题";
            [self.navigationController pushViewController:readAloudViewController animated:YES];
            break;
        }
        case BilingualType://中英对照
        {
            JJBilingualViewController *bilingualViewController = [[JJBilingualViewController alloc]init];
            bilingualViewController.topicModel = model;
            bilingualViewController.name = self.name;
            bilingualViewController.navigationTitleName = @"中英对照";
            [self.navigationController pushViewController:bilingualViewController animated:YES];
            break;
        }
        case WordFollowReadType://单词跟读
        {
            JJFollowReadViewController *followReadViewController = [[JJFollowReadViewController alloc]init];
            followReadViewController.topicModel = model;
            followReadViewController.name = self.name;
            followReadViewController.navigationTitleName = @"单词跟读";
            [self.navigationController pushViewController:followReadViewController animated:YES];
            break;
        }
        case WordSpellingTypeSecond://单词拼写
        {
            JJWordSpellingViewController *wordSpellingViewController = [[JJWordSpellingViewController alloc]init];
            wordSpellingViewController.topicModel = model;
            wordSpellingViewController.name = self.name;
            wordSpellingViewController.navigationTitleName = @"单词拼写";
            [self.navigationController pushViewController:wordSpellingViewController animated:YES];
            break;
        }
        case BilingualTypeSecond://英汉对照
        {
            JJBilingualViewController *bilingualViewController = [[JJBilingualViewController alloc]init];
            bilingualViewController.topicModel = model;
            bilingualViewController.name = self.name;
            bilingualViewController.navigationTitleName = @"英汉对照";
            [self.navigationController pushViewController:bilingualViewController animated:YES];
            break;
        }
        case ArticleFollowReadType://全文跟读
        {
            JJFollowReadViewController *followReadViewController = [[JJFollowReadViewController alloc]init];
            followReadViewController.topicModel = model;
            followReadViewController.name = self.name;
            followReadViewController.navigationTitleName = @"全文跟读";
            [self.navigationController pushViewController:followReadViewController animated:YES];
            break;
        }
        case ArticalReadWordType://全文朗读
        {
            JJReadAloudViewController *readAloudViewController = [[JJReadAloudViewController alloc]init];
            readAloudViewController.topicModel = model;
            readAloudViewController.name = self.name;
            readAloudViewController.navigationTitleName = @"全文朗读";
            [self.navigationController pushViewController:readAloudViewController animated:YES];
            break;
        }

        default:
            break;
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    DebugLog(@"f");
}

//#import "JJWordSpellingViewController.h"
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    JJWordSpellingViewController *wordSpellingViewController = [[JJWordSpellingViewController alloc]init];
//    
//    //wordSpellingViewController.topicModel = model;
//    wordSpellingViewController.name = @"最新作业";
//    wordSpellingViewController.navigationTitleName = @"单词拼写";
//    [self.navigationController pushViewController:wordSpellingViewController animated:YES];
//}

@end
