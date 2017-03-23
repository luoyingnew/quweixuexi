//
//  JJFunClassRoomViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJFunClassRoomViewController.h"
#import "JJChangeBookViewController.h"
#import "JJFunLessionCell.h"
#import "JJFunReadLessionWordViewController.h"
#import "JJFunLessionModel.h"
#import "JJHomeworkListViewController.h"
#import "JJFunModulesViewController.h"
#import "JJAgreementViewController.h"
#import "JJIsSelfStudyTopicViewController.h"
#import "JJPlateViewController.h"
#import "JJIsSelfPlateViewController.h"

@interface JJFunClassRoomViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *lessionTableView;

@property (nonatomic, strong) NSArray<JJFunLessionModel *> *lessionModelArray;

//书本图片
@property (nonatomic, strong)UIImageView *bookImageView;
//书本名称描述
@property (nonatomic, strong)UILabel *bookNameLabel;
//书本id
@property (nonatomic, strong) NSString *bookID;

//@property (nonatomic, strong) UILabel *l;
//@property(nonatomic,assign)NSInteger i;
//@property (nonatomic, strong) AFHTTPSessionManager *manager;


@end

static NSString *funLessionCellIdentifier = @"JJFunLessionCellIdentifier";

@implementation JJFunClassRoomViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUpBaseView];
    [self setUpCenter];
    [self requestWithChooseClassBook];
//    DebugLog(@"%ld",self.automaticallyAdjustsScrollViewInsets);
//    self.automaticallyAdjustsScrollViewInsets = NO;
   
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    if(self.isSelfStudy) {
        //如果是自学用户
        self.titleName = @"自学中心";
    } else {
        //非自学用户
        self.titleName = @"Fun课堂";
    }
    
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    //    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
}

//设置中间视图
- (void)setUpCenter {
    //中部大背景
    UIImageView *centerBackView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FunClassRoomBack"]];
    [self.view addSubview:centerBackView];
    centerBackView.userInteractionEnabled = YES;
    [centerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(125 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(330 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(389 * KWIDTH_IPHONE6_SCALE);
    }];

    //中部topview
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor clearColor];
    [centerBackView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(centerBackView);
        make.height.mas_equalTo(104 * KWIDTH_IPHONE6_SCALE);
    }];
    //书本图片
    UIImageView *bookImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.bookImageView = bookImageView;
    [topView addSubview:bookImageView];
    [bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.with.offset(24 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(57 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(82 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //换课本按钮
    UIButton *changeBookBtn = [[UIButton alloc]init];
    changeBookBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
    [changeBookBtn addTarget:self action:@selector(changeBookClick) forControlEvents:UIControlEventTouchUpInside];
    [changeBookBtn setBackgroundImage:[UIImage imageNamed:@"getAwardBtn"] forState:UIControlStateNormal];
    [changeBookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeBookBtn setTitle:@"换课本" forState:UIControlStateNormal];
    [topView addSubview:changeBookBtn];
    [changeBookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bookImageView.mas_right).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.bottom.with.offset(-9 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(59 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(28 * KWIDTH_IPHONE6_SCALE);
    }];
    //视频课程按钮
    UIButton *videoBtn = [[UIButton alloc]init];
    videoBtn.hidden = YES;
    [videoBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [videoBtn setBackgroundImage:[UIImage imageNamed:@"FunClassRoomVideoBtn"] forState:UIControlStateNormal];
    [videoBtn setTitle:@"视频课程" forState:UIControlStateNormal];
    [videoBtn setTitleColor:RGBA(160, 0, 0, 1) forState:UIControlStateNormal];
    [topView addSubview:videoBtn];
    [videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.with.offset(-20 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(34 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(73 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(33 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //书本名称描述
    UILabel *bookNameLabel = [[UILabel alloc]init];
    self.bookNameLabel = bookNameLabel;
    bookNameLabel.font = [UIFont systemFontOfSize:13 * KWIDTH_IPHONE6_SCALE];
    bookNameLabel.text = @"";
    bookNameLabel.textColor = RGBA(0, 40, 100, 1);
    [topView addSubview:bookNameLabel];
    bookNameLabel.numberOfLines = 0;
    [bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(24 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(bookImageView.mas_right).with.offset(8 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(videoBtn.mas_left).with.offset(-3 * KWIDTH_IPHONE6_SCALE);
    }];
    
    
    //底部TableView
    self.lessionTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.lessionTableView.backgroundColor = [UIColor clearColor];
    [self.lessionTableView registerClass:[JJFunLessionCell class] forCellReuseIdentifier:funLessionCellIdentifier];
    self.lessionTableView.dataSource = self;
    self.lessionTableView.delegate = self;
    [centerBackView addSubview:self.lessionTableView];
    [self.lessionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackView);
        make.bottom.with.offset(-29 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(113 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(257 * KWIDTH_IPHONE6_SCALE);
    }];
}

//换课本
- (void)changeBookClick {
    JJChangeBookViewController *changeBookVC = [[JJChangeBookViewController alloc]init];
    changeBookVC.isSelfStudy = self.isSelfStudy;
    weakSelf(weakSelf);
    changeBookVC.block = ^(JJBookModel *bookModel){
        weakSelf.currentBookModel = bookModel;
    };
    [self.navigationController pushViewController:changeBookVC  animated:YES];
}

#pragma mark - 选择教材请求
- (void)requestWithChooseClassBook {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_CHOOSE_CLASSBOOK];
    NSMutableDictionary *params =[NSMutableDictionary dictionary];
    if(self.currentBookModel) {
        params[@"book_id"] = self.currentBookModel.book_id;
        
    }
    params[@"fun_user_id"] = [User getUserInformation].fun_user_id;
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

        
        NSArray<JJFunLessionModel *> *lessionmodulArray = [JJFunLessionModel mj_objectArrayWithKeyValuesArray:response[@"unit_list"]];
        NSMutableArray<JJFunLessionModel *> *lessionModulMutableArray = [NSMutableArray array];
        if(self.isSelfStudy) {
            //如果是点击自学用户跳转的
            for(JJFunLessionModel *model in lessionmodulArray) {
                if(model.is_homework) {
                    //is_HomeworkID表示是否有作业 && is_done表示该作业是否已经做过
                    [lessionModulMutableArray addObject:model];
                }
            }
            self.lessionModelArray = lessionModulMutableArray;
            
        } else {
            for(JJFunLessionModel *model in lessionmodulArray) {
                if(model.has_words == YES) {
                    [lessionModulMutableArray addObject:model];
                }
            }
            self.lessionModelArray = lessionModulMutableArray;
            
        }
        
        JJBookModel *bookModel = [[JJBookModel alloc]init];
        bookModel.book_title = response[@"book_name"];
        bookModel.book_img = response[@"book_cover"];
        bookModel.book_id = response[@"book_id"];
        [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:bookModel.book_img] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
        self.bookNameLabel.text = bookModel.book_title;
        self.bookID = response[@"book_id"];
        _currentBookModel = bookModel;
        
        for(JJFunLessionModel *model in self.lessionModelArray) {
            model.book_id = _currentBookModel.book_id;
        }
        
        [self.lessionTableView reloadData];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}
#pragma mark - 重写ModelSet方法
- (void)setCurrentBookModel:(JJBookModel *)currentBookModel {
    _currentBookModel = currentBookModel;
    [self requestWithChooseClassBook];
}


#pragma mark - UITableViewDataSource & UITableVIewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.lessionModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJFunLessionCell *cell = [tableView dequeueReusableCellWithIdentifier:funLessionCellIdentifier forIndexPath:indexPath];
    cell.model = self.lessionModelArray[indexPath.section];
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
    if(self.isSelfStudy) {
        JJFunLessionModel *lessionModel = self.lessionModelArray[indexPath.section];
        JJBookModel *bookModel = self.currentBookModel;
        //如果是点击自学用户跳转的 1如果是小学跳转到板块列表 2如果是初中跳转到大题列表
//        if(lessionModel.homework_type == 1) {
            //小学   现在只显示小学
            JJIsSelfPlateViewController *plateVC = [[JJIsSelfPlateViewController alloc]init];
            plateVC.name = lessionModel.unit_title;
            plateVC.typeName = @"最新作业";
            plateVC.model = lessionModel;
            [self.navigationController pushViewController:plateVC animated:YES];
//        } else {
//            //初中
//            JJIsSelfStudyTopicViewController *topicVC = [[JJIsSelfStudyTopicViewController alloc]init];
//            topicVC.model = lessionModel;
//            [self.navigationController pushViewController:topicVC animated:YES];
//        }
        
        
    } else {
        JJFunModulesViewController *modulesViewController = [[JJFunModulesViewController alloc]init];
        modulesViewController.model = self.lessionModelArray[indexPath.section];
        modulesViewController.bookModel = self.currentBookModel;
        [self.navigationController pushViewController:modulesViewController animated:YES];
        
//        JJFunReadLessionWordViewController *readWordVC = [[JJFunReadLessionWordViewController alloc]init];
//        readWordVC.lessionModelArray = self.lessionModelArray;
//        readWordVC.currentLessionIndex = indexPath.section;
//        readWordVC.bookModel = self.currentBookModel;
//        [self.navigationController pushViewController:readWordVC animated:YES];
    }
}

- (void)dealloc {
    DebugLog(@"%s",__func__);
}




@end
