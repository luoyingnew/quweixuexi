//
//  JJMyTeacherViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMyTeacherViewController.h"
#import "JJMyTeacherCell.h"
#import "JJTeacherModel.h"

@interface JJMyTeacherViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<JJTeacherModel *> *modelArray;


@end

static NSString *myTeacherCellIdentifier = @"JJMyTeacherCellIdentifier";

@implementation JJMyTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    [self requestWithTeacherList];
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = @"我的老师";
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    UIImageView *centerBackImageView = [[UIImageView alloc]init];
    centerBackImageView.userInteractionEnabled = YES;
    centerBackImageView.image = [UIImage imageNamed:@"TeacherAwardBack"];
    [self.view addSubview:centerBackImageView];
    [centerBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(318 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(450 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(88 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //添加新老师按钮
    UIButton *addNewBtn = [[UIButton alloc]init];
    addNewBtn.hidden = YES;
    [addNewBtn setBackgroundImage:[UIImage imageNamed:@"addNewTeacherBtn"] forState:UIControlStateNormal];
    [centerBackImageView addSubview:addNewBtn];
    [addNewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.with.offset(-27 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(centerBackImageView);
        make.height.mas_equalTo(48 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(245 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView .backgroundColor = [UIColor clearColor];
    [self.tableView  registerClass:[JJMyTeacherCell class] forCellReuseIdentifier:myTeacherCellIdentifier];
    self.tableView .dataSource = self;
    self.tableView .delegate = self;
    [centerBackImageView addSubview:self.tableView ];
    [self.tableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackImageView);
        make.bottom.equalTo(addNewBtn.mas_top).with.offset(-8 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(16 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(287 * KWIDTH_IPHONE6_SCALE);
    }];
}

#pragma mark - 我的老师列表请求
- (void)requestWithTeacherList {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_MYTEACHER_LIST];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id};
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
        self.modelArray = [JJTeacherModel mj_objectArrayWithKeyValuesArray:response[@"teacher_list"]];
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}



#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
};
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJMyTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:myTeacherCellIdentifier forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104 * KWIDTH_IPHONE6_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 16 * KWIDTH_IPHONE6_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

@end
