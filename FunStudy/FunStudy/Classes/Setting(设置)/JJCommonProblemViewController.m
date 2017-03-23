//
//  JJCommonProblemViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/2.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJCommonProblemViewController.h"
#import "JJCommanProblemCell.h"
#import "JJCommonProblemHeadView.h"
#import "JJCommonProblemModel.h"
#import "JJCommonProblemCellModel.h"

static NSString *const commanProblemCellIdentifier = @"JJCommanProblemCellIdentifier";

@interface JJCommonProblemViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<JJCommonProblemModel *> *problemModelArray;


@end

@implementation JJCommonProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    JJCommonProblemModel *homeworkProblemModel = [[JJCommonProblemModel alloc]init];
    homeworkProblemModel.leftQuestion = @"作业问题";
    homeworkProblemModel.rightQuestion = @"更多问题";
    
    
    JJCommonProblemCellModel *homeworkCellModel1 = [[JJCommonProblemCellModel alloc]init];
    homeworkCellModel1.isDisplay = NO;
    homeworkCellModel1.question = @"1.录音录不上怎么办?";
    homeworkCellModel1.questionAndAnswer = @"1.录音录不上怎么办?\n如果遇到提示“没有录音权限”，您可以尝试以下方式重新获取权限：\n(1)iPhone通用设置：在手机的“设置->隐私->麦克风”中，允许“Fun学”访问。\n(2)安卓通用设置：进入手机的“设置->应用管理-> Fun学->权限管理”，选择允许录音权限。\n(3)OPPO：进入手机“设置->安全服务->个人信息安全->按程序管理->Fun学->录音”，选择允许录音权限。\n(4)华为：进入手机的“设置->权限管理->应用->Fun学->录音”，选择允许录音权限。\n(5)Vivio：进入手机的“i管家->软件管理->软件权限管理->录音->Fun学”，选择允许录音权限。\n(6)如上述方法仍无法解决问题，可尝试安装以下安全管理软件：360卫士：在“360卫士->软件管理->权限管理”中，允许Fun学获取录音权限。腾讯手机管家：在“腾讯手机管家->软件管理->软件权限管理”中，允许Fun学获取录音权限。";
    
    
    JJCommonProblemCellModel *homeworkCellModel2 = [[JJCommonProblemCellModel alloc]init];
    homeworkCellModel2.question = @"2.点击开始作业,一直显示不出来怎么办?";
    homeworkCellModel2.questionAndAnswer = @"2.点击开始作业,一直显示不出来怎么办?\n请检测您的网络是否流畅，为了不影响作业显示，建议您在wifi条件下完成作业。";
    
    
    JJCommonProblemCellModel *homeworkCellModel3 = [[JJCommonProblemCellModel alloc]init];
    homeworkCellModel3.question = @"3.如何补做作业和测验？";
    homeworkCellModel3.questionAndAnswer = @"3.如何补做作业和测验？\n请您点击主页的【Fun学足迹】，在“作业”和“测验”列表里，找到需要补做的作业和测验，点击后面的“补做”即可。";
    
    JJCommonProblemCellModel *homeworkCellModel4 = [[JJCommonProblemCellModel alloc]init];
    homeworkCellModel4.question = @"4.我为什么没有作业?";
    homeworkCellModel4.questionAndAnswer = @"4.我为什么没有作业?\n如果老师布置了作业或测验，手机登录后就会显示。如果看不到，请点击【个人中心】->【设置】->【个人信息】查看班级学校信息是否和您的信息一致，如果不一致，请退出重新登录。";
    
    JJCommonProblemCellModel *homeworkCellModel5 = [[JJCommonProblemCellModel alloc]init];
    homeworkCellModel5.question = @"5.【Fun课堂】是什么？";
    homeworkCellModel5.questionAndAnswer = @"5.【Fun课堂】是什么？\n【Fun课堂】是可以用来听现代新理念系列教材录音的电子课本，选择你使用的教材，在手机上听课本内容来预习和复习。";
    
    JJCommonProblemCellModel *homeworkCellModel6 = [[JJCommonProblemCellModel alloc]init];
    homeworkCellModel6.question = @"6.作业中断后，是否能重做？";
    homeworkCellModel6.questionAndAnswer = @"6.作业中断后，是否能重做？\n如果作业已经提交，就不能重做；一部分作业提交，一部分没有提交，那么没提交的部分可以重新登录后继续做。";
    
    JJCommonProblemCellModel *homeworkCellModel7 = [[JJCommonProblemCellModel alloc]init];
    homeworkCellModel7.question = @"7.没有作业时，可以学习什么？";
    homeworkCellModel7.questionAndAnswer = @"7.没有作业时，可以学习什么？\n没有作业时，可以进入【Fun课堂】进行预习和复习，或者告知老师布置新作业。";
    
    
    homeworkProblemModel.cellModelArray = @[homeworkCellModel1,homeworkCellModel2,homeworkCellModel3,homeworkCellModel4,homeworkCellModel5,homeworkCellModel6,homeworkCellModel7];
    
    
    
    
    JJCommonProblemModel *accountProblemModel = [[JJCommonProblemModel alloc]init];
    accountProblemModel.leftQuestion = @"账号问题";
    accountProblemModel.rightQuestion = @"更多问题";
    
    JJCommonProblemCellModel *accountCellModel1 = [[JJCommonProblemCellModel alloc]init];
    accountCellModel1.question = @"1.忘记账号或密码怎么办？";
    accountCellModel1.questionAndAnswer = @"1.忘记账号或密码怎么办？\n（1）	使用已绑定或注册手机号，点击【登录遇到问题】->【忘记密码】找回。\n（2）忘记账号和密码，请联系你的新理念任课老师询问账号或重置密码。";
    accountProblemModel.cellModelArray = @[accountCellModel1];
    
    
    
    JJCommonProblemModel *coinProblemModel = [[JJCommonProblemModel alloc]init];
    coinProblemModel.leftQuestion = @"学币问题";
    coinProblemModel.rightQuestion = @"更多问题";
    
    
    JJCommonProblemCellModel *coinCellModel1 = [[JJCommonProblemCellModel alloc]init];
    coinCellModel1.isDisplay = NO;
    coinCellModel1.question = @"1.Fun学币如何使用？";
    coinCellModel1.questionAndAnswer = @"1.Fun学币如何使用？\n根据你所在学校的相关奖励制度，Fun学币可用于兑换相应的奖品或小礼物，兑换后，学币会被扣减。";
    
    JJCommonProblemCellModel *coinCellModel2 = [[JJCommonProblemCellModel alloc]init];
    coinCellModel2.question = @"2.如何获得Fun学币?";
    coinCellModel2.questionAndAnswer = @"2.如何获得Fun学币?\n按时完成老师布置的作业，平均分越高获得的Fun学币越多，学币榜名次越高。老师也会根据作业完成情况奖励相应的学币。";

    coinProblemModel.cellModelArray = @[coinCellModel1,coinCellModel2];
    
    
    self.problemModelArray = @[homeworkProblemModel,accountProblemModel,coinProblemModel];

    

    
    
    [self setUpBaseView];
    [self setUpCenter];
}
#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = @"常见问题";
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    //    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"ReadTestBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
}

//设置中间视图
- (void)setUpCenter {
    //中部大背景
    UIView *centerBackView = [[UIView alloc]init];
    [self.view addSubview:centerBackView];
    [centerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(109 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(330 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(424 * KWIDTH_IPHONE6_SCALE);
    }];
    centerBackView.backgroundColor = RGBA(126, 251, 252, 1);
    [centerBackView createBordersWithColor:RGBA(0, 164, 197, 1) withCornerRadius:10*KWIDTH_IPHONE6_SCALE andWidth:4*KWIDTH_IPHONE6_SCALE];
    
    //Book  TableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    self.tableView.estimatedRowHeight = 400;
//    self.tableView.estimatedSectionHeaderHeight = 400;
    self.tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[JJCommanProblemCell class] forCellReuseIdentifier:commanProblemCellIdentifier];
    [centerBackView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackView);
        make.top.with.offset(23 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(281 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(369 * KWIDTH_IPHONE6_SCALE);
    }];
}

#pragma mark - UItableViewDataSource&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.problemModelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JJCommonProblemModel *model = self.problemModelArray[section];
    return model.cellModelArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJCommanProblemCell *cell = [tableView dequeueReusableCellWithIdentifier:commanProblemCellIdentifier forIndexPath:indexPath];
    cell.model = self.problemModelArray[indexPath.section].cellModelArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JJCommonProblemHeadView *headView = [[JJCommonProblemHeadView alloc]init];
    headView.model = self.problemModelArray[section];
    return headView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    JJCommanProblemCell *cel = cell;
    
    
    [cel.backView createDashLineBordersWithColor:RGBA(0, 122, 170, 1) withCornerRadius:13 * KWIDTH_IPHONE6_SCALE andWidth:5 * KWIDTH_IPHONE6_SCALE];
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    JJCommonProblemHeadView *headView = view;
    
    [headView layoutIfNeeded];
    NSLog(@"%@",NSStringFromCGRect(headView.frame));
    [headView.backView createDashLineBordersWithColor:RGBA(0, 122, 170, 1) withCornerRadius:13 * KWIDTH_IPHONE6_SCALE andWidth:5 * KWIDTH_IPHONE6_SCALE ];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 76 * KWIDTH_IPHONE6_SCALE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JJCommonProblemModel *headModel = self.problemModelArray[indexPath.section];
//    switch (indexPath.section) {
//        case 0:
//        {
            JJCommonProblemCellModel *cellModel = headModel.cellModelArray[indexPath.row];
            cellModel.isDisplay = !cellModel.isDisplay;
//        }
//            break;
//        case 1:
//        {
//            
//        }
//            break;
//        case 2:
//        {
//            
//        }
//            break;
//        default:
//            break;
//    }
//    [tableView reloadData];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}



@end
