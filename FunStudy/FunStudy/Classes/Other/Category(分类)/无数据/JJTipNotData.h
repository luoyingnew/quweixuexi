//
//  JJTipNotData.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/15.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJTipNotData : UIView

@property (nonatomic, strong) UIImageView *noInternetImageView;
@property (nonatomic, strong) UILabel *tipLabel;
+ (instancetype)tipTryOnceView;

@end
