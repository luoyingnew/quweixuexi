//
//  JJFunTrackHomeworkCell.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/15.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJFunTrackTestCell.h"
#import "NSString+XPKit.h"

@interface JJFunTrackTestCell ()
@property (nonatomic, strong)UILabel *courseLabel;
@property (nonatomic, strong)UILabel *scoreLabel;
@property (nonatomic, strong)UIButton *topBtn;
@property (nonatomic, strong)UIButton *evalucateBtn;
@property (nonatomic, strong)UIButton *continueDoHomeworkBtn;

@property (nonatomic, strong)UILabel *overTimeLabel;
@end

@implementation JJFunTrackTestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        //topView
        UIView *topView = [[UIView alloc]init];
        [topView createBordersWithColor:RGBA(0, 202, 240, 1) withCornerRadius:10* KWIDTH_IPHONE6_SCALE andWidth:2 * KWIDTH_IPHONE6_SCALE];
        topView.backgroundColor = NORMAL_COLOR;
        [self.contentView addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(10 * KWIDTH_IPHONE6_SCALE);
            make.centerX.equalTo(self.contentView);
            make.width.mas_equalTo(291 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(95 * KWIDTH_IPHONE6_SCALE);
        }];
        //学科:英语Lable
        UILabel *courseLabel = [[UILabel alloc]init];
        self.courseLabel = courseLabel;
        [topView addSubview:courseLabel];
        //        courseLabel.backgroundColor = [UIColor redColor];
        courseLabel.text = @"";
        courseLabel.textColor = RGBA(0, 51, 152, 1);
        [courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(22 * KWIDTH_IPHONE6_SCALE);
            make.top.with.offset(9 * KWIDTH_IPHONE6_SCALE);
            make.right.equalTo(self.mas_right);
        }];
        //打分Label
        UILabel *scoreLabel = [[UILabel alloc]init];
        self.scoreLabel = scoreLabel;
        [topView addSubview:scoreLabel];
        self.scoreLabel.text = @"未打分";
//        self.scoreLabel.backgroundColor = [UIColor redColor];
        scoreLabel.font = [UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE];
        //        scoreLabel.backgroundColor = [UIColor redColor];
        scoreLabel.textColor = [UIColor whiteColor];//RGBA(0, 51, 152, 1);
        [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(22 * KWIDTH_IPHONE6_SCALE);
            make.bottom.with.offset(-14 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(15 * KWIDTH_IPHONE6_SCALE);
        }];
        
        //结束时间Lable
        UILabel *overTimeLabel = [[UILabel alloc]init];
        overTimeLabel.font = [UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE];
        //        overTimeLabel.backgroundColor = [UIColor redColor];
        [topView addSubview:overTimeLabel];
        overTimeLabel.text = @"";
        self.overTimeLabel = overTimeLabel;
        overTimeLabel.textColor = [UIColor whiteColor];//RGBA(0, 51, 152, 1);
        [overTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(22 * KWIDTH_IPHONE6_SCALE);
            make.top.equalTo(courseLabel.mas_bottom).with.offset(7 * KWIDTH_IPHONE6_SCALE);
            //            make.right.equalTo(topBtn.mas_left);
        }];
        
        //查看Button
        UIButton *topBtn = [[UIButton alloc]init];
        self.topBtn = topBtn;
        [topBtn addTarget:self action:@selector(checkLookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topBtn.titleLabel setFont:[UIFont systemFontOfSize:14 * KWIDTH_IPHONE6_SCALE]];
        [topView addSubview:topBtn];
        [topBtn setBackgroundColor:RGBA(254, 92, 48, 1)];
        [topBtn createBordersWithColor:RGBA(86, 142, 146, 1) withCornerRadius:4*KWIDTH_IPHONE6_SCALE andWidth:1 * KWIDTH_IPHONE6_SCALE];
        [topBtn setTitle:@"查看" forState:UIControlStateNormal];
        [topBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(overTimeLabel);
            make.right.with.offset(-11 * KWIDTH_IPHONE6_SCALE);
            make.width.mas_equalTo(44 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(25 * KWIDTH_IPHONE6_SCALE);
        }];
        //补做Btn
        UIButton *continueDoHomeworkBtn = [[UIButton alloc]init];
        self.continueDoHomeworkBtn = continueDoHomeworkBtn;
        [continueDoHomeworkBtn addTarget:self action:@selector(continueDoHomeworkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [continueDoHomeworkBtn.titleLabel setFont:[UIFont systemFontOfSize:14 * KWIDTH_IPHONE6_SCALE]];
        [topView addSubview:continueDoHomeworkBtn];
        [continueDoHomeworkBtn setBackgroundColor:RGBA(254, 92, 48, 1)];
        [continueDoHomeworkBtn createBordersWithColor:RGBA(86, 142, 146, 1) withCornerRadius:4*KWIDTH_IPHONE6_SCALE andWidth:1 * KWIDTH_IPHONE6_SCALE];
        [continueDoHomeworkBtn setTitle:@"补做" forState:UIControlStateNormal];
        [continueDoHomeworkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [continueDoHomeworkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(overTimeLabel);
            make.right.with.offset(-11 * KWIDTH_IPHONE6_SCALE);
            make.width.mas_equalTo(44 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(25 * KWIDTH_IPHONE6_SCALE);
        }];

        
        //查看分数评语button
        UIButton *evalucateBtn = [[UIButton alloc]init];
        self.evalucateBtn = evalucateBtn;
        [evalucateBtn addTarget:self action:@selector(checkCommandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [evalucateBtn.titleLabel setFont:[UIFont systemFontOfSize:14 * KWIDTH_IPHONE6_SCALE]];
        [topView addSubview:evalucateBtn];
        [evalucateBtn setBackgroundColor:RGBA(254, 92, 48, 1)];
        [evalucateBtn createBordersWithColor:RGBA(86, 142, 146, 1) withCornerRadius:4*KWIDTH_IPHONE6_SCALE andWidth:1 * KWIDTH_IPHONE6_SCALE];
        [evalucateBtn setTitle:@"分数评语" forState:UIControlStateNormal];
        [evalucateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [evalucateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(scoreLabel);
            make.right.with.offset(-11 * KWIDTH_IPHONE6_SCALE);
            make.width.mas_equalTo(88 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(25 * KWIDTH_IPHONE6_SCALE);
        }];

//        //bottomView
//        UIView *bottomView = [[UIView alloc]init];
//        [bottomView createBordersWithColor:RGBA(0, 202, 240, 1) withCornerRadius:10* KWIDTH_IPHONE6_SCALE andWidth:2*KWIDTH_IPHONE6_SCALE];
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
//        [bottomBtn createBordersWithColor:RGBA(86, 142, 146, 1) withCornerRadius:4*KWIDTH_IPHONE6_SCALE andWidth:1*KWIDTH_IPHONE6_SCALE];
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
    }
    return self;
}
//查看按钮点击
- (void)checkLookBtnClick:(UIButton *)btn {
    if(self.checkLookBlock) {
        self.checkLookBlock();
    }
}
//查看分数评语按钮点击
- (void)checkCommandBtnClick:(UIButton *)btn {
    if(self.checkCommandBlock) {
        self.checkCommandBlock();
    }
}
//补做题按钮点击
- (void)continueDoHomeworkBtnClick:(UIButton *)btn {
    NSString *typeName = nil;
    NSString *homeworkTitle = self.funTrackModel.title;
    NSString *homeworkID = self.funTrackModel.homework_exam_id;
    if(self.funTrackModel.eh_type == 1) {
        typeName = @"最新作业";
    } else {
        typeName = @"最新测验";
    }
    
    if(self.continueDoHomeworkBlock) {
        self.continueDoHomeworkBlock(typeName,homeworkTitle,homeworkID);
    }
}

- (void)setFunTrackModel:(JJFunTrackModel *)funTrackModel {
    _funTrackModel = funTrackModel;
    self.courseLabel.text = [NSString stringWithFormat:@"%@",funTrackModel.title];
    self.overTimeLabel.text = [NSString stringWithFormat:@"结束时间 :%@",[funTrackModel.endtime stringChangeToDate:@"MM月dd日 HH:mm"]];
    if(funTrackModel.status == 1) {
        //未打分
        self.topBtn.hidden = YES;
        self.evalucateBtn.hidden = YES;
        self.continueDoHomeworkBtn.hidden = YES;
        self.scoreLabel.text = @"等待老师打分";
        self.scoreLabel.font = [UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE];
        self.scoreLabel.textColor = [UIColor whiteColor];
    } else if(funTrackModel.status == 2){
        //已打分
        self.topBtn.hidden = NO;
        self.evalucateBtn.hidden = NO;
        self.continueDoHomeworkBtn.hidden = YES;
        self.scoreLabel.text =[NSString stringWithFormat:@"%@分",funTrackModel.score] ;
        self.scoreLabel.font = [UIFont systemFontOfSize:17 * KWIDTH_IPHONE6_SCALE];
        //        scoreLabel.backgroundColor = [UIColor redColor];
        self.scoreLabel.textColor = [UIColor redColor];
        
    } else {
        //未完成的作业
        self.topBtn.hidden = YES;
        self.evalucateBtn.hidden = YES;
        self.continueDoHomeworkBtn.hidden = NO;
        self.scoreLabel.text = @"尚未完成";
        self.scoreLabel.font = [UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE];
        self.scoreLabel.textColor = [UIColor whiteColor];
    }
}

@end
