//
//  JJMessageViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/15.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMessageViewController.h"
#import "JJMessageCell.h"
#import "JJMessageModel.h"
#import "JJTopicViewController.h"
#import "JJHomeWorkModel.h"
#import "JJPlateViewController.h"
#import "JJFunTrackViewController.h"

@interface JJMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *messageTableView;
@property (nonatomic, strong) NSArray<JJMessageModel *> *modelArray;

@end

static NSString *messageCellIdentifier = @"JJMEssageCellIdentifier";

@implementation JJMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    [self requestWithReportList];
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = @"消息";
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    
    UIImageView *centerBackImageView = [[UIImageView alloc]init];
    centerBackImageView.userInteractionEnabled = YES;
    centerBackImageView.image = [UIImage imageNamed:@"Login_BackCenterImage"];
    [self.view addSubview:centerBackImageView];
    [centerBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(315 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(363 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(99 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //messageTableView
    self.messageTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.messageTableView.pagingEnabled = YES;
    [self.messageTableView registerClass:[JJMessageCell class] forCellReuseIdentifier:messageCellIdentifier];
    self.messageTableView.backgroundColor = [UIColor clearColor];
    self.messageTableView.dataSource = self;
    self.messageTableView.delegate = self;
    [self.messageTableView registerClass:[JJMessageCell class] forCellReuseIdentifier:messageCellIdentifier];
    [self.view addSubview:self.messageTableView];
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(315 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(363 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(99 * KWIDTH_IPHONE6_SCALE);
    }];
}

#pragma mark - 消息列表请求
- (void)requestWithReportList {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL = nil;
    URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_PUSH_RECORDS];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id};
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
        self.modelArray = [JJMessageModel mj_objectArrayWithKeyValuesArray:response[@"records_list"]];
        [self.messageTableView reloadData];
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}

#pragma mark - UItableviewDataSource & UItableVIewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCellIdentifier forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 363 * KWIDTH_IPHONE6_SCALE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JJTopicViewController *topicViewController = [[JJTopicViewController alloc]init];
    JJMessageModel *messageModel = self.modelArray[indexPath.row];
    if(messageModel.is_exam_homework) {
        JJFunTrackViewController *funTrackVC = [[JJFunTrackViewController alloc]init];
        [self.navigationController pushViewController:funTrackVC animated:YES];
    } else {
        
    }
//    if(messageModel.is_done == YES) {
        //如果这个消息对应的作业是已经完成的.那么跳进Fun学足迹
    
//    } else {
//        if(messageModel.push_type == 2) {
//            //        topicViewController.name = @"最新测验";
//            [self homeworkListBtnClick:@"最新测验" homeworkTitle:messageModel.topic homeworkID:messageModel.eh_id];
//        } else {
//            //        topicViewController.name = @"最新作业";
//            [self homeworkListBtnClick:@"最新作业" homeworkTitle:messageModel.topic homeworkID:messageModel.eh_id];
//        }
//
//    }
}

#pragma mark - 进去最新作业,最新测验,补作业
- (void)homeworkListBtnClick:(NSString *)typeName homeworkTitle:(NSString *)homeworkTitle homeworkID:(NSString *)homeworkId{
    weakSelf(weakSelf);
    if(![typeName isEqualToString:@""]) {
        if([User getUserInformation].class_type == 1) {
            //小学
            if([typeName isEqualToString: @"最新作业"]) {
                //小学最新作业
                JJPlateViewController *plateVC = [[JJPlateViewController alloc]init];
                plateVC.name = homeworkTitle;//[User getUserInformation].last_new_homework_title;
                plateVC.typeName = @"最新作业";
                plateVC.homework_id = homeworkId;//[User getUserInformation].last_new_homeworkID;
                [self.navigationController pushViewController:plateVC animated:YES];
            }
            if([typeName isEqualToString: @"最新测验"]) {
                //小学最新测验
                JJTopicViewController *topicVC = [[JJTopicViewController alloc]init];
                //                topicVC.refeshHomeworkListBlock = ^{
                //                    [weakSelf requestWithExamList];
                //                };
                topicVC.name = @"最新测验";//[User getUserInformation].last_new_test_title;
                JJHomeWorkModel *homeworkModel = [[JJHomeWorkModel alloc]init];
                homeworkModel.homework_id = homeworkId;//[User getUserInformation].last_new_testID;
                homeworkModel.homework_title = homeworkTitle;//[User getUserInformation].last_new_test_title;
                topicVC.model = homeworkModel;
                [self.navigationController pushViewController:topicVC animated:YES];
            }
        } else {
            //初中
            if([typeName isEqualToString: @"最新作业"]) {
                JJTopicViewController *topicVC = [[JJTopicViewController alloc]init];
                //                topicVC.refeshHomeworkListBlock = ^{
                //                    [weakSelf requestWithExamList];
                //                };
                topicVC.name = @"最新作业";//[User getUserInformation].last_new_homework_title;
                JJHomeWorkModel *homeworkModel = [[JJHomeWorkModel alloc]init];
                homeworkModel.homework_id = homeworkId;//[User getUserInformation].last_new_homeworkID;
                homeworkModel.homework_title = homeworkTitle;//[User getUserInformation].last_new_homework_title;
                topicVC.model = homeworkModel;
                [self.navigationController pushViewController:topicVC animated:YES];
            }
            if([typeName isEqualToString: @"最新测验"]) {
                //初中最新测验
                JJTopicViewController *topicVC = [[JJTopicViewController alloc]init];
                //                topicVC.refeshHomeworkListBlock = ^{
                //                    [weakSelf requestWithExamList];
                //                };
                topicVC.name = @"最新测验";//[User getUserInformation].last_new_test_title;
                JJHomeWorkModel *homeworkModel = [[JJHomeWorkModel alloc]init];
                homeworkModel.homework_id = homeworkId;//[User getUserInformation].last_new_testID;
                homeworkModel.homework_title = homeworkTitle;//[User getUserInformation].last_new_test_title;
                topicVC.model = homeworkModel;
                [self.navigationController pushViewController:topicVC animated:YES];
            }
        }
        
    }
}


@end
