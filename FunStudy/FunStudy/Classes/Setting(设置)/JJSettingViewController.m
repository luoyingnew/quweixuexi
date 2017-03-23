//
//  JJSettingViewController.m
//  FunStudy
//
//  Created by tang on 16/11/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJSettingViewController.h"
#import "SetModel.h"
#import "AboutViewController.h"
#import "PersonMessageViewController.h"
#import "FeedbackViewController.h"
#import "JJFunAlerView.h"
#import "JJFunAlerView.h"
#import "JJLoginOrSignUpViewController.h"
#import "JJNavigationController.h"
#import "JJClearCache.h"
#import "JJCommonProblemViewController.h"
#import "JPUSHService.h"
#import "JJSettingCell.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


static NSString * const settingCellIdentifier = @"settingCellIdentifier";


@interface JJSettingViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong)NSArray *array;
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation JJSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseView];
    [self setNavigationBar];
    
    UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(25 * KWIDTH_IPHONE6_SCALE , 97 *KWIDTH_IPHONE6_SCALE, 328 * KWIDTH_IPHONE6_SCALE, 457 * KWIDTH_IPHONE6_SCALE)];
    blankView.backgroundColor = RGBA(126, 251, 252, 1);
    [blankView createBordersWithColor:RGBA(0, 164, 197, 1) withCornerRadius:10 andWidth:4];
    [self.view addSubview:blankView];
    [blankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(97 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(328 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(457 * KWIDTH_IPHONE6_SCALE);
    }];

    //  1
    SetModel *personInfo = [SetModel configTitle:@"个人信息" icon:@"leftArrow"];
    personInfo.class = [PersonMessageViewController class];
    //  2
    SetModel *feedback = [SetModel configTitle:@"用户反馈" icon:@"leftArrow"];
    feedback.class = [FeedbackViewController class];
    //  3
    SetModel *wifi = [SetModel configTitle:@"非wifi环境下每次提示" icon:@"" type:JJSetTypeSwitch];
    //  4
    SetModel *cache = [SetModel configTitle:@"清除缓存" icon:@"leftArrow"];
   
    DebugLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]);
    cache.block = ^(){
        /**
         *  创建音频缓存目录文件
         */

       [JJFunAlerView showFunAlertViewWithTitle:@"是否清除缓存" CenterBlock:^{
           NSFileManager *fileManager = [NSFileManager defaultManager];
           [JJHud showStatus:@"正在清除缓存"];
           //清除音频缓存是否成功
           BOOL isSuccessToClearAudioCachePath = [JJClearCache clearCacheWithFilePath:JJAudioCachesDirectory];
           //清除Cache文件夹缓存是否成功
           BOOL isSuccessToClearCachePath = [JJClearCache clearCacheWithFilePath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               if(isSuccessToClearCachePath && isSuccessToClearAudioCachePath) {
                   [JJHud showToast:@"清除缓存成功"];
               } else {
                   [JJHud showToast:@"清除缓存失败"];
               }
               NSFileManager *fileManager = [NSFileManager defaultManager];
               if (![fileManager fileExistsAtPath:JJAudioCachesDirectory]) {
                   [fileManager createDirectoryAtPath:JJAudioCachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
               }
           });
           
       }];
        NSLog(@"清除缓存");
    };
    //  5
    SetModel *problem = [SetModel configTitle:@"常见问题" icon:@"leftArrow"];
     problem.class = [JJCommonProblemViewController class];
    //  6
//    SetModel *version = [SetModel configTitle:@"版本更新" icon:@"leftArrow"];
//    weakSelf(weakSelf);
//    version.block = ^(){
//        //检查更新请求
//        [weakSelf checkUpdateRequest];
//       // [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1167961008"]];
//    };
    //  7
    SetModel *about = [SetModel configTitle:@"关于我们" icon:@"leftArrow"];
    about.class = [AboutViewController class];
    self.array = @[personInfo,feedback,wifi,cache,problem,about];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[JJSettingCell class] forCellReuseIdentifier:settingCellIdentifier];
    [blankView addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(blankView);
        make.top.with.offset(0);
        make.width.mas_equalTo(300 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(385 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //退出登录
    UIButton *button = [[UIButton alloc]init ];//WithFrame:CGRectMake(40*KWIDTH_IPHONE6_SCALE, imageY, blankView.width - 40*KWIDTH_IPHONE6_SCALE * 2, 42*KWIDTH_IPHONE6_SCALE)];
    [button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"loginOutBack"] forState:UIControlStateNormal];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:19.0*KWIDTH_IPHONE6_SCALE]];
    [blankView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(261 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(42 * KWIDTH_IPHONE6_SCALE);
        make.bottom.with.offset(-15 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(blankView);
    }];

}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.array[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 14 * KWIDTH_IPHONE6_SCALE;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40 * KWIDTH_IPHONE6_SCALE;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SetModel *model = self.array[indexPath.section];
    if(model.type == JJSetTypeSwitch) {
        return ;
    }
    if (model.block) {
        model.block();
    }
    UIViewController *vc = [[model.class alloc]init];
    if([vc isKindOfClass:[PersonMessageViewController class]]) {
        vc.fd_interactivePopDisabled = NO;
    }
    [self.navigationController pushViewController:vc animated:YES];
}


//检查更新请求
- (void)checkUpdateRequest{
    
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_LATEST_VERSION];
    NSDictionary *params = @{@"os" : @"iOS"};
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
        NSString *baseVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];//当前App版本
        NSString *lastNewVersion = response[@"version"][@"version_no"];
        NSComparisonResult result = [baseVersion compare:lastNewVersion];
        if(result == NSOrderedAscending) {
            //如果有更新
            [self showAlertWithTitle:@"版本更新" message:@"是否前往AppStore更新应用" cancelBlock:^{
            } certainBlock:^{
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appStoreID]]];
            }];
        } else {
            [JJHud showToast:@"当前版本为最新版本"];
        }
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];

}

//退出登录
- (void)logout {
    //设置一个错误的别名
    //[self networkDidSetup];
    [User removeUserInformation];
    JJLoginOrSignUpViewController *loginOrSignUpVC = [[JJLoginOrSignUpViewController alloc]init];
    JJNavigationController *loginOrSignUpViewController = [[JJNavigationController alloc]initWithRootViewController:loginOrSignUpVC];
    loginOrSignUpViewController.navigationBarHidden = YES;
    [UIApplication sharedApplication].keyWindow.rootViewController = loginOrSignUpViewController;
}

#pragma mark -- 极光推送回调方法   退出登录的时候给一个空的别名
- (void)networkDidSetup
{
    // 获取当前用户id，上报给极光，用作别名
    User *user = [User getUserInformation];
    //针对设备给极光服务器反馈了别名，app服务端可以用别名来针对性推送消息
    [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        DebugLog(@"极光推送错误码+++++++：%d", iResCode);
        
        if (iResCode == 0) {
            DebugLog(@"极光推送：设置别名成功, 别名：%@", user.fun_user_id);
        }
    }];
}

//设置背景图
- (void)setBaseView {
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
}
//设置导航条
- (void)setNavigationBar {
    self.titleName = @"设置";
}





@end
