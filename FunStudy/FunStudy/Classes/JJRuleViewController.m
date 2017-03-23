//
//  JJRuleViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJRuleViewController.h"

@interface JJRuleViewController ()

@property(nonatomic,strong) UILabel *tipLabel1;
@property(nonatomic,strong) UILabel *tipLabel2;
@property(nonatomic,strong) UILabel *tipLabel3;

@end

@implementation JJRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    [self setNavigationBar];
    [self requestWithRuleList];
    // Do any additional setup after loading the view.
}
#pragma mark - 基本设置
- (void)setUpBaseView{
    //    self.titleName = @"手机号码";
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    
    UIImageView *centerBackImageView = [[UIImageView alloc]init];
    centerBackImageView.userInteractionEnabled = YES;
    centerBackImageView.image = [UIImage imageNamed:@"ruleBackImage"];
    [self.view addSubview:centerBackImageView];
    [centerBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(107 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(315 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(363 * KWIDTH_IPHONE6_SCALE);
    }];

    //积分规则Lable
    UILabel *ruleLabel = [[UILabel alloc]init];
    ruleLabel.font = [UIFont systemFontOfSize:28 * KWIDTH_IPHONE6_SCALE];
    ruleLabel.text = @"积分规则";
    ruleLabel.textColor = RGBA(239, 142, 0, 1);
    [centerBackImageView addSubview:ruleLabel];
    [ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerBackImageView).with.offset(20 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(centerBackImageView).with.offset(51 * KWIDTH_IPHONE6_SCALE);
    }];
    //帮助提示1
    UILabel *tipLabel1 = [[UILabel alloc]init];
    tipLabel1.font = [UIFont systemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
    self.tipLabel1 = tipLabel1;
    tipLabel1.text = @"1、学生每完成1次教师布置的作业，奖励5学币；";
    tipLabel1.textColor = RGBA(0, 130, 190, 1);
    [centerBackImageView addSubview:tipLabel1];
    tipLabel1.numberOfLines = 0;
    [tipLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerBackImageView).with.offset(20 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(centerBackImageView).with.offset(98 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(centerBackImageView).with.offset(-20 * KWIDTH_IPHONE6_SCALE);
    }];
    //帮助提示2
    UILabel *tipLabel2 = [[UILabel alloc]init];
    tipLabel2.font = [UIFont systemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
    self.tipLabel2 = tipLabel2;
    tipLabel2.text = @"2、每周在线完成作业超过2次（含两次），奖励5学币；";
    tipLabel2.textColor = RGBA(0, 130, 190, 1);
    [centerBackImageView addSubview:tipLabel2];
    tipLabel2.numberOfLines = 0;
    [tipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerBackImageView).with.offset(20 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(centerBackImageView).with.offset(163 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(centerBackImageView).with.offset(-20 * KWIDTH_IPHONE6_SCALE);
    }];
    //帮助提示3
    UILabel *tipLabel3 = [[UILabel alloc]init];
    tipLabel3.font = [UIFont systemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
    self.tipLabel3 = tipLabel3;
    tipLabel3.text = @"3、每次测验成绩90分以上，奖励10学币；";
    tipLabel3.textColor = RGBA(0, 130, 190, 1);
    [centerBackImageView addSubview:tipLabel3];
    tipLabel3.numberOfLines = 0;
    [tipLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerBackImageView).with.offset(20 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(centerBackImageView).with.offset(240 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(centerBackImageView).with.offset(-20 * KWIDTH_IPHONE6_SCALE);
    }];
}

//设置导航条
- (void)setNavigationBar {
    self.titleName = @"规则";
}

#pragma mark - 积分规则请求
- (void)requestWithRuleList {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_RULELIST];
    [JJHud showStatus:nil];
    [HFNetWork postWithURL:URL params:nil isCache:NO success:^(id response) {
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
        self.tipLabel1.text = [NSString stringWithFormat:@"1、学生每完成1次教师布置的作业，奖励%@学币；",response[@"rules"][@"coin_one_homework"]];
        self.tipLabel2.text = [NSString stringWithFormat:@"2、每周在线完成作业超过2次（含两次），奖励%@学币；",response[@"rules"][@"coin_two_homework_week"]];
        self.tipLabel3.text = [NSString stringWithFormat:@"3、每次测验成绩90分以上，奖励%@学币；",response[@"rules"][@"coin_90_exam"]];
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}



@end
