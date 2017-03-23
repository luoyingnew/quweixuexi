//
//  DatePickerView.m
//  TestAttacktPro
//
//  Created by attackt on 16/8/17.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import "DatePickerView.h"
#define PICKER_VIEW_HEIGHT      260 * KHEIGHT_IPHONE6_SCALE
#define PICKER_TOP_OFFSET       50 * KHEIGHT_IPHONE6_SCALE
#define TOOLBAR_HEIGHT          44 
#define ANIMATION_DUING         0.25
@interface DatePickerView ()
@property (nonatomic, strong) UIView *basePickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, assign) BOOL isShowing;
@end

@implementation DatePickerView

#pragma mark Public Method
- (id)init {
   self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self creatViews];
    }
    return self;
}


- (void)showInView:(UIView *)view {
    _isShowing = !_isShowing;
    [view addSubview:self];
    [self datePickerShowOrHidden:_isShowing];
}


#pragma mark Priviate Method
- (void)datePickerShowOrHidden:(BOOL)flag {
    if (flag) { // 开始显示
        [UIView animateWithDuration:ANIMATION_DUING animations:^{
            _basePickerView.frame = CGRectMake(0, SCREEN_HEIGHT - PICKER_VIEW_HEIGHT, SCREEN_WIDTH, PICKER_VIEW_HEIGHT);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        } completion:^(BOOL finished) {
            
        }];

    } else { // 开始收回去
        [UIView animateWithDuration:ANIMATION_DUING animations:^{
            _basePickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, PICKER_VIEW_HEIGHT);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];

    }
}

//界面的初始化
- (void)creatViews {
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    _basePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, PICKER_VIEW_HEIGHT)];
    _basePickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_basePickerView];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, PICKER_TOP_OFFSET, SCREEN_WIDTH, PICKER_VIEW_HEIGHT - PICKER_TOP_OFFSET)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"]; //设置日期格式
    NSDate *defaultDate = [dateFormatter dateFromString:@"1990-08-01"];//设置当前显示的默认日期
    NSDate *minDate = [dateFormatter dateFromString:@"1915-01-01"]; //设置显示最小日期
    NSDate *maxDate = [NSDate date]; //设置显示的最大日期
    
    _datePicker.minimumDate = minDate;
    _datePicker.maximumDate = maxDate;
    _datePicker.date = defaultDate;
    
    _datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_basePickerView addSubview:_datePicker];
    
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    weakSelf(weakSelf);
    [self whenTapped:^{
        [weakSelf datePickerShowOrHidden:NO];
    }];
    toolBar.items = [NSArray arrayWithObjects:cancelButton,space,doneButton, nil];
    [_basePickerView addSubview:toolBar];
}


#pragma mark event Responses

// 点击完成
- (void)doneAction {
    if (self.selectBlock) {
        self.selectBlock(_datePicker.date);
    }
    [self datePickerShowOrHidden:NO];
}

//点击取消
- (void)cancelAction {
    [self datePickerShowOrHidden:NO];
}




@end
