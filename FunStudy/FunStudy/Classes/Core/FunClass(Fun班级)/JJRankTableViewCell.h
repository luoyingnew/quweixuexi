//
//  JJRankTableViewCell.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJRankModel.h"

@interface JJRankTableViewCell : UITableViewCell

//第几名图
@property (nonatomic, strong) UIImageView *rankImageView;
//名次
@property (nonatomic, strong) UILabel *rankLabel;

//头像
@property (nonatomic, strong) UIImageView *iconImageView;
//名字
@property (nonatomic, strong) UILabel *nameLabel;
//学号
@property (nonatomic, strong) UILabel *countLabel;
//学币数量
@property (nonatomic, strong) UILabel *coinNumLabel;

@property (nonatomic, strong) JJRankModel *rankModel;


////领取奖励按钮
//@property (nonatomic, strong) UIButton *getAwardBtn;

@end
