//
//  JJIsSelfPlateViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2017/1/19.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "JJIsSelfPlateViewController.h"
//#import "JJPlateViewController.h"
#import "JJPlateCell.h"
#import "JJPlateModel.h"
#import "JJIsSelfStudyTopicViewController.h"


static NSString *plateCellIdentifier = @"JJplateCellIdentifier";

@interface JJIsSelfPlateViewController ()<UITableViewDataSource,UITableViewDelegate>

//板块模型数组
@property (nonatomic, strong) NSArray<JJPlateModel *> *plateModelArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JJIsSelfPlateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    [self setUpCenter];

    [self requestWithLastNewHomeworkPlateList];


}
#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = self.name;
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
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
    [tableView registerClass:[JJPlateCell class] forCellReuseIdentifier:plateCellIdentifier];
    [centerBackView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackView);
        make.top.with.offset(56 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(275 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(340 * KWIDTH_IPHONE6_SCALE);
    }];
    
}


#pragma mark - 板块列表请求(最新作业)
- (void)requestWithLastNewHomeworkPlateList {
    //    self.titleName = self;
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL = nil;
    URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_STUDY_HOMEWORK_LIST];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id , @"unit_id" : self.model.unit_id, @"book_id" : self.model.book_id};
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
        NSArray<JJPlateModel *> *plateModelArray =[JJPlateModel mj_objectArrayWithKeyValuesArray: [JJPlateModel plateModelArrayWithDictArray:response[@"data"][@"topic_list"]]];
        self.plateModelArray = plateModelArray;
        for(JJPlateModel *plateModel in self.plateModelArray) {
            plateModel.homework_id = response[@"data"][@"homework_id"];
            for(JJTopicModel *topicModel in plateModel.topicDictArray) {
                topicModel.homework_id = response[@"data"][@"homework_id"];
                topicModel.isSelfStudy = YES;
            }
        }
        
        //        for(JJPlateModel *plateModel in plateModelArray) {
        //
        //            if([plateModel.plate_name isEqualToString:self.name]) {
        //                self.plateModelArray = unitModel.plateDictArray;
        //                break;
        //            }
        //
        //        }
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}

#pragma mark - UItableViewDataSource&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.plateModelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JJPlateCell *plateCell = [tableView dequeueReusableCellWithIdentifier:plateCellIdentifier forIndexPath:indexPath];
    plateCell.model = self.plateModelArray[indexPath.section];
    return plateCell;
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
    JJIsSelfStudyTopicViewController *topicVC = [[JJIsSelfStudyTopicViewController alloc]init];
    weakSelf(weakSelf);

    JJPlateModel *plateModel = self.plateModelArray[indexPath.section];
    
//    topicVC.name = self.typeName;
//    JJHomeWorkModel *homeWorkModel = [[JJHomeWorkModel alloc]init];
//    homeWorkModel.homework_id = plateModel.homework_id;
//    homeWorkModel.homework_title = plateModel.plate_name;
    self.model.unit_title = plateModel.plate_name;
    topicVC.model = self.model;
    [self.navigationController pushViewController:topicVC animated:YES];
}
- (void)dealloc {
    DebugLog(@"f");
}


@end
