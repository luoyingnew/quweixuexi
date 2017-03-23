//
//  JJChangeBookViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJChangeBookViewController.h"
#import "JJFunClassroomCategoryCell.h"
#import "JJFunClassroomBookTableViewCell.h"
//#import "JJCategoryBookModel.h"
#import "JJBookModel.h"
#import "JJFunClassRoomViewController.h"


@interface JJChangeBookViewController ()<UITableViewDelegate,UITableViewDataSource>

//选中书本分类按钮
@property (nonatomic, strong) UIButton *funClassRoomBtn;


//bookTableView
@property (nonatomic, strong) UITableView *bookTableView;

//categoryTableVIew的背景VIew
@property (nonatomic, strong) UIView *categoryBackView;
@property (nonatomic, strong) UITableView *categoryTableView;

//书本模型数组
@property (nonatomic, strong) NSArray<JJBookModel *> *bookModelArray;


//书本分类模型数组
//@property (nonatomic, strong) NSArray<JJCategoryBookModel *> *categoryModelArray;
//当前选中的分类模型
//@property (nonatomic, strong) JJCategoryBookModel *currentSelectedCategotyModel;

@end

static NSString *funClassroomCategoryIdentifier = @"JJFunClassroomCategoryIdentifier";
static NSString *funClassroomBookIdentifier = @"JJFunClassroomBookIdentifier";

@implementation JJChangeBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    [self setUpCenter];
    
    [self requestWithBookList];
//    JJCategoryBookModel *cateBookModel = [[JJCategoryBookModel alloc]init];
//    cateBookModel.name = @"111";
//    JJBookModel *bookModel1= [[JJBookModel alloc]init];
//    bookModel1.name = @"book1";
//    JJBookModel *bookModel2= [[JJBookModel alloc]init];
//    bookModel2.name = @"book11";
//    JJBookModel *bookModel3= [[JJBookModel alloc]init];
//    bookModel3.name = @"book111";
//    cateBookModel.bookModelArray = @[bookModel1,bookModel2,bookModel3];
//    
//    JJCategoryBookModel *cateBookMode2 = [[JJCategoryBookModel alloc]init];
//    cateBookMode2.name = @"222";
//    JJBookModel *bookModel21= [[JJBookModel alloc]init];
//    bookModel21.name = @"book2";
//    JJBookModel *bookModel22= [[JJBookModel alloc]init];
//    bookModel22.name = @"book11";
//    JJBookModel *bookModel23= [[JJBookModel alloc]init];
//    bookModel23.name = @"book111";
//    cateBookMode2.bookModelArray = @[bookModel21,bookModel22,bookModel23];
//    self.categoryModelArray = @[cateBookModel,cateBookMode2];
    
//    if(self.categoryModelArray.count) {
//        self.currentSelectedCategotyModel = self.categoryModelArray[0];
//        [self.funClassRoomBtn setTitle:self.currentSelectedCategotyModel.name forState:UIControlStateNormal];
//    }
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
    UIView *centerBackView = [[UIView alloc]init];
    [self.view addSubview:centerBackView];
    [centerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(125 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(330 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(388 * KWIDTH_IPHONE6_SCALE);
    }];
    centerBackView.backgroundColor = RGBA(126, 251, 252, 1);
    //    centerBackView.userInteractionEnabled = YES;
    [centerBackView createBordersWithColor:RGBA(0, 164, 197, 1) withCornerRadius:10*KWIDTH_IPHONE6_SCALE andWidth:4*KWIDTH_IPHONE6_SCALE];
    
    //头部点击按钮
    UIButton *funClassRoomBtn = [[UIButton alloc]init];
    funClassRoomBtn.hidden = YES;
    self.funClassRoomBtn = funClassRoomBtn;
    [funClassRoomBtn addTarget:self action:@selector(openOrCloseCategory:) forControlEvents:UIControlEventTouchUpInside];
    [funClassRoomBtn setBackgroundImage:[UIImage imageNamed:@"FunClassRoomBtnBack"] forState:UIControlStateNormal];
    [funClassRoomBtn setTitle:@"现代概念英语.XX版" forState:UIControlStateNormal];
    [centerBackView addSubview:funClassRoomBtn];
    [funClassRoomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(18 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(centerBackView);
        make.width.mas_equalTo(265 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(28 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //Book  TableView
    UITableView *bookTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.bookTableView = bookTableView;
    self.bookTableView.backgroundColor = [UIColor clearColor];
    bookTableView.dataSource = self;
    bookTableView.delegate = self;
    [bookTableView registerClass:[JJFunClassroomBookTableViewCell class] forCellReuseIdentifier:funClassroomBookIdentifier];
    [centerBackView addSubview:bookTableView];
    [bookTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackView);
        make.top.equalTo(funClassRoomBtn.mas_bottom);
        make.width.mas_equalTo(275 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(314 * KWIDTH_IPHONE6_SCALE);
    }];
    
//    //CategoryTableVIew
//    UIView *categoryBackView = [[UIView alloc]init];
//    self.categoryBackView = categoryBackView;
//    categoryBackView.backgroundColor = [UIColor whiteColor];
//    [centerBackView addSubview:categoryBackView];
//    [categoryBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(centerBackView);
//        make.top.equalTo(funClassRoomBtn.mas_bottom).with.offset(4 * KWIDTH_IPHONE6_SCALE);
//        make.width.mas_equalTo(235 * KWIDTH_IPHONE6_SCALE);
//        make.height.mas_equalTo(0 * KWIDTH_IPHONE6_SCALE);
//    }];
//    [categoryBackView createBordersWithColor:RGBA(72, 182, 242, 1) withCornerRadius:8 andWidth:4 ];
//    
//    
//    self.categoryTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    [self.categoryTableView registerClass:[JJFunClassroomCategoryCell class] forCellReuseIdentifier:funClassroomCategoryIdentifier];
//    [categoryBackView addSubview:self.categoryTableView];
//    self.categoryTableView.dataSource = self;
//    self.categoryTableView.delegate = self;
//    [self.categoryTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(centerBackView);
//        make.top.equalTo(categoryBackView);
//        make.width.mas_equalTo(215 * KWIDTH_IPHONE6_SCALE);
//        //        make.bottom.equalTo(categoryBackView);
//        make.height.mas_equalTo(203 * KWIDTH_IPHONE6_SCALE);
//    }];
//    //    self.categoryBackView.layer.anchorPoint = CGPointMake(0.5, 0.5);
//    self.categoryTableView.backgroundColor = [UIColor whiteColor];
    
    //    self.categoryBackView.height = 0; //transform = CGAffineTransformMakeScale(0.01, 0.01);
    //    [self.categoryTableView createBordersWithColor:RGBA(72, 182, 242, 1) withCornerRadius:8 andWidth:4 ];
}


#pragma mark - 书本列表请求 
- (void)requestWithBookList {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_GET_CLASSBOOKS];
    [JJHud showStatus:nil];
    [HFNetWork getWithURL:URL params:nil isCache:NO success:^(id response) {
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
        
        NSArray<JJBookModel *> *bookModelArray = [JJBookModel mj_objectArrayWithKeyValuesArray:response[@"books_list"]];
        if(self.isSelfStudy) {
            //自学用户,把初中教材去掉
            NSMutableArray *bookMutableArray = [NSMutableArray array];
            for(JJBookModel *model in bookModelArray) {
                if(model.book_type == 1) {
                    [bookMutableArray addObject:model];
                }
            }
            self.bookModelArray = bookMutableArray;
        } else {
            
            //非自学用户
            //有随身听才显示
            NSMutableArray *bookMutableArray = [NSMutableArray array];
            for(JJBookModel *model in bookModelArray) {
                if(model.is_listen == 1) {
                    [bookMutableArray addObject:model];
                }
            }
            self.bookModelArray = bookMutableArray;
        }
        
        [self.bookTableView reloadData];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];

}

//#pragma mark - 打开或者关闭书本
//- (void)openOrCloseCategory:(UIButton *)btn {
//    if(btn.selected == NO) {
//        //未选中状态时要打开书本分类
//        [UIView animateWithDuration:0.5 animations:^{
//            self.categoryTableView.superview.height = 203 * KWIDTH_IPHONE6_SCALE;//.transform = CGAffineTransformIdentity;
//        }];
//    } else {
//        //选中状态时要关系书本分类
//        [UIView animateWithDuration:0.5 animations:^{
//            self.categoryTableView.superview.height = 0.0;//.transform = CGAffineTransformMakeScale(0.01, 0.01);
//        }];
//    }
//    
//    btn.selected = !btn.selected;
//}


#pragma mark - UItableViewDataSource&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if(tableView == self.categoryTableView) {
//        return self.categoryModelArray.count;
//    }else {
//        return self.currentSelectedCategotyModel.bookModelArray.count;
//    }
    
    return self.bookModelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(tableView == self.bookTableView) {
//        JJFunClassroomBookTableViewCell *bookCell = [tableView dequeueReusableCellWithIdentifier:funClassroomBookIdentifier forIndexPath:indexPath];
//        [bookCell createBordersWithColor:[UIColor clearColor] withCornerRadius:8 andWidth:0];
//        bookCell.model = self.currentSelectedCategotyModel.bookModelArray[indexPath.section];
//        return bookCell;
//        
//    } else {
//        JJFunClassroomCategoryCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:funClassroomCategoryIdentifier forIndexPath:indexPath ];
//        categoryCell.model = self.categoryModelArray[indexPath.section];
//        return categoryCell;
//    }
    
    JJFunClassroomBookTableViewCell *bookCell = [tableView dequeueReusableCellWithIdentifier:funClassroomBookIdentifier forIndexPath:indexPath];
            [bookCell createBordersWithColor:[UIColor clearColor] withCornerRadius:8 andWidth:0];
    bookCell.model = self.bookModelArray[indexPath.section];
    return bookCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == self.bookTableView) {
//        return 92 * KWIDTH_IPHONE6_SCALE;
//    } else {
//        return 22 * KWIDTH_IPHONE6_SCALE;
//    }
    return 92 * KWIDTH_IPHONE6_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if(tableView == self.bookTableView) {
//        return 11 * KWIDTH_IPHONE6_SCALE;
//    } else {
//        return 6 * KWIDTH_IPHONE6_SCALE;
//    }
    return 11 * KWIDTH_IPHONE6_SCALE;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == self.categoryTableView) {
//        //若选中的是分类tableView
//        self.currentSelectedCategotyModel.isSelected = NO;
//        JJCategoryBookModel *categoryBookModel = self.categoryModelArray[indexPath.section];
//        categoryBookModel.isSelected = YES;
//        self.currentSelectedCategotyModel = categoryBookModel;
//        [self.funClassRoomBtn setTitle:self.currentSelectedCategotyModel.name forState:UIControlStateNormal];
//        [self.bookTableView reloadData];
//        [self openOrCloseCategory:self.funClassRoomBtn];
//    } else {
//        //若选中的是booktableVIew
//    }
    if(self.block) {
        self.block(self.bookModelArray[indexPath.section]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc {
    DebugLog(@"f");
}

@end
