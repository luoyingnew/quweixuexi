//
//  JJWordSpellingResultViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/29.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJWordSpellingResultViewController.h"
#import "JJBilingualResultCell.h"
#import "JJTopicViewController.h"
#import "JJIsSelfStudyTopicViewController.h"

static NSString *bilingualResultIdentifier = @"JJbilingualResultIdentifier";

@interface JJWordSpellingResultViewController ()<UITableViewDataSource,UITableViewDelegate>

//重做错题按钮
@property (nonatomic, strong) UIButton *reFormBtn;


@end

@implementation JJWordSpellingResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = self.name;//@"中英对照结果";
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"bilingualBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    
    //答对6题,打错两题
    int trueCount = 0;
    int falseCount = 0;
    for(JJBilingualResultModel *model in self.bilingualResultModelArray) {
        if(model.isRight) {
            trueCount++;
        } else {
            falseCount++;
        }
    }
    UILabel *questionMessageLabel = [[UILabel alloc]init];
    [ questionMessageLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:6 * KWIDTH_IPHONE6_SCALE andWidth:0];
    questionMessageLabel.textAlignment = NSTextAlignmentCenter;
    questionMessageLabel.backgroundColor = [UIColor whiteColor];
    questionMessageLabel.text = [NSString stringWithFormat:@"答对%d题,答错%d题",trueCount,falseCount];
    questionMessageLabel.textColor = RGBA(26, 118, 194, 1);
    questionMessageLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
    [self.view addSubview:questionMessageLabel];
    [questionMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(31 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(189 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(126 * KWIDTH_IPHONE6_SCALE);
    }];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerClass:[JJBilingualResultCell class] forCellReuseIdentifier:bilingualResultIdentifier];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(336 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(336 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        if(isPhone) {
            make.top.with.offset(222 * KWIDTH_IPHONE6_SCALE);
        } else {
            make.top.with.offset(160 * KWIDTH_IPHONE6_SCALE);
        }
    }];
    //重做错题
    UIButton *reFormBtn= [[UIButton alloc]init];
    self.reFormBtn = reFormBtn;
    if(falseCount == 0) {
        reFormBtn.hidden = YES;
    } else {
        reFormBtn.hidden = NO;
    }
    
    [reFormBtn addTarget:self action:@selector(reformBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reFormBtn];
    [reFormBtn setBackgroundImage:[UIImage imageNamed:@"MatchNextBtn"] forState:UIControlStateNormal];
    [reFormBtn setTitle:@"重做错题" forState:UIControlStateNormal];
    [reFormBtn setTitleColor:RGBA(212, 0, 0, 1) forState:UIControlStateNormal];
    reFormBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20 * KWIDTH_IPHONE6_SCALE];
    [reFormBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(130 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(38 * KWIDTH_IPHONE6_SCALE);
        make.bottom.with.offset(-26 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(26 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //继续做题
    UIButton *nextHomeworkBtn= [[UIButton alloc]init];
    [self.view addSubview:nextHomeworkBtn];
    [nextHomeworkBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextHomeworkBtn setBackgroundImage:[UIImage imageNamed:@"MatchNextBtn"] forState:UIControlStateNormal];
    [nextHomeworkBtn setTitle:@"继续做题" forState:UIControlStateNormal];
    [nextHomeworkBtn setTitleColor:RGBA(212, 0, 0, 1) forState:UIControlStateNormal];
    nextHomeworkBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20 * KWIDTH_IPHONE6_SCALE];
    [nextHomeworkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(130 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(38 * KWIDTH_IPHONE6_SCALE);
        make.bottom.with.offset(-26 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-26 * KWIDTH_IPHONE6_SCALE);
    }];
}

#pragma mark - 重做错题按钮点击
- (void)reformBtnClick:(UIButton *)btn {
    if(self.redoBlock) {
        self.redoBlock();
    }
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - 继续做题按钮点击
-(void)nextBtnClick:(UIButton *)btn {
    [self.view endEditing:YES];
    //当已经是最后一个小题时,提交作业
    [self requestToSubmitHomework];
}

#pragma mark - 作业提交
- (void)requestToSubmitHomework {
//    if(self.isSelfStudy) {
//        //如果是自学中心跳进来的
//        for(UIViewController *vc in self.navigationController.childViewControllers) {
//            if([vc isKindOfClass:[JJTopicViewController class]]) {
//                [self.navigationController popToViewController:vc animated:YES];
//                return;
//                break;
//            }
//        }
//    }
    
    //    if(self.modelArray.count == 0) return;
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    //小题索引 1232_1233_1234
    NSString *answer_index = nil;
    //答案内容listA_B_C
    NSString *answer_content = nil;
    
    for(int i = 0; i < self.bilingualResultModelArray.count; i++) {
        JJBilingualResultModel *model = self.bilingualResultModelArray[i];
        
        if(i == 0) {
            answer_content = model.myAnswerleftText;
            answer_index = model.unit_id;
        } else {
            answer_index = [NSString stringWithFormat:@"%@_%@",answer_index,model.unit_id];
            answer_content = [NSString stringWithFormat:@"%@_%@",answer_content,model.myAnswerleftText];
        }
    }
    NSString *URL = nil;
    NSDictionary *params = nil;
    
    if([self.typeName isEqualToString:@"最新测验"]) {
        params = @{ @"exam_id" : self.homeworkID , @"answer_index" : answer_index, @"answer_content" : answer_content, @"fun_user_id" : [User getUserInformation].fun_user_id};
        URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_POST_EXAM];
    } else {
        if(self.isSelfStudy) {
            //自学
            URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_SELFSTUDY_POST_HOMEWORK];
            params = @{ @"homework_id" : self.homeworkID , @"answer_index" : answer_index, @"answer_content" : answer_content};//, @"fun_user_id" : [User getUserInformation].fun_user_id};
        } else {
            params = @{ @"homework_id" : self.homeworkID , @"answer_index" : answer_index, @"answer_content" : answer_content, @"fun_user_id" : [User getUserInformation].fun_user_id};
            URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_POST_HOMEWORK];
        }
        
        
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
        [JJHud showToast:@"提交成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for(UIViewController *vc in self.navigationController.childViewControllers) {
                if([vc isKindOfClass:[JJTopicViewController class]] ||[vc isKindOfClass:[JJIsSelfStudyTopicViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:TopicListRefreshNotificatiion object:nil];
                    break;
                }
            }
        });
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}


#pragma mark - UITableviewDataSource&UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"%ld",self.bilingualResultModelArray.count);
    return self.bilingualResultModelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 *KWIDTH_IPHONE6_SCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJBilingualResultCell *cell = [tableView dequeueReusableCellWithIdentifier:bilingualResultIdentifier forIndexPath:indexPath];
    cell.bilingualResultModel = self.bilingualResultModelArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 32 * KWIDTH_IPHONE6_SCALE;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}


- (void)dealloc {
    NSLog(@"xiaohui");
}


@end
