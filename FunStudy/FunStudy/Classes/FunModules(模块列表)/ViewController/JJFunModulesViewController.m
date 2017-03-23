//
//  JJFunModulesViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2017/1/5.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "JJFunModulesViewController.h"
#import "JJFunReadWardCell.h"
#import "JJWordModel.h"
#import <ReactiveCocoa.h>
#import <AVFoundation/AVFoundation.h>
#import "NSString+XPKit.h"
#import "NetWorkChecker.h"
#import "JJFunAlerView.h"
#import <ReactiveCocoa.h>
#import "JJFunModulModel.h"
#import "JJFunModulCell.h"
#import "JJFunReadLessionWordViewController.h"

static NSString *funModulCellIdentifier = @"JJFunModulCellIdentifier";

@interface JJFunModulesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray<JJFunModulModel *> *modulModelArray;

@property (nonatomic, strong) UITableView *modulesTableView;

@end

@implementation JJFunModulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    [self setUpCenter];
    [self requestWithModulList];
}

#pragma mark - 基本设置
- (void)setUpBaseView{
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
//    self.bookNameLabel = bookNameLabel;
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
    
    //lession名称Label
    UILabel *lessionNameLabel = [[UILabel alloc]init];
    lessionNameLabel.numberOfLines = 2;
    lessionNameLabel.font = [UIFont systemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
    JJFunLessionModel *currentLessionModel = self.model;
    lessionNameLabel.text = currentLessionModel.unit_title;
    lessionNameLabel.textColor = RGBA(0, 125, 172, 1);
    [topView addSubview:lessionNameLabel];
    lessionNameLabel.numberOfLines = 0;
    [lessionNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(5 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(18 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(0);
        make.height.mas_equalTo(40 * KWIDTH_IPHONE6_SCALE);
    }];

    //中部TableView
    self.modulesTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.modulesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.modulesTableView.backgroundColor = [UIColor clearColor];
    [self.modulesTableView registerClass:[JJFunModulCell class] forCellReuseIdentifier:funModulCellIdentifier];
    self.modulesTableView.dataSource = self;
    self.modulesTableView.delegate = self;
    [centerBackView addSubview:self.modulesTableView];
    [self.modulesTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackView);
        make.bottom.with.offset(-60 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(54 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(281 * KWIDTH_IPHONE6_SCALE);
    }];
}


#pragma mark - 模块列表请求
- (void)requestWithModulList {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_CHOOSE_CLASSUNITS];
    NSMutableDictionary *params =[NSMutableDictionary dictionary];
    params[@"unit_id"] = self.model.unit_id;
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
//        NSDictionary *word1 = @{@"audio": @"http://fun.dev.attackt.com/data/upload/unzip/20170104/148351293780641460/sound/Lesson4-2/W05.mp3",
//                                @"word": @"orange",
//                                @"translation": @"橘子"};
//        NSDictionary *word11 = @{@"audio": @"http://fun.dev.attackt.com/data/upload/unzip/20170104/148351293780641460/sound/Lesson4-2/W04.mp3",
//                                 @"word": @"orangee",
//                                 @"translation": @"橘子z"};
//        NSDictionary *word2 = @{@"audio": @"http://asdfadfad.mp3",
//                                @"word": @"orange2",
//                                @"translation": @"橘子2"};
//        NSDictionary *word22 = @{@"audio": @"http://asdfadfad.mp3",
//                                 @"word": @"orangee22",
//                                 @"translation": @"橘子z22"};
//        NSDictionary *m1 = @{ @"plate_id": @"Words1",
//                              @"plate_name": @"Words1",
//                              @"word_list" : @[word1,word11]};
//        NSDictionary *m2 = @{ @"plate_id": @"Words2",
//                              @"plate_name": @"Words22",
//                              @"word_list" : @[word2,word22]
//                              };
//        NSArray *a = @[m1,m2];
        NSArray *modulModelArray = [JJFunModulModel mj_objectArrayWithKeyValuesArray:response[@"plate_list"]];
        NSMutableArray *modulMutableArray = [NSMutableArray array];
        for(JJFunModulModel *model in modulModelArray) {
            if(model.word_list.count != 0) {
                [modulMutableArray addObject:model];
            }
        }
        self.modulModelArray = modulMutableArray;
        [self.modulesTableView reloadData];
        
    } fail:^(NSError *error) {
        
        
        [JJHud showToast:@"加载失败"];
    }];
}


#pragma mark - UITableViewDataSource & UITableVIewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modulModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJFunModulCell *cell = [tableView dequeueReusableCellWithIdentifier:funModulCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JJFunModulModel *model =self.modulModelArray[indexPath.section];
    cell.model = model;
   [cell createBordersWithColor:RGBA(55, 201, 227, 1) withCornerRadius:6 andWidth:2];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 * KWIDTH_IPHONE6_SCALE;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 39 * KWIDTH_IPHONE6_SCALE;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *a = @[@"",@"2"];
    NSArray *aa = a;
    DebugLog(@"%p  %p",a,aa);
    
    JJFunReadLessionWordViewController *readWordVC = [[JJFunReadLessionWordViewController alloc]init];
    readWordVC.modulModel = self.modulModelArray[indexPath.section] ;
    for(JJWordModel *model in readWordVC.modulModel.word_list) {
        model.isPlay = NO;
        model.isDisplayChinese = NO;
    }
//    readWordVC.modulModel.word_list = [readWordVC.modulModel.word_list mutableCopy];
//    readWordVC.lessionModelArray = self.lessionModelArray;
//    readWordVC.currentLessionIndex = indexPath.section;
    readWordVC.bookModel = self.bookModel;
    [self.navigationController pushViewController:readWordVC animated:YES];
}
@end
