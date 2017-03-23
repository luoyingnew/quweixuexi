//
//  JJHomeWorkDetailViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/15.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJHomeWorkDetailViewController.h"
#import "JJScoreDetailTopicCell.h"
#import "JJScoreDetailModel.h"
#import "JJScoreDetailTopicModel.h"
#import "NSString+XPKit.h"
#import "JJScoreDetailSecondModel.h"

static NSString *const ScoreDetailTopicCellIdentifier = @"JJScoreDetailTopicCellIdentifier";

@interface JJHomeWorkDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JJScoreDetailModel *scoreDetailModel;

@property (nonatomic, strong) JJScoreDetailSecondModel *scoreDetailSecondModel;


//英语作业得分
@property (nonatomic, strong)UILabel *courseLabel;
//10月10日作业
@property (nonatomic, strong)UILabel *homeworkDate;
//班级平均85分
@property (nonatomic, strong)UILabel *averageScoreLabel;
//巴掌85分
@property (nonatomic, strong)UILabel *cloudScoreLabel;
//作业Lable
@property (nonatomic, strong)UILabel *workLabel;
//成绩Label
@property (nonatomic, strong) UILabel *achievementLabel;


@end

@implementation JJHomeWorkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    [self setUpCenter];
    if(self.model != nil) {
        [self requestWithScoreDetailData];
        return;
    }
    if(self.homework_id.length != 0) {
        [self requestWithScoreDetailDataSecond];
    }
    
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = @"作业详情";
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
}

//设置中间视图
- (void)setUpCenter {
    //中部大背景
    UIView *backView = [[UIView alloc]init];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(87 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(321 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(452 * KWIDTH_IPHONE6_SCALE);
    }];
    backView.backgroundColor = RGBA(190, 246, 255, 1);
    [backView createBordersWithColor:RGBA(0, 164, 197, 1) withCornerRadius:10 andWidth:4];
#pragma mark Top
    //topView
    UIImageView *topBackImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HomeworkDetailTipBack"]];
    [backView addSubview:topBackImageView];
    [topBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(24 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(backView);
        make.width.mas_equalTo(281 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(150 * KWIDTH_IPHONE6_SCALE);
    }];
    //英语作业得分
    UILabel *courseLabel = [[UILabel alloc]init];
    self.courseLabel = courseLabel;
    courseLabel.text = @"";
    courseLabel.font = [UIFont boldSystemFontOfSize:22*KWIDTH_IPHONE6_SCALE];
    courseLabel.textColor = RGBA(163, 16, 0, 1);
    [topBackImageView addSubview:courseLabel];
    [courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(31 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(25 * KWIDTH_IPHONE6_SCALE);
    }];
    //10月10日作业
    UILabel *homeworkDate = [[UILabel alloc]init];
    self.homeworkDate = homeworkDate;
    homeworkDate.textColor = RGBA(163, 16, 0, 1);
    homeworkDate.text = @"";
    homeworkDate.font = [UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE];
    [topBackImageView addSubview:homeworkDate];
    [homeworkDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(28 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(62 * KWIDTH_IPHONE6_SCALE);
    }];
    //班级平均85分
    UILabel *averageScoreLabel = [[UILabel alloc]init];
    self.averageScoreLabel = averageScoreLabel;
//    averageScoreLabel.backgroundColor = [UIColor greenColor];
    [topBackImageView addSubview:averageScoreLabel];
    [averageScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(28 * KWIDTH_IPHONE6_SCALE);
        make.bottom.with.offset(-43 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(23 * KWIDTH_IPHONE6_SCALE);

    }];
//    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc]init];
//    //班级平均
//    NSAttributedString *attributeClass = [[NSAttributedString alloc]initWithString:@"班级平均" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : RGBA(0, 0, 0, 1)}];
//    //85
//    NSAttributedString *attributeNumber = [[NSAttributedString alloc]initWithString:@"85" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:21 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : RGBA(255, 0, 0, 1)}];
//    //分
//    NSAttributedString *attributeScore = [[NSAttributedString alloc]initWithString:@"分" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : RGBA(0, 0, 0, 1)}];
//    [mutableAttributeString appendAttributedString:attributeClass];
//    [mutableAttributeString appendAttributedString:attributeNumber];
//    [mutableAttributeString appendAttributedString:attributeScore];
//    [averageScoreLabel setAttributedText:mutableAttributeString];
    
    //巴掌云ImageView
    UIImageView *cloudImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cloud"]];
    [topBackImageView addSubview:cloudImageView];
    [cloudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.with.offset(-22 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(89 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(80 * KWIDTH_IPHONE6_SCALE);
        make.centerY.equalTo(topBackImageView);
    }];
    //巴掌85分
    UILabel *cloudScoreLabel = [[UILabel alloc]init];
    self.cloudScoreLabel = cloudScoreLabel;
    [cloudImageView addSubview:cloudScoreLabel];
    [cloudScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(cloudImageView).with.offset(-24 * KWIDTH_IPHONE6_SCALE);
        make.center.equalTo(cloudImageView);
    }];
    
#pragma mark center
    //centerView
    UIView *centerBackView = [[UIView alloc]init];
    [centerBackView createBordersWithColor:RGBA(0, 157, 192, 1) withCornerRadius:17.5 * KWIDTH_IPHONE6_SCALE andWidth:3 * KWIDTH_IPHONE6_SCALE ];
    [backView addSubview:centerBackView];
    centerBackView.backgroundColor = NORMAL_COLOR;
    [centerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBackImageView.mas_bottom).with.offset(5 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(backView);
        make.width.mas_equalTo(267 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(35 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //作业Lable
    UILabel *workLabel = [[UILabel alloc]init];
    self.workLabel = workLabel;
    workLabel.text = @"";
    [centerBackView addSubview:workLabel];
    workLabel.font = [UIFont boldSystemFontOfSize:19 * KWIDTH_IPHONE6_SCALE];
    [workLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(17 * KWIDTH_IPHONE6_SCALE);
        make.top.bottom.equalTo(centerBackView);
    }];
    //成绩Label
    UILabel *achievementLabel = [[UILabel alloc]init];
    self.achievementLabel = achievementLabel;
    achievementLabel.text = @"成绩";
    [centerBackView addSubview:achievementLabel];
    achievementLabel.font = [UIFont boldSystemFontOfSize:19 * KWIDTH_IPHONE6_SCALE];
    [achievementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.with.offset(-17 * KWIDTH_IPHONE6_SCALE);
        make.top.bottom.equalTo(centerBackView);
    }];
    
#pragma mark bottom
    //底部背景图
    UIImageView *bottomBackImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MyCoinTableViewBack"]];
    bottomBackImageView.userInteractionEnabled = YES;
    [backView addSubview:bottomBackImageView];
    [bottomBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerBackView.mas_bottom).with.offset(13 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(282 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(183 * KWIDTH_IPHONE6_SCALE);
    }];
    //tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerClass:[JJScoreDetailTopicCell class] forCellReuseIdentifier:ScoreDetailTopicCellIdentifier];
    tableView.dataSource = self;
    tableView.delegate = self;
    [bottomBackImageView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(17 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(bottomBackImageView);
        make.width.mas_equalTo(229 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(150 * KWIDTH_IPHONE6_SCALE);
    }];
}


#pragma mark - 数据请求  该请求是Fun学足迹时跳转的
- (void)requestWithScoreDetailData {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_SCORE_DETAIL];
    NSDictionary *params = @{@"eh_id" : self.model.eh_id, @"eh_type" : @(self.model.eh_type)};
    [JJHud showStatus:nil];
    HFURLSessionTask *task = [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
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
        self.scoreDetailModel =[JJScoreDetailModel mj_objectWithKeyValues:response[@"data"]];
        for(JJScoreDetailTopicModel *scoreDetailTopicModel in self.scoreDetailModel.topics) {
            scoreDetailTopicModel.eh_type = self.scoreDetailModel.eh_type;
        }
        
        
        //班级平均
        NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc]init];
        NSAttributedString *attributeClass = [[NSAttributedString alloc]initWithString:@"班级平均" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : RGBA(0, 0, 0, 1)}];
        //85
        NSAttributedString *attributeNumber = [[NSAttributedString alloc]initWithString:self.scoreDetailModel.class_avg_score attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:21 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : RGBA(255, 0, 0, 1)}];
        //分
        NSAttributedString *attributeScore = [[NSAttributedString alloc]initWithString:@"分" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : RGBA(0, 0, 0, 1)}];
        [mutableAttributeString appendAttributedString:attributeClass];
        [mutableAttributeString appendAttributedString:attributeNumber];
        [mutableAttributeString appendAttributedString:attributeScore];
        [self.averageScoreLabel setAttributedText:mutableAttributeString];
        
        NSMutableAttributedString *cloudMutableAttributeString = [[NSMutableAttributedString alloc]init];
        //85
        NSAttributedString *cloudAttributeNumber = [[NSAttributedString alloc]initWithString:self.scoreDetailModel.score attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:29 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : [UIColor blackColor]}];
        //分
        NSAttributedString *cloudAttributeScore = [[NSAttributedString alloc]initWithString:@"分" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : [UIColor blackColor]}];
        [cloudMutableAttributeString appendAttributedString:cloudAttributeNumber];
        [cloudMutableAttributeString appendAttributedString:cloudAttributeScore];
        self.cloudScoreLabel.attributedText = cloudMutableAttributeString;
        
        
        if(self.scoreDetailModel.eh_type == JJFunTrackHomework) {
            //作业
            self.titleName = @"作业详情";
            self.homeworkDate.text = [NSString stringWithFormat:@"%@作业",[self.scoreDetailModel.endtime stringChangeToDate:@"MM月dd日" ]];
            self.courseLabel.text = @"英语作业得分";
            self.workLabel.text = @"作业";
            
        } else {
            //测验
            self.titleName = @"测验详情";
            self.homeworkDate.text = [NSString stringWithFormat:@"%@测验",[self.scoreDetailModel.endtime stringChangeToDate:@"MM月dd日" ]];
            self.courseLabel.text = @"英语测验得分";
            self.workLabel.text = @"测验";
        }
        
        if([User getUserInformation].class_type == 1 && self.scoreDetailModel.eh_type == JJFunTrackHomework) {
            //小学 并且是 作业 才隐藏
            self.achievementLabel.hidden = YES;
        } else {
            //初中
            self.achievementLabel.hidden = NO;
        }
        
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}


#pragma mark - 数据请求  该请求是成绩单时跳转
- (void)requestWithScoreDetailDataSecond {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_GRADE_DETAILS];
    NSDictionary *params = @{@"homework_id" : self.homework_id};
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
        self.scoreDetailSecondModel =[JJScoreDetailSecondModel mj_objectWithKeyValues:response[@"data"]];
        
        
        //班级平均
        NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc]init];
        NSAttributedString *attributeClass = [[NSAttributedString alloc]initWithString:@"班级平均" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : RGBA(0, 0, 0, 1)}];
        //85
        NSAttributedString *attributeNumber = [[NSAttributedString alloc]initWithString:self.scoreDetailSecondModel.score_avg attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:21 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : RGBA(255, 0, 0, 1)}];
        //分
        NSAttributedString *attributeScore = [[NSAttributedString alloc]initWithString:@"分" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : RGBA(0, 0, 0, 1)}];
        [mutableAttributeString appendAttributedString:attributeClass];
        [mutableAttributeString appendAttributedString:attributeNumber];
        [mutableAttributeString appendAttributedString:attributeScore];
        [self.averageScoreLabel setAttributedText:mutableAttributeString];
        
        NSMutableAttributedString *cloudMutableAttributeString = [[NSMutableAttributedString alloc]init];
        //85
        NSAttributedString *cloudAttributeNumber = [[NSAttributedString alloc]initWithString:self.scoreDetailSecondModel.score_homework attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:29 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : [UIColor blackColor]}];
        //分
        NSAttributedString *cloudAttributeScore = [[NSAttributedString alloc]initWithString:@"分" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : [UIColor blackColor]}];
        [cloudMutableAttributeString appendAttributedString:cloudAttributeNumber];
        [cloudMutableAttributeString appendAttributedString:cloudAttributeScore];
        self.cloudScoreLabel.attributedText = cloudMutableAttributeString;
            
        self.homeworkDate.text = [NSString stringWithFormat:@"%@作业",[self.scoreDetailSecondModel.start_homework stringChangeToDate:@"MM月dd日" ]];
        self.courseLabel.text = @"英语作业得分";
        self.workLabel.text = @"作业";
            
        if([User getUserInformation].class_type == 1) {
            //小学 并且是 作业 才隐藏
            self.achievementLabel.hidden = YES;
        } else {
            //初中
            self.achievementLabel.hidden = NO;
        }
        
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}

#pragma mark - UITableviewDataSource&UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.model != nil){
        return self.scoreDetailModel.topics.count;
    } else {
        return self.scoreDetailSecondModel.topic_list.count;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5 *KWIDTH_IPHONE6_SCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJScoreDetailTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:ScoreDetailTopicCellIdentifier forIndexPath:indexPath];
    if(self.model != nil) {
        cell.model = self.scoreDetailModel.topics[indexPath.section];
    } else {
        cell.secondModel = self.scoreDetailSecondModel.topic_list[indexPath.section];
    }
    
//    [cell createBordersWithColor:[UIColor clearColor] withCornerRadius:4 *KWIDTH_IPHONE6_SCALE andWidth:0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45 * KWIDTH_IPHONE6_SCALE;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5 * KWIDTH_IPHONE6_SCALE;
}

@end
