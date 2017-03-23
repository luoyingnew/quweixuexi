//
//  JJReportCartCell.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/1.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJReportCartCell.h"

@interface JJReportCartCell ()

//第17课Lable
@property (nonatomic, strong)UILabel *workLabel;
//85分Label
@property (nonatomic, strong)UILabel *achievementLabel;

@end

@implementation JJReportCartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       self.contentView.backgroundColor = RGBA(0, 153, 205, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createBordersWithColor:[UIColor clearColor] withCornerRadius:13 * KWIDTH_IPHONE6_SCALE andWidth:0];
        //第17课Lable
        UILabel *workLabel = [[UILabel alloc]init];
        self.workLabel = workLabel;
        workLabel.text = @"第17课";
        workLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:workLabel];
        workLabel.font = [UIFont boldSystemFontOfSize:18 * KWIDTH_IPHONE6_SCALE];
        
        //85分Label
        UILabel *achievementLabel = [[UILabel alloc]init];
        //achievementLabel.backgroundColor = [UIColor redColor];
        achievementLabel.textAlignment = NSTextAlignmentRight;
        self.achievementLabel = achievementLabel;
        achievementLabel.text = @"85分 >";
        achievementLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:achievementLabel];
        achievementLabel.font = [UIFont systemFontOfSize:18 * KWIDTH_IPHONE6_SCALE];
        [workLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(13 * KWIDTH_IPHONE6_SCALE);
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(achievementLabel.mas_left);
        }];

        [achievementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.with.offset(-8 * KWIDTH_IPHONE6_SCALE);
            make.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(65 * KWIDTH_IPHONE6_SCALE);
        }];
    }
    return self;
}

- (void)setModel:(JJReportCartCellModel *)model {
    _model = model;
    if([User getUserInformation].class_type == 1) {
        self.achievementLabel.text =[NSString stringWithFormat:@">"] ;
    } else {
        self.achievementLabel.text =[NSString stringWithFormat:@"%@分 >",model.score] ;
    }
    self.workLabel.text = model.homework_title;
    
}

@end
