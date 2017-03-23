//
//  JJWordSpellingView.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJWordSpellingView.h"

@interface JJWordSpellingView ()

@property (nonatomic, strong) UILabel *tipLabel;


@end

@implementation JJWordSpellingView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        //创建视图控件
        [self createView];
    }
    return self;
}

//创建视图
- (void)createView {
    self.backgroundColor = [UIColor clearColor];
//    //进度条
//    self.progressView = [[JJProgressView alloc]init];
//    [self addSubview:self.progressView];
//    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.with.offset(16 * KWIDTH_IPHONE6_SCALE);
//        make.centerX.equalTo(self);
//        make.width.mas_equalTo(287 * KWIDTH_IPHONE6_SCALE);
//        make.height.mas_equalTo(19 * KWIDTH_IPHONE6_SCALE);
//    }];
    //播放读音
    UIButton *playAudioBtn = [[UIButton alloc]init];
    [self addSubview:playAudioBtn];
    [playAudioBtn addTarget:self action:@selector(playAudioBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [playAudioBtn setBackgroundImage:[UIImage imageNamed:@"wordSpellingYellowBtn"] forState:UIControlStateNormal];
    [playAudioBtn setTitle:@"播放读音" forState:UIControlStateNormal];
    [playAudioBtn setTitleColor:RGBA(174, 50, 14, 1) forState:UIControlStateNormal];
    [playAudioBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE]];
    [playAudioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(72 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(141 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(89 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(28 * KWIDTH_IPHONE6_SCALE);
    }];
    //打开提示
    UIButton *openTipBtn = [[UIButton alloc]init];
    [self addSubview:openTipBtn];
    [openTipBtn setBackgroundImage:[UIImage imageNamed:@"wordSpellingYellowBtn"] forState:UIControlStateNormal];
    [openTipBtn addTarget:self action:@selector(openTipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [openTipBtn setTitle:@"打开提示" forState:UIControlStateNormal];
    [openTipBtn setTitleColor:RGBA(174, 50, 14, 1) forState:UIControlStateNormal];
    [openTipBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE]];
    [openTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.with.offset(-72 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(141 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(89 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(28 * KWIDTH_IPHONE6_SCALE);
    }];
    //中文提示
    UILabel *tipLabel = [[UILabel alloc]init];
    self.tipLabel = tipLabel;
    tipLabel.font = [UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
    [self addSubview:tipLabel];
    self.tipLabel.hidden = YES;
    tipLabel.textColor = RGBA(174, 50, 14, 1);
//    tipLabel.text = @"提示";
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(openTipBtn.mas_top).with.offset(-6);
    }];
    
    //创建可选字母Button数组
    UIView *chooseBtnBackView = [[UIView alloc]init];
    chooseBtnBackView.backgroundColor = [UIColor clearColor];
    [self addSubview:chooseBtnBackView];
    [chooseBtnBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(175 * KWIDTH_IPHONE6_SCALE);
        if(isPhone) {
            make.top.with.offset(250 * KWIDTH_IPHONE6_SCALE);
        } else {
            make.top.with.offset(220 * KWIDTH_IPHONE6_SCALE);
        }
        
    }];
    CGFloat leftSpace;
    CGFloat width;
    CGFloat height;
    CGFloat space;
    CGFloat verticalSpace;
    if(isPhone) {
        leftSpace = 44.4  * KWIDTH_IPHONE6_SCALE;
        width = 57 * KWIDTH_IPHONE6_SCALE;
        height = 66.3 * KWIDTH_IPHONE6_SCALE;
        space = 19.4 * KWIDTH_IPHONE6_SCALE;
        verticalSpace = 37 * KWIDTH_IPHONE6_SCALE;
    } else {
        
        width = 57 * KWIDTH_IPHONE6_SCALE;
        height = 66.3 * KWIDTH_IPHONE6_SCALE;
        space = 19.4 * KWIDTH_IPHONE6_SCALE;
        verticalSpace = 37 * KWIDTH_IPHONE6_SCALE;
        leftSpace = (SCREEN_WIDTH - space * 3 - width * 4) / 2;
    }
    for (int i = 0; i<8 ; i++) {
        UIButton *chooseBtn = [[UIButton alloc]init];
        [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [chooseBtn setTitleColor:RGBA(0, 82, 100, 1) forState:UIControlStateNormal];
        [chooseBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:29 * KWIDTH_IPHONE6_SCALE]];
        [self.chooseBtnArray addObject:chooseBtn];
        [chooseBtn setBackgroundImage:[UIImage imageNamed:@"wordSpellingChooseBack"] forState:UIControlStateNormal];
        [chooseBtnBackView addSubview:chooseBtn];
        chooseBtn.frame = CGRectMake(leftSpace + (i % 4)*(width + space), (height + verticalSpace) * (i/4), width, height);
    }
}

- (void)setModel:(JJWordSpellingModel *)model {
    NSLog(@"%@",_model);
    _model = model;
    self.tipLabel.text = model.option_right;
    //先去除所有的原先的label
    for(UILabel *letterLabel in self.wordLetterArray) {
        [letterLabel removeFromSuperview];
    }
    [self.wordLetterArray removeAllObjects];
    
    NSUInteger len = [model.word length];
    for(NSUInteger i=0; i<len; i++)
    {
        UILabel *letterLabel = [[UILabel alloc]init];
        letterLabel.textColor = RGBA(0, 106, 207, 1);
        [letterLabel createBordersWithColor:[UIColor grayColor] withCornerRadius:2 * KWIDTH_IPHONE6_SCALE andWidth:1*KWIDTH_IPHONE6_SCALE ];
        letterLabel.textAlignment = NSTextAlignmentCenter;
        [self.wordLetterArray addObject:letterLabel];
        [letterLabel adjustsFontSizeToFitWidth];
        NSString *text = [model.word substringWithRange:NSMakeRange(i, 1)];
        letterLabel.text = text;
        [self addSubview:letterLabel];
    }
    
    //如果大于7个
    if(self.wordLetterArray.count > 7) {
        CGFloat labelWidth = SCREEN_WIDTH / self.wordLetterArray.count * (46 / 53.0);
        CGFloat labelHeight = labelWidth;
        CGFloat space = labelWidth * (7 / 53.0);
        for(int i = 0; i < self.wordLetterArray.count; i++) {
            UILabel *letterLabel = self.wordLetterArray[i];
            letterLabel.frame = CGRectMake(space + i*(labelWidth + space), 60 * KWIDTH_IPHONE6_SCALE, labelWidth, labelHeight);
            letterLabel.font = [UIFont boldSystemFontOfSize:labelHeight *2 / 3];
        }
    } else {
        //如果小于等于7个
        CGFloat labelWidth = 46 * KWIDTH_IPHONE6_SCALE;
        CGFloat labelHeight = labelWidth;
        CGFloat space = 7 * KWIDTH_IPHONE6_SCALE;
        CGFloat leftSpace = (SCREEN_WIDTH - (self.wordLetterArray.count * labelWidth) - ((self.wordLetterArray.count-1) * space))/2;
        for(int i = 0; i < self.wordLetterArray.count; i++) {
            UILabel *letterLabel = self.wordLetterArray[i];
            letterLabel.frame = CGRectMake(leftSpace + i*(labelWidth + space), 60 * KWIDTH_IPHONE6_SCALE, labelWidth, labelHeight);
            [letterLabel setFont:[UIFont boldSystemFontOfSize:33 * KWIDTH_IPHONE6_SCALE]];
        }
    }
    //取到空白string数组并将label的text等于@"".
    self.spaceLetterArray = [self randomArrayWithWordLetterArray:[self.wordLetterArray mutableCopy]];
    self.chooseLetterArray = [self.spaceLetterArray mutableCopy];
    NSMutableArray *allLetterArray = [NSMutableArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z", nil];
    [allLetterArray removeObjectsInArray:self.spaceLetterArray];
    //将待选字母数组填满
    [self.chooseLetterArray addObjectsFromArray: [self randomArrayWithALLWordLetterArray:allLetterArray]];
    //将待选字母数组打乱
    [self randamArry:self.chooseLetterArray];
    NSArray *b = self.spaceLetterArray;
    NSArray *bb = self.chooseLetterArray;
    NSArray *bbb = self.wordLetterArray;
    for(int i = 0; i<self.chooseBtnArray.count; i++) {
        UIButton *chooseBtn = self.chooseBtnArray[i];
        [chooseBtn setTitle:self.chooseLetterArray[i] forState:UIControlStateNormal];
    }
    
    
    NSLog(@"%@   %@",self.spaceLetterArray,self.chooseLetterArray);
}

//将一个可变数组乱序
- (void)randamArry:(NSMutableArray *)arry
{
    // 对数组乱序
    NSArray *arrayCurrent = [arry sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    for (NSString *str in arrayCurrent) {
        NSLog(@"%@", str);
    }
    [arry removeAllObjects];
    [arry addObjectsFromArray:arrayCurrent];
}
//从单词字母Label数组中抽取出空白String数组   并且将label的text=@""
- (NSMutableArray *)randomArrayWithWordLetterArray:(NSMutableArray *)letterArray {
    //随机数从这里边产生
    //随机数产生结果
    NSMutableArray *resultArray=[NSMutableArray array];
    //随机数个数(每3个取1个   不满3个取1个)
    NSInteger m = letterArray.count / 3;
    if(m == 0 && letterArray.count != 0) {
        m = 1;
    }
    
    for (int i=0; i<m; i++) {
        int t=arc4random()%letterArray.count;
        UILabel *label = letterArray[t];
        //判断当前空白数组是有已经有这个字母
        if(![resultArray containsObject:label.text]) {
            [resultArray addObject: label.text];
        }
        label.text = @"";
        letterArray[t]=[letterArray lastObject]; //为更好的乱序，故交换下位置
        [letterArray removeLastObject];
    }
    for(UILabel *la in letterArray) {
        NSLog(@"%@",la.text);
    }
    return resultArray;
}

//从所有的字母数组(去除已挖空的)中随机去除剩余需要的字母数组
- (NSMutableArray *)randomArrayWithALLWordLetterArray:(NSMutableArray *)letterArray {
    //随机数从这里边产生
    //随机数产生结果
    NSMutableArray *resultArray=[NSMutableArray array];
    //随机数个数
    NSInteger m=8 - (26 - letterArray.count);
    for (int i=0; i<m; i++) {
        int t=arc4random()%letterArray.count;
        [resultArray addObject: letterArray[t]];
        letterArray[t]=[letterArray lastObject]; //为更好的乱序，故交换下位置
        [letterArray removeLastObject];
    }
    return resultArray;
}

- (void)playAudioBtnClick {
    if(self.playAudioBlock) {
        self.playAudioBlock();
    }
}
#pragma mark - 打开提示按钮点击
-(void)openTipBtnClick:(UIButton *)btn {
    if([btn.titleLabel.text isEqualToString:@"打开提示"]) {
        self.tipLabel.hidden = NO;
        [btn setTitle:@"隐藏提示" forState:UIControlStateNormal];
    } else {
        self.tipLabel.hidden = YES;
        [btn setTitle:@"打开提示" forState:UIControlStateNormal];
    }
    
}

#pragma mark - 可选按钮点击
- (void)chooseBtnClick:(UIButton *)chooseBtn {
    for(UILabel *label in self.wordLetterArray) {
        if([label.text isEqualToString:@""]) {
            label.text = chooseBtn.titleLabel.text;
            label.textColor = [UIColor redColor];
            break;
        }
    }
    NSArray *a = self.spaceLetterArray;
}

//布局
- (void)layoutSubviews {
    [super layoutSubviews];
}


#pragma mark - 懒加载
- (NSMutableArray *)wordLetterArray {
    if(!_wordLetterArray) {
        _wordLetterArray = [NSMutableArray array];
    }
    return _wordLetterArray;
}
- (NSMutableArray *)chooseBtnArray {
    if(!_chooseBtnArray) {
        _chooseBtnArray = [NSMutableArray array];
    }
    return _chooseBtnArray;
}
@end
