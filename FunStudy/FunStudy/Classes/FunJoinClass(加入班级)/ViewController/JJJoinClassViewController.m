//
//  JJJoinClassViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJJoinClassViewController.h"
#import "JJFunAlerView.h"
#import "JJJoinClassCell.h"
#import "UIImageView+JJScrollView.h"

@interface JJJoinClassViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *joinClassTableView;
////当前想要加入的班级model
//@property (nonatomic, strong) JJClassModel *classModel;



@end

static NSString *joinClassCellIdentifier = @"JJJoinClassCellIdentifer";

@implementation JJJoinClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = @"加入班级";
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    
    UIImageView *centerBackImageView = [[UIImageView alloc]init];
    centerBackImageView.userInteractionEnabled = YES;
    centerBackImageView.image = [UIImage imageNamed:@"Login_BackCenterImage"];
    [self.view addSubview:centerBackImageView];
    [centerBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(315 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(363 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //班级列表tableVIew
    self.joinClassTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.joinClassTableView.tag = noDisableVerticalScrollTag;
    
    self.joinClassTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.joinClassTableView.backgroundColor = [UIColor clearColor];
    [self.joinClassTableView registerClass:[JJJoinClassCell class] forCellReuseIdentifier:joinClassCellIdentifier];
    self.joinClassTableView.dataSource = self;
    self.joinClassTableView.delegate = self;
    [centerBackImageView addSubview:self.joinClassTableView];
    [self.joinClassTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(26 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(centerBackImageView);
        make.width.mas_equalTo(250 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(312 * KWIDTH_IPHONE6_SCALE);
    }];
}

#pragma mark - 加入班级请求
- (void)joinClassRequestWithModel:(JJClassModel *)model {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    [JJHud showStatus:nil];
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_APPLY_JOIN_CLASS];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[User getUserInformation].fun_user_id forKey:@"fun_user_id"];
    [params setObject:model.class_id forKey:@"class_id"];
    [params setObject:self.teacherModel.teacher_id forKey:@"teacher_id"];
    [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
        
        if (![response isKindOfClass:[NSDictionary class]]) {
            [JJHud dismiss];
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
        [JJHud showToast:@"已提交审核,请耐心等待"];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter]postNotificationName:POP object:@0];

//        //成功加入班级
//        User *user = [User getUserInformation];
//        user.user_class = YES;
//        [User saveUserInformation:user];
//        //发出通知让首页和tabbar修改
//        [[NSNotificationCenter defaultCenter]postNotificationName:SuccessJoinClass object:nil];
//        [self.navigationController popToRootViewControllerAnimated:NO];
        
        
//        JJTeacherModel *teacherModel = [JJTeacherModel mj_objectWithKeyValues:response];
//        
//        JJJoinClassViewController *joinClassVC = [[JJJoinClassViewController alloc]init];
//        joinClassVC.teacherModel = teacherModel;
//        [self.navigationController pushViewController:joinClassVC animated:YES];
        
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];

    
}

#pragma mark - UITableVIewDataSource & UITableVIewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.teacherModel.class_list.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJJoinClassCell *cell = [tableView dequeueReusableCellWithIdentifier:joinClassCellIdentifier forIndexPath:indexPath];
    [cell createBordersWithColor:[UIColor clearColor] withCornerRadius:10 andWidth:0];
    cell.model = self.teacherModel.class_list[indexPath.section];
    weakSelf(weakSelf);
    cell.block = ^(JJClassModel *model) {
//        self.classModel = model;
        [JJFunAlerView showFunAlertViewWithTitle:@"是否加入班级" CenterBlock:^{
            [weakSelf joinClassRequestWithModel:model];
        }];
        
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 * KWIDTH_IPHONE6_SCALE;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.joinClassTableView flashScrollIndicators];
    return 39 * KWIDTH_IPHONE6_SCALE;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}



@end
