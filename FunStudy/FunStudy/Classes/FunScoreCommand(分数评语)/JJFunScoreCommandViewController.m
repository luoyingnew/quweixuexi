//
//  JJFunScoreCommandViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/15.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJFunScoreCommandViewController.h"
#import "JJOverHomeWorkViewController.h"

@interface JJFunScoreCommandViewController ()

@end

@implementation JJFunScoreCommandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    [self setUpCenter];
}

#pragma mark - 基本设置
- (void)setUpBaseView{
        self.titleName = @"分数评语";
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
    UIImageView *centerBackView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FunReadLessionWordBack"]];
    [self.view addSubview:centerBackView];
    centerBackView.userInteractionEnabled = YES;
    [centerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(108 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(330 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(423 * KWIDTH_IPHONE6_SCALE);
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
    lessionNameLabel.font = [UIFont systemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
    lessionNameLabel.text = @"我的分数评语";
    lessionNameLabel.textColor = RGBA(0, 125, 172, 1);
    [topView addSubview:lessionNameLabel];
    lessionNameLabel.numberOfLines = 0;
    [lessionNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(17 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(18 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(topView);
    }];
    
    //中部分数评语ScrollVIew   Label
    UIScrollView *scrollView = [[UIScrollView alloc]init];
//    scrollView.backgroundColor = [UIColor redColor];
    [centerBackView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackView);
        make.bottom.with.offset(-55 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(58 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(281 * KWIDTH_IPHONE6_SCALE);
    }];
    
    UILabel *scoreCommandLabel = [[UILabel alloc]init];
//    scoreCommandLabel.
    scoreCommandLabel.font = [UIFont systemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
       scoreCommandLabel.textColor = RGBA(0, 125, 172, 1);
    scoreCommandLabel.numberOfLines = 0;
    [scrollView addSubview:scoreCommandLabel];

    [scoreCommandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(281 * KWIDTH_IPHONE6_SCALE);
        make.top.left.right.bottom.equalTo(scrollView);
    }];
    scoreCommandLabel.text = self.scoretext;
    
    if(self.scoretext.length == 0) {
        //如果没有分数评语
        UILabel *textLabel = [[UILabel alloc]init];
        textLabel.text = @"暂无评语";
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = RGBA(206, 206, 206, 1);
        textLabel.font = [UIFont boldSystemFontOfSize:30 * KWIDTH_IPHONE6_SCALE];
        textLabel.textAlignment = NSTextAlignmentCenter;
        [centerBackView addSubview:textLabel];
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(centerBackView);
            make.bottom.with.offset(-55 * KWIDTH_IPHONE6_SCALE);
            make.top.with.offset(58 * KWIDTH_IPHONE6_SCALE);
            make.width.mas_equalTo(281 * KWIDTH_IPHONE6_SCALE);
        }];
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    JJOverHomeWorkViewController *ov = [[JJOverHomeWorkViewController alloc]init];
//    weakSelf(weakSelf);
//    ov.overHomeworkBlock = ^{
////        if(weakSelf.refeshHomeworkListBlock) {
////            weakSelf.refeshHomeworkListBlock();
////        }
//        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//    };
////    ov.name = self.name;
////    ov.homework_id = self.model.homework_id;
//    [self presentViewController:ov animated:YES completion:^{
//    }];
//
//}

@end
