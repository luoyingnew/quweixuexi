//
//  JJFollowReadCell.h
//  FunStudy
//
//  Created by hao on 16/11/24.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJFollowReadModel.h"
#import "JJListenTestView.h"
#import "JJProgressView.h"

@interface JJFollowReadCell : UICollectionViewCell

@property (nonatomic, strong) JJProgressView *progressView; // 进度条
@property (nonatomic, strong) JJFollowReadModel *model;

@property (nonatomic, copy) ListenBtnClickBlock block;

//喇叭
@property (nonatomic, strong) UIButton *playButton;

//请朗读/请跟读
@property (nonatomic, strong) UILabel *readLabel;

@end
