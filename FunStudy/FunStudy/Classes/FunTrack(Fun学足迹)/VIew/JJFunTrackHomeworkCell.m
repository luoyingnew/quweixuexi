////
////  JJFunTrackHomeworkCell.m
////  FunStudy
////
////  Created by 唐天成 on 2016/11/15.
////  Copyright © 2016年 唐天成. All rights reserved.
////
//
//#import "JJFunTrackHomeworkCell.h"
//
//@interface JJFunTrackHomeworkCell ()
//
//@end
//
//@implementation JJFunTrackHomeworkCell
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor clearColor];
//        //topView
//        UIView *topView = [[UIView alloc]init];
//        [topView createBordersWithColor:RGBA(0, 202, 240, 1) withCornerRadius:10* KWIDTH_IPHONE6_SCALE andWidth:2];
//        topView.backgroundColor = NORMAL_COLOR;
//        [self.contentView addSubview:topView];
//        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.with.offset(10 * KWIDTH_IPHONE6_SCALE);
//            make.centerX.equalTo(self.contentView);
//            make.width.mas_equalTo(291 * KWIDTH_IPHONE6_SCALE);
//            make.height.mas_equalTo(95 * KWIDTH_IPHONE6_SCALE);
//        }];
//        //补做|查看Button
//        UIButton *topBtn = [[UIButton alloc]init];
//        [topBtn addTarget:self action:@selector(redoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [topBtn.titleLabel setFont:[UIFont systemFontOfSize:14 * KWIDTH_IPHONE6_SCALE]];
//        [topView addSubview:topBtn];
//        [topBtn setBackgroundColor:RGBA(254, 92, 48, 1)];
//        [topBtn createBordersWithColor:RGBA(86, 142, 146, 1) withCornerRadius:4 andWidth:1];
//        [topBtn setTitle:@"补做" forState:UIControlStateNormal];
//        [topBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(topView);
//            make.right.with.offset(-11 * KWIDTH_IPHONE6_SCALE);
//            make.width.mas_equalTo(44 * KWIDTH_IPHONE6_SCALE);
//            make.height.mas_equalTo(25 * KWIDTH_IPHONE6_SCALE);
//        }];
//        //学科:英语Lable
//        UILabel *courseLabel = [[UILabel alloc]init];
//        [topView addSubview:courseLabel];
////        courseLabel.backgroundColor = [UIColor redColor];
//        courseLabel.text = @"学科:英语";
//        courseLabel.textColor = RGBA(0, 51, 152, 1);
//        [courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.with.offset(22 * KWIDTH_IPHONE6_SCALE);
//            make.top.with.offset(9 * KWIDTH_IPHONE6_SCALE);
//            make.right.equalTo(self.mas_right);
//        }];
//        //打分Label
//        UILabel *scoreLabel = [[UILabel alloc]init];
//        [topView addSubview:scoreLabel];
//        scoreLabel.font = [UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE];
////        scoreLabel.backgroundColor = [UIColor redColor];
//        scoreLabel.text = @"未打分";
//        scoreLabel.textColor = [UIColor whiteColor];//RGBA(0, 51, 152, 1);
//        [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.with.offset(22 * KWIDTH_IPHONE6_SCALE);
//            make.bottom.with.offset(-14 * KWIDTH_IPHONE6_SCALE);
//            make.right.equalTo(self.mas_right);
//        }];
//        //结束时间Lable
//        UILabel *overTimeLabel = [[UILabel alloc]init];
//        overTimeLabel.font = [UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE];
////        overTimeLabel.backgroundColor = [UIColor redColor];
//        [topView addSubview:overTimeLabel];
//        overTimeLabel.text = @"结束时间: 09月09日 23:00";
//        overTimeLabel.textColor = [UIColor whiteColor];//RGBA(0, 51, 152, 1);
//        [overTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.with.offset(22 * KWIDTH_IPHONE6_SCALE);
//            make.top.equalTo(courseLabel.mas_bottom).with.offset(7 * KWIDTH_IPHONE6_SCALE);
//            make.right.equalTo(topBtn.mas_left);
//        }];
//
//        
//
//        
//        //bottomView
//        UIView *bottomView = [[UIView alloc]init];
//        [bottomView createBordersWithColor:RGBA(0, 202, 240, 1) withCornerRadius:10* KWIDTH_IPHONE6_SCALE andWidth:2 * KWIDTH_IPHONE6_SCALE];
//        bottomView.backgroundColor = NORMAL_COLOR;
//        [self.contentView addSubview:bottomView];
//        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(topView.mas_bottom).with.offset(18 * KWIDTH_IPHONE6_SCALE);
//            make.centerX.equalTo(self.contentView);
//            make.width.mas_equalTo(291 * KWIDTH_IPHONE6_SCALE);
//            make.height.mas_equalTo(95 * KWIDTH_IPHONE6_SCALE);
//        }];
//        //补做|查看Button
//        UIButton *bottomBtn = [[UIButton alloc]init];
//        [bottomBtn addTarget:self action:@selector(checkCommandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:14 * KWIDTH_IPHONE6_SCALE]];
//        [bottomView addSubview:bottomBtn];
//        [bottomBtn setBackgroundColor:RGBA(254, 92, 48, 1)];
//        [bottomBtn createBordersWithColor:RGBA(86, 142, 146, 1) withCornerRadius:4 * KWIDTH_IPHONE6_SCALE andWidth:1 * KWIDTH_IPHONE6_SCALE];
//        [bottomBtn setTitle:@"查看分数评语" forState:UIControlStateNormal];
//        [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(bottomView);
//            make.right.with.offset(-3 * KWIDTH_IPHONE6_SCALE);
//            make.width.mas_equalTo(93 * KWIDTH_IPHONE6_SCALE);
//            make.height.mas_equalTo(25 * KWIDTH_IPHONE6_SCALE);
//        }];
//        //我的分数评语Lable
//        UILabel *evaluateLabel = [[UILabel alloc]init];
//        [bottomView addSubview:evaluateLabel];
//        //        courseLabel.backgroundColor = [UIColor redColor];
//        evaluateLabel.text = @"我的分数评语";
//        evaluateLabel.textColor = RGBA(0, 51, 152, 1);
//        [evaluateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(bottomView);
//            make.left.with.offset(22 * KWIDTH_IPHONE6_SCALE);
//            make.right.equalTo(bottomBtn.mas_left);
//        }];
//    }
//    return self;
//}
//
////补做按钮点击
//- (void)redoBtnClick:(UIButton *)btn {
//    if(self.redoBlock) {
//        self.redoBlock();
//    }
//}
////查看分数评语按钮点击
//- (void)checkCommandBtnClick:(UIButton *)btn {
//    if(self.checkCommandBlock) {
//        self.checkCommandBlock();
//    }
//}
//
//@end
