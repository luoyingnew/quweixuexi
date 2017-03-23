//
//  JJCityPickerView.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//
/*
#import "JJCityPickerView.h"
#import "JJCity.h"
#import "HXAddressManager.h"

#define SHAddressPickerViewHeight 216

@interface JJCityPickerView () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *headView;
@property (strong, nonatomic) UIPickerView *pickView;
@property (strong,nonatomic) NSArray<JJCity *> *firstAry;//一级数据源
@property (nonatomic,assign) NSInteger firstCurrentIndex;//第一行当前位置


@end

@implementation JJCityPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    if (self) {
        [self internalConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self internalConfig];
    }
    return self;
}

- (void)internalConfig {
    _backView = [[UIView alloc] initWithFrame:self.frame];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.6;
    [self addSubview:_backView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_backView addGestureRecognizer:tap];
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.pickView];
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, self.pickView.frame.origin.y - 43.5, self.frame.size.width, 43.5)];
    _headView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 0, 43.5, 43.5);
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:button];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.frame.size.width - 42, 0, 34, 43.5);
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(completionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:button];
    
    [self addSubview:_headView];
}

- (void)showPickerWithCityName:(NSString *)cityName {
    _firstAry = [JJCity getcityArrayInformation];
    
    if (cityName.length > 0) {
        [_firstAry enumerateObjectsUsingBlock:^(JJCity *city, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([city.cityName isEqualToString:cityName]) {
                _firstCurrentIndex = idx+1;
            }
        }];
    } else {
        _firstCurrentIndex = 0;
    }
    [self.pickView reloadAllComponents];
    [self.pickView selectRow:_firstCurrentIndex inComponent:0 animated:NO];
    
    [self show];
}


- (void)show {
    self.hidden = NO;
    _backView.alpha = 0.6;
    [UIView animateWithDuration:0.5 animations:^{
        self.pickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - SHAddressPickerViewHeight, self.frame.size.width, SHAddressPickerViewHeight);
        _headView.frame = CGRectMake(0, self.pickView.frame.origin.y - 43.5, self.frame.size.width, 43.5);
    }];
}

- (void)hide {
    _backView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.pickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+44, self.frame.size.width, SHAddressPickerViewHeight);
        _headView.frame = CGRectMake(0, self.pickView.frame.origin.y, self.frame.size.width, 43.5);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate

//选项默认值
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    return;
}

//设置列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {

    return 1;
  }

//返回数组总数
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {

        return _firstAry.count + 1;

}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

        if (row > 0) {
            if (row - 1 < _firstAry.count) {
                JJCity *city = _firstAry[row - 1];
                //获取市
                NSString *str = city.cityName;
                return str;
            }
        }
    return @"请选择";
}

//触发事件
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _firstCurrentIndex = row;
    JJCity *city = _firstAry[row - 1];
    [self.pickView reloadAllComponents];
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16]];
    }
    // Fill the label text here
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)completionButtonAction:(UIButton *)sender {
    
    NSString *cityName = @"";
    JJCity *city;
    if (_firstAry.count > 0) {
        if (_firstCurrentIndex > 0) {
            if (_firstCurrentIndex - 1 < _firstAry.count) {
                city = _firstAry[_firstCurrentIndex - 1];
                //获取省
//                cityName = city.cityName;
            }
        }
    }
    
    if (_completion) {
        _completion(city);
    }
    [self hide];
}

- (void)cancleButtonAction:(UIButton *)sender {
    [self hide];
}

#pragma mark - 懒加载

- (UIPickerView*)pickView {
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height + 44, self.frame.size.width, SHAddressPickerViewHeight)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = [UIColor whiteColor];
        [_pickView selectRow:0 inComponent:0 animated:NO];
    }
    return _pickView;
}


@end
 */
