//
//  JJErrorCorrectionViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJErrorCorrectionViewController.h"
#import "JJErrorCorrectionModel.h"
#import "JJErrorCorrectionView.h"
#import <ReactiveCocoa.h>
@interface JJErrorCorrectionViewController ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *topImageView;

@property (nonatomic, strong) UIScrollView  *scrollView;

@property (nonatomic, strong) NSMutableArray<JJErrorCorrectionModel *> *modelArray;

//该题对应的作业ID,主要用于提交答案时用
@property (nonatomic, strong) NSString *homeworkID;

//下一题按钮
@property (nonatomic, strong) UIButton *nextHomeworkBtn;
@end

@implementation JJErrorCorrectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    [self requestWithData];
    //监听scrollerView的滚动后可以设置titleName
    [[RACObserve(self, scrollView.contentOffset)ignore:nil] subscribeNext:^(NSValue *x) {
        CGPoint point = [x CGPointValue];
        
        NSInteger currentIndex = (point.x / SCREEN_WIDTH)+1;
        
        self.titleName = [NSString stringWithFormat:@"%@%ld/%ld",self.navigationTitleName,currentIndex,self.modelArray.count];
    }];

}

#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = self.navigationTitleName;
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.userInteractionEnabled = YES;
    self.backImageView = backImageView;
    backImageView.image = [UIImage imageNamed:@"SingleChooseBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    
    //top
    UIImageView *topImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SingleChooseTopBack"]];
    topImageV.userInteractionEnabled = YES;
    self.topImageView = topImageV;
    [self.backImageView addSubview:topImageV];
    [topImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(328 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(243 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(92 * KWIDTH_IPHONE6_SCALE);
    }];
}


#pragma mark - 改错题数据请求
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
        NSArray <NSDictionary *>*dataArray = response[@"data"][@"content"];
        for(NSDictionary *dict in dataArray) {
            JJErrorCorrectionModel *errorCorrectionModel = [JJErrorCorrectionModel modelWithDictionary:dict];
            errorCorrectionModel.topic_title = self.topicModel.topic_title;
            JJErrorCorrectionView *errorCorrectionView = [JJErrorCorrectionView errorCorrectionViewWithModel:errorCorrectionModel];
            errorCorrectionView.frame = CGRectMake(self.modelArray.count * SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height);
            [self.scrollView addSubview:errorCorrectionView];
            [self.modelArray addObject:errorCorrectionModel];
            self.scrollView.contentSize = CGSizeMake(self.modelArray.count * SCREEN_WIDTH, self.scrollView.height);
        }
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}

#pragma mark - 下一步按钮点击
-(void)nextBtnClick:(UIButton *)btn {
    [self.view endEditing:YES];
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
    if(self.modelArray.count == 0) return;
    NSArray *a = self.modelArray;
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
   
    //小题索引 1232_1233_1234
    NSString *answer_index = nil;
    //答案内容listA_B_C
    NSString *answer_content = nil;
    for(int i = 0; i < self.modelArray.count; i++) {
        
        JJErrorCorrectionModel *model = self.modelArray[i];
        
        DebugLog(@"%d%@",i,model.myAnswer);
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
    NSDictionary *params = nil;
    NSString *URL = nil;
    if([self.name isEqualToString:@"最新测验"]) {
        params = @{ @"exam_id" : self.homeworkID , @"answer_index" : answer_index, @"answer_content" : answer_content, @"fun_user_id" : [User getUserInformation].fun_user_id};
        URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_POST_EXAM];
    } else {
        
        if(self.topicModel.isSelfStudy) {
            //自学
            URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_SELFSTUDY_POST_HOMEWORK];
            params = @{ @"homework_id" : self.homeworkID , @"answer_index" : answer_index, @"answer_content" : answer_content};//, @"fun_user_id" : [User getUserInformation].fun_user_id};
        } else {
            params = @{ @"homework_id" : self.homeworkID , @"answer_index" : answer_index, @"answer_content" : answer_content, @"fun_user_id" : [User getUserInformation].fun_user_id};
            
            URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_POST_HOMEWORK];
        }
    }
    DebugLog(@"%@",params);
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
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 92 * KWIDTH_IPHONE6_SCALE, SCREEN_WIDTH, 243 * KWIDTH_IPHONE6_SCALE)];
        [self.backImageView addSubview:_scrollView];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        
        //下一题
        UIButton *nextHomeworkBtn= [[UIButton alloc]init];
        self.nextHomeworkBtn = nextHomeworkBtn;
        [self.view addSubview:nextHomeworkBtn];
        [nextHomeworkBtn setBackgroundImage:[UIImage imageNamed:@"MatchNextBtn"] forState:UIControlStateNormal];
        [nextHomeworkBtn setTitle:@"下一题" forState:UIControlStateNormal];
        [nextHomeworkBtn setTitleColor:RGBA(212, 0, 0, 1) forState:UIControlStateNormal];
        nextHomeworkBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14 * KWIDTH_IPHONE6_SCALE];
        [nextHomeworkBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [nextHomeworkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(88 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(26 * KWIDTH_IPHONE6_SCALE);
            make.top.with.offset(281 * KWIDTH_IPHONE6_SCALE);
            make.centerX.equalTo(self.backImageView);
        }];
    }
    return _scrollView;
}

//懒加载
- (NSMutableArray *)modelArray {
    if(!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}
@end
