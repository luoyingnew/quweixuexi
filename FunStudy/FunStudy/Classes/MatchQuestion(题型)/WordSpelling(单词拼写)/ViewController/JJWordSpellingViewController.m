//
//  JJWordSpellingViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/22.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJWordSpellingViewController.h"
#import "JJWordSpellingCell.h"
#import "JJWordSpellingModel.h"
#import "JJWordSpellingView.h"
#import <AVFoundation/AVFoundation.h>
#import "JJBilingualResultViewController.h"
#import "JJBilingualResultModel.h"
#import <ReactiveCocoa.h>
#import "JJWordSpellingResultViewController.h"



//注册JJHorizontalCollectionViewCell标示
static NSString * const wordSpellingCellIdentifier = @"JJWordSpellingCellIdentifier";

@interface JJWordSpellingViewController ()

//@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *scrollView;

//接口得到的数据数据
@property (nonatomic, strong) NSMutableArray<JJWordSpellingModel *> *modelArray;
//结果数组
@property (nonatomic, strong) NSMutableArray<JJBilingualResultModel *> *billingualResultModelArray;

//播放器
@property(nonatomic, strong)AVPlayer *player;

//该题对应的作业ID,主要用于提交答案时用
@property (nonatomic, strong) NSString *homeworkID;

//下一题按钮
@property (nonatomic, strong) UIButton *nextHomeworkBtn;
@end

@implementation JJWordSpellingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBaseView];
    [self requestWithData];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSDictionary *d1 = @{@"option_desc" : @"苹果", @"topic_text" : @"apple"};
//        NSDictionary *d2 = @{@"option_desc" : @"你", @"topic_text" : @"you"};
//        NSDictionary *d3 = @{@"option_desc" : @"祝福", @"topic_text" : @"contragulation"};
//        NSDictionary *d4 = @{@"option_desc" : @"中文", @"topic_text" : @"Chinese"};
//        NSArray <NSDictionary *>*dataArray = @[d1,d2,d3,d4];
//        for(NSDictionary *dict in dataArray) {
//            JJWordSpellingModel *wordSpellingModel = [JJWordSpellingModel modelWithDictionary:dict];
//            //            wordSpellingModel.file_video = @"http://xunlei.sc.chinaz.com/Files/DownLoad/sound1/201611/7991.wav";
//            [self.modelArray addObject:wordSpellingModel];
//        }
//        [self setUpQuestionView];
//
//    });
    
    //监听scrollerView的滚动后可以设置titleName
    @weakify(self);
    [[RACObserve(self, scrollView.contentOffset)ignore:nil] subscribeNext:^(NSValue *x) {
        @strongify(self);
        CGPoint point = [x CGPointValue];
        
        NSInteger currentIndex = (point.x / SCREEN_WIDTH)+1;
        NSInteger count = 0;
        for(JJWordSpellingModel *model in self.modelArray) {
            if(model.isRight == NO) count++;
        }
        self.titleName = [NSString stringWithFormat:@"%@%ld/%ld",self.navigationTitleName, currentIndex, count];
    }];

}
#pragma mark - 基本设置
//基本设置
- (void)setUpBaseView{
    self.titleName = self.navigationTitleName;
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.userInteractionEnabled = YES;
//    self.backImageView = backImageView;
    backImageView.image = [UIImage imageNamed:@"wordSpellingBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    
}
//取到数据之后 或者 重做错题时 进行布局
- (void)setUpQuestionView {
    [self.scrollView removeAllSubviews];
    self.scrollView.contentSize = CGSizeMake(0, 0);
    for(int i=0; i<self.modelArray.count;i++) {
        JJWordSpellingModel *wordSpellingModel = self.modelArray[i];
        
        if(wordSpellingModel.isRight == YES) continue;
        JJBilingualResultModel *resultModel = self.billingualResultModelArray[i];
        JJWordSpellingView *wordSpellingView = [[JJWordSpellingView alloc]init];
        weakSelf(weakSelf);
        wordSpellingView.playAudioBlock = ^{
            [weakSelf playWithModel:wordSpellingModel];
        };
        wordSpellingView.frame = CGRectMake(self.scrollView.contentSize.width, 0, SCREEN_WIDTH, self.scrollView.height);
        [self.scrollView addSubview:wordSpellingView];
        wordSpellingView.model = wordSpellingModel;
        wordSpellingView.resultModel = resultModel;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width + SCREEN_WIDTH, self.scrollView.height);
    }
    //修改下一题按钮的文字展示
    [self changeNextBtnTitle];
}

#pragma mark - 单词数据请求
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
            JJWordSpellingModel *wordSpellingModel = [JJWordSpellingModel modelWithDictionary:dict];
            JJBilingualResultModel *resultModel = [[JJBilingualResultModel alloc]init];
//            wordSpellingModel.file_video = @"http://xunlei.sc.chinaz.com/Files/DownLoad/sound1/201611/7991.wav";
//            JJWordSpellingView *wordSpellingView = [[JJWordSpellingView alloc]init];
//            weakSelf(weakSelf);
//            wordSpellingView.playAudioBlock = ^{
//                [weakSelf playWithModel:wordSpellingModel];
//            };
//            wordSpellingView.frame = CGRectMake(self.modelArray.count * SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height);
//            [self.scrollView addSubview:wordSpellingView];
//            wordSpellingView.model = wordSpellingModel;
            [self.modelArray addObject:wordSpellingModel];
            [self.billingualResultModelArray addObject:resultModel];
            
//            self.scrollView.contentSize = CGSizeMake(self.modelArray.count * SCREEN_WIDTH, self.scrollView.height);
        }
        //布局界面
        [self setUpQuestionView];
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}


#pragma mark 播放音乐
-(void)playWithModel:(JJWordSpellingModel*)model{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
    [[AVAudioSession sharedInstance] setActive:YES error:NULL];
    NSURL *url = nil;
    NSFileManager *ma = [NSFileManager defaultManager];
    if([ma fileExistsAtPath:JJAudioFileFullpathMP3(model.file_video)]){
        //如果已经下载过的话,直接播放本地的
        url =[NSURL fileURLWithPath: JJAudioFileFullpathMP3(model.file_video)];
        
    } else {
        //如果没下载过,则播放网络资源并进行下载
        url = [NSURL URLWithString:model.file_video];
        [HFNetWork downLoadWithURL:model.file_video destinationPath:JJAudioFileFullpathMP3(model.file_video) params:nil progress:^(NSProgress *progress) {
            NSLog(@"jindu:%@",progress);
        }];
    }
    //    AVURLAsset *asset  = [AVURLAsset assetWithURL:url];
    //        NSString *transKey = @"tracks";
    //    [asset loadValuesAsynchronouslyForKeys:@[transKey]  completionHandler:^{
    //        NSError *error;
    //        AVKeyValueStatus status = [asset statusOfValueForKey:transKey error:&error];
    AVPlayerItem *playerItem = nil;
    //        if(status == AVKeyValueStatusLoaded){
    //            playerItem = [AVPlayerItem playerItemWithAsset:asset];
    //        }else{
    playerItem = [AVPlayerItem playerItemWithURL:url];
    //        }
    //[self.player.currentItem removeObserver:self forKeyPath:@"status"];
    //替换当前音乐资源
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    
    //[self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];

    //    //监听音乐播放完成通知
    //    [self addNSNotificationForPlayMusicFinish];
    //监听播放器状态
    //        [self addPlayStatus];
    //开始播放
        [self.player play];

    //    }];
    //    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
}


#pragma mark - 取消按钮点击
- (void)cancleBtnClick:(UIButton *)btn {
    int i = self.scrollView.contentOffset.x / SCREEN_WIDTH;
    JJWordSpellingView *currentWordSpellingView = self.scrollView.subviews[i];
    NSArray<UILabel *> *labelArray = currentWordSpellingView.wordLetterArray;
    for(UILabel *label in labelArray) {
        if(label.textColor == [UIColor redColor]) {
            label.text = @"";
        }
    }
    
}

#pragma mark - 下一题按钮点击
- (void)nextBtnClick:(UIButton *)btn {
    [self.player pause];
    if(self.scrollView.contentOffset.x < self.scrollView.contentSize.width - SCREEN_WIDTH) {
        //当小题未完时
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + SCREEN_WIDTH, 0) animated:YES];
    } else {
        //结果数组
        //NSMutableArray<JJBilingualResultModel *> *billingualResultModelArray = [NSMutableArray array];
        NSArray<JJWordSpellingView *> *wordSpellingViewArray = self.scrollView.subviews;
       
        
        
        
        for(JJWordSpellingView *wordSpellingView in wordSpellingViewArray) {
            NSString *myAnswer = @"";
//            if(wordSpellingView.model == nil) {
//                wordSpellingView.resultModel = [[JJBilingualResultModel alloc]init];
//                [self.billingualResultModelArray addObject:wordSpellingView.resultModel];
//            } else {
//                for(int i = 0; i < self.modelArray.count; i++) {
//                    if(wordSpellingView.model == self.modelArray[i]) {
//                        wordSpellingView.resultModel = self.billingualResultModelArray[i];
//                        break;
//                    }
//                }
//            }
            //JJBilingualResultModel *bilingualResultModel = [[JJBilingualResultModel alloc]init];
            for(UILabel *lab in wordSpellingView.wordLetterArray) {
                myAnswer = [NSString stringWithFormat:@"%@%@",myAnswer,lab.text];
                NSLog(@"--%@--",myAnswer);
            }
            wordSpellingView.model.myAnswer = myAnswer;
            wordSpellingView.resultModel.myAnswerleftText = wordSpellingView.model.myAnswer;
            wordSpellingView.resultModel.unit_id = wordSpellingView.model.unit_id;
            if([wordSpellingView.model.myAnswer isEqualToString:wordSpellingView.model.word]) {
                wordSpellingView.resultModel.isRight = YES;
                wordSpellingView.model.isRight = YES;
            } else {
                wordSpellingView.resultModel.isRight = NO;
                wordSpellingView.model.isRight = NO;
            }
            
        }
        JJWordSpellingResultViewController *resultViewController = [[JJWordSpellingResultViewController alloc]init];
        resultViewController.isSelfStudy = self.topicModel.isSelfStudy;
        resultViewController.bilingualResultModelArray = self.billingualResultModelArray;
        resultViewController.name = @"单词拼写结果";
        resultViewController.typeName = self.name;
        resultViewController.homeworkID = self.homeworkID;
        weakSelf(weakSelf);
        resultViewController.redoBlock = ^{
            //点击重做错题后重新布局
            [weakSelf setUpQuestionView];
        };
        [self.navigationController pushViewController:resultViewController animated:YES];
        //        //当已经是最后一个小题时,提交作业
        //        [self requestToSubmitHomework];
    }
}


#pragma mark - <UIScrollViewDelegate>
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self changeNextBtnTitle];
}

/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 人为拖拽scrollView产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self changeNextBtnTitle];
}

#pragma mark 根据scrollerView的contentofset设置下一题按钮的文字
- (void)changeNextBtnTitle {
    if(self.scrollView.contentOffset.x < self.scrollView.contentSize.width - SCREEN_WIDTH) {
        //当小题未完时
        [self.nextHomeworkBtn setTitle:@"下一题" forState:UIControlStateNormal];
    } else {
        [self.nextHomeworkBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
}


#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100 * KWIDTH_IPHONE6_SCALE, SCREEN_WIDTH, 433 * KWIDTH_IPHONE6_SCALE)];
        [self.view addSubview:_scrollView];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        
        //提交按钮
        UIButton *submitBtn= [[UIButton alloc]init];
        self.nextHomeworkBtn = submitBtn;
        [self.view addSubview:submitBtn];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"wordSpellingGreenBtn"] forState:UIControlStateNormal];
        [submitBtn setTitle:@"下一题" forState:UIControlStateNormal];
        [submitBtn setTitleColor:RGBA(0, 103, 0, 1) forState:UIControlStateNormal];
        submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18 * KWIDTH_IPHONE6_SCALE];
        [submitBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(116 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(35 * KWIDTH_IPHONE6_SCALE);
            make.bottom.with.offset(-20 * KWIDTH_IPHONE6_SCALE);
            make.left.with.offset(44 * KWIDTH_IPHONE6_SCALE);
        }];

        //取消按钮
        UIButton *cancleBtn= [[UIButton alloc]init];
        [self.view addSubview:cancleBtn];
        [cancleBtn setBackgroundImage:[UIImage imageNamed:@"wordSpellingGreenBtn"] forState:UIControlStateNormal];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:RGBA(0, 103, 0, 1) forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18 * KWIDTH_IPHONE6_SCALE];
        [cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(116 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(35 * KWIDTH_IPHONE6_SCALE);
            make.bottom.with.offset(-20 * KWIDTH_IPHONE6_SCALE);
            make.right.with.offset(-44 * KWIDTH_IPHONE6_SCALE);
        }];
    }
    return _scrollView;
}

//#pragma mark - KVO观察者回调
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    //注意这里查看的是self.player.status属性
//    if ([keyPath isEqualToString:@"status"]) {
//        switch (_player.currentItem.status) {
//            case AVPlayerStatusUnknown:
//            {
//                DebugLog(@"未知转态");
//            }
//                break;
//            case AVPlayerStatusReadyToPlay:
//            {
//                DebugLog(@"准备播放");
//            }
//                break;
//            case AVPlayerStatusFailed:
//            {
//                [JJHud showToast:@"无法播放"];
//            }
//                break;
//            default:
//                break;
//        }
//    }
//}

#pragma mark - 懒加载

//播放器
- (AVPlayer *)player {
    if(_player == nil) {
        //初始化_player
        _player = [[AVPlayer alloc] init];
        [[RACObserve(_player, currentItem.status) ignore:nil] subscribeNext:^(NSNumber *x) {
            AVPlayerItemStatus status = x.intValue;
            switch (status) {
                case AVPlayerStatusUnknown:
                {
                    DebugLog(@"未知转态");
                }
                    break;
                case AVPlayerStatusReadyToPlay:
                {
                    DebugLog(@"准备播放");
                }
                    break;
                case AVPlayerStatusFailed:
                {
                    [JJHud showToast:@"无法播放"];
                }
                    break;
                default:
                    break;
            }
            
        }];

    }
    return _player;
}

- (NSMutableArray *)modelArray {
    if(!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (NSMutableArray *)billingualResultModelArray {
    if(!_billingualResultModelArray) {
        _billingualResultModelArray = [NSMutableArray array];
    }
    return _billingualResultModelArray;
}

- (void)dealloc {
    NSLog(@"JJWSPVCxiaohui");
}

//#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.modelArray.count;//self.HorizontalCollectionViewCellModelArray.count;
//    
//}
//
////创建collectionViewCell
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    JJWordSpellingCell *cell = [[JJWordSpellingCell alloc]init];// [collectionView dequeueReusableCellWithReuseIdentifier:wordSpellingCellIdentifier forIndexPath:indexPath];
//            cell.model = self.modelArray[indexPath.item];
//    
//    return cell;
//}
//
////itemSize
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return self.collectionView.size;
//}
//
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    //    最小行间距
//
//        return 0;
//}
////布局
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    //    NSLog(@"%@",NSStringFromCGRect(self.bounds));
//    self.imageView.frame = CGRectMake(10 , 10, self.width - 10 * 2 , (self.width - 10 * 2) * (176.0 /375));
//    self.collectionView.frame = CGRectMake(0, self.imageView.bottom, SCREEN_WIDTH, self.height - self.imageView.bottom - 10);
//    DebugLog(@"%@",NSStringFromCGRect(self.collectionView.frame));
//    self.lineView.frame = CGRectMake(0, self.collectionView.bottom, self.width, 10);
//    
//    
//}
//@property (nonatomic, strong) NSString *option_right;//中文
//@property (nonatomic, strong) NSString *word;//单词
//@property (nonatomic, strong) NSString *file_video;//音频路径
//@property (nonatomic, strong) NSString *unit_id; //id
//@property (nonatomic, strong) NSString *myAnswer;




//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    NSArray *a = self.navigationController.viewControllers;
//    NSLog(@"出现了%ld",self.navigationController.viewControllers.count);
//    
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    NSLog(@"消失了%ld",self.navigationController.viewControllers.count);
//    //NSLog(@"消失了");
//}

@end
