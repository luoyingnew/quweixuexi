//
//  JJIssueActionView.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JJIssueActionViewDelegate <NSObject>

//选第几个
- (void)actionViewDidSelectedIndex:(NSInteger)index;

@end

@interface JJIssueActionView : UIView
@property (nonatomic, weak) id<JJIssueActionViewDelegate> delegate;
- (void)actionViewHide;
- (void)actionViewShow;
@end
