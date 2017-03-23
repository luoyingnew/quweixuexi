//
//  JJReadAloudViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJReadAloudViewController.h"
#import "JJFollowReadCell.h"
#import "JJFollowReadModel.h"
#import <AVFoundation/AVFoundation.h>
#import "JJFollowReadResultViewController.h"
#import <ReactiveCocoa.h>
#import "UINavigationController+FDFullscreenPopGesture.h"

//讯飞
#import <QuartzCore/QuartzCore.h>
#import "Definition.h"
#import "JJRecordResultView.h"
#import "ISRDataHelper.h"
#import "IATConfig.h"
#import "iflyMSC/iflyMSC.h"
#import "PopupView.h"

@interface JJReadAloudViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,IFlySpeechRecognizerDelegate,IFlyRecognizerViewDelegate,UIActionSheetDelegate,IFlyPcmRecorderDelegate>

//===============ifly讯飞====================

@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic, strong) PopupView *popUpView;
@property (nonatomic, strong) NSString * result;//录音后的json串
@property (nonatomic, strong) NSString* resultText;//json串解析后的
@property (nonatomic,assign) BOOL isBeginOfSpeech;//是否返回BeginOfSpeech回调
@property (nonatomic, strong) JJRecordResultView *recordResultView;
@property(nonatomic,assign)Boolean isError;//朗读内容是否有误

//===================================


//播放器
@property(nonatomic, strong)AVPlayer *player;

//录音器
@property (nonatomic, strong) AVAudioRecorder *recorder;


@property (nonatomic, strong) UICollectionView *collectionView; // 作业题视图

@property (nonatomic, strong) NSMutableArray<JJFollowReadModel *> *modelArray;
@property (nonatomic, strong) NSMutableArray<JJFollowReadModel *> *unReadModelArray;//未读的modelARray

//该题对应的作业ID,主要用于提交答案时用
@property (nonatomic, strong) NSString *homeworkID;

//@property (strong ,nonatomic) NSTimer *recordTimer;// 定时器
@property (strong, nonatomic) dispatch_source_t timer;//定时器

@property (assign ,nonatomic) CGFloat recordTime;// 录音时间

//下一题按钮
@property (nonatomic, strong) UIButton *nextHomeworkBtn;
@end

#pragma mark -- 标识符
static NSString *const followReadCellID = @"followReadCellID";

@implementation JJReadAloudViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //在这个界面将全局左划手势的有效范围缩窄至一半,原因:当按住按钮录音的时候有时候会和全局手势冲突
    self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = SCREEN_WIDTH / 3 ;
    //讯飞
    [self initRecognizer];//初始化识别对象
    
}

- (void)viewWillDisappear:(BOOL)animated {
    //讯飞
    [_iFlySpeechRecognizer cancel]; //取消识别
    [_iFlySpeechRecognizer setDelegate:nil];
    [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    [super viewWillDisappear:animated];
    //离开这个界面后将全局左划手势的有效范围变为全屏
    self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = SCREEN_WIDTH ;
    [self.unReadModelArray removeAllObjects];
    [self.unReadModelArray addObjectsFromArray:self.modelArray];
    [self.collectionView reloadData];
}

#pragma mark -- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建缓存目录文件
    [self createCacheDirectory];
    // 初始化视图
    [self setupView];
    // 初始化作业题视图
    [self setupCollectionView];
    //跟读数据获取
    [self requestWithData];
    
    //监听scrollerView的滚动后可以设置titleName
    @weakify(self);
    [[RACObserve(self, collectionView.contentOffset)ignore:nil] subscribeNext:^(NSValue *x) {
        @strongify(self);
        CGPoint point = [x CGPointValue];
        
        NSInteger currentIndex = (point.x / SCREEN_WIDTH)+1;
        
        self.titleName = [NSString stringWithFormat:@"%@%ld/%ld",self.navigationTitleName,currentIndex,self.unReadModelArray.count];
    }];
    
    //设置讯飞
    [self setupIFLY];
}


/**
 *  创建缓存目录文件
 */
- (void)createCacheDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:JJAudioCachesDirectory]) {
        [fileManager createDirectoryAtPath:JJAudioCachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}


#pragma mark -- 初始化视图
- (void)setupView {
    // 标题
    self.titleName = self.navigationTitleName;
    // 背景图片
    self.view.layer.contents = (id)[UIImage imageNamed:@"FollowReadVC_Background"].CGImage;
    
    // 录音按钮
    UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recordButton.frame = CGRectMake((SCREEN_WIDTH - 100) / 2.0, SCREEN_HEIGHT - 140 - 100 * KHEIGHT_IPHONE6_SCALE, 100, 140);
    [recordButton setImage:[UIImage imageNamed:@"FollowRead_RecordButton"] forState:UIControlStateNormal];
    [recordButton setImage:[UIImage imageNamed:@"FollowRead_RecordButtonSelected"] forState:UIControlStateHighlighted];
    //开始录音
    [recordButton addTarget:self action:@selector(begineRecordAction:) forControlEvents:UIControlEventTouchDown];
    //停止录音
    [recordButton addTarget:self action:@selector(endRecordAction:) forControlEvents:UIControlEventTouchUpInside];
    [recordButton addTarget:self action:@selector(endRecordAction:) forControlEvents:UIControlEventTouchUpOutside];
    [recordButton setTitle:@" 按住录音 " forState:UIControlStateNormal];
    [recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    recordButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:1];
    recordButton.titleLabel.layer.cornerRadius = 8;
    recordButton.titleLabel.layer.masksToBounds = YES;
    recordButton.titleLabel.backgroundColor = RGB(0, 151, 206);
    [recordButton verticalCenterImageAndTitle:5];
    [self.view addSubview:recordButton];
    
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
        make.top.equalTo(recordButton.mas_bottom).with.offset(10 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    
}

// 初始化作业题视图
- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, 250 * KWIDTH_IPHONE6_SCALE);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 140 * KHEIGHT_IPHONE6_SCALE, SCREEN_WIDTH, 250 * KWIDTH_IPHONE6_SCALE) collectionViewLayout:flowLayout];
    //    self.collectionView.backgroundColor = [UIColor redColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    [self.view addSubview:self.collectionView];
    
    // 设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // 注册
    [self.collectionView registerClass:[JJFollowReadCell class] forCellWithReuseIdentifier:followReadCellID];
}

//设置讯飞
- (void)setupIFLY {
    IATConfig *instance = [IATConfig sharedInstance];
    instance.speechTimeout = @"15000";
    instance.vadBos = @"15000";
    instance.vadEos = @"15000";
    instance.language = [IFlySpeechConstant LANGUAGE_ENGLISH];
    _popUpView = [[PopupView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 60 * KWIDTH_IPHONE6_SCALE, 100 * KWIDTH_IPHONE6_SCALE, 0, 0) withParentView:self.view];
}
/**
 设置识别参数
 ****/
-(void)initRecognizer
{
    DebugLog(@"%s",__func__);
    
    //单例模式，无UI的实例
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iFlySpeechRecognizer.delegate = self;
    
    if (_iFlySpeechRecognizer != nil) {
        IATConfig *instance = [IATConfig sharedInstance];
        
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"15000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
}


#pragma mark - 跟读数据请求
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
        self.modelArray = [JJFollowReadModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"content"]];
        self.unReadModelArray = [NSMutableArray arrayWithArray:self.modelArray];
        for(int i=0;i<self.modelArray.count;i++) {
            JJFollowReadModel *model = self.modelArray[i];
            //            model.topic_text = @"aaa#bbb#fccc";
            model.topic_title = self.topicModel.topic_title;
            model.homeworkID = self.homeworkID;
            //            model.file_video = @"http://xunlei.sc.chinaz.com/Files/DownLoad/sound1/201611/7983.wav";
            //            if(i==1) {
            //                model.file_video = @"http://xunlei.sc.chinaz.com/Files/DownLoad/sound1/201611/7985.wav";
            //            }
        }
        [self.collectionView reloadData];
        
        //        NSArray <NSDictionary *>*dataArray = response[@"data"][@"homework_content"];
        //        for(NSDictionary *dict in dataArray) {
        //            JJErrorCorrectionModel *errorCorrectionModel = [JJErrorCorrectionModel modelWithDictionary:dict];
        //            JJErrorCorrectionView *errorCorrectionView = [JJErrorCorrectionView errorCorrectionViewWithModel:errorCorrectionModel];          errorCorrectionView.frame = CGRectMake(self.modelArray.count * SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height);
        //            [self.scrollView addSubview:errorCorrectionView];
        //            [self.modelArray addObject:errorCorrectionModel];
        //            self.scrollView.contentSize = CGSizeMake(self.modelArray.count * SCREEN_WIDTH, self.scrollView.height);
        //        }
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}


#pragma mark -播放音乐
-(void)playWithString:(NSString *)file_video{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
    [[AVAudioSession sharedInstance] setActive:YES error:NULL];
    NSURL *url = nil;
    NSFileManager *ma = [NSFileManager defaultManager];
    if([ma fileExistsAtPath:JJAudioFileFullpathWAV(file_video)]){
        //如果已经下载过的话,直接播放本地的
        url =[NSURL fileURLWithPath: JJAudioFileFullpathWAV(file_video)];
        
    } else {
        //如果没下载过,则播放网络资源并进行下载
        url = [NSURL URLWithString:file_video];
        [HFNetWork downLoadWithURL:file_video destinationPath:JJAudioFileFullpathWAV(file_video) params:nil progress:^(NSProgress *progress) {
            DebugLog(@"jindu:%@",progress);
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


//判断是否允许使用麦克风7.0新增的方法requestRecordPermission
-(BOOL)canRecord
{
    __block BOOL bCanRecord = NO;
    if ([[UIDevice currentDevice] systemVersion].doubleValue >= 7.0)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:nil
                                                    message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                                   delegate:nil
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
    
    return bCanRecord;
}
#pragma mark -- 响应事件
//开始录音
- (void)begineRecordAction:(UIButton *)button {
    self.isError = NO;
    self.resultText = @"";
    [self.player pause];
    if(![self canRecord]) return;
    
    //    [self.player pause];
    
    DebugLog(@"%s",__func__);
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (session == nil) {
        DebugLog(@"Error creating session: %@",[sessionError description]);
    }else{
        [session setActive:YES error:nil];
        DebugLog(@"fdsfs");
    }
    
    
    NSInteger currentIndex =  self.collectionView.contentOffset.x / self.collectionView.width;
    JJFollowReadModel *followReadModel = self.unReadModelArray[currentIndex];
    
    //设置录音的参数
    NSDictionary *settingRecorder = @{
                                      AVEncoderAudioQualityKey : [NSNumber numberWithInteger:AVAudioQualityHigh],
                                      AVEncoderBitRateKey : [NSNumber numberWithInteger:16],
                                      AVSampleRateKey : [NSNumber numberWithFloat:8000],
                                      AVNumberOfChannelsKey : [NSNumber numberWithInteger:2],
                                      };
    NSString *s = JJAudioFileFullpathWAV(followReadModel.lastURL);
    // 5.创建录音对象
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:JJAudioFileFullpathWAV(followReadModel.lastURL)] settings:settingRecorder error:nil];
    [self.recorder prepareToRecord];
    [self.recorder record];
    
    //self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 0.01 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //        DebugLog(@"%@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self countVoiceTime];
        });
    });
    dispatch_resume(_timer);
    
    
    //开始讯飞录音
    [self iflyBegineRecordAction];
}

#pragma mark 讯飞开始录音
- (void)iflyBegineRecordAction {
    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer];
    }
    
    [_iFlySpeechRecognizer cancel];
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    //    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iFlySpeechRecognizer setDelegate:self];
    
    BOOL ret = [_iFlySpeechRecognizer startListening];
    
    if (ret) {
        
    }else{
        [_popUpView showText: @"启动识别服务失败，请稍后重试"];//可能是上次请求未结束，暂不支持多路并发
    }

}


//点击按钮的手指停止按住.停止录音
- (void) endRecordAction:(UIButton *)button {
    DebugLog(@"agagagagadsaaf");
    if(![self canRecord]){
        DebugLog(@"还没同意");
        return;
    }
    if(!self.isError) {
        [JJHud showStatus:@"正在评测"];
    }
    [self.recorder stop];
    //    [self.recordTimer invalidate];
    //
    //    self.recordTimer = nil;
    dispatch_source_cancel(_timer);
    JJFollowReadCell *cell = self.collectionView.visibleCells[0];
    cell.progressView.progressValue = 0.0;
    if(self.recordTime > 0.1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSInteger currentIndex =  self.collectionView.contentOffset.x / self.collectionView.width;
            JJFollowReadModel *followReadModel = self.unReadModelArray[currentIndex];
            [self playWithString:followReadModel.lastURL];
        });
    }
    self.recordTime = 0.0;
    //停止讯飞录音
    [self iflyEndRecordAction];
}

#pragma mark 讯飞停止录音
- (void)iflyEndRecordAction {
    [_iFlySpeechRecognizer stopListening];
}

//每0.01秒触发一次
-(void)countVoiceTime
{
    self.recordTime += 0.01;
    DebugLog(@"shuliang%ld   countime:%lf",self.collectionView.visibleCells.count,self.recordTime);
    JJFollowReadCell *cell = self.collectionView.visibleCells[0];
    cell.progressView.progressValue = self.recordTime / 15.0;
    DebugLog(@"%lf",cell.progressView.progressValue);
    if (self.recordTime >= 15.0) {
        //self.recordTime = 0.0;
        //cell.progressView.progressValue = 0.0;
        [self.recorder stop];
        //        [self.recordTimer invalidate];
        //        self.recordTimer = nil;
        dispatch_source_cancel(_timer);
        //        [self timeisOver];
    }
}

#pragma mark - 讯飞Delegate
#pragma mark - IFlySpeechRecognizerDelegate

/**
 音量回调函数
 volume 0－30
 ****/
- (void) onVolumeChanged: (int)volume
{
    //    if (self.isCanceled) {
    //        [_popUpView removeFromSuperview];
    //        return;
    //    }
    
    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
    [_popUpView showText: vol];
}



/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech
{
    DebugLog(@"onBeginOfSpeech开始识别");
    
    //    if (self.isStreamRec == NO)
    //    {
    self.isBeginOfSpeech = YES;
    [_popUpView showText: @"正在录音"];
    //    }
}

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech
{
    DebugLog(@"onEndOfSpeech录音停止回调");
    
    //    [_pcmRecorder stop];
    [_popUpView showText: @"停止录音"];
}


/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
//这个是最后调用的
- (void) onError:(IFlySpeechError *) error
{
    [JJHud dismiss];
    self.isError = NO;
    DebugLog(@"%s  %@  %d",__func__,error.errorDesc,error.errorCode);
    
    //    if ([IATConfig sharedInstance].haveView == NO ) {
    
    //        if (self.isStreamRec) {
    //            //当音频流识别服务和录音器已打开但未写入音频数据时stop，只会调用onError不会调用onEndOfSpeech，导致录音器未关闭
    //            [_pcmRecorder stop];
    //            self.isStreamRec = NO;
    //            DebugLog(@"error录音停止");
    //        }
    
    NSString *text ;
    
    /*if (self.isCanceled) {
     text = @"识别取消";
     } else */
    if (error.errorCode == 0 ) {
        if (_result.length == 0) {
            self.isError = YES;
            text = @"无识别结果";
            [JJHud showToast:@"无识别结果"];
            [self endRecordAction:nil];
        }else {
            text = @"识别成功";
            NSInteger currentIndex =  self.collectionView.contentOffset.x / self.collectionView.width;
            JJFollowReadModel *followReadModel = self.unReadModelArray[currentIndex];
            self.recordResultView.hidden = NO;
            self.recordResultView.alpha = 1.0;
            float totalScore = ([followReadModel.topic_text likePercent:_resultText] + [_resultText likePercent:followReadModel.topic_text])/2 / 20;
            followReadModel.score = totalScore;
            if(totalScore < 2.5){
                self.recordResultView.type = RecordGrade80;
            }else if(totalScore <4.0){
                self.recordResultView.type = RecordGrade90;
            }else {
                self.recordResultView.type = RecordGrade100;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0 animations:^{
                    self.recordResultView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    self.recordResultView.hidden = YES;
                }];
            });
            DebugLog(@"哇哈哈比较 %@  %@  相似度:%lf",_resultText,followReadModel.topic_text,totalScore);
            
            
            //清空识别结果
            _result = nil;
        }
    }else {
        self.isError = YES;
        text = [NSString stringWithFormat:@"发生错误%@",error.errorDesc];
        [JJHud showToast:[NSString stringWithFormat:@"发生错误：%@",error.errorDesc]];
        [self endRecordAction:nil];
        DebugLog(@"%@",text);
    }
    
    [_popUpView showText: text];
    
    //    }else {
    //        [_popUpView showText:@"识别结束"];
    //        DebugLog(@"errorCode:%d",[error errorCode]);
    //    }
    
    //    [_startRecBtn setEnabled:YES];
    //    [_audioStreamBtn setEnabled:YES];
    //    [_upWordListBtn setEnabled:YES];
    //    [_upContactBtn setEnabled:YES];
    
}

/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    _result =[NSString stringWithFormat:@"%@%@", _resultText,resultString];
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    _resultText = [NSString stringWithFormat:@"%@%@", _resultText,resultFromJson];
    
    if (isLast){
        //        _resultText = [NSString stringWithFormat:@"听写结果(json)：%@", _resultText];
        DebugLog(@"听写结果(json)：%@",  _resultText);
    }
    
    //    DebugLog(@"_result=%@",_result);
    //    DebugLog(@"resultFromJson=%@",resultFromJson);
    //    DebugLog(@"isLast=%d,_textView.text=%@",isLast,_textView.text);
}


#pragma mark -- 代理方法
// -- UICollectionViewDelegate代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.unReadModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JJFollowReadCell *followReadCell = [collectionView dequeueReusableCellWithReuseIdentifier:followReadCellID forIndexPath:indexPath];
    //    followReadCell.readLabel.text = @"请朗读";
    followReadCell.model = self.unReadModelArray[indexPath.item];
    followReadCell.playButton.hidden = YES;
    //    followReadCell.playURL = @"http://xunlei.sc.chinaz.com/Files/DownLoad/sound1/201611/7991.wav";
    return followReadCell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - <UIScrollViewDelegate>
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if(self.collectionView.contentOffset.x < self.collectionView.contentSize.width - SCREEN_WIDTH) {
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
    if(self.collectionView.contentOffset.x < self.collectionView.contentSize.width - SCREEN_WIDTH) {
        //当小题未完时
        [self.nextHomeworkBtn setTitle:@"下一题" forState:UIControlStateNormal];
    } else {
        [self.nextHomeworkBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
}

#pragma mark - 下一步按钮点击
-(void)nextBtnClick:(UIButton *)btn {
    [self.player pause];
    [self.view endEditing:YES];
    NSInteger currentIndex =  self.collectionView.contentOffset.x / self.collectionView.width;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:currentIndex+1 inSection:0];
    
    if(self.collectionView.contentOffset.x < self.collectionView.contentSize.width - SCREEN_WIDTH) {
        //当小题未完时
        //        [UIView animateWithDuration:0.5 animations:^{
        //            self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x + SCREEN_WIDTH, 0);
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        //        }];
        
    } else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [self.unReadModelArray removeAllObjects];
        for(int i = 0; i < self.modelArray.count; i++) {
            JJFollowReadModel *model = self.modelArray[i];
            if(![fileManager fileExistsAtPath:JJAudioFileFullpathWAV(model.lastURL)]) {
                 [self.unReadModelArray addObject:model];
            }
        }
        if(self.unReadModelArray.count) {
            [self.collectionView reloadData];
            [UIView animateWithDuration:0.5 animations:^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }];
            [JJHud showToast:@"题目没有做完,请继续做题"];
            return;
        }

        //        //当已经是最后一个小题时,前往结果页
        JJFollowReadResultViewController *followReadResultViewController = [[JJFollowReadResultViewController alloc]init];
        followReadResultViewController.isSelfStudy = self.topicModel.isSelfStudy;
        followReadResultViewController.modelArray = self.modelArray;
        followReadResultViewController.name = @"全文朗读结果";
        followReadResultViewController.homeworkID = self.homeworkID;
        followReadResultViewController.typeName = self.name;
        [self.navigationController pushViewController:followReadResultViewController animated:YES];
        
    }
}



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

//懒加载
- (NSMutableArray *)modelArray {
    if(!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (JJRecordResultView *)recordResultView {
    if(!_recordResultView) {
        _recordResultView = [[JJRecordResultView alloc]init];
        [self.view addSubview:_recordResultView];
        [_recordResultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.with.offset(0);
        }];
    }
    return _recordResultView;
}

- (void)dealloc {
    DebugLog(@"朗读销毁");
}
@end





////
////  JJReadAloudViewController.m
////  FunStudy
////
////  Created by 唐天成 on 2016/11/27.
////  Copyright © 2016年 唐天成. All rights reserved.
////
//
//#import "JJReadAloudViewController.h"
//#import "JJFollowReadCell.h"
//#import "JJFollowReadModel.h"
//#import <AVFoundation/AVFoundation.h>
//#import "JJFollowReadResultViewController.h"
//#import <ReactiveCocoa.h>
//#import "UINavigationController+FDFullscreenPopGesture.h"
//
////讯飞
//#import "ISEParams.h"
//#import "IFlyMSC/IFlyMSC.h"
//#import "ISEResult.h"
//#import "ISEResultXmlParser.h"
//#import "Definition.h"
//#import "JJRecordResultView.h"
//
//@interface JJReadAloudViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,IFlySpeechEvaluatorDelegate ,ISEResultXmlParserDelegate>
//
////===============ifly讯飞====================
//
//@property (nonatomic, strong) ISEParams *iseParams;
//@property (nonatomic, strong) IFlySpeechEvaluator *iFlySpeechEvaluator;
//
//@property (nonatomic, assign) BOOL isSessionResultAppear;
//@property (nonatomic, assign) BOOL isSessionEnd;
//@property(nonatomic,assign)Boolean isError;//朗读内容是否有误
//@property(nonatomic,assign)Boolean isOverRecord;//是否停止录音
//@property (nonatomic, strong) NSString* resultText;
//
//@property (nonatomic, strong) JJRecordResultView *recordResultView;
//
////===================================
//
//
////播放器
//@property(nonatomic, strong)AVPlayer *player;
//
////录音器
//@property (nonatomic, strong) AVAudioRecorder *recorder;
//
//
//@property (nonatomic, strong) UICollectionView *collectionView; // 作业题视图
//
//@property (nonatomic, strong) NSMutableArray<JJFollowReadModel *> *modelArray;
//
////该题对应的作业ID,主要用于提交答案时用
//@property (nonatomic, strong) NSString *homeworkID;
//
////@property (strong ,nonatomic) NSTimer *recordTimer;// 定时器
//@property (strong, nonatomic) dispatch_source_t timer;//定时器
//
//@property (assign ,nonatomic) CGFloat recordTime;// 录音时间
//
////下一题按钮
//@property (nonatomic, strong) UIButton *nextHomeworkBtn;
//@end
//
//#pragma mark -- 标识符
//static NSString *const followReadCellID = @"followReadCellID";
//
//@implementation JJReadAloudViewController
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    //在这个界面将全局左划手势的有效范围缩窄至一半,原因:当按住按钮录音的时候有时候会和全局手势冲突
//    self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = SCREEN_WIDTH / 3 ;
//    //讯飞
//    self.iFlySpeechEvaluator.delegate = self;
//    self.isSessionResultAppear=YES;
//    self.isSessionEnd=YES;
//    
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    //离开这个界面后将全局左划手势的有效范围变为全屏
//    self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = SCREEN_WIDTH ;
//    //讯飞
//    [self.iFlySpeechEvaluator cancel];
//    self.iFlySpeechEvaluator.delegate = nil;
//}
//
//#pragma mark -- 生命周期
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    //创建缓存目录文件
//    [self createCacheDirectory];
//    // 初始化视图
//    [self setupView];
//    // 初始化作业题视图
//    [self setupCollectionView];
//    //跟读数据获取
//    [self requestWithData];
//    
//    //监听scrollerView的滚动后可以设置titleName
//    @weakify(self);
//    [[RACObserve(self, collectionView.contentOffset)ignore:nil] subscribeNext:^(NSValue *x) {
//        @strongify(self);
//        CGPoint point = [x CGPointValue];
//        
//        NSInteger currentIndex = (point.x / SCREEN_WIDTH)+1;
//        
//        self.titleName = [NSString stringWithFormat:@"%@%ld/%ld",self.navigationTitleName,currentIndex,self.modelArray.count];
//    }];
//
//    //讯飞
//    if (!self.iFlySpeechEvaluator) {
//        self.iFlySpeechEvaluator = [IFlySpeechEvaluator sharedInstance];
//    }
//    self.iFlySpeechEvaluator.delegate = self;
//    //清空参数，目的是评测和听写的参数采用相同数据
//    [self.iFlySpeechEvaluator setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
//    _isSessionResultAppear=YES;
//    _isSessionEnd=YES;
//    self.iseParams=[ISEParams fromUserDefaults];
//    [self reloadCategoryText];
//
//}
//
//#pragma mark 重新设置讯飞
//-(void)reloadCategoryText{
//    NSLog(@"%@  %@  %@  %@  %@ %@",self.iseParams.bos,
//          self.iseParams.eos,
//          self.iseParams.category,
//          self.iseParams.language,
//          self.iseParams.rstLevel,
//          self.iseParams.timeout);
//    
//    //前端电超时
//    self.iseParams.bos = @"30000";
//    //后端点超时
//    self.iseParams.eos = @"30000";
//    //英文
//    self.iseParams.language = KCLanguageENUS;
//    self.iseParams.languageShow = KCLanguageShowENUS;
//    //句子
//    self.iseParams.category = KCCategorySentence;
//    self.iseParams.categoryShow = KCCategoryShowSentence;
//    
//    [self.iFlySpeechEvaluator setParameter:self.iseParams.bos forKey:[IFlySpeechConstant VAD_BOS]];
//    [self.iFlySpeechEvaluator setParameter:self.iseParams.eos forKey:[IFlySpeechConstant VAD_EOS]];
//    [self.iFlySpeechEvaluator setParameter:self.iseParams.category forKey:[IFlySpeechConstant ISE_CATEGORY]];
//    [self.iFlySpeechEvaluator setParameter:self.iseParams.language forKey:[IFlySpeechConstant LANGUAGE]];
//    [self.iFlySpeechEvaluator setParameter:self.iseParams.rstLevel forKey:[IFlySpeechConstant ISE_RESULT_LEVEL]];
//    [self.iFlySpeechEvaluator setParameter:self.iseParams.timeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
//}
//
//
///**
// *  创建缓存目录文件
// */
//- (void)createCacheDirectory
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:JJAudioCachesDirectory]) {
//        [fileManager createDirectoryAtPath:JJAudioCachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
//    }
//}
//
//
//#pragma mark -- 初始化视图
//- (void)setupView {
//    // 标题
//    self.titleName = self.navigationTitleName;
//    // 背景图片
//    self.view.layer.contents = (id)[UIImage imageNamed:@"FollowReadVC_Background"].CGImage;
//    
//    // 录音按钮
//    UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    recordButton.frame = CGRectMake((SCREEN_WIDTH - 100) / 2.0, SCREEN_HEIGHT - 140 - 100 * KHEIGHT_IPHONE6_SCALE, 100, 140);
//    [recordButton setImage:[UIImage imageNamed:@"FollowRead_RecordButton"] forState:UIControlStateNormal];
//    [recordButton setImage:[UIImage imageNamed:@"FollowRead_RecordButtonSelected"] forState:UIControlStateHighlighted];
//    //开始录音
//    [recordButton addTarget:self action:@selector(begineRecordAction:) forControlEvents:UIControlEventTouchDown];
//    //停止录音
//    [recordButton addTarget:self action:@selector(endRecordAction:) forControlEvents:UIControlEventTouchUpInside];
//    [recordButton addTarget:self action:@selector(endRecordAction:) forControlEvents:UIControlEventTouchUpOutside];
//    [recordButton setTitle:@" 按住录音 " forState:UIControlStateNormal];
//    [recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    recordButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:1];
//    recordButton.titleLabel.layer.cornerRadius = 8;
//    recordButton.titleLabel.layer.masksToBounds = YES;
//    recordButton.titleLabel.backgroundColor = RGB(0, 151, 206);
//    [recordButton verticalCenterImageAndTitle:5];
//    [self.view addSubview:recordButton];
//    
//    //下一题
//    UIButton *nextHomeworkBtn= [[UIButton alloc]init];
//    self.nextHomeworkBtn = nextHomeworkBtn;
//    [self.view addSubview:nextHomeworkBtn];
//    [nextHomeworkBtn setBackgroundImage:[UIImage imageNamed:@"MatchNextBtn"] forState:UIControlStateNormal];
//    [nextHomeworkBtn setTitle:@"下一题" forState:UIControlStateNormal];
//    [nextHomeworkBtn setTitleColor:RGBA(212, 0, 0, 1) forState:UIControlStateNormal];
//    nextHomeworkBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14 * KWIDTH_IPHONE6_SCALE];
//    [nextHomeworkBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [nextHomeworkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(88 * KWIDTH_IPHONE6_SCALE);
//        make.height.mas_equalTo(26 * KWIDTH_IPHONE6_SCALE);
//        make.top.equalTo(recordButton.mas_bottom).with.offset(10 * KWIDTH_IPHONE6_SCALE);
//        make.centerX.equalTo(self.view.mas_centerX);
//    }];
//    
//    
//}
//
//// 初始化作业题视图
//- (void)setupCollectionView {
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, 250 * KWIDTH_IPHONE6_SCALE);
//    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 140 * KHEIGHT_IPHONE6_SCALE, SCREEN_WIDTH, 250 * KWIDTH_IPHONE6_SCALE) collectionViewLayout:flowLayout];
//    //    self.collectionView.backgroundColor = [UIColor redColor];
//    self.collectionView.backgroundColor = [UIColor clearColor];
//    self.collectionView.showsHorizontalScrollIndicator = NO;
//    self.collectionView.pagingEnabled = YES;
//    [self.view addSubview:self.collectionView];
//    
//    // 设置代理
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//    
//    // 注册
//    [self.collectionView registerClass:[JJFollowReadCell class] forCellWithReuseIdentifier:followReadCellID];
//}
//
//#pragma mark - 跟读数据请求
//- (void)requestWithData {
//    if (![Util isNetWorkEnable]) {
//        [JJHud showToast:@"网络连接不可用"];
//        return;
//    }
//    NSString *URL = nil;
//    if([self.name isEqualToString:@"最新测验"]) {
//        URL = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL,API_EXAM_INFO];
//    } else {
//        URL = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL,API_HOMEWORK_INFO];
//    }
//    NSDictionary *params = @{ @"topics_id" : self.topicModel.topics_id};
//    [JJHud showStatus:nil];
//    [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
//        [JJHud dismiss];
//        if (![response isKindOfClass:[NSDictionary class]]) {
//            return ;
//        }
//        DebugLog(@"response = %@", response);
//        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
//        if (codeValue) { //详情数据加载失败
//            NSString *codeMessage = [response objectForKey:@"error_msg"];
//            DebugLog(@"codeMessage = %@", codeMessage);
//            [JJHud showToast:codeMessage];
//            return ;
//        }
//        self.homeworkID = self.topicModel.homework_id;
//        self.modelArray = [JJFollowReadModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"content"]];
//        for(int i=0;i<self.modelArray.count;i++) {
//            JJFollowReadModel *model = self.modelArray[i];
////            model.topic_text = @"aaa#bbb#fccc";
//            model.topic_title = self.topicModel.topic_title;
//            model.homeworkID = self.homeworkID;
////            model.file_video = @"http://xunlei.sc.chinaz.com/Files/DownLoad/sound1/201611/7983.wav";
////            if(i==1) {
////                model.file_video = @"http://xunlei.sc.chinaz.com/Files/DownLoad/sound1/201611/7985.wav";
////            }
//        }
//        [self.collectionView reloadData];
//        
//        //        NSArray <NSDictionary *>*dataArray = response[@"data"][@"homework_content"];
//        //        for(NSDictionary *dict in dataArray) {
//        //            JJErrorCorrectionModel *errorCorrectionModel = [JJErrorCorrectionModel modelWithDictionary:dict];
//        //            JJErrorCorrectionView *errorCorrectionView = [JJErrorCorrectionView errorCorrectionViewWithModel:errorCorrectionModel];          errorCorrectionView.frame = CGRectMake(self.modelArray.count * SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height);
//        //            [self.scrollView addSubview:errorCorrectionView];
//        //            [self.modelArray addObject:errorCorrectionModel];
//        //            self.scrollView.contentSize = CGSizeMake(self.modelArray.count * SCREEN_WIDTH, self.scrollView.height);
//        //        }
//        
//    } fail:^(NSError *error) {
//        [JJHud showToast:@"加载失败"];
//    }];
//}
//
//
//#pragma mark -播放音乐
//-(void)playWithString:(NSString *)file_video{
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
//    [[AVAudioSession sharedInstance] setActive:YES error:NULL];
//    NSURL *url = nil;
//    NSFileManager *ma = [NSFileManager defaultManager];
//    if([ma fileExistsAtPath:JJAudioFileFullpathWAV(file_video)]){
//        //如果已经下载过的话,直接播放本地的
//        url =[NSURL fileURLWithPath: JJAudioFileFullpathWAV(file_video)];
//        
//    } else {
//        //如果没下载过,则播放网络资源并进行下载
//        url = [NSURL URLWithString:file_video];
//        [HFNetWork downLoadWithURL:file_video destinationPath:JJAudioFileFullpathWAV(file_video) params:nil progress:^(NSProgress *progress) {
//            DebugLog(@"jindu:%@",progress);
//        }];
//    }
//    //    AVURLAsset *asset  = [AVURLAsset assetWithURL:url];
//    //        NSString *transKey = @"tracks";
//    //    [asset loadValuesAsynchronouslyForKeys:@[transKey]  completionHandler:^{
//    //        NSError *error;
//    //        AVKeyValueStatus status = [asset statusOfValueForKey:transKey error:&error];
//    AVPlayerItem *playerItem = nil;
//    //        if(status == AVKeyValueStatusLoaded){
//    //            playerItem = [AVPlayerItem playerItemWithAsset:asset];
//    //        }else{
//    playerItem = [AVPlayerItem playerItemWithURL:url];
//    //        }
//    //[self.player.currentItem removeObserver:self forKeyPath:@"status"];
//    //替换当前音乐资源
//    [self.player replaceCurrentItemWithPlayerItem:playerItem];
//    
//    //[self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//    
//    //    //监听音乐播放完成通知
//    //    [self addNSNotificationForPlayMusicFinish];
//    //监听播放器状态
//    //        [self addPlayStatus];
//    //开始播放
//    [self.player play];
//    //    }];
//    //    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
//}
//
//
////判断是否允许使用麦克风7.0新增的方法requestRecordPermission
//-(BOOL)canRecord
//{
//    __block BOOL bCanRecord = NO;
//    if ([[UIDevice currentDevice] systemVersion].doubleValue >= 7.0)
//    {
//        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
//            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
//                if (granted) {
//                    bCanRecord = YES;
//                }
//                else {
//                    bCanRecord = NO;
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [[[UIAlertView alloc] initWithTitle:nil
//                                                    message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
//                                                   delegate:nil
//                                          cancelButtonTitle:@"关闭"
//                                          otherButtonTitles:nil] show];
//                    });
//                }
//            }];
//        }
//    }
//    
//    return bCanRecord;
//}
//#pragma mark -- 响应事件
////开始录音
//- (void)begineRecordAction:(UIButton *)button {
//    [self.player pause];
//    self.isError = NO;
//    self.isOverRecord = NO;
//    if(![self canRecord]) return;
//    
//    //    [self.player pause];
//    
//    DebugLog(@"%s",__func__);
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    NSError *sessionError;
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
//    if (session == nil) {
//        DebugLog(@"Error creating session: %@",[sessionError description]);
//    }else{
//        [session setActive:YES error:nil];
//        DebugLog(@"fdsfs");
//    }
//    
//    
//    NSInteger currentIndex =  self.collectionView.contentOffset.x / self.collectionView.width;
//    JJFollowReadModel *followReadModel = self.modelArray[currentIndex];
//    
//    //设置录音的参数
//    NSDictionary *settingRecorder = @{
//                                      AVEncoderAudioQualityKey : [NSNumber numberWithInteger:AVAudioQualityHigh],
//                                      AVEncoderBitRateKey : [NSNumber numberWithInteger:16],
//                                      AVSampleRateKey : [NSNumber numberWithFloat:8000],
//                                      AVNumberOfChannelsKey : [NSNumber numberWithInteger:2],
//                                      };
//    NSString *s = JJAudioFileFullpathWAV(followReadModel.lastURL);
//    // 5.创建录音对象
//    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:JJAudioFileFullpathWAV(followReadModel.lastURL)] settings:settingRecorder error:nil];
//    [self.recorder prepareToRecord];
//    [self.recorder record];
//    
//    //self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    //每秒执行一次
//    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 0.01 * NSEC_PER_SEC, 0);
//    dispatch_source_set_event_handler(_timer, ^{
////        DebugLog(@"%@",[NSThread currentThread]);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self countVoiceTime];
//        });
//    });
//    dispatch_resume(_timer);
//    
//    
//    //开始讯飞录音
//    [self iflyBegineRecordAction];
//}
//
//#pragma mark 讯飞开始录音
//- (void)iflyBegineRecordAction {
//    [self.iFlySpeechEvaluator setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
//    [self.iFlySpeechEvaluator setParameter:@"utf-8" forKey:[IFlySpeechConstant TEXT_ENCODING]];
//    [self.iFlySpeechEvaluator setParameter:@"xml" forKey:[IFlySpeechConstant ISE_RESULT_TYPE]];
//    [self.iFlySpeechEvaluator setParameter:@"eva.pcm" forKey:[IFlySpeechConstant ISE_AUDIO_PATH]];
//    
//    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    
//    NSLog(@"text encoding:%@",[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant TEXT_ENCODING]]);
//    NSLog(@"language:%@",[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant LANGUAGE]]);
//    
//    BOOL isUTF8=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant TEXT_ENCODING]] isEqualToString:@"utf-8"];
//    BOOL isZhCN=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant LANGUAGE]] isEqualToString:KCLanguageZHCN];
//    
//    BOOL needAddTextBom=isUTF8&&isZhCN;
//    NSMutableData *buffer = nil;
//    
//    NSInteger index = (self.collectionView.contentOffset.x + (self.collectionView.width / 2)) / self.collectionView.width;
//    JJFollowReadModel *followReadModel = self.modelArray[index];
//    
//    if(needAddTextBom){
//        Byte bomHeader[] = { 0xEF, 0xBB, 0xBF };
//        buffer = [NSMutableData dataWithBytes:bomHeader length:sizeof(bomHeader)];
//        [buffer appendData:[followReadModel.topic_text dataUsingEncoding:NSUTF8StringEncoding]];
//        NSLog(@" \ncn buffer length: %lu",(unsigned long)[buffer length]);
//        
//    }else{
//        buffer= [NSMutableData dataWithData:[followReadModel.topic_text dataUsingEncoding:encoding]];
//        NSLog(@" \nen buffer length: %lu",(unsigned long)[buffer length]);
//    }
//    [self.iFlySpeechEvaluator startListening:buffer params:nil];
//    self.isSessionResultAppear=NO;
//    self.isSessionEnd=NO;
//}
//
//
////点击按钮的手指停止按住.停止录音
//- (void) endRecordAction:(UIButton *)button {
//    self.isOverRecord = YES;
//    DebugLog(@"agagagagadsaaf");
//    if(![self canRecord]){
//        DebugLog(@"还没同意");
//        return;
//    }
//    
//    [self.recorder stop];
////    [self.recordTimer invalidate];
////    
////    self.recordTimer = nil;
//    dispatch_source_cancel(_timer);
//    JJFollowReadCell *cell = self.collectionView.visibleCells[0];
//    cell.progressView.progressValue = 0.0;
//    if(self.recordTime > 0.1) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSInteger currentIndex =  self.collectionView.contentOffset.x / self.collectionView.width;
//            JJFollowReadModel *followReadModel = self.modelArray[currentIndex];
//            [self playWithString:followReadModel.lastURL];
//        });
//    }
//    self.recordTime = 0.0;
//    //停止讯飞录音
//    [self iflyEndRecordAction];
//}
//
//#pragma mark 讯飞停止录音
//- (void)iflyEndRecordAction {
//    [self.iFlySpeechEvaluator stopListening];
//    if(self.isError == YES) {
//        ISEResultXmlParser* parser=[[ISEResultXmlParser alloc] init];
//        parser.delegate=self;
//        [parser parserXml:self.resultText];
//        DebugLog(@"不在评测");
//    } else {DebugLog(@"正在评测");
//        [JJHud showStatus:@"正在测评..."];
//    }
//
//}
//
//
//////10秒已经到了,停止录音
////- (void)timeisOver {
////    [self.recorder stop];
////    [self.recordTimer invalidate];
////    self.recordTime = 0.0;
////    self.recordTimer = nil;
////    JJFollowReadCell *cell = self.collectionView.visibleCells[0];
////    cell.progressView.progressValue = 0.0;
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        NSInteger currentIndex =  self.collectionView.contentOffset.x / self.collectionView.width;
////        JJFollowReadModel *followReadModel = self.modelArray[currentIndex];
////        [self playWithString:followReadModel.lastURL];
////    });
////
////}
//
////每0.01秒触发一次
//-(void)countVoiceTime
//{
//    self.recordTime += 0.01;
//    DebugLog(@"shuliang%ld   countime:%lf",self.collectionView.visibleCells.count,self.recordTime);
//    JJFollowReadCell *cell = self.collectionView.visibleCells[0];
//    cell.progressView.progressValue = self.recordTime / 30.0;
//    DebugLog(@"%lf",cell.progressView.progressValue);
//    if (self.recordTime >= 30.0) {
//        //self.recordTime = 0.0;
//        //cell.progressView.progressValue = 0.0;
//        [self.recorder stop];
////        [self.recordTimer invalidate];
////        self.recordTimer = nil;
//        dispatch_source_cancel(_timer);
//        //        [self timeisOver];
//    }
//}
//
//
////#pragma AVAudioRecordDeleagte
////-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
////{
////
////    DebugLog(@"shashahsahs");
////}
//
//
//#pragma mark - 讯飞Delegate
//#pragma mark IFlySpeechEvaluatorDelegate
///*!
// *  音量和数据回调
// *
// *  @param volume 音量
// *  @param buffer 音频数据
// */
//- (void)onVolumeChanged:(int)volume buffer:(NSData *)buffer {
//    
//}
//
///*!
// *  开始录音回调
// *  当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。如果发生错误则回调onError:函数
// */
//- (void)onBeginOfSpeech {
//    
//}
//
///*!
// *  停止录音回调
// *    当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。
// *  如果发生错误则回调onError:函数
// */
//- (void)onEndOfSpeech {
//    
//}
//
///*!
// *  正在取消
// */
//- (void)onCancel {
//    
//}
//
///*!
// *  评测结果回调
// *    在进行语音评测过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理.
// *  当errorCode没有错误时，表示此次会话正常结束，否则，表示此次会话有错误发生。特别的当调用
// *  `cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函
// *  数之前如果重新调用了`startListenging`函数则会报错误。
// *
// *  @param errorCode 错误描述类
// */
//- (void)onError:(IFlySpeechError *)errorCode {
//    DebugLog(@"错误:%@ %d",errorCode.errorDesc,errorCode.errorCode);
//    if(errorCode && errorCode.errorCode!=0){
//        self.isError = YES;//有错误
//        [JJHud dismiss];
//        //        [self showAlertWithTitle:@"错误" message:[NSString stringWithFormat:@"错误码：%d %@",[errorCode errorCode],[errorCode errorDesc]] cancelTitle:@"确定"];
//    } else {
//        self.isError = NO;//无错误
//    }
//    [self performSelectorOnMainThread:@selector(resetBtnSatus:) withObject:errorCode waitUntilDone:NO];
//}
//-(void)resetBtnSatus:(IFlySpeechError *)errorCode{
//    
//    if(errorCode && errorCode.errorCode!=0){
//        self.isSessionResultAppear=NO;
//        self.isSessionEnd=YES;
//        if(self.isOverRecord == YES) {
//            ISEResultXmlParser* parser=[[ISEResultXmlParser alloc] init];
//            parser.delegate=self;
//            [parser parserXml:self.resultText];
//        }
//
//    }else{
//        [JJHud dismiss];
//        self.isSessionResultAppear=YES;
//        self.isSessionEnd=YES;
//        ISEResultXmlParser* parser=[[ISEResultXmlParser alloc] init];
//        parser.delegate=self;
//        [parser parserXml:self.resultText];
//    }
//    
//}
//
//
//
///*!
// *  评测结果回调
// *   在评测过程中可能会多次回调此函数，你最好不要在此回调函数中进行界面的更改等操作，只需要将回调的结果保存起来。
// *
// *  @param results -[out] 评测结果。
// *  @param isLast  -[out] 是否最后一条结果
// */
//- (void)onResults:(NSData *)results isLast:(BOOL)isLast{
//    if (results) {
//        NSString *showText = @"";
//        
//        const char* chResult=[results bytes];
//        
//        BOOL isUTF8=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant RESULT_ENCODING]]isEqualToString:@"utf-8"];
//        NSString* strResults=nil;
//        if(isUTF8){
//            strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:NSUTF8StringEncoding];
//        }else{
//            NSLog(@"result encoding: gb2312");
//            NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//            strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:encoding];
//        }
//        if(strResults){
//            showText = [showText stringByAppendingString:strResults];
//        }
//        
//        self.resultText=showText;
//        self.isSessionResultAppear=YES;
//        self.isSessionEnd=YES;
//        if(isLast){
////            [self showAlertWithTitle:@"评测结束" message:@"评测结束" cancelTitle:@"确定"];
//        }
//    }
//    else{
//        if(isLast){
////            [self showAlertWithTitle:@"没有说话" message:@"没有说话" cancelTitle:@"确定"];
//        }
//        self.isSessionEnd=YES;
//    }
//}
//
//#pragma mark ISEResultXmlParserDelegate
//
//-(void)onISEResultXmlParser:(NSXMLParser *)parser Error:(NSError*)error{
//    
//}
////解析回调
//-(void)onISEResultXmlParserResult:(ISEResult*)result{
//    self.recordResultView.hidden = NO;
//    self.recordResultView.alpha = 1.0;
//    float totalScore = result.total_score;
//    if(totalScore <3.0){
//        self.recordResultView.type = RecordGrade80;
//    }else if(totalScore <4.5){
//        self.recordResultView.type = RecordGrade90;
//    }else {
//        self.recordResultView.type = RecordGrade100;
//    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:1.0 animations:^{
//            self.recordResultView.alpha = 0.0;
//        } completion:^(BOOL finished) {
//            self.recordResultView.hidden = YES;
//        }];
//    });
//    
////    [JJHud showToast:[NSString stringWithFormat:@"得分:%lf",totalScore]];
//    DebugLog(@"哇哈哈%@",[NSString stringWithFormat:@"哇哈哈%@",[result toString]]);
//}
//
//
//
//#pragma mark -- 代理方法
//// -- UICollectionViewDelegate代理方法
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.modelArray.count;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    JJFollowReadCell *followReadCell = [collectionView dequeueReusableCellWithReuseIdentifier:followReadCellID forIndexPath:indexPath];
////    followReadCell.readLabel.text = @"请朗读";
//    followReadCell.model = self.modelArray[indexPath.item];
//    followReadCell.playButton.hidden = YES;
//    //    followReadCell.playURL = @"http://xunlei.sc.chinaz.com/Files/DownLoad/sound1/201611/7991.wav";
//    return followReadCell;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 0;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 0;
//}
//
//#pragma mark - <UIScrollViewDelegate>
///**
// * 在scrollView滚动动画结束时, 就会调用这个方法
// * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
// */
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    if(self.collectionView.contentOffset.x < self.collectionView.contentSize.width - SCREEN_WIDTH) {
//        //当小题未完时
//        [self.nextHomeworkBtn setTitle:@"下一题" forState:UIControlStateNormal];
//    } else {
//        [self.nextHomeworkBtn setTitle:@"提交" forState:UIControlStateNormal];
//    }
//    
//}
///**
// * 在scrollView滚动动画结束时, 就会调用这个方法
// * 前提: 人为拖拽scrollView产生的滚动动画
// */
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if(self.collectionView.contentOffset.x < self.collectionView.contentSize.width - SCREEN_WIDTH) {
//        //当小题未完时
//        [self.nextHomeworkBtn setTitle:@"下一题" forState:UIControlStateNormal];
//    } else {
//        [self.nextHomeworkBtn setTitle:@"提交" forState:UIControlStateNormal];
//    }
//}
//
//#pragma mark - 下一步按钮点击
//-(void)nextBtnClick:(UIButton *)btn {
//    [self.player pause];
//    [self.view endEditing:YES];
//    NSInteger currentIndex =  self.collectionView.contentOffset.x / self.collectionView.width;
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:currentIndex+1 inSection:0];
//    
//    if(self.collectionView.contentOffset.x < self.collectionView.contentSize.width - SCREEN_WIDTH) {
//        //当小题未完时
//        //        [UIView animateWithDuration:0.5 animations:^{
//        //            self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x + SCREEN_WIDTH, 0);
//        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//        //        }];
//        
//    } else {
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        for(int i = 0; i < self.modelArray.count; i++) {
//            JJFollowReadModel *model = self.modelArray[i];
//            if(![fileManager fileExistsAtPath:JJAudioFileFullpathWAV(model.lastURL)]) {
//                [UIView animateWithDuration:0.5 animations:^{
//                    DebugLog(@"di%dge",i);
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//                    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//                }];
//                [JJHud showToast:@"题目没有做完,请继续做题"];
//                
//                return ;
//            }
//        }
//        
//
//
//        //        //当已经是最后一个小题时,前往结果页
//        JJFollowReadResultViewController *followReadResultViewController = [[JJFollowReadResultViewController alloc]init];
//        followReadResultViewController.isSelfStudy = self.topicModel.isSelfStudy;
//        followReadResultViewController.modelArray = self.modelArray;
//        followReadResultViewController.name = @"全文朗读结果";
//        followReadResultViewController.homeworkID = self.homeworkID;
//        followReadResultViewController.typeName = self.name;
//        [self.navigationController pushViewController:followReadResultViewController animated:YES];
//        
//    }
//}
//
////#pragma mark - KVO观察者回调
////-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
////{
////    //注意这里查看的是self.player.status属性
////    if ([keyPath isEqualToString:@"status"]) {
////        switch (_player.currentItem.status) {
////            case AVPlayerStatusUnknown:
////            {
////                DebugLog(@"未知转态");
////            }
////                break;
////            case AVPlayerStatusReadyToPlay:
////            {
////                DebugLog(@"准备播放");
////            }
////                break;
////            case AVPlayerStatusFailed:
////            {
////                [JJHud showToast:@"无法播放"];
////            }
////                break;
////            default:
////                break;
////        }
////    }
////}
//
//
//#pragma mark - 懒加载
//
////播放器
//- (AVPlayer *)player {
//    if(_player == nil) {
//        //初始化_player
//        _player = [[AVPlayer alloc] init];
//        [[RACObserve(_player, currentItem.status) ignore:nil] subscribeNext:^(NSNumber *x) {
//            AVPlayerItemStatus status = x.intValue;
//            switch (status) {
//                case AVPlayerStatusUnknown:
//                {
//                    DebugLog(@"未知转态");
//                }
//                    break;
//                case AVPlayerStatusReadyToPlay:
//                {
//                    DebugLog(@"准备播放");
//                }
//                    break;
//                case AVPlayerStatusFailed:
//                {
//                    [JJHud showToast:@"无法播放"];
//                }
//                    break;
//                default:
//                    break;
//            }
//            
//        }];
//
//    }
//    return _player;
//}
//
////懒加载
//- (NSMutableArray *)modelArray {
//    if(!_modelArray) {
//        _modelArray = [NSMutableArray array];
//    }
//    return _modelArray;
//}
//
//- (JJRecordResultView *)recordResultView {
//    if(!_recordResultView) {
//        _recordResultView = [[JJRecordResultView alloc]init];
//        [self.view addSubview:_recordResultView];
//        [_recordResultView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.bottom.with.offset(0);
//        }];
//    }
//    return _recordResultView;
//}
//
//- (void)dealloc {
//    DebugLog(@"朗读销毁");
//}
//@end



