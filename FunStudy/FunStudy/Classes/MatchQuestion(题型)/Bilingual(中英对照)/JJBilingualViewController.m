//
//  JJBilingualViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/20.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBilingualViewController.h"
#import "JJBilingualView.h"
#import "JJProgressView.h"
#import "JJBilingualResultViewController.h"
#import "JJBilingualModel.h"
#import <ReactiveCocoa.h>
#import "JJBilingualArrayModel.h"

@interface JJBilingualViewController ()

//@property (nonatomic, strong) JJBilingualView *bilingualView;
//模型
//@property (nonatomic, strong) JJBilingualArrayModel *bilingualArrayModel;
//将请求下来的JJBilingualArrayModel没4个位一组重新弄成的模型数组
@property (nonatomic, strong)NSMutableArray<JJBilingualArrayModel *> *bilingualArrayModelArray;

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) JJProgressView *progressView;
//@property (nonatomic, strong) NSArray<JJBilingualModel *> *bilingualModelArray;

//该题对应的作业ID,主要用于提交答案时用
@property (nonatomic, strong) NSString *homeworkID;

//下一题按钮
@property (nonatomic, strong) UIButton *nextHomeworkBtn;
@end

@implementation JJBilingualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    [self requestWithData];
    //监听scrollerView的滚动后可以设置titleName
    [[RACObserve(self, scrollView.contentOffset)ignore:nil] subscribeNext:^(NSValue *x) {
        CGPoint point = [x CGPointValue];
        
        NSInteger currentIndex = ((point.x + 122 * KWIDTH_IPHONE6_SCALE)  / (244 * KWIDTH_IPHONE6_SCALE))+1;
        
        self.titleName = [NSString stringWithFormat:@"%@%ld/%ld",self.navigationTitleName,currentIndex,self.bilingualArrayModelArray.count];
    }];
    
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    //self.titleName = self.navigationTitleName;
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"bilingualBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    
    //设置进度条
    self.progressView = [[JJProgressView alloc]init];
    self.progressView.hidden = YES;
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(94 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(287 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(19 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //将对应的中英文配对
    UILabel *textLabel = [[UILabel alloc]init];
    self.textLabel = textLabel;
    textLabel.textColor = RGBA(0, 96, 181, 1);
    textLabel.text = @"";//@"将对应的中英文配对";
    textLabel.font = [UIFont boldSystemFontOfSize:18 * KWIDTH_IPHONE6_SCALE];
    [self.view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        if(isPhone) {
            make.top.equalTo(self.progressView.mas_bottom).with.offset(22 * KWIDTH_IPHONE6_SCALE);
        } else {
            make.top.equalTo(self.progressView.mas_bottom).with.offset(-40 * KWIDTH_IPHONE6_SCALE);
        }
        
    }];
}

#pragma mark - 中英对照数据请求
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
        JJTopicModel *t = self.topicModel;
        self.textLabel.text = t.topic_title;
        self.homeworkID = self.topicModel.homework_id;
        JJBilingualArrayModel *bilingualArrayModel = [JJBilingualArrayModel mj_objectWithKeyValues:response[@"data"]];
        
        NSArray<JJBilingualModel *> *bilingualModelArray = bilingualArrayModel.bilingualModelArray;
        
        
        
//        JJBilingualModel *model1 = [[JJBilingualModel alloc]init];
//        model1.option_right = @"11";
//        model1.topic_text = @"111";
//        model1.unit_id = @"1";
//        JJBilingualModel *model2 = [[JJBilingualModel alloc]init];
//        model2.option_right = @"22";
//        model2.topic_text = @"222";
//        model2.unit_id = @"2";
//        JJBilingualModel *model3 = [[JJBilingualModel alloc]init];
//        model3.option_right = @"33";
//        model3.topic_text = @"333";
//        model3.unit_id = @"3";
//        JJBilingualModel *model4 = [[JJBilingualModel alloc]init];
//        model4.option_right = @"44";
//        model4.topic_text = @"444";
//        model4.unit_id = @"4";
//        JJBilingualModel *model5 = [[JJBilingualModel alloc]init];
//        model5.option_right = @"55";
//        model5.topic_text = @"555";
//        model5.unit_id = @"5";
//        bilingualModelArray = @[model1,model2,model3,model4,model5];
//        bilingualArrayModel.bilingualModelArray = bilingualModelArray;
        
        
        
        
        int count = bilingualModelArray.count / 4 + (bilingualModelArray.count % 4 ? 1 : 0);
        self.scrollView.contentSize = CGSizeMake(244 * count * KWIDTH_IPHONE6_SCALE, 0);
        for(int i = 0; i < count; i++) {
            NSArray<JJBilingualModel *> *subBilingualModelArray = [bilingualModelArray subarrayWithRange:NSMakeRange(i * 4, (bilingualModelArray.count - i * 4) >= 4 ? 4 : (bilingualModelArray.count - i * 4))];
            JJBilingualArrayModel *bilingualArrayModel = [[JJBilingualArrayModel alloc]init];
            bilingualArrayModel.bilingualModelArray = subBilingualModelArray;
            
            JJBilingualView *bilingualView = [[JJBilingualView alloc]init];
            bilingualView.backgroundColor = [UIColor clearColor];
            [self.scrollView addSubview:bilingualView];
            bilingualView.frame = CGRectMake(244 * KWIDTH_IPHONE6_SCALE * self.bilingualArrayModelArray.count, 0, 244 * KWIDTH_IPHONE6_SCALE, 432 * KWIDTH_IPHONE6_SCALE);
            bilingualView.model = bilingualArrayModel;
            [self.bilingualArrayModelArray addObject:bilingualArrayModel];
        }
        
        //获取到数据之后先给titname赋值
        CGPoint point = self.scrollView.contentOffset;
        NSInteger currentIndex = (point.x / (244 * KWIDTH_IPHONE6_SCALE))+1;
        self.titleName = [NSString stringWithFormat:@"%@%ld/%ld",self.navigationTitleName,currentIndex,self.bilingualArrayModelArray.count];
        
        NSLog(@"123");
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}

#pragma mark - 下一题按钮点击
- (void)nextBtnClick:(UIButton *)btn {
    if(self.scrollView.contentOffset.x < self.scrollView.contentSize.width - (366 * KWIDTH_IPHONE6_SCALE)) {
        //当小题未完时
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + (244 * KWIDTH_IPHONE6_SCALE), 0) animated:YES];
    } else {
        NSMutableArray<JJBilingualResultModel *> *allBillingualResultModelArray = [NSMutableArray array];
        
        for(int i = 0; i < self.bilingualArrayModelArray.count; i++) {
            JJBilingualArrayModel *model = self.bilingualArrayModelArray[i];
            //结果数组
            NSMutableArray<JJBilingualResultModel *> *billingualResultModelArray = [NSMutableArray array];
            NSArray<NSString *> *rightBtnTextArray = self.bilingualArrayModelArray[i].rightBtnTextArray;
            NSArray<NSNumber *> *leftlineRelationArray = self.bilingualArrayModelArray[i].leftlineRelationArray;
            NSArray<JJBilingualModel *> *bilingualModelArray = self.bilingualArrayModelArray[i].bilingualModelArray;
            for(int j = 0 ; j<leftlineRelationArray.count ; j++) {
                JJBilingualResultModel *resultModel = [[JJBilingualResultModel alloc]init];
                resultModel.unit_id = bilingualModelArray[j].unit_id;
                NSString *myAnswer = bilingualModelArray[j].topic_text;
                //-1表示没连线
                if(leftlineRelationArray[j].intValue != (-1)) {
                    //通过leftlineRelationArray 第i个的值可知道左边第i个连线的是右边第j个,然后通过j值索引rightBtnTextArray数组就能取到右边第j个按钮的text
                    NSString *myRightAnswer = rightBtnTextArray[leftlineRelationArray[j].intValue];
                    myAnswer = [NSString stringWithFormat:@"%@-%@",myAnswer,myRightAnswer];
                    //如果右边第i个按钮的text等于bilingualModelArray第i个model的option_right属性,则表示连线正确
                    if([myRightAnswer isEqualToString:bilingualModelArray[j].option_desc]) {
                        resultModel.isRight = YES;
                    }
                } else {
                    [JJHud showToast:@"题目没有做完,请继续做题"];
                    [self.scrollView setContentOffset:CGPointMake(i * 244 * KWIDTH_IPHONE6_SCALE, 0) animated:YES];
                    return;
                }
                resultModel.myAnswerleftText = myAnswer;
                [billingualResultModelArray addObject:resultModel];
            }
            [allBillingualResultModelArray addObjectsFromArray:billingualResultModelArray];
        }
        
            
        JJBilingualResultViewController *resultViewController = [[JJBilingualResultViewController alloc]init];
        resultViewController.isSelfStudy = self.topicModel.isSelfStudy;
        resultViewController.bilingualResultModelArray = allBillingualResultModelArray;
        resultViewController.name = @"中英对照结果";
        resultViewController.homeworkID = self.homeworkID;
        resultViewController.typeName = self.name;
        [self.navigationController pushViewController:resultViewController animated:YES];
    }

    
    
//    //结果数组
//    NSMutableArray<JJBilingualResultModel *> *billingualResultModelArray = [NSMutableArray array];
//    NSArray<NSString *> *rightBtnTextArray = self.bilingualView.model.rightBtnTextArray;
//    NSArray<NSNumber *> *leftlineRelationArray = self.bilingualView.model.leftlineRelationArray;
//    NSArray<JJBilingualModel *> *bilingualModelArray = self.bilingualView.model.bilingualModelArray;
//    for(int i = 0 ; i<leftlineRelationArray.count ; i++) {
//        JJBilingualResultModel *resultModel = [[JJBilingualResultModel alloc]init];
//        resultModel.unit_id = bilingualModelArray[i].unit_id;
//        NSString *myAnswer = bilingualModelArray[i].topic_text;
//        //-1表示没连线
//        if(leftlineRelationArray[i].intValue != (-1)) {
//            //通过leftlineRelationArray 第i个的值可知道左边第i个连线的是右边第j个,然后通过j值索引rightBtnTextArray数组就能取到右边第j个按钮的text
//            NSString *myRightAnswer = rightBtnTextArray[leftlineRelationArray[i].intValue];
//            myAnswer = [NSString stringWithFormat:@"%@-%@",myAnswer,myRightAnswer];
//            //如果右边第i个按钮的text等于bilingualModelArray第i个model的option_right属性,则表示连线正确
//            if([myRightAnswer isEqualToString:bilingualModelArray[i].option_right]) {
//                resultModel.isRight = YES;
//            }
//        } else {
//            [JJHud showToast:@"题目没有做完,请继续做题"];
//            return;
//        }
//        resultModel.myAnswerleftText = myAnswer;
//        [billingualResultModelArray addObject:resultModel];
//    }
//    
//    JJBilingualResultViewController *resultViewController = [[JJBilingualResultViewController alloc]init];
//    resultViewController.isSelfStudy = self.topicModel.isSelfStudy;
//    resultViewController.bilingualResultModelArray = billingualResultModelArray;
//    resultViewController.name = @"中英对照结果";
//    resultViewController.homeworkID = self.homeworkID;
//    resultViewController.typeName = self.name;
//    [self.navigationController pushViewController:resultViewController animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if(self.scrollView.contentOffset.x < self.scrollView.contentSize.width - 366 * KWIDTH_IPHONE6_SCALE) {
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
    if(self.scrollView.contentOffset.x < self.scrollView.contentSize.width - 366 * KWIDTH_IPHONE6_SCALE) {
        //当小题未完时
        [self.nextHomeworkBtn setTitle:@"下一题" forState:UIControlStateNormal];
    } else {
        [self.nextHomeworkBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        [self.view addSubview:_scrollView];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(244 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(432 * KWIDTH_IPHONE6_SCALE);
            if(isPhone) {
                make.bottom.with.offset(-70 * KWIDTH_IPHONE6_SCALE);
            } else {
                make.bottom.with.offset(-40 * KWIDTH_IPHONE6_SCALE);
            }
            
        }];
        //提交按钮
        UIButton *submitBtn= [[UIButton alloc]init];
        self.nextHomeworkBtn = submitBtn;
        [self.view addSubview:submitBtn];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"MatchNextBtn"] forState:UIControlStateNormal];
        [submitBtn setTitle:@"下一题" forState:UIControlStateNormal];
        [submitBtn setTitleColor:RGBA(212, 0, 0, 1) forState:UIControlStateNormal];
        submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18 * KWIDTH_IPHONE6_SCALE];
        [submitBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(88 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(26 * KWIDTH_IPHONE6_SCALE);
            make.centerX.equalTo(self.view);
            make.top.equalTo(_scrollView.mas_bottom).with.offset(5 * KWIDTH_IPHONE6_SCALE);
        }];

        
    }
    return _scrollView;
}

//- (JJBilingualView *)bilingualView {
//    if(!_bilingualView) {
//        UIScrollView *scrollView = [[UIScrollView alloc]init];
//        [self.view addSubview:scrollView];
//        scrollView.delegate = self;
////        scrollView.backgroundColor = [UIColor yellowColor];
//        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.view);
//            make.width.mas_equalTo(244 * KWIDTH_IPHONE6_SCALE);
//            make.height.mas_equalTo(432 * KWIDTH_IPHONE6_SCALE);
//            make.bottom.with.offset(-70 * KWIDTH_IPHONE6_SCALE);
//        }];
//        
//        //提交按钮
//        UIButton *submitBtn= [[UIButton alloc]init];
//        self.nextHomeworkBtn = submitBtn;
//        [self.view addSubview:submitBtn];
//        [submitBtn setBackgroundImage:[UIImage imageNamed:@"MatchNextBtn"] forState:UIControlStateNormal];
//        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
//        [submitBtn setTitleColor:RGBA(212, 0, 0, 1) forState:UIControlStateNormal];
//        submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18 * KWIDTH_IPHONE6_SCALE];
//        [submitBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(88 * KWIDTH_IPHONE6_SCALE);
//            make.height.mas_equalTo(26 * KWIDTH_IPHONE6_SCALE);
//            make.centerX.equalTo(self.view);
//            make.top.equalTo(scrollView.mas_bottom).with.offset(10 * KWIDTH_IPHONE6_SCALE);
//        }];
//
//        _bilingualView = [[JJBilingualView alloc]init];
//        _bilingualView.backgroundColor = [UIColor clearColor];
////        _bilingualView.bilingualBlock = ^(int currentCount, int allCount){
////            CGFloat currentFloatCount = (CGFloat)currentCount;
////            self.progressView.progressValue = (currentFloatCount / allCount);
////        };
//        [scrollView addSubview:_bilingualView];
//        _bilingualView.backgroundColor = [UIColor greenColor];
////        _bilingualView.backgroundColor = [UIColor greenColor];
//        [_bilingualView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.bottom.equalTo(scrollView);
//            make.width.mas_equalTo(244 * KWIDTH_IPHONE6_SCALE);
//            make.height.mas_equalTo(432 * KWIDTH_IPHONE6_SCALE);
//        }];
//    }
//    return _bilingualView;
//}

- (NSMutableArray *)bilingualArrayModelArray {
    if(!_bilingualArrayModelArray) {
        _bilingualArrayModelArray = [NSMutableArray array];
    }
    return _bilingualArrayModelArray;
}


- (void)dealloc {
    NSLog(@"JJBVCxiaohui");
}

@end
