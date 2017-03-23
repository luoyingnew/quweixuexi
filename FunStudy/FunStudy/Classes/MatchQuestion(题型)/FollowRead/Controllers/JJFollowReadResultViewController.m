//
//  JJFollowReadResultViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJFollowReadResultViewController.h"
#import "JJFollowReadModel.h"
#import "JJFollowReadResultCell.h"
#import "JJTopicViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"
#import <ReactiveCocoa.h>
#import "JJIsSelfStudyTopicViewController.h"

static NSString *followReadResultCellIdentifier = @"JJFollowReadResultCellIdentifier";

@interface JJFollowReadResultViewController ()<UITableViewDataSource,UITableViewDelegate>

//播放器
@property(nonatomic, strong)AVPlayer *player;

//当前上传的是第几个
@property(nonatomic,assign)int currentIndex;

@end

@implementation JJFollowReadResultViewController

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
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerClass:[JJFollowReadResultCell class] forCellReuseIdentifier:followReadResultCellIdentifier];
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
    [reFormBtn addTarget:self action:@selector(reformBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reFormBtn];
    [reFormBtn setBackgroundImage:[UIImage imageNamed:@"MatchNextBtn"] forState:UIControlStateNormal];
    [reFormBtn setTitle:@"重新做题" forState:UIControlStateNormal];
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
    for(UIViewController *vc in self.navigationController.childViewControllers) {
        if([vc isKindOfClass:[JJTopicViewController class]] || [vc isKindOfClass:[JJIsSelfStudyTopicViewController class]]) {
            [self.navigationController popToViewController:vc animated:NO];
            [[NSNotificationCenter defaultCenter]postNotificationName:TopicListPushToMatchNotification object:nil ];
            break;
        }
    }
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

    
        if(self.modelArray.count == 0) return;
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    //小题索引 1232_1233_1234
    NSString *answer_index = nil;
    
    JJFollowReadModel *model = self.modelArray[self.currentIndex];
    answer_index = model.unit_id;
    NSDictionary *params = nil;
    NSString *URL = nil;
    if([self.typeName isEqualToString:@"最新测验"]) {
        CGFloat score = 90;
        if(model.score < 2.5) {
            score = 90.0;
        } else if(model.score < 4.0){
            score = roundf(90 + (4.0 * (model.score - 2.5)));//四舍五入
        } else if(model.score < 5.0) {
            score = roundf(96 + (4.0 * (model.score - 4.0)));
        } else {
            score = 100.0;
        }

        params = @{ @"exam_id" : self.homeworkID , @"answer_index" : answer_index, @"fun_user_id" : [User getUserInformation].fun_user_id, @"score" : @((int)score)};
        URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_POST_EXAM_MEDIA];
    } else {
        if(self.isSelfStudy) {
            //自学
            CGFloat score = 90;
            if(model.score < 2.5) {
                score = 90.0;
            } else if(model.score < 4.0){
                score = roundf(90 + (4.0 * (model.score - 2.5)));
            } else if(model.score < 5.0) {
                score = roundf(96 + (4.0 * (model.score - 4.0)));
            } else {
                score = 100.0;
            }

            params = @{ @"homework_id" : self.homeworkID , @"answer_index" : answer_index, @"score" : @((int)score)};//, @"fun_user_id" : [User getUserInformation].fun_user_id)};;
            URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_SELFSTUDY_POST_MEDIA];
        } else {
            CGFloat score = 90;
            if(model.score < 2.5) {
                score = 90.0;
            } else if(model.score < 4.0){
                score = roundf(90 + (4.0 * (model.score - 2.5)));
            } else if(model.score < 5.0) {
                score = roundf(96 + (4.0 * (model.score - 4.0)));
            } else {
                score = 100.0;
            }

            params = @{ @"homework_id" : self.homeworkID , @"answer_index" : answer_index, @"fun_user_id" : [User getUserInformation].fun_user_id, @"score" : @((int)score)};
            URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_POST_MEDIA];
        }
        
    }

    AFHTTPSessionManager *httpManager = [HFNetWork AFHTTPSessionManager];
    [JJHud showStatus:nil];
    User *u = [User getUserInformation];
    [httpManager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        for(JJFollowReadModel *model in self.modelArray) {
//            [ formData appendPartWithFileURL:[NSURL fileURLWithPath: JJAudioFileFullpath(model.lastURL)] name:@"file" fileName:JJAudioFileName(model.lastURL) mimeType:@"application/octet-stream" error:NULL];
//        }
        JJFollowReadModel *model = self.modelArray[self.currentIndex];
        [ formData appendPartWithFileURL:[NSURL fileURLWithPath: JJAudioFileFullpathWAV(model.lastURL)] name:@"file" fileName:JJAudioFileNameWAV(model.lastURL) mimeType:@"application/octet-stream" error:NULL];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        float progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        DebugLog(@"上传进度-----   %f    %@",progress,uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [JJHud dismiss];
            return ;
        }
        DebugLog(@"response = %@", responseObject);
        NSInteger codeValue = [[responseObject objectForKey:@"error_code"] integerValue];
        if (codeValue) { //详情数据加载失败
            NSString *codeMessage = [responseObject objectForKey:@"error_msg"];
            DebugLog(@"codeMessage = %@", codeMessage);
            [JJHud showToast:codeMessage];
            return ;
        }
        
        DebugLog(@"上传成功 %@",responseObject);
        if(self.currentIndex == self.modelArray.count - 1) {
            [JJHud showToast:@"上传成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                for(UIViewController *vc in self.navigationController.childViewControllers) {
                    if([vc isKindOfClass:[JJTopicViewController class]] ||[vc isKindOfClass:[JJIsSelfStudyTopicViewController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                        [[NSNotificationCenter defaultCenter]postNotificationName:TopicListRefreshNotificatiion object:nil];
                        break;
                    }
                }
            });
        } else {
            self.currentIndex++;
            [self requestToSubmitHomework];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [JJHud showToast:@"加载失败"];
        DebugLog(@"上传失败 %@",error);
    }];
}


#pragma mark - UITableviewDataSource&UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 *KWIDTH_IPHONE6_SCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJFollowReadResultCell *cell = [tableView dequeueReusableCellWithIdentifier:followReadResultCellIdentifier forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 32 * KWIDTH_IPHONE6_SCALE;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JJFollowReadModel *model = self.modelArray[indexPath.section];
    [self playWithString:model.lastURL];
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
    //替换当前音乐资源
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    //    //监听音乐播放完成通知
    //    [self addNSNotificationForPlayMusicFinish];
    //监听播放器状态
    //        [self addPlayStatus];
    //开始播放
    [self.player play];
    //    }];
    //    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"xiaohui");
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

@end
