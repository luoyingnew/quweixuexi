//
//  DatePickerView.h
//  TestAttacktPro
//
//  Created by attackt on 16/8/17.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectBlock) (NSDate *selectedDate);
@interface DatePickerView : UIView
@property (nonatomic, copy)SelectBlock selectBlock;

- (id)init;
- (void)showInView:(UIView *)view;
@end
