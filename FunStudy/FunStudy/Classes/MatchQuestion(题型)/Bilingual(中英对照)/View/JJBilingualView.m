#import "JJBilingualView.h"
#import "Masonry.h"
#import "UIView+FrameExpand.h"

@interface JJBilingualView()
@property (nonatomic, strong) NSArray *leftButtonArray;
@property (nonatomic, strong) NSArray *rightButtonArray;



//当前待匹配的左端按钮
@property (nonatomic, strong) UIButton *currentLeftSelectedBtn;
//当前待匹配的右端按钮
@property (nonatomic, strong) UIButton *currentRightSelectedBtn;



@end

@implementation JJBilingualView
- (NSArray *)leftButtonArray
{
    if (!_leftButtonArray) {
        NSMutableArray *arrarM = [NSMutableArray array];
        
        // 仅初始化控件，设置数组内容
        for (int i = 0; i < self.model.bilingualModelArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:RGBA(0, 105, 207, 1) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
            btn.titleLabel.numberOfLines = 3;
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            // 禁止按钮的用户交互
            
            // 设置按钮的tag
            btn.tag = i;
            [btn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            //            [btn setBackgroundColor:[UIColor redColor]];
            
            // 设置背景图片
            [btn setBackgroundImage:[UIImage imageNamed:@"bilingualBtn"] forState:UIControlStateNormal];
            [btn setTitle:self.model.bilingualModelArray[i].topic_text forState:UIControlStateNormal];

            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setBackgroundImage:[UIImage imageNamed:@"bilingualBtnSelected"] forState:UIControlStateSelected];
            //            [btn setTitle:[NSString stringWithFormat:@"LBtnSelected%d",i] forState:UIControlStateSelected];
            
            [self addSubview:btn];
            [arrarM addObject:btn];
        }
        
        // 返回数组
        _leftButtonArray = [arrarM copy];
    }
    return _leftButtonArray;
}
- (NSArray *)rightButtonArray
{
    if (!_rightButtonArray) {
        NSMutableArray *arrarM = [NSMutableArray array];
        
        // 仅初始化控件，设置数组内容
        for (int i = 0; i < self.model.bilingualModelArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.numberOfLines = 3;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
            [btn setTitleColor:RGBA(0, 105, 207, 1) forState:UIControlStateNormal];
            //btn.titleLabel.numberOfLines = 0;
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            // 禁止按钮的用户交互
            //            btn.userInteractionEnabled = NO;
            
            // 设置按钮的tag
            btn.tag = i;
            [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            // 设置背景图片
            [btn setBackgroundImage:[UIImage imageNamed:@"bilingualBtn"] forState:UIControlStateNormal];
            [btn setTitle:self.model.rightBtnTextArray[i] forState:UIControlStateNormal];
            //            [btn setBackgroundColor:[UIColor redColor]];
            [btn setBackgroundImage:[UIImage imageNamed:@"bilingualBtnSelected"] forState:UIControlStateSelected];
            //            [btn setTitle:[NSString stringWithFormat:@"RSele%d",i] forState:UIControlStateSelected];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            [self addSubview:btn];
            [arrarM addObject:btn];
        }
        
        // 返回数组
        _rightButtonArray = [arrarM copy];
    }
    return _rightButtonArray;
}


- (void)leftBtnClick:(UIButton *)btn {
    if(btn.selected == YES) {
        //按钮是选中时
        if([self.model.leftlineRelationArray[btn.tag] intValue]!= (-1)) {
            //如果是有连线
            btn.selected = NO;
            
            UIButton *rightBtn = self.rightButtonArray[[self.model.leftlineRelationArray[btn.tag] intValue]];
            rightBtn.selected = NO;
            self.model.rightlineRelationArray[[self.model.leftlineRelationArray[btn.tag] intValue]] = @(-1);
            self.model.leftlineRelationArray[btn.tag] = @(-1);
            
            
        } else {
            //如果是无连线的
            btn.selected = NO;
            self.currentLeftSelectedBtn = nil;
        }
    } else {
        //还没有选中
        btn.selected = YES;
        if(self.currentRightSelectedBtn != nil) {
            //如果点击后能与右边匹配
            self.model.leftlineRelationArray[btn.tag] = @(self.currentRightSelectedBtn.tag);
            self.model.rightlineRelationArray[self.currentRightSelectedBtn.tag] = @(btn.tag);
            self.currentRightSelectedBtn = nil;
            self.currentLeftSelectedBtn = nil;
        } else {
            //如果点击后不与右边匹配
            self.currentLeftSelectedBtn.selected = NO;
            self.currentLeftSelectedBtn = btn;
        }
    }
    [self setNeedsDisplay];
    
}
- (void)rightBtnClick:(UIButton *)btn {
    //按钮是选中时
    if(btn.selected == YES) {
        
        if([self.model.rightlineRelationArray[btn.tag] intValue]!= (-1)) {
            //如果是有连线
            btn.selected = NO;
            
            UIButton *leftBtn = self.leftButtonArray[[self.model.rightlineRelationArray[btn.tag] intValue]];
            leftBtn.selected = NO;
            self.model.leftlineRelationArray[[self.model.rightlineRelationArray[btn.tag] intValue]] = @(-1);
            self.model.rightlineRelationArray[btn.tag] = @(-1);
        } else {
            //如果是无连线的
            btn.selected = NO;
            self.currentRightSelectedBtn = nil;
        }
    } else {
        //还没有选中
        btn.selected = YES;
        if(self.currentLeftSelectedBtn != nil) {
            //如果点击后能与左边匹配
            self.model.rightlineRelationArray[btn.tag] = @(self.currentLeftSelectedBtn.tag);
            NSLog(@"%@",self.model.rightlineRelationArray);
            self.model.leftlineRelationArray[self.currentLeftSelectedBtn.tag] = @(btn.tag);
            NSLog(@"%@",self.model.leftlineRelationArray);
            self.currentRightSelectedBtn = nil;
            self.currentLeftSelectedBtn = nil;
            
            
        } else {
            //如果点击后不与左边匹配
            self.currentRightSelectedBtn.selected = NO;
            self.currentRightSelectedBtn = btn;
        }
    }
    [self setNeedsDisplay];
}

// 重新调整界面布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"%ld",self.model.bilingualModelArray.count);
    for(int i =0;i<self.model.bilingualModelArray.count;i++) {
        UIButton *lBtn = self.leftButtonArray[i];
        [lBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(87 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(87* KWIDTH_IPHONE6_SCALE);
            make.left.with.offset(10* KWIDTH_IPHONE6_SCALE);
            make.top.with.offset(i * 108* KWIDTH_IPHONE6_SCALE);
        }];
        
        UIButton *rBtn = self.rightButtonArray[i];
        [rBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(87* KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(87* KWIDTH_IPHONE6_SCALE);
            make.right.with.offset(-10* KWIDTH_IPHONE6_SCALE);
            make.top.with.offset(i * 108* KWIDTH_IPHONE6_SCALE);
        }];
    }
}

- (void)drawRect:(CGRect)rect {
    int currentCount = 0;
    for(int i = 0;i<self.model.leftlineRelationArray.count;i++) {
        NSNumber *number = self.model.leftlineRelationArray[i];
        if(number.intValue != (-1)) {
            currentCount++;
            UIButton *startPointButton = self.leftButtonArray[i];
            CGPoint startPoint = CGPointMake(startPointButton.right - (2 * KWIDTH_IPHONE6_SCALE), startPointButton.centerY);
            
            UIButton *destinationBtn = self.rightButtonArray[[self.model.leftlineRelationArray[i] intValue]];
            CGPoint destinationPoint = CGPointMake(destinationBtn.left + (1 * KWIDTH_IPHONE6_SCALE), destinationBtn.centerY);
            UIBezierPath *bezierPath = [UIBezierPath bezierPath];
            bezierPath.lineCapStyle =kCGLineCapRound;
            
            [bezierPath moveToPoint:startPoint];
            [bezierPath addLineToPoint:destinationPoint];
            [[UIColor yellowColor]set];
            [bezierPath setLineWidth:5.0* KWIDTH_IPHONE6_SCALE];
            [bezierPath setLineJoinStyle:kCGLineJoinRound];
            [bezierPath stroke];
        }
    }
    //    if(self.bilingualBlock) {
    //        self.bilingualBlock(currentCount,self.leftlineRelationArray.count);
    //    }
}













//- (NSArray *)leftButtonArray
//{
//    if (!_leftButtonArray) {
//        NSMutableArray *arrarM = [NSMutableArray array];
//        
//        // 仅初始化控件，设置数组内容
//        for (int i = 0; i < self.bilingualModelArray.count; i++) {
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            // 禁止按钮的用户交互
//            
//            // 设置按钮的tag
//            btn.tag = i;
//            [btn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
////            [btn setBackgroundColor:[UIColor redColor]];
//            
//            // 设置背景图片
//            [btn setBackgroundImage:[UIImage imageNamed:@"bilingualBtn"] forState:UIControlStateNormal];
//           [btn setTitle:self.bilingualModelArray[i].topic_text forState:UIControlStateNormal];
//            [btn setBackgroundImage:[UIImage imageNamed:@"bilingualBtnSelected"] forState:UIControlStateSelected];
////            [btn setTitle:[NSString stringWithFormat:@"LBtnSelected%d",i] forState:UIControlStateSelected];
//            
//            [self addSubview:btn];
//            [arrarM addObject:btn];
//        }
//        
//        // 返回数组
//        _leftButtonArray = [arrarM copy];
//    }
//    return _leftButtonArray;
//}
//- (NSArray *)rightButtonArray
//{
//    if (!_rightButtonArray) {
//        NSMutableArray *arrarM = [NSMutableArray array];
//        
//        // 仅初始化控件，设置数组内容
//        for (int i = 0; i < self.bilingualModelArray.count; i++) {
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            
//            // 禁止按钮的用户交互
//            //            btn.userInteractionEnabled = NO;
//            
//            // 设置按钮的tag
//            btn.tag = i;
//            [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            // 设置背景图片
//            [btn setBackgroundImage:[UIImage imageNamed:@"bilingualBtn"] forState:UIControlStateNormal];
//            [btn setTitle:self.rightBtnTextArray[i] forState:UIControlStateNormal];
////            [btn setBackgroundColor:[UIColor redColor]];
//            [btn setBackgroundImage:[UIImage imageNamed:@"bilingualBtnSelected"] forState:UIControlStateSelected];
////            [btn setTitle:[NSString stringWithFormat:@"RSele%d",i] forState:UIControlStateSelected];
//            
//            [self addSubview:btn];
//            [arrarM addObject:btn];
//        }
//        
//        // 返回数组
//        _rightButtonArray = [arrarM copy];
//    }
//    return _rightButtonArray;
//}
//
//
//- (void)leftBtnClick:(UIButton *)btn {
//    if(btn.selected == YES) {
//        //按钮是选中时
//        if([self.leftlineRelationArray[btn.tag] intValue]!= (-1)) {
//            //如果是有连线
//            btn.selected = NO;
//            
//            UIButton *rightBtn = self.rightButtonArray[[self.leftlineRelationArray[btn.tag] intValue]];
//            rightBtn.selected = NO;
//            self.rightlineRelationArray[[self.leftlineRelationArray[btn.tag] intValue]] = @(-1);
//            self.leftlineRelationArray[btn.tag] = @(-1);
//            
//            
//        } else {
//            //如果是无连线的
//            btn.selected = NO;
//            self.currentLeftSelectedBtn = nil;
//        }
//    } else {
//        //还没有选中
//        btn.selected = YES;
//        if(self.currentRightSelectedBtn != nil) {
//            //如果点击后能与右边匹配
//            self.leftlineRelationArray[btn.tag] = @(self.currentRightSelectedBtn.tag);
//            self.rightlineRelationArray[self.currentRightSelectedBtn.tag] = @(btn.tag);
//            self.currentRightSelectedBtn = nil;
//            self.currentLeftSelectedBtn = nil;
//        } else {
//            //如果点击后不与右边匹配
//            self.currentLeftSelectedBtn.selected = NO;
//            self.currentLeftSelectedBtn = btn;
//        }
//    }
//    [self setNeedsDisplay];
//    
//}
//- (void)rightBtnClick:(UIButton *)btn {
//    //按钮是选中时
//    if(btn.selected == YES) {
//        
//        if([self.rightlineRelationArray[btn.tag] intValue]!= (-1)) {
//            //如果是有连线
//            btn.selected = NO;
//            
//            UIButton *leftBtn = self.leftButtonArray[[self.rightlineRelationArray[btn.tag] intValue]];
//            leftBtn.selected = NO;
//            self.leftlineRelationArray[[self.rightlineRelationArray[btn.tag] intValue]] = @(-1);
//            self.rightlineRelationArray[btn.tag] = @(-1);
//        } else {
//            //如果是无连线的
//            btn.selected = NO;
//            self.currentRightSelectedBtn = nil;
//        }
//    } else {
//        //还没有选中
//        btn.selected = YES;
//        if(self.currentLeftSelectedBtn != nil) {
//            //如果点击后能与左边匹配
//            self.rightlineRelationArray[btn.tag] = @(self.currentLeftSelectedBtn.tag);
//            NSLog(@"%@",self.rightlineRelationArray);
//            self.leftlineRelationArray[self.currentLeftSelectedBtn.tag] = @(btn.tag);
//            NSLog(@"%@",self.leftlineRelationArray);
//            self.currentRightSelectedBtn = nil;
//            self.currentLeftSelectedBtn = nil;
//            
//            
//        } else {
//            //如果点击后不与左边匹配
//            self.currentRightSelectedBtn.selected = NO;
//            self.currentRightSelectedBtn = btn;
//        }
//    }
//    [self setNeedsDisplay];
//}

//- (void)setBilingualModelArray:(NSArray<JJBilingualModel *> *)bilingualModelArray{
//    _bilingualModelArray = bilingualModelArray;
//    for(JJBilingualModel *model in bilingualModelArray) {
//        [self.rightBtnTextArray addObject:model.option_right];
//    }
//    [self randamArry:self.rightBtnTextArray];
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(108 * KWIDTH_IPHONE6_SCALE * bilingualModelArray.count);
//    }];
//}

////将一个可变数组乱序
//- (void)randamArry:(NSMutableArray *)arry
//{
//    NSArray *arrayCurrent = [arry sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
//        int seed = arc4random_uniform(2);
//        
//        if (seed) {
//            return [str1 compare:str2];
//        } else {
//            return [str2 compare:str1];
//        }
//    }];
//    for (NSString *str in arrayCurrent) {
//        NSLog(@"%@", str);
//    }
//    [arry removeAllObjects];
//    [arry addObjectsFromArray:arrayCurrent];
//}

//- (NSMutableArray *)leftlineRelationArray {
//    if(!_leftlineRelationArray) {
//        _leftlineRelationArray = [NSMutableArray array];
//        for(int i = 0;i<self.self.bilingualModelArray.count; i++) {
//            [_leftlineRelationArray addObject:@(-1)];
//        }
//    }
//    return _leftlineRelationArray;
//}
//- (NSMutableArray *)rightlineRelationArray {
//    if(!_rightlineRelationArray) {
//        _rightlineRelationArray = [NSMutableArray array];
//        for(int i = 0;i<self.bilingualModelArray.count;i++) {
//            [_rightlineRelationArray addObject:@(-1)];
//        }
//    }
//    return _rightlineRelationArray;
//}


//// 重新调整界面布局
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    NSLog(@"%ld",self.bilingualModelArray.count);
//    for(int i =0;i<self.bilingualModelArray.count;i++) {
//        UIButton *lBtn = self.leftButtonArray[i];
//        [lBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(87 * KWIDTH_IPHONE6_SCALE);
//            make.height.mas_equalTo(87* KWIDTH_IPHONE6_SCALE);
//            make.left.with.offset(10* KWIDTH_IPHONE6_SCALE);
//            make.top.with.offset(i * 108* KWIDTH_IPHONE6_SCALE);
//        }];
//        
//        UIButton *rBtn = self.rightButtonArray[i];
//        [rBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(87* KWIDTH_IPHONE6_SCALE);
//            make.height.mas_equalTo(87* KWIDTH_IPHONE6_SCALE);
//            make.right.with.offset(-10* KWIDTH_IPHONE6_SCALE);
//            make.top.with.offset(i * 108* KWIDTH_IPHONE6_SCALE);
//        }];
//    }
//}
//
//- (void)drawRect:(CGRect)rect {
//    int currentCount = 0;
//    for(int i = 0;i<self.leftlineRelationArray.count;i++) {
//        NSNumber *number = self.leftlineRelationArray[i];
//        if(number.intValue != (-1)) {
//            currentCount++;
//            UIButton *startPointButton = self.leftButtonArray[i];
//            CGPoint startPoint = CGPointMake(startPointButton.right - (2 * KWIDTH_IPHONE6_SCALE), startPointButton.centerY);
//            
//            UIButton *destinationBtn = self.rightButtonArray[[self.leftlineRelationArray[i] intValue]];
//            CGPoint destinationPoint = CGPointMake(destinationBtn.left + (1 * KWIDTH_IPHONE6_SCALE), destinationBtn.centerY);
//            UIBezierPath *bezierPath = [UIBezierPath bezierPath];
//            bezierPath.lineCapStyle =kCGLineCapRound;
//
//            [bezierPath moveToPoint:startPoint];
//            [bezierPath addLineToPoint:destinationPoint];
//            [[UIColor yellowColor]set];
//            [bezierPath setLineWidth:5.0* KWIDTH_IPHONE6_SCALE];
//            [bezierPath setLineJoinStyle:kCGLineJoinRound];
//            [bezierPath stroke];
//        }
//    }
////    if(self.bilingualBlock) {
////        self.bilingualBlock(currentCount,self.leftlineRelationArray.count);
////    }
//}



//- (NSMutableArray *)rightBtnTextArray {
//    if(!_rightBtnTextArray) {
//        _rightBtnTextArray = [NSMutableArray array];
//    }
//    return _rightBtnTextArray;
//}
@end
