//
//  JJClozeProcedureViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJClozeProcedureViewController.h"
#import "UIImage+XPKit.h"
#import "JJReadTestModel.h"
#import "JJReadTestProblemModel.h"
#import "JJSingleChooseOptionalModel.h"
#import "JJClozeProcedureView.h"
#import <ReactiveCocoa.h>
#import "UIImageView+JJScrollView.h"


@interface JJClozeProcedureViewController ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *topImageView;

//顶端ScrollView
@property (nonatomic, strong) UIScrollView *topScrollView;
//底部ScrollView
@property (nonatomic, strong) UIScrollView  *scrollView;
//问题Label
@property (nonatomic, strong) UILabel *questionLabel;

@property (nonatomic, strong) UILabel *textLabel;


//该题对应的作业ID,主要用于提交答案时用
@property (nonatomic, strong) NSString *homeworkID;

//模型
@property (nonatomic, strong) JJReadTestModel *readTestModel;

//下一题按钮
@property (nonatomic, strong) UIButton *nextHomeworkBtn;
@end

@implementation JJClozeProcedureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    [self requestWithData];
    @weakify(self);
    //监听scrollerView的滚动后可以设置titleName
    [[RACObserve(self, scrollView.contentOffset)ignore:nil] subscribeNext:^(NSValue *x) {
        @strongify(self);
        CGPoint point = [x CGPointValue];
        
        NSInteger currentIndex = (point.x / SCREEN_WIDTH)+1;
        
        self.titleName = [NSString stringWithFormat:@"%@%ld/%ld",self.navigationTitleName,currentIndex,self.readTestModel.questionList.count];
    }];

}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//    JJReadTestModel *readTestModel1 = [[JJReadTestModel alloc]init];
//    readTestModel1.passage = @"fjdshafjkdahkjvfdakvjfbndsmvdffjdshafjkdahkjvfdakvjfdsf分萨克发你咖啡就爱玩了解放了卡死在,名字相册,吗女卡瓦尼股份看见我居然赶快加入哈刚看见的,没得事做,明的说法中呢么,你说的,莫甘娜离开微软国际ndsm,vndskjf基伍I认为UI放假啊fbndsmvdffjdshafjkdahkjvfdakvjfbndsmvdffjdshafjkdahkjvfdakvjfbndsmvdffjdshafjkdahkjvfdakvjfbndsmvdf";
//    JJReadTestProblemModel *testModel1Problem1 = [[JJReadTestProblemModel alloc]init];
//    testModel1Problem1.order = 1;
//    testModel1Problem1.question = @"你是谁1?";
//    
//    JJSingleChooseOptionalModel *op1model1 = [[JJSingleChooseOptionalModel alloc]init];
//    op1model1.letter = @"A";op1model1.word = @"applejfsfjaslkjflsadkjglkafdfkgjldgjfslgdsmjflsdkjflsjflsdajldskjsd";
//    JJSingleChooseOptionalModel *op1model2 = [[JJSingleChooseOptionalModel alloc]init];
//    op1model2.letter = @"B";op1model2.word = @"apple1";
//    JJSingleChooseOptionalModel *op1model3 = [[JJSingleChooseOptionalModel alloc]init];
//    op1model3.letter = @"C";op1model3.word = @"apple2";
//    JJSingleChooseOptionalModel *op1model4 = [[JJSingleChooseOptionalModel alloc]init];
//    op1model4.letter = @"D";op1model4.word = @"apple3";
//    testModel1Problem1.optionModelList = @[op1model1,op1model2,op1model3,op1model4];
//    
//    
//    
//    
//    JJReadTestProblemModel *testModel1Problem2 = [[JJReadTestProblemModel alloc]init];
//    testModel1Problem2.order = 2;
//    testModel1Problem2.question = @"whoaryouFDSJFKLJFKSJFKLSDJGLFDSJGLDSJGLSDFhaha";
//    
//    JJSingleChooseOptionalModel *op2model1 = [[JJSingleChooseOptionalModel alloc]init];
//    op2model1.letter = @"A";op2model1.word = @"apple2";
//    JJSingleChooseOptionalModel *op2model2 = [[JJSingleChooseOptionalModel alloc]init];
//    op2model2.letter = @"B";op2model2.word = @"apple12";
//    JJSingleChooseOptionalModel *op2model3 = [[JJSingleChooseOptionalModel alloc]init];
//    op2model3.letter = @"C";op2model3.word = @"apple22";
//    JJSingleChooseOptionalModel *op2model4 = [[JJSingleChooseOptionalModel alloc]init];
//    op2model4.letter = @"D";op2model4.word = @"apple32";
//    testModel1Problem2.optionModelList = @[op2model1,op2model2,op2model3,op2model4];
//    
//    self.questionLabel.text = readTestModel1.passage;
//    
//    JJClozeProcedureView *clozerProcedureView1 = [JJClozeProcedureView clozeProcedureViewWithReadTestModel:testModel1Problem1];
//    JJClozeProcedureView *clozerProcedureView2 = [JJClozeProcedureView clozeProcedureViewWithReadTestModel:testModel1Problem2];
//    
//    clozerProcedureView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [self.scrollView addSubview:clozerProcedureView1];
//    
//    clozerProcedureView2.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [self.scrollView addSubview:clozerProcedureView2];
//    
//    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
//}

#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = self.navigationTitleName;
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.userInteractionEnabled = YES;
    self.backImageView = backImageView;
    backImageView.image = [UIImage imageNamed:@"ReadTestBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    
    //top
    UIImageView *topImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ReadTestTopBack"]];
    topImageV.userInteractionEnabled = YES;
    self.topImageView = topImageV;
    [self.backImageView addSubview:topImageV];
    [topImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(291 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(295 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        if(isPhone) {
            make.top.mas_equalTo(92 * KWIDTH_IPHONE6_SCALE);
        } else {
            make.top.mas_equalTo(72 * KWIDTH_IPHONE6_SCALE);
        }
        
    }];
    //根据短文内容,选择最佳答案
    UILabel *textLabel = [[UILabel alloc]init];
    self.textLabel = textLabel;
    textLabel.text = [NSString stringWithFormat:@" %@ ",self.topicModel.topic_title];
    textLabel.adjustsFontSizeToFitWidth = YES;
    textLabel.backgroundColor = [UIColor whiteColor];
    textLabel.font = [UIFont boldSystemFontOfSize:12 * KWIDTH_IPHONE6_SCALE];
    textLabel.textColor = RGBA(136, 0, 0, 1);
    [topImageV addSubview:textLabel];
//    textLabel.text = @" 根据短文内容,选择最佳答案 ";
    [textLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:8 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(17 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(21 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(16 * KWIDTH_IPHONE6_SCALE);
    }];
    //scrollerView
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    self.topScrollView = scrollView;
    scrollView.tag = noDisableVerticalScrollTag;
    //    scrollView.backgroundColor = [UIColor greenColor];
    [self.topImageView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(45 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(topImageV);
        make.width.mas_equalTo(240 * KWIDTH_IPHONE6_SCALE);
        make.bottom.with.offset(-54 * KWIDTH_IPHONE6_SCALE);
    }];
    //问题Label
    self.questionLabel = [[UILabel alloc]init];
    self.questionLabel.text = @"";
    self.questionLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
    self.questionLabel.numberOfLines = 0;
    self.questionLabel.textColor = RGBA(0, 152, 206, 1);
    [scrollView addSubview:self.questionLabel];
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(scrollView);
        make.width.mas_equalTo(240 * KWIDTH_IPHONE6_SCALE);
    }];
}

#pragma mark - 完型填空数据请求
- (void)requestWithData {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL = nil;
    if([self.name isEqualToString:@"最新测验"]) {
        URL = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL,API_EXAM_INFO];
    } else {
        URL = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL,API_HOMEWORK_INFO];
    }
    NSDictionary *params = @{ @"topics_id" : self.topicModel.topics_id};
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
        self.homeworkID = self.topicModel.homework_id;
        JJReadTestModel *readTestModel = [JJReadTestModel modelWithDictionary:response[@"data"]];
        self.readTestModel = readTestModel;
        self.questionLabel.text = readTestModel.passage;
//        self.textLabel.text = [NSString stringWithFormat:@" %@ ",self.readTestModel.topic_title];
        for(int i = 0; i<readTestModel.questionList.count ; i++) {
            JJReadTestProblemModel *model = readTestModel.questionList[i];
            JJClozeProcedureView *readTestView = [JJClozeProcedureView clozeProcedureViewWithReadTestModel:model];
            //self.scrollView.backgroundColor = [UIColor redColor];
            readTestView.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, self.scrollView.height);
            [self.scrollView addSubview:readTestView];
        }
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * readTestModel.questionList.count, self.scrollView.height);
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}

#pragma mark - 下一步按钮点击
-(void)nextBtnClick:(UIButton *)btn {
    if(self.scrollView.contentOffset.x < self.scrollView.contentSize.width - SCREEN_WIDTH) {
        //当小题未完时
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + SCREEN_WIDTH, 0) animated:YES];
    } else {
        //当已经是最后一个小题时,提交作业
        [self requestToSubmitHomework];
    }
}
#pragma mark - <UIScrollViewDelegate>
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if(self.scrollView.contentOffset.x < self.scrollView.contentSize.width - SCREEN_WIDTH) {
        //当小题未完时
        [self.nextHomeworkBtn setTitle:@"下一题" forState:UIControlStateNormal];
    } else {
        [self.nextHomeworkBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    
}
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 人为拖拽scrollView产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(self.scrollView.contentOffset.x < self.scrollView.contentSize.width - SCREEN_WIDTH) {
        //当小题未完时
        [self.nextHomeworkBtn setTitle:@"下一题" forState:UIControlStateNormal];
    } else {
        [self.nextHomeworkBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
}


#pragma mark - 作业提交
- (void)requestToSubmitHomework {
    if(self.readTestModel.questionList.count == 0) return;
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    
    //小题索引 1232_1233_1234
    NSString *answer_index = nil;
    //答案内容listA_B_C
    NSString *answer_content = nil;
    for(int i = 0; i < self.readTestModel.questionList.count; i++) {
        JJReadTestProblemModel *model = self.readTestModel.questionList[i];
        if(i == 0) {
            answer_content = model.myAnswer;
            answer_index = model.unit_id;
        } else {
            answer_index = [NSString stringWithFormat:@"%@_%@",answer_index,model.unit_id];
            answer_content = [NSString stringWithFormat:@"%@_%@",answer_content,model.myAnswer];
        }
        //如果有X,就表示题目没做完
        if([model.myAnswer isEqualToString:@"X"]) {
            //当小题未完时
            [self.scrollView setContentOffset:CGPointMake(i * SCREEN_WIDTH, 0) animated:YES];
            [JJHud showToast:@"题目没有做完,请继续做题"];
            
            return;
        }
    }
    NSString *URL = nil;
    NSDictionary *params = nil;
    if([self.name isEqualToString:@"最新测验"]) {
        URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_POST_EXAM];
        params = @{@"exam_id" : self.homeworkID , @"answer_index" : answer_index, @"answer_content" : answer_content, @"fun_user_id" : [User getUserInformation].fun_user_id};
    } else {
        if(self.topicModel.isSelfStudy) {
            //自学
            URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_SELFSTUDY_POST_HOMEWORK];
            params = @{ @"homework_id" : self.homeworkID , @"answer_index" : answer_index, @"answer_content" : answer_content};//, @"fun_user_id" : [User getUserInformation].fun_user_id};
        } else {
            params = @{@"homework_id" : self.homeworkID , @"answer_index" : answer_index, @"answer_content" : answer_content, @"fun_user_id" : [User getUserInformation].fun_user_id};
            
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
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:TopicListRefreshNotificatiion object:nil];
        });
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
    
    
}



#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        if(isPhone) {
            _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 390 * KWIDTH_IPHONE6_SCALE, SCREEN_WIDTH, 180 * KWIDTH_IPHONE6_SCALE)];
        } else {
            _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 370 * KWIDTH_IPHONE6_SCALE, SCREEN_WIDTH, 130 * KWIDTH_IPHONE6_SCALE)];
        }
        
        [self.backImageView addSubview:_scrollView];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        //下一题
        UIButton *nextHomeworkBtn= [[UIButton alloc]init];
        self.nextHomeworkBtn = nextHomeworkBtn;
        [self.backImageView addSubview:nextHomeworkBtn];
        [nextHomeworkBtn setBackgroundImage:[UIImage imageNamed:@"MatchNextBtn"] forState:UIControlStateNormal];
        [nextHomeworkBtn setTitle:@"下一题" forState:UIControlStateNormal];
        [nextHomeworkBtn setTitleColor:RGBA(212, 0, 0, 1) forState:UIControlStateNormal];
        nextHomeworkBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14 * KWIDTH_IPHONE6_SCALE];
        [nextHomeworkBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [nextHomeworkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(88 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(26 * KWIDTH_IPHONE6_SCALE);
            make.bottom.with.offset(-40 * KWIDTH_IPHONE6_SCALE);
            make.centerX.equalTo(self.backImageView);
        }];
    }
    return _scrollView;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.questionLabel sizeToFit];
    [self.topScrollView layoutIfNeeded];
    [self.topScrollView flashScrollIndicators];
//    DebugLog(@"%@   %@",NSStringFromCGSize(self.topScrollView.contentSize),NSStringFromCGSize(self.topScrollView.contentSize));
//    if(self.topScrollView.contentSize.height > self.topScrollView.height) {
//        for(UIView *subView in self.topScrollView.subviews) {
//            if([subView isKindOfClass:[UIImageView class]]) {
//                [subView setAlpha:1];
//                break;
//            }
//        }
//        [self.topScrollView scrollRectToVisible:CGRectMake(0, 1, self.topScrollView.width * KWIDTH_IPHONE6_SCALE, self.topScrollView.height) animated:YES];
//    }
    
}


@end
