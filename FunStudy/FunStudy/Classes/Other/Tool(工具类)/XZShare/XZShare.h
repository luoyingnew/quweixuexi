//
//  XZShare.h
//  NotAloneInTheDark
//
//  Created by hao on 2017/1/2.
//  Copyright © 2017年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FinishedBlock)();

@interface XZShare : UIView

@property (nonatomic, copy) FinishedBlock showBlk;
@property (nonatomic, copy) FinishedBlock hideBlk;

+ (instancetype)sharedInstance;
+ (instancetype)sharedHorzInstance;
- (void)shareWithTitle:(NSString *)title images:(NSArray *)images content:(NSString *)content url:(NSString *)url;
@end
