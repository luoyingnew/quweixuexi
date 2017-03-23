//
//  JJHomeworkListViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJHomeworkListViewController.h"
#import "JJHomeWorkModel.h"
#import "JJHomeworkCell.h"
#import "JJTopicViewController.h"


static NSString *homeworkCellIdentifier = @"JJhomeworkCellIdentifier";

@interface JJHomeworkListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

//作业模型
@property (nonatomic, strong) NSArray<JJHomeWorkModel *> *homeworkModelArray;

@end

@implementation JJHomeworkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    [self setUpCenter];
    DebugLog(@"%@",self.name);
    
    if(self.isSelfStudy == YES) {
        //如果是自学用户
        [self requestWithStudyHomeworkList];
    } else {
        //如果不是自学用户
        if([self.name isEqualToString:@"补作业"] || [self.name isEqualToString:@"最新作业"]) {
            [self requestWithHomeworkList];
        } else {
            [self requestWithExamList];
        }
    }
}
#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = self.name;
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
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor redColor];
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[JJHomeworkCell class] forCellReuseIdentifier:homeworkCellIdentifier];
    [centerBackView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackView);
        make.top.with.offset(56 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(275 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(340 * KWIDTH_IPHONE6_SCALE);
    }];

}

#pragma mark - 自学作业列表请求
- (void)requestWithStudyHomeworkList {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL = nil;
    URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_STUDY_HOMEWORK_LIST];
    NSDictionary *params = @{@"book_id" : self.book_id, @"unit_id" : self.unit_id};
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
        NSMutableArray *modelArrayMutable = [NSMutableArray array];
        for(NSDictionary *dict in response[@"data"]) {
            JJHomeWorkModel *model = [JJHomeWorkModel modelWithDict:dict];
            [modelArrayMutable addObject:model];
        }
        self.homeworkModelArray = modelArrayMutable;
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];

}

#pragma mark - 作业列表请求
- (void)requestWithHomeworkList {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL = nil;
    if([self.name isEqualToString:@"补作业"]) {
         URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_MAKE_HOMEWORK_LIST];
    } else if([self.name isEqualToString:@"最新作业"]) {
        URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_TODAY_HOMEWORK_LIST];
    }
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
        self.homeworkModelArray = [JJHomeWorkModel mj_objectArrayWithKeyValuesArray:response[@"homework_list"]];
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}

#pragma mark - 测验列表请求
- (void)requestWithExamList {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL = nil;
    URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_TODAY_EXAM_LIST];
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
        NSMutableArray *modelArrayMutable = [NSMutableArray array];
        for(NSDictionary *dict in response[@"exam_list"]) {
            JJHomeWorkModel *model = [JJHomeWorkModel modelWithDict:dict];
            [modelArrayMutable addObject:model];
        }
        self.homeworkModelArray = modelArrayMutable;
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}


#pragma mark - UItableViewDataSource&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    if(tableView == self.categoryTableView) {
    //        return self.categoryModelArray.count;
    //    }else {
    //        return self.currentSelectedCategotyModel.bookModelArray.count;
    //    }
    
    return self.homeworkModelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if(tableView == self.bookTableView) {
    //        JJFunClassroomBookTableViewCell *bookCell = [tableView dequeueReusableCellWithIdentifier:funClassroomBookIdentifier forIndexPath:indexPath];
    //        [bookCell createBordersWithColor:[UIColor clearColor] withCornerRadius:8 andWidth:0];
    //        bookCell.model = self.currentSelectedCategotyModel.bookModelArray[indexPath.section];
    //        return bookCell;
    //
    //    } else {
    //        JJFunClassroomCategoryCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:funClassroomCategoryIdentifier forIndexPath:indexPath ];
    //        categoryCell.model = self.categoryModelArray[indexPath.section];
    //        return categoryCell;
    //    }
    
    JJHomeworkCell *bookCell = [tableView dequeueReusableCellWithIdentifier:homeworkCellIdentifier forIndexPath:indexPath];
    bookCell.model = self.homeworkModelArray[indexPath.section];
    return bookCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (tableView == self.bookTableView) {
    //        return 92 * KWIDTH_IPHONE6_SCALE;
    //    } else {
    //        return 22 * KWIDTH_IPHONE6_SCALE;
    //    }
    return 46 * KWIDTH_IPHONE6_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20 * KWIDTH_IPHONE6_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //    if(tableView == self.bookTableView) {
    //        return 11 * KWIDTH_IPHONE6_SCALE;
    //    } else {
    //        return 6 * KWIDTH_IPHONE6_SCALE;
    //    }
    return  0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JJTopicViewController *topicVC = [[JJTopicViewController alloc]init];
    weakSelf(weakSelf);
    if(self.isSelfStudy == YES) {
        //如果是自学用户
        topicVC.refeshHomeworkListBlock = ^{
            [weakSelf requestWithStudyHomeworkList];
        };
        topicVC.isSelfStudy = self.isSelfStudy;
    } else {
        if([self.name isEqualToString:@"最新测验"]) {
            topicVC.refeshHomeworkListBlock = ^{
                [weakSelf requestWithExamList];
            };
        } else {
            topicVC.refeshHomeworkListBlock = ^{
                [weakSelf requestWithHomeworkList];
            };
        }
    }
   
    topicVC.name = self.name;
    topicVC.model = self.homeworkModelArray[indexPath.section];
    [self.navigationController pushViewController:topicVC animated:YES];
}
- (void)dealloc {
    DebugLog(@"f");
}


@end
