//
//  JJFunReadLessionWordViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJFunReadLessionWordViewController.h"
#import "JJFunReadWardCell.h"
#import "JJWordModel.h"
#import <ReactiveCocoa.h>
#import <AVFoundation/AVFoundation.h>
#import "NSString+XPKit.h"
#import "NetWorkChecker.h"
#import "JJFunAlerView.h"
#import <ReactiveCocoa.h>



@interface JJFunReadLessionWordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *readWordTableView;

////单词模型数组
//@property (nonatomic, strong) NSArray<JJWordModel *> *wordModelArray;
//当前正在播放的单词
@property (nonatomic, strong) JJWordModel *currentPlayModel;
//课本名称
@property (nonatomic, strong)UILabel *bookNameLabel;
//Modul名称Label
@property (nonatomic, strong)UILabel *lessionNameLabel;
//下载按钮
@property (nonatomic, strong) UIButton *downLoadBtn;
////下一单元
//@property (nonatomic, strong)UIButton *nextLessionBtn;
//是否显示中文
@property(nonatomic,assign)BOOL isDisplayChinese;
//播放器
@property(nonatomic, strong)AVPlayer *player;
//播放器的当前playerItem
@property (nonatomic, strong) AVPlayerItem *currentItem;

//是否自动播放下一首
@property(nonatomic,assign)BOOL isAutoPlayNext;


//@property (nonatomic, strong) UILabel *showLabel;


@end

static NSString *funReadWardCellIdentifier = @"JJFunReadWardCellIdentifier";

@implementation JJFunReadLessionWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBaseView];
    [self setUpCenter];
//    self.showLabel = [[UILabel alloc]initWithFrame:CGRectMake(80 * KWIDTH_IPHONE6_SCALE, 20, 200 * KWIDTH_IPHONE6_SCALE, 80)];
//    [self.view addSubview:self.showLabel];
//    self.showLabel.backgroundColor = [UIColor greenColor];
    
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    //创建缓存文件目录
    [self createCacheDirectory];
    
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.userInteractionEnabled = YES;
    //    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
}

//设置中间视图
- (void)setUpCenter {
    //中部大背景
    UIImageView *centerBackView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FunReadLessionWordBack"]];
    [self.view addSubview:centerBackView];
    centerBackView.userInteractionEnabled = YES;
    [centerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(108 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(330 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(423 * KWIDTH_IPHONE6_SCALE);
    }];
    //课本名称
    UILabel *bookNameLabel = [[UILabel alloc]init];
    self.bookNameLabel = bookNameLabel;
    bookNameLabel.font = [UIFont systemFontOfSize:19 * KWIDTH_IPHONE6_SCALE];
    bookNameLabel.text = self.bookModel.book_title;
    bookNameLabel.textColor = [UIColor whiteColor];//RGBA(0, 125, 172, 1);
    [self.view addSubview:bookNameLabel];
    [bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.with.offset(17 * KWIDTH_IPHONE6_SCALE);
//        make.left.with.offset(18 * KWIDTH_IPHONE6_SCALE);
//        make.right.equalTo(downLoadBtn.mas_left).with.offset(-3 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(centerBackView.mas_top).with.offset(-3 * KWIDTH_IPHONE6_SCALE);
    }];

    //中部topview
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor clearColor];
    [centerBackView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(centerBackView);
        make.height.mas_equalTo(44 * KWIDTH_IPHONE6_SCALE);
    }];
    //下载课本按钮
    UIButton *downLoadBtn = [[UIButton alloc]init];
    downLoadBtn.hidden = YES;
    self.downLoadBtn = downLoadBtn;
    [downLoadBtn.titleLabel setFont:[UIFont systemFontOfSize:11 * KWIDTH_IPHONE6_SCALE]];
    [downLoadBtn addTarget:self action:@selector(downloadBook:) forControlEvents:UIControlEventTouchUpInside];
    [downLoadBtn setBackgroundImage:[UIImage imageNamed:@"FunClassRoomVideoBtn"] forState:UIControlStateNormal];
    [downLoadBtn setTitle:@"下载课本" forState:UIControlStateNormal];
    [downLoadBtn setTitle:@"已下载" forState:UIControlStateDisabled];
    [downLoadBtn setTitleColor:RGBA(160, 0, 0, 1) forState:UIControlStateNormal];
    [topView addSubview:downLoadBtn];
    [downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.with.offset(-31 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(11 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(50 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(27 * KWIDTH_IPHONE6_SCALE);
    }];
    //判断以下单词是否已经全部下载
    if([self isDownloadWithWordArray:self.modulModel.word_list]) {
        [self.downLoadBtn setTitle:@"已下载" forState:UIControlStateDisabled];
        self.downLoadBtn.enabled = NO;
    } else {
        self.downLoadBtn.enabled = YES;
    }
    
    
    //Modul名称Label
    UILabel *lessionNameLabel = [[UILabel alloc]init];
    self.lessionNameLabel = lessionNameLabel;
    lessionNameLabel.numberOfLines = 2;

    lessionNameLabel.font = [UIFont systemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
    //JJFunLessionModel *currentLessionModel = self.lessionModelArray[self.currentLessionIndex];
    lessionNameLabel.text = self.modulModel.plate_name;
    lessionNameLabel.textColor = RGBA(0, 125, 172, 1);
    [topView addSubview:lessionNameLabel];
    lessionNameLabel.numberOfLines = 0;
    [lessionNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(5 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(18 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(downLoadBtn.mas_left).with.offset(-3 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(40 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //中部TableView
    self.readWordTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.readWordTableView.estimatedRowHeight = 400;
    self.readWordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.readWordTableView.backgroundColor = [UIColor clearColor];
    [self.readWordTableView registerClass:[JJFunReadWardCell class] forCellReuseIdentifier:funReadWardCellIdentifier];
    self.readWordTableView.dataSource = self;
    self.readWordTableView.delegate = self;
    [centerBackView addSubview:self.readWordTableView];
    [self.readWordTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackView);
        make.bottom.with.offset(-91 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(54 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(281 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //底部bottomView
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor clearColor];
    [centerBackView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(centerBackView);
        make.top.equalTo(self.readWordTableView.mas_bottom);
    }];
    
//    //下一单元
//    UIButton *nextLessionBtn = [[UIButton alloc]init];
//    [nextLessionBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    self.nextLessionBtn = nextLessionBtn;
//    [nextLessionBtn setBackgroundImage:[UIImage imageNamed:@"nextLessionBtn"] forState:UIControlStateNormal];
//    [bottomView addSubview:nextLessionBtn];
//    [nextLessionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.with.offset(62 * KWIDTH_IPHONE6_SCALE);
//        make.top.with.offset(8 * KWIDTH_IPHONE6_SCALE);
//        make.width.mas_equalTo(81 * KWIDTH_IPHONE6_SCALE);
//        make.height.mas_equalTo(27 * KWIDTH_IPHONE6_SCALE);
//    }];

    //开始播放
    UIButton *starPlayBtn = [[UIButton alloc]init];
    [starPlayBtn addTarget:self action:@selector(startPlayVideo) forControlEvents:UIControlEventTouchUpInside];
    [starPlayBtn setBackgroundImage:[UIImage imageNamed:@"startPlay"] forState:UIControlStateNormal];
    [bottomView addSubview:starPlayBtn];
    [starPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.with.offset(-62 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(8 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(81 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(27 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //显示中文
    UIButton *showChineseBtn = [[UIButton alloc]init];
    [showChineseBtn addTarget:self action:@selector(displayChineseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [showChineseBtn setBackgroundImage:[UIImage imageNamed:@"FunClassRoomVideoBtn"] forState:UIControlStateNormal];
    [showChineseBtn setTitle:@"显示中文" forState:UIControlStateNormal];
    showChineseBtn.titleLabel.font = [UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE];
    [showChineseBtn setTitleColor:RGBA(185, 32, 0, 1) forState:UIControlStateNormal];
    [bottomView addSubview:showChineseBtn];
    [showChineseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.with.offset(-17 * KWIDTH_IPHONE6_SCALE);
        make.bottom.with.offset(-9 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(57 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(28 * KWIDTH_IPHONE6_SCALE);
    }];
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

#pragma mark - 点击下载按钮
- (void)downloadBook:(UIButton *)btn {
    if([btn.titleLabel.text isEqualToString:@"下载中"]) return;
    
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    //如果是用流量
    if([[NetWorkChecker shareInstance] networkStatus] == ReachableViaWWAN) {
        [JJFunAlerView showFunAlertViewWithTitle:@"当前使用的是流量,确认下载?" CenterBlock:^{
            //这个用于记录未下载的个数
            __block int noDownLoadCount = 0;
            
            [btn setTitle:@"下载中" forState:UIControlStateDisabled];
            btn.enabled = NO;
            NSFileManager *ma = [NSFileManager defaultManager];
            for(JJWordModel *model in self.modulModel.word_list) {
                if([ma fileExistsAtPath:JJAudioFileFullpathMP3(model.audio)]){
                    
                } else {
                    noDownLoadCount = noDownLoadCount + 1;
                    //如果没下载过,则进行下载
                    [HFNetWork downLoadWithURL:model.audio destinationPath:JJAudioFileFullpathMP3(model.audio) params:nil progress:^(NSProgress *progress) {
//                        DebugLog(@"jindu:%@   %@",progress,[NSThread currentThread]);
                        if(progress.completedUnitCount == progress.totalUnitCount) {
                            noDownLoadCount = noDownLoadCount - 1;
                            if(noDownLoadCount == 0) {
//                                DebugLog(@"xiazaihaola");
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    btn.enabled = NO;
                                    [btn setTitle:@"已下载" forState:UIControlStateDisabled];
                                });
                                
                                
                            }
                        }
                    }];
                }
            }
        }];
    } else {
            //这个用于记录未下载的个数
            __block int noDownLoadCount = 0;
            [btn setTitle:@"下载中" forState:UIControlStateDisabled];
            btn.enabled = NO;
            NSFileManager *ma = [NSFileManager defaultManager];
            for(JJWordModel *model in self.modulModel.word_list) {
                if([ma fileExistsAtPath:JJAudioFileFullpathMP3(model.audio)]){
                } else {
                    noDownLoadCount = noDownLoadCount + 1;
                    //如果没下载过,则进行下载
                    [HFNetWork downLoadWithURL:model.audio destinationPath:JJAudioFileFullpathMP3(model.audio) params:nil progress:^(NSProgress *progress) {
//                        DebugLog(@"jindu:%@   %@",progress,[NSThread currentThread]);
                        if(progress.completedUnitCount == progress.totalUnitCount) {
                            noDownLoadCount = noDownLoadCount - 1;
                            if(noDownLoadCount == 0) {
//                                DebugLog(@"xiazaihaola");
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    btn.enabled = NO;
                                    [btn setTitle:@"已下载" forState:UIControlStateDisabled];
                                });
                                
                                
                            }
                        }
                    }];
                }
            }
    }
}

#pragma mark - 开始播放
- (void)startPlayVideo {
    self.isAutoPlayNext = YES;
    if(self.modulModel.word_list.count != 0) {
        [self.readWordTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self autoAplayWithtableView:self.readWordTableView didSelectRowAtIndexPath:indexPath];
    }
}
//#pragma mark - 下一单元按钮点击
//- (void)nextBtnClick {
//    self.currentLessionIndex ++;
//    self.currentPlayModel = nil;
//    JJFunLessionModel *currentLessionModel = self.lessionModelArray[self.currentLessionIndex];
//    self.lessionNameLabel.text = currentLessionModel.unit_title;
//    [self requestWithWordList];
//}

#pragma mark - 显示中文
- (void)displayChineseBtnClick:(UIButton *)btn {
    
    if([btn.titleLabel.text isEqualToString:@"显示中文"]) {
        [btn setTitle:@"隐藏中文" forState:UIControlStateNormal];
    } else {
        [btn setTitle:@"显示中文" forState:UIControlStateNormal];
    }
    self.isDisplayChinese = !self.isDisplayChinese;
    [self.readWordTableView reloadData];
}


//#pragma mark - 单词列表请求
//- (void)requestWithWordList {
//    if (![Util isNetWorkEnable]) {
//        [JJHud showToast:@"网络连接不可用"];
//        return;
//    }
//    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_CHOOSE_CLASSUNITS];
//    NSMutableDictionary *params =[NSMutableDictionary dictionary];
//    params[@"unit_id"] = self.lessionModelArray[self.currentLessionIndex].unit_id;
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
//       
////        JJWordModel *model1 = [[JJWordModel alloc]init];
////        if(self.currentLessionIndex==0){
////        model1.audio = @"http://xunlei.sc.chinaz.com/Files/DownLoad/sound1/201611/7983.wav";
////        }else {
////            model1.audio = @"http://xunlei.sc.chinaz.com/Files/DownLoad/sound1/201611/7983.wav";
////        }
////        model1.word = @"aaaa";
////        model1.translation = @"苹果";
////        JJWordModel *model2 = [[JJWordModel alloc]init];
////        if(self.currentLessionIndex==0){
////             model2.audio = @"http://xunlei.sc.chinaz.com/Files/DownLoad/sound1/201611/79844.wav";
////        }else {
////            model1.audio = @"http://xunlei.sc.chinaz.com/Files/DownLoad/sound1/201611/79744.wav";
////        }
////       
////        model2.word = @"aaaa2";
////        model2.translation = @"苹果2";
////        JJWordModel *model3 = [[JJWordModel alloc]init];
////        model3.audio = @"http://xunlei.sc.chinaz.com/Files/DownLoad/sound1/201611/7989.wav";
////        model3.word = @"aaaa3";
////        model3.translation = @"苹果3";
////        self.wordModelArray = @[model1,model2,model3];
//        
//        self.wordModelArray = [JJWordModel mj_objectArrayWithKeyValuesArray:response[@"word_list"]];
//        [self.readWordTableView reloadData];
//        //判断以下单词是否已经全部下载
//        if([self isDownloadWithWordArray:self.wordModelArray]) {
//            [self.downLoadBtn setTitle:@"已下载" forState:UIControlStateDisabled];
//            self.downLoadBtn.enabled = NO;
//        } else {
//            self.downLoadBtn.enabled = YES;
//        }
//        
//    } fail:^(NSError *error) {
//        [JJHud showToast:@"加载失败"];
//    }];
//}

//判断以下单词是否已经全部下载
- (BOOL)isDownloadWithWordArray:(NSArray<JJWordModel *> *)modelArray {
    NSFileManager *ma = [NSFileManager defaultManager];
    for(JJWordModel *model in modelArray) {
//        DebugLog(@"%@",JJAudioFileFullpathMP3(model.audio));
        if(![ma fileExistsAtPath:JJAudioFileFullpathMP3(model.audio)]) {
            //如果存在一个没下载过,则按钮显示下载课本
            return NO;
        }
    }
    return YES;
}



#pragma mark - UITableViewDataSource & UITableVIewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    DebugLog(@"%ld",self.modulModel.word_list.count);
    return self.modulModel.word_list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JJFunReadWardCell *cell = [tableView dequeueReusableCellWithIdentifier:funReadWardCellIdentifier forIndexPath:indexPath];
    [cell createBordersWithColor:RGBA(0, 190, 234, 1) withCornerRadius:10 * KWIDTH_IPHONE6_SCALE andWidth:1.5 * KWIDTH_IPHONE6_SCALE ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JJWordModel *model =self.modulModel.word_list[indexPath.section];
    
//    if(indexPath.section == 0) {
//        model.word = @"fhkjsdfhdkfjhyeir yfdeiwydb f jfgsjh e3dwerffhkjsdfhdkfjhyeir yfdeiwydb f jfgsjh e3dwerffhkjsdfhdkfjhyeir yfdeiwydb f jfgsjh e3dwerffhkjsdfhdkfjhyeir yfdeiwydb f jfgsjh e3dwerffhkjsdfhdkfjhyeir yfdeiwydb f jfgsjh e3dwerffhkjsdfhdkfjhyeir yfdeiwydb f jfgsjh e3dwerf";
//        model.translation = @"你好暗红色的回萨达看你好暗红色的回萨达看你好暗红色的回萨达看你好暗红色的回萨达看你好暗红色的回萨达看你好暗红色的回萨达看你好暗红色的回萨达看你好暗红色的回萨达看你好暗红色的回萨达看你好暗红色的回萨达看你好暗红色的回萨达看";
//    }
//    if(indexPath.section == 1) {
//        model.word = @"fhkjsdfhdkfjhyeir ";
//        model.translation = @"色的回萨达看";
//    }
//    if(indexPath.section == 4) {
//        model.word = @"fhkjsdfh efudwifu fnsdkjhf wrtqetyr 39482429  dkfjhyeir ";
//        model.translation = @"女的说,闺女,的妇女`";
//    }
    
    model.isDisplayChinese = self.isDisplayChinese;
    cell.model = model;
    if(model.isPlay) {
        cell.playBtn.hidden = NO;
    } else {
        cell.playBtn.hidden = YES;
    }
//    [cell createBordersWithColor:RGBA(55, 201, 227, 1) withCornerRadius:6 andWidth:2];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 11 * KWIDTH_IPHONE6_SCALE;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
//    JJWordModel *model = self.modulModel.word_list[indexPath.section];
//    if (model.isPlay) {
//        return 70 * KWIDTH_IPHONE6_SCALE;
//    } else {
//        return 37 * KWIDTH_IPHONE6_SCALE;
//    }
}
//手动点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.isAutoPlayNext = NO;
    JJWordModel *model = self.modulModel.word_list[indexPath.section];
    model.isPlay = YES;
    if(self.currentPlayModel != model) {
        NSIndexPath *oldIndexPath = nil;
        for(int i = 0;i < self.modulModel.word_list.count;i++) {
            if(self.currentPlayModel == self.modulModel.word_list[i]) {
                oldIndexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                break;
            }
        }
        self.currentPlayModel.isPlay = NO;
        self.currentPlayModel = model;
        self.currentPlayModel.isPlay = YES;
//        NSArray *indexPaths = nil;
//        if(oldIndexPath == nil) {
//            indexPaths = @[indexPath];
//        } else {
//            indexPaths = @[oldIndexPath, indexPath];
//        }
//        self.showLabel.text = [NSString stringWithFormat:@"old:%ld new:%ld",oldIndexPath.section,indexPath.section];
        [tableView reloadData];
//        [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
    }
    [self playWithModel:self.currentPlayModel];
}
//自动播放代码调用
- (void)autoAplayWithtableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    DebugLog(@"%ld  %ld",indexPath.section,indexPath.row);
    
    self.isAutoPlayNext = YES;
    JJWordModel *model = self.modulModel.word_list[indexPath.section];
//    model.isPlay = YES;
//    if(self.currentPlayModel != model) {
        NSIndexPath *oldIndexPath = nil;
        for(int i = 0;i < self.modulModel.word_list.count;i++) {
            if(self.currentPlayModel == self.modulModel.word_list[i]) {
                oldIndexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                break;
            }
        }
        self.currentPlayModel.isPlay = NO;
        self.currentPlayModel = model;
        self.currentPlayModel.isPlay = YES;
//        NSArray *indexPaths = nil;
//        if(oldIndexPath == nil) {
//            indexPaths = @[indexPath];
//        } else {
//            indexPaths = @[oldIndexPath, indexPath];
//        }
//        self.showLabel.text = [NSString stringWithFormat:@"old:%ld new:%ld",oldIndexPath.section,indexPath.section];
//        [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [self playWithModel:self.currentPlayModel];
        });
        
//        DebugLog(@"haha");
//    }
    
}



//播放音乐
-(void)playWithModel:(JJWordModel*)model{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
    [[AVAudioSession sharedInstance] setActive:YES error:NULL];
    NSURL *url = nil;
    NSFileManager *ma = [NSFileManager defaultManager];
    if([ma fileExistsAtPath:JJAudioFileFullpathMP3(model.audio)]){
//        //如果已经下载过的话,直接播放本地的
//        url =[NSURL fileURLWithPath: JJAudioFileFullpathMP3(model.audio)];
        url = [NSURL URLWithString:model.audio];
        DebugLog(@"已经下载");
    } else {
        //如果没下载过,则播放网络资源并进行下载
        DebugLog(@"没有下载过");
        url = [NSURL URLWithString:model.audio];
        [HFNetWork downLoadWithURL:model.audio destinationPath:JJAudioFileFullpathMP3(model.audio) params:nil progress:^(NSProgress *progress) {
//            NSLog(@"jindu:%@",progress);
//            DebugLog(@"进度为:%f",100.0*progress.completedUnitCount/progress.totalUnitCount);
        }];
    }
        AVPlayerItem *playerItem = nil;
        playerItem = [AVPlayerItem playerItemWithURL:url];
    DebugLog(@"playerItem : %@",playerItem);
    self.currentItem = playerItem;
//    DebugLog(@"%@",self.player.currentItem);
    
    if (self.player.currentItem != nil) {
        //先把上一次item通知移除
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    }
    //替换当前音乐资源
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    //监听音乐播放完成通知
    //如果_isAutoPlayNext为真,表示需要自动播放下一首
    
    
    if(self.isAutoPlayNext) {
        [self addNSNotificationForPlayMusicFinish];
    }

    //[self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        //监听播放器状态
//        [self addPlayStatus];
    if([ma fileExistsAtPath:JJAudioFileFullpathMP3(model.audio)]){
        //如果已经下载过的话,先暂停一小会
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //开始播放
            [self.player play];
            

        });
    } else {
        //如果没下载过
        //开始播放
        [self.player play];
    }
//    }];
//    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
}

#pragma mark - NSNotification  播放结束通知
-(void)addNSNotificationForPlayMusicFinish
{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];

    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVPlayerItemTimeJumpedNotification:) name:AVPlayerItemTimeJumpedNotification object:_player.currentItem];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVPlayerItemFailedToPlayToEndTimeNotification:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:_player.currentItem];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVPlayerItemPlaybackStalledNotification:) name:AVPlayerItemPlaybackStalledNotification object:_player.currentItem];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVPlayerItemNewAccessLogEntryNotification:) name:AVPlayerItemNewAccessLogEntryNotification object:_player.currentItem];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVPlayerItemNewErrorLogEntryNotification:) name:AVPlayerItemNewErrorLogEntryNotification object:_player.currentItem];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVPlayerItemFailedToPlayToEndTimeErrorKey:) name:AVPlayerItemFailedToPlayToEndTimeErrorKey object:_player.currentItem];
}
-(void)AVPlayerItemTimeJumpedNotification:(NSNotification*)notification{
//    DebugLog(@"1%s",__func__);
}
-(void)AVPlayerItemFailedToPlayToEndTimeNotification:(NSNotification*)notification{
//    DebugLog(@"2%s",__func__);

}
-(void)AVPlayerItemPlaybackStalledNotification:(NSNotification*)notification{
//    DebugLog(@"3%s",__func__);

}
-(void)AVPlayerItemNewAccessLogEntryNotification:(NSNotification*)notification{
//    DebugLog(@"4%s",__func__);

}
-(void)AVPlayerItemNewErrorLogEntryNotification:(NSNotification*)notification{
//    DebugLog(@"5%s",__func__);

}
-(void)AVPlayerItemFailedToPlayToEndTimeErrorKey:(NSNotification*)notification{
//    DebugLog(@"6%s",__func__);

}

#pragma mark - 播放结束notification通知
-(void)playFinished:(NSNotification*)notification
{
    //[self.player.currentItem removeObserver:self forKeyPath:@"status"];
//    NSArray * timeRanges = self.player.currentItem.loadedTimeRanges;
//    NSArray *a = _player.currentItem.timedMetadata;
    //播放结束后先移除当前CurrentItem的观察
//    [self removePlayStatus];
    
    //播放下一首
    DebugLog(@"jieshula %@",notification);
//    [self nextBtnAction:nil];
    if(self.currentItem == self.player.currentItem) {//设置这个的原因主要是怕上一个item连续发送两次播放完成通知
        for(int i = 0; i < self.modulModel.word_list.count;i++) {
            JJWordModel *model = self.modulModel.word_list[i];
            if(model == self.currentPlayModel) {
                if(i < self.modulModel.word_list.count-1) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i+1];
                    [self autoAplayWithtableView:self.readWordTableView didSelectRowAtIndexPath:indexPath];
                    break;
                } else {
                    [JJHud showToast:@"本模块播放完毕"];
                }
            }
        }
    } else {
        [JJHud showToast:@"音频加载失败,请重新尝试.."];
    }
}


#pragma mark - 懒加载
- (AVPlayer *)player {
    if(_player == nil) {
        //初始化_player
        _player = [[AVPlayer alloc] init];
        [[RACObserve(_player, currentItem.status) ignore:nil] subscribeNext:^(NSNumber *x) {
//            DebugLog(@"%ld  %ld",_player.status,_player.currentItem.status);
            AVPlayerItemStatus status = x.intValue;
            switch (status) {
                case AVPlayerStatusUnknown:
                {
//                    DebugLog(@"未知转态");
                }
                    break;
                case AVPlayerStatusReadyToPlay:
                {
//                    DebugLog(@"准备播放");
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSIndexPath *ind = [NSIndexPath indexPathForRow:0 inSection:10   ];
//    [self.readWordTableView scrollToRowAtIndexPath:ind atScrollPosition:UITableViewScrollPositionTop animated:YES];
//}
@end
