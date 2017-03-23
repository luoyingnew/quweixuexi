//
//  JJSettingCell.m
//  FunStudy
//
//  Created by 唐天成 on 2017/1/2.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "JJSettingCell.h"

@interface JJSettingCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowV;
@property (nonatomic, strong) UISwitch *mySwitch;



@end

@implementation JJSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *imageV = [[UIImageView alloc]init ];
        imageV.image = [UIImage imageNamed:@"SetDashed"];
        [self.contentView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.contentView);
        }];
        //leftArrow
        UIImageView *arrowV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftArrow"]];
        [self.contentView addSubview:arrowV];
        self.arrowV = arrowV;
        [arrowV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.with.offset(-16 * KWIDTH_IPHONE6_SCALE);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(14 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(17 * KWIDTH_IPHONE6_SCALE);
        }];
        //开关
        UISwitch* mySwitch = [[ UISwitch alloc]init];//WithFrame:CGRectMake(imageView.width - 67*KWIDTH_IPHONE6_SCALE, 5*KWIDTH_IPHONE6_SCALE, 67*KWIDTH_IPHONE6_SCALE,20*KWIDTH_IPHONE6_SCALE)];
        self.mySwitch = mySwitch;
        BOOL isOn = [[NSUserDefaults standardUserDefaults]boolForKey:isNoticNetWork];
        [ mySwitch setOn:isOn animated:YES];
        mySwitch.tintColor = NORMAL_COLOR;
        mySwitch.onTintColor = NORMAL_COLOR;
        //mySwitch.backgroundColor = [UIColor greenColor];
        [ mySwitch addTarget: self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [ self.contentView addSubview:mySwitch];//添加到父视图
        [mySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.with.offset(-16 * KWIDTH_IPHONE6_SCALE);
            make.centerY.equalTo(self.contentView);
            make.height.with.offset(31 );
            make.width.with.offset(50 );
        }];

        
        
        UILabel *titleLabel = [[UILabel alloc]init]; //;]WithFrame:CGRectMake(20*KWIDTH_IPHONE6_SCALE, 0, 200*KWIDTH_IPHONE6_SCALE, self.height)];
        self.titleLabel = titleLabel;
        titleLabel.text = @"fds";//model.title;
        titleLabel.textColor = NORMAL_COLOR;
        titleLabel.font = [UIFont boldSystemFontOfSize:19.0 * KWIDTH_IPHONE6_SCALE];
        [imageV addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(20 * KWIDTH_IPHONE6_SCALE);
            make.top.bottom.with.offset(0);
            make.right.mas_equalTo(arrowV.mas_left);
        }];

    }
    return self;
}

//开关
- (void) switchValueChanged:(id)sender {
    UISwitch* control = (UISwitch*)sender;
    NSLog(@"%d",control.isOn);
    [[NSUserDefaults standardUserDefaults]setBool:control.isOn forKey:isNoticNetWork];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

- (void)setModel:(SetModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    if (model.type == JJSetTypeSwitch) {
        self.mySwitch.hidden = NO;
        self.arrowV.hidden = YES;
    } else {
        self.mySwitch.hidden = YES;
        self.arrowV.hidden = NO;
    }
}

@end
