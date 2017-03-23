//
//  JJOverHomeWorkViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJOverHomeWorkViewController.h"

@interface JJOverHomeWorkViewController ()

@property (nonatomic, strong) UILabel *contragulateLabel;
@property (nonatomic, strong) UILabel *getAwardLabel;

@property (nonatomic, strong) UILabel *coinLabel;
//top背景图
@property (nonatomic, strong) UIImageView *topImageV;

//奖励学币
@property (nonatomic, strong) UIButton *awardBtn;

//金币
@property (nonatomic, strong) UIImageView *coinImageV;

//完成作业按钮
@property (nonatomic, strong) UIButton *overHomeworkBtn;

//myscore我的成绩
@property (nonatomic, strong) NSString *myScore;
//是否已经打分  1代表已经打分
@property(nonatomic,assign)NSInteger isHaveScore;
//分享按钮
@property (nonatomic, strong) UIButton *shareButton;

//分享字典
@property (nonatomic, strong) NSMutableDictionary *shareDictionary;


@end

@implementation JJOverHomeWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationViewBg.hidden = YES;
    [self setupBaseView];
    [self requestWithCompleteHomework];
    
}

- (void)setupBaseView {
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"overHomeworkBack"];
    [self.view addSubview:backImageView];

    

    
    //top
    UIImageView *topImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"overHomeworkCenterBack"]];
    topImageV.userInteractionEnabled = YES;
    self.topImageV = topImageV;
//    self.topImageView = topImageV;
    [backImageView addSubview:topImageV];
    [topImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(298 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(316 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(132 * KWIDTH_IPHONE6_SCALE);
    }];
    //分享按钮
    UIButton *shareButton = [[UIButton alloc]init];
    self.shareButton = shareButton;
    [shareButton setTitle:@"点击分享" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setBackgroundColor:RGBA(255, 187, 17, 1)];
    shareButton.titleLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
    [self.view addSubview:shareButton];
    [shareButton setTitleColor:RGBA(157, 68, 0, 1) forState:UIControlStateNormal];
    [shareButton createBordersWithColor:[UIColor clearColor] withCornerRadius:21 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topImageV.mas_top).with.offset(-17 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.topImageV);
        make.width.mas_equalTo(100 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(42 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //恭喜你本周完成2次以上作业
    UILabel *contragulateLabel = [[UILabel alloc]init];
    contragulateLabel.text = @"";
    self.contragulateLabel = contragulateLabel;
    contragulateLabel.textAlignment = NSTextAlignmentCenter;
    contragulateLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
    contragulateLabel.textColor = RGBA(255, 255, 108, 1);
    [topImageV addSubview:contragulateLabel];
    [contragulateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImageV);
        make.top.with.offset(10 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(204 * KWIDTH_IPHONE6_SCALE);
        
    }];
    //获得了额外奖励哦!
    UILabel *getAwardLabel = [[UILabel alloc]init];
    getAwardLabel.text = @"";
    self.getAwardLabel = getAwardLabel;
    getAwardLabel.textAlignment = NSTextAlignmentCenter;
    getAwardLabel.font = [UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
    getAwardLabel.textColor = RGBA(255, 255, 108, 1);
    [topImageV addSubview:getAwardLabel];
    [getAwardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contragulateLabel.mas_bottom).with.offset(10 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(204 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(topImageV);
        
    }];
    
    //名字
    UIButton *nameBtn = [[UIButton alloc]init];
    [nameBtn setTitleColor:RGBA(139, 0, 0, 1) forState:UIControlStateNormal];
    [topImageV addSubview:nameBtn];
    [nameBtn setBackgroundImage:[UIImage imageNamed:@"overHomeworkNameBack"] forState:UIControlStateNormal];
    [nameBtn setTitle:[User getUserInformation].user_nicename forState:UIControlStateNormal];
    [nameBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12 * KWIDTH_IPHONE6_SCALE]];
    [nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(80 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(topImageV);
        make.width.mas_equalTo(54 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(21 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //照片
    UIImageView *pictureImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"overHomeWorkPicture"]];
    [pictureImageV createBordersWithColor:[UIColor clearColor] withCornerRadius:13 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [pictureImageV sd_setImageWithURL:[NSURL URLWithString:[User getUserInformation].avatar_url] placeholderImage:[UIImage imageNamed:@"overHomeWorkPicture"]];
    [topImageV addSubview:pictureImageV];
    [pictureImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(108 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(topImageV);
        make.top.with.offset(105 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //奖励学币
    UIButton *awardBtn = [[UIButton alloc]init];
    self.awardBtn = awardBtn;
    [awardBtn setTitleColor:RGBA(139, 0, 0, 1) forState:UIControlStateNormal];
    [topImageV addSubview:awardBtn];
    [awardBtn setBackgroundImage:[UIImage imageNamed:@"overHomeworkAward"] forState:UIControlStateNormal];
    [awardBtn setTitle:@"奖励学币" forState:UIControlStateNormal];
    [awardBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE]];
    [awardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(225 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(topImageV);
        make.width.mas_equalTo(80 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(23 * KWIDTH_IPHONE6_SCALE);
    }];

    //金币
    UIImageView *coinImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"overHomeWorkCoin"]];
    self.coinImageV = coinImageV;
    [topImageV addSubview:coinImageV];
    [coinImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(251 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(topImageV);
        make.width.mas_equalTo(56 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(30 * KWIDTH_IPHONE6_SCALE);
    }];
    UILabel *coinLabel = [[UILabel alloc]init];
    coinLabel.text = @"";
    self.coinLabel = coinLabel;
    coinLabel.textColor = [UIColor whiteColor];
    
    coinLabel.font = [UIFont boldSystemFontOfSize:10 * KWIDTH_IPHONE6_SCALE];
    [coinImageV addSubview:coinLabel];
    [coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(coinImageV).with.offset(3 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-8 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //url图
    UIImageView *urlImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"overHomeworkUrl"]];
    [topImageV addSubview:urlImageV];
    [urlImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(142 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(24 * KWIDTH_IPHONE6_SCALE);
        make.bottom.with.offset(-10 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(topImageV);
    }];

    //完成作业
    UIButton *overHomeworkBtn = [[UIButton alloc]init];
    self.overHomeworkBtn = overHomeworkBtn;
    [overHomeworkBtn addTarget:self action:@selector(overHomeworkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [overHomeworkBtn setBackgroundImage:[UIImage imageNamed:@"overHomeworkBtn"] forState:UIControlStateNormal];
    [backImageView addSubview:overHomeworkBtn];
    [overHomeworkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(494 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(138 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(57 * KWIDTH_IPHONE6_SCALE);
    }];
}
#pragma mark - 分享
- (void)shareBtnClick {
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImage"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        NSString *shareText = [NSString stringWithFormat:@"我刚在Fun学APP完成了英语测验,测验成绩%@,你也来试试吧!",self.myScore];
        if([self.name isEqualToString:@"最新作业"]) {
            if(self.isHaveScore == 1) {
                //已经打分
                shareText = [NSString stringWithFormat:@"我刚在Fun学APP完成了英语作业,作业成绩%@,你也来试试吧!",self.myScore];
            } else {
                //未打分
                shareText = [NSString stringWithFormat:@"我刚在Fun学APP完成了英语作业,你也来试试吧!"];
            }
        } else if([self.name isEqualToString:@"最新测验"]) {
            if(self.isHaveScore == 1) {
                //已经打分
                shareText = [NSString stringWithFormat:@"我刚在Fun学APP完成了英语测验,测验成绩%@,你也来试试吧!",self.myScore];
            } else {
                //未打分
                shareText = [NSString stringWithFormat:@"我刚在Fun学APP完成了英语测验,你也来试试吧!"];
            }
        }
//        shareText = @"ewrewrw";
        NSString *sharedURL = ShanreUrl;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.shareDictionary options:NSJSONWritingPrettyPrinted error:NULL];
        NSString *shopString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *base64String = [shopString base64Encode];
        sharedURL = [NSString stringWithFormat:@"%@?r=%@",ShanreUrl,base64String];
        [shareParams SSDKSetupShareParamsByText:shareText
                                         images:imageArray
                                            url:[NSURL URLWithString:sharedURL]
                                          title:@"Fun学"
                                           type:SSDKContentTypeAuto];
    // 定制新浪微博的分享内容
    [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",shareText,sharedURL] title:@"Fun学" image:imageArray url:[NSURL URLWithString:sharedURL] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
     //定制微信朋友圈的分享内容
    [shareParams SSDKSetupWeChatParamsByText:shareText title:shareText url:[NSURL URLWithString:sharedURL] thumbImage:nil image:imageArray musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];// 微信朋友圈平台
//    [shareParams SSDKSetupQQParamsByText:@"定制QQ分享内容" title:self.model.name url:nil thumbImage:nil image:self.model.picture type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];//QQ好友
        
        
        //有的平台要客户端分享需要加此方法，例如微博.不加这一句的话微博分享会不跳进微博页就分享成功
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        SSUIShareActionSheetController *shareActionSheetController = [ShareSDK showShareActionSheet:self.shareButton //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                                                                              items:@[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)]
                                                                                        shareParams:shareParams
                                                                                onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                                                    
                                                                                    switch (state) {
                                                                                        case SSDKResponseStateSuccess:
                                                                                        {
                                                                                            [JJHud showToast:@"分享成功"];
                                                                                            //                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                            //                                                                                   message:nil
                                                                                            //                                                                                  delegate:nil
                                                                                            //                                                                         cancelButtonTitle:@"确定"
                                                                                            //                                                                         otherButtonTitles:nil];
                                                                                            //                               [alertView show];
                                                                                            break;
                                                                                        }
                                                                                        case SSDKResponseStateFail:
                                                                                        {
                                                                                            if (error.code == 208) {
                                                                                                [JJHud showToast:@"未安装客户端"];
                                                                                            } else {
                                                                                                [JJHud showToast:@"分享失败"];
                                                                                            }
                                                                                            //                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                            //                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                                            //                                                                              delegate:nil
                                                                                            //                                                                     cancelButtonTitle:@"OK"
                                                                                            //                                                                     otherButtonTitles:nil, nil];
                                                                                            //                               [alert show];
                                                                                            break;
                                                                                        }
                                                                                        default:
                                                                                            break;
                                                                                    }
                                                                                }
                                                                      ];
        //加上这个可以不进UI编辑页面
        [shareActionSheetController.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    }
    
    
    
    
    //    XZShare *share = [XZShare sharedInstance];
    //    [share shareWithTitle:@"fdsfs" images:@[[UIImage imageNamed:@"FunClassRoomVideoBtn"]] content:@"邀你来参加EIGHTEEN的活动。" url:ShanreUrl];
}

//完成作业请求
- (void)requestWithCompleteHomework {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL = nil;
    NSDictionary *params = nil;
    if([self.name isEqualToString:@"最新测验"]) {
        URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_EXAMFINISH];
        params = @{@"fun_user_id" : [User getUserInformation].fun_user_id , @"exam_id" : self.homework_id};
    } else {
        if(self.isSelfStudy) {
            //自学
            URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_SELFSTUDY_HOMEWORKFINISH];
            params = @{@"fun_user_id" : [User getUserInformation].fun_user_id , @"homework_id" : self.homework_id};
        } else {
            URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_HOMEWORKFINISH];
            params = @{@"fun_user_id" : [User getUserInformation].fun_user_id , @"homework_id" : self.homework_id};
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
        self.shareDictionary = [NSMutableDictionary dictionaryWithDictionary:response];
        self.shareDictionary[@"user_id"] = [User getUserInformation].fun_user_id;
        if(self.isSelfStudy) {
            //自学用户
            self.shareDictionary[@"study_id"] = self.homework_id;
        } else {
            if([self.name isEqualToString:@"最新作业"]) {
                self.shareDictionary[@"homework_id"] = self.homework_id;
            } else {
                self.shareDictionary[@"exam_id"] = self.homework_id;
            }
        }
        [self successOverHomework:response];
        
    } fail:^(NSError *error) {
//        self.shareButton.hidden = YES;
        [JJHud showToast:@"加载失败"];
    }];
}

#pragma mark - 完成作业请求成功
- (void)successOverHomework:(NSDictionary *)response {
    self.myScore = response[@"score"];
    if(self.isSelfStudy) {
        
        //自学中心的,肯定出分数且没有金币奖励
        self.getAwardLabel.hidden = YES;
        self.contragulateLabel.text = [NSString stringWithFormat:@"本次成绩%@分",response[@"score"]];
        
        [self.contragulateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.topImageV);
            make.top.with.offset(17 * KWIDTH_IPHONE6_SCALE);
            //make.width.mas_equalTo(204 * KWIDTH_IPHONE6_SCALE);
        }];
        self.contragulateLabel.font = [UIFont boldSystemFontOfSize:30 * KWIDTH_IPHONE6_SCALE];
        
        UILabel *messageLabel = [[UILabel alloc]init];
        messageLabel.numberOfLines = 0;
        messageLabel.backgroundColor = RGBA(255, 187, 17, 1);
        messageLabel.textColor = RGBA(157, 68, 0, 1);
        messageLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
        [self.view addSubview:messageLabel];
        [messageLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:21 * KWIDTH_IPHONE6_SCALE andWidth:0];
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topImageV.mas_bottom).with.offset(17 * KWIDTH_IPHONE6_SCALE);
            make.centerX.equalTo(self.topImageV);
            make.width.mas_equalTo(257 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(42 * KWIDTH_IPHONE6_SCALE);
        }];
        [self.overHomeworkBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            if(isPhone) {
                make.top.equalTo(messageLabel.mas_bottom).with.offset(57 * KWIDTH_IPHONE6_SCALE);
            } else {
                make.top.equalTo(messageLabel.mas_bottom).with.offset(10 * KWIDTH_IPHONE6_SCALE);
            }
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(138 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(57 * KWIDTH_IPHONE6_SCALE);
        }];
        if(!isPhone) {
            [self.topImageV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.with.offset(110 * KWIDTH_IPHONE6_SCALE);
            }];
        }
        self.coinLabel.hidden = YES;
        self.coinImageV.hidden = YES;
        self.awardBtn.hidden = YES;
        messageLabel.hidden = YES;
    } else {//如果是非自学用户
        //已经有打分的
        self.isHaveScore = [response[@"status"] intValue];
        if([response[@"status"] intValue] == 1) {
            
            self.getAwardLabel.hidden = YES;
            self.contragulateLabel.text = [NSString stringWithFormat:@"本次成绩%@分",response[@"score"]];
            [self.contragulateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.equalTo(self.topImageV);
                make.top.with.offset(17 * KWIDTH_IPHONE6_SCALE);
                //make.width.mas_equalTo(204 * KWIDTH_IPHONE6_SCALE);
            }];
            self.contragulateLabel.font = [UIFont boldSystemFontOfSize:30 * KWIDTH_IPHONE6_SCALE];
            
            UILabel *messageLabel = [[UILabel alloc]init];
            messageLabel.numberOfLines = 0;
            messageLabel.backgroundColor = RGBA(255, 187, 17, 1);
            messageLabel.textColor = RGBA(157, 68, 0, 1);
            messageLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
            [self.view addSubview:messageLabel];
            [messageLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:21 * KWIDTH_IPHONE6_SCALE andWidth:0];
            [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topImageV.mas_bottom).with.offset(17 * KWIDTH_IPHONE6_SCALE);
                make.centerX.equalTo(self.topImageV);
                make.width.mas_equalTo(257 * KWIDTH_IPHONE6_SCALE);
                make.height.mas_equalTo(42 * KWIDTH_IPHONE6_SCALE);
            }];
            [self.overHomeworkBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                if(isPhone) {
                    make.top.equalTo(messageLabel.mas_bottom).with.offset(57 * KWIDTH_IPHONE6_SCALE);
                } else {
                    make.top.equalTo(messageLabel.mas_bottom).with.offset(10 * KWIDTH_IPHONE6_SCALE);
                }
                make.centerX.equalTo(self.view);
                make.width.mas_equalTo(138 * KWIDTH_IPHONE6_SCALE);
                make.height.mas_equalTo(57 * KWIDTH_IPHONE6_SCALE);
            }];
            if(!isPhone) {
                [self.topImageV mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.with.offset(110 * KWIDTH_IPHONE6_SCALE);
                }];
            }
            
            
            if([self.name isEqualToString:@"最新测验"]) {
                if([response[@"score"] floatValue] >= 90) {
                    //如果大于等于90分
                    self.coinLabel.text = [NSString stringWithFormat:@"+%@",response[@"reward_coin"]];
                    
                    messageLabel.text = @"恭喜你,本次测验取得优异成绩,获得奖励,再接再厉!";
                    
                    [messageLabel headIndentLength:10 * KWIDTH_IPHONE6_SCALE tailIndentLength:247 * KWIDTH_IPHONE6_SCALE];
                } else {
                    //如果低于90分
                    messageLabel.text = @"还需继续努力哦!90分以上就能获得学币奖励,加油!";
                    //                [messageLabel headIndentLength:10]
                    //                [messageLabel tailIndentLength:290 * KWIDTH_IPHONE6_SCALE];
                    [messageLabel headIndentLength:10 * KWIDTH_IPHONE6_SCALE tailIndentLength:247 * KWIDTH_IPHONE6_SCALE];
                    self.coinImageV.hidden = YES;
                    self.awardBtn.hidden = YES;
                    [self.topImageV mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(271 * KWIDTH_IPHONE6_SCALE);
                    }];
                }
            } else {
                if([response[@"score"] floatValue] >= 90) {
                    //如果大于等于90分
                    self.coinLabel.text = [NSString stringWithFormat:@"+%@",response[@"reward_coin"]];
                    messageLabel.text = @"恭喜你,本次作业取得优异成绩,获得奖励,再接再厉!";
                    [messageLabel headIndentLength:10 * KWIDTH_IPHONE6_SCALE tailIndentLength:247 * KWIDTH_IPHONE6_SCALE];
                } else {
                    //如果低于90分
                    self.coinLabel.text = [NSString stringWithFormat:@"+%@",response[@"reward_coin"]];
                    messageLabel.text = @"还需继续努力哦!加油!";
                    [messageLabel headIndentLength:10 * KWIDTH_IPHONE6_SCALE tailIndentLength:247 * KWIDTH_IPHONE6_SCALE];
                }
            }
        } else {
            //如果是没有打分的
            if([self.name isEqualToString:@"最新测验"]) {
                //最新测验如果没有打分
                
                self.contragulateLabel.text = @"恭喜你完成本次测验";
                self.getAwardLabel.text = @"继续努力哦!";
                self.coinLabel.hidden = YES;
                self.coinImageV.hidden = YES;
                self.awardBtn.hidden = YES;
            } else {
                if([response[@"home_work_week_num"] intValue] != 2 ) {
                    self.contragulateLabel.text = @"恭喜你完成本次作业";
                    self.getAwardLabel.text = @"继续努力哦!";
                } else {
                    self.contragulateLabel.text = @"恭喜你本周完成2次以上作业";
                    self.getAwardLabel.text = @"获得了额外奖励哦!";
                }
                self.coinLabel.text = [NSString stringWithFormat:@"+%@",response[@"reward_coin"]];
            }
        }
    }

}


#pragma mark - 完成作业按钮点击
- (void)overHomeworkBtnClick:(UIButton *)btn {
    NSLog(@"%@",self.parentViewController);
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    if(self.overHomeworkBlock) {
        self.overHomeworkBlock();
    }
}

- (NSMutableDictionary *)shareDictionary {
    if(!_shareDictionary) {
        _shareDictionary = [NSMutableDictionary dictionary];
    }
    return _shareDictionary;
}
- (void)dealloc {
    DebugLog(@"作业王城销毁了");
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self successOverHomework:@{@"error_code" : @"0", @"reward_coin" : @"0", @"score" : @"38", @"status" : @"1"}];
//}

@end
