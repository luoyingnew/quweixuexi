////
////  JJWordSpellingCell.m
////  FunStudy
////
////  Created by 唐天成 on 2016/11/22.
////  Copyright © 2016年 唐天成. All rights reserved.
////
//
//#import "JJWordSpellingCell.h"
//#import "JJProgressView.h"
//
//@interface JJWordSpellingCell ()
//
////进度条
//@property (nonatomic, strong) JJProgressView *progressView;
////单词字母Label数组
//@property (nonatomic, strong) NSMutableArray<UILabel *> *wordLetterArray;
////可选字母Button数组
//@property (nonatomic, strong) NSMutableArray<UIButton *> *chooseBtnArray;
////单词字母抽空数组
//@property (nonatomic, strong) NSMutableArray<NSString *> *spaceLetterArray;
////底部待选字母数组
//@property (nonatomic, strong) NSMutableArray<NSString *> *chooseLetterArray;
//
//@end
//
//@implementation JJWordSpellingCell
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    if(self = [super initWithFrame:frame]){
//        //创建视图控件
//        [self createView];
//    }
//    return self;
//}
//
//
////创建视图
//- (void)createView {
//    self.contentView.backgroundColor = [UIColor greenColor];
//    //进度条
//    self.progressView = [[JJProgressView alloc]init];
//    [self.contentView addSubview:self.progressView];
//    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.with.offset(16 * KWIDTH_IPHONE6_SCALE);
//        make.centerX.equalTo(self.contentView);
//        make.width.mas_equalTo(287 * KWIDTH_IPHONE6_SCALE);
//        make.height.mas_equalTo(19 * KWIDTH_IPHONE6_SCALE);
//    }];
//    
//    //播放读音
//    UIButton *playAudioBtn = [[UIButton alloc]init];
//    [self.contentView addSubview:playAudioBtn];
//    [playAudioBtn setBackgroundImage:[UIImage imageNamed:@"wordSpellingYellowBtn"] forState:UIControlStateNormal];
//    [playAudioBtn setTitle:@"播放读音" forState:UIControlStateNormal];
//    [playAudioBtn setTitleColor:RGBA(174, 50, 14, 1) forState:UIControlStateNormal];
//    [playAudioBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE]];
//    [playAudioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.with.offset(72 * KWIDTH_IPHONE6_SCALE);
//        make.top.with.offset(141 * KWIDTH_IPHONE6_SCALE);
//        make.width.mas_equalTo(89 * KWIDTH_IPHONE6_SCALE);
//        make.height.mas_equalTo(28 * KWIDTH_IPHONE6_SCALE);
//    }];
//    //打开提示
//    UIButton *openTipBtn = [[UIButton alloc]init];
//    [self.contentView addSubview:openTipBtn];
//    [openTipBtn setBackgroundImage:[UIImage imageNamed:@"wordSpellingYellowBtn"] forState:UIControlStateNormal];
//    [openTipBtn setTitle:@"打开提示" forState:UIControlStateNormal];
//    [openTipBtn setTitleColor:RGBA(174, 50, 14, 1) forState:UIControlStateNormal];
//    [openTipBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE]];
//    [openTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.with.offset(-72 * KWIDTH_IPHONE6_SCALE);
//        make.top.with.offset(141 * KWIDTH_IPHONE6_SCALE);
//        make.width.mas_equalTo(89 * KWIDTH_IPHONE6_SCALE);
//        make.height.mas_equalTo(28 * KWIDTH_IPHONE6_SCALE);
//    }];
//
//    
//    //创建可选字母Button数组
//    UIView *chooseBtnBackView = [[UIView alloc]init];
//    chooseBtnBackView.backgroundColor = [UIColor clearColor];
//    [self.contentView addSubview:chooseBtnBackView];
//    [chooseBtnBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.contentView);
//        make.height.mas_equalTo(175 * KWIDTH_IPHONE6_SCALE);
//        make.top.with.offset(250 * KWIDTH_IPHONE6_SCALE);
//    }];
//    CGFloat leftSpace = 44.4 * KWIDTH_IPHONE6_SCALE;
//    CGFloat width = 57 * KWIDTH_IPHONE6_SCALE;
//    CGFloat height = 66.3 * KWIDTH_IPHONE6_SCALE;
//    CGFloat space = 19.4 * KWIDTH_IPHONE6_SCALE;
//    CGFloat verticalSpace = 37 * KWIDTH_IPHONE6_SCALE;
//    for (int i = 0; i<8 ; i++) {
//        UIButton *chooseBtn = [[UIButton alloc]init];
//        [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [chooseBtn setTitleColor:RGBA(0, 82, 100, 1) forState:UIControlStateNormal];
//        [chooseBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:29 * KWIDTH_IPHONE6_SCALE]];
//        [self.chooseBtnArray addObject:chooseBtn];
//        [chooseBtn setBackgroundImage:[UIImage imageNamed:@"wordSpellingChooseBack"] forState:UIControlStateNormal];
//        [chooseBtnBackView addSubview:chooseBtn];
//        chooseBtn.frame = CGRectMake(leftSpace + (i % 4)*(width + space), (height + verticalSpace) * (i/4), width, height);
//    }
//
//    
//}
//
//- (void)setModel:(JJWordSpellingModel *)model {
//    NSLog(@"%@",_model);
//    _model = model;
//    if(_model.isDisplay) return;
//    //先去除所有的原先的label
//    for(UILabel *letterLabel in self.wordLetterArray) {
//        [letterLabel removeFromSuperview];
//    }
//    [self.wordLetterArray removeAllObjects];
//    
//    NSUInteger len = [model.word length];
//    for(NSUInteger i=0; i<len; i++)
//    {
//        UILabel *letterLabel = [[UILabel alloc]init];
//        letterLabel.textColor = RGBA(0, 106, 207, 1);
//        [letterLabel createBordersWithColor:[UIColor grayColor] withCornerRadius:2 * KWIDTH_IPHONE6_SCALE andWidth:1*KWIDTH_IPHONE6_SCALE ];
//        letterLabel.textAlignment = NSTextAlignmentCenter;
//        [self.wordLetterArray addObject:letterLabel];
//        [letterLabel adjustsFontSizeToFitWidth];
//        NSString *text = [model.word substringWithRange:NSMakeRange(i, 1)];
//        letterLabel.text = text;
//        [self.contentView addSubview:letterLabel];
//    }
//    
//    //如果大于7个
//    if(self.wordLetterArray.count > 7) {
//        CGFloat labelWidth = SCREEN_WIDTH / self.wordLetterArray.count * (46 / 53.0);
//        CGFloat labelHeight = labelWidth;
//        CGFloat space = labelWidth * (7 / 53.0);
//        for(int i = 0; i < self.wordLetterArray.count; i++) {
//            UILabel *letterLabel = self.wordLetterArray[i];
//            letterLabel.frame = CGRectMake(space + i*(labelWidth + space), 60 * KWIDTH_IPHONE6_SCALE, labelWidth, labelHeight);
//            letterLabel.font = [UIFont boldSystemFontOfSize:labelHeight *2 / 3];
//        }
//    } else {
//        //如果小于等于7个
//        CGFloat labelWidth = 46 * KWIDTH_IPHONE6_SCALE;
//        CGFloat labelHeight = labelWidth;
//        CGFloat space = 7 * KWIDTH_IPHONE6_SCALE;
//        CGFloat leftSpace = (SCREEN_WIDTH - (self.wordLetterArray.count * labelWidth) - ((self.wordLetterArray.count-1) * space))/2;
//        for(int i = 0; i < self.wordLetterArray.count; i++) {
//            UILabel *letterLabel = self.wordLetterArray[i];
//            letterLabel.frame = CGRectMake(leftSpace + i*(labelWidth + space), 60 * KWIDTH_IPHONE6_SCALE, labelWidth, labelHeight);
//            [letterLabel setFont:[UIFont boldSystemFontOfSize:33 * KWIDTH_IPHONE6_SCALE]];
//        }
//    }
//    //取到空白string数组并将label的text等于@"".
//    self.spaceLetterArray = [self randomArrayWithWordLetterArray:[self.wordLetterArray mutableCopy]];
//    self.chooseLetterArray = [self.spaceLetterArray mutableCopy];
//    NSMutableArray *allLetterArray = [NSMutableArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z", nil];
//    [allLetterArray removeObjectsInArray:self.spaceLetterArray];
//    //将待选字母数组填满
//    [self.chooseLetterArray addObjectsFromArray: [self randomArrayWithALLWordLetterArray:allLetterArray]];
//    //将待选字母数组打乱
//    [self randamArry:self.chooseLetterArray];
//    NSArray *b = self.spaceLetterArray;
//    NSArray *bb = self.chooseLetterArray;
//    NSArray *bbb = self.wordLetterArray;
//    for(int i = 0; i<self.chooseBtnArray.count; i++) {
//        UIButton *chooseBtn = self.chooseBtnArray[i];
//        [chooseBtn setTitle:self.chooseLetterArray[i] forState:UIControlStateNormal];
//    }
//    
//    
//    
//}
//
////将一个可变数组乱序
//- (void)randamArry:(NSMutableArray *)arry
//{
//    // 对数组乱序
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
////从单词字母Label数组中抽取出空白String数组   并且将label的text=@""
//- (NSMutableArray *)randomArrayWithWordLetterArray:(NSMutableArray *)letterArray {
//    //随机数从这里边产生
//    //随机数产生结果
//    NSMutableArray *resultArray=[NSMutableArray array];
//    //随机数个数
//    NSInteger m=letterArray.count / 3;
//    for (int i=0; i<m; i++) {
//        int t=arc4random()%letterArray.count;
//        UILabel *label = letterArray[t];
//        //判断当前空白数组是有已经有这个字母
//        if(![resultArray containsObject:label.text]) {
//            [resultArray addObject: label.text];
//        }
//        label.text = @"";
//        letterArray[t]=[letterArray lastObject]; //为更好的乱序，故交换下位置
//        [letterArray removeLastObject];
//    }
//    for(UILabel *la in letterArray) {
//        NSLog(@"%@",la.text);
//    }
//    return resultArray;
//}
//
////从所有的字母数组(去除已挖空的)中随机去除剩余需要的字母数组
//- (NSMutableArray *)randomArrayWithALLWordLetterArray:(NSMutableArray *)letterArray {
//    //随机数从这里边产生
//    //随机数产生结果
//    NSMutableArray *resultArray=[NSMutableArray array];
//    //随机数个数
//    NSInteger m=8 - (26 - letterArray.count);
//    for (int i=0; i<m; i++) {
//        int t=arc4random()%letterArray.count;
//        [resultArray addObject: letterArray[t]];
//        letterArray[t]=[letterArray lastObject]; //为更好的乱序，故交换下位置
//        [letterArray removeLastObject];
//    }
//    return resultArray;
//}
//
//
//#pragma mark - 可选按钮点击
//- (void)chooseBtnClick:(UIButton *)chooseBtn {
//    for(UILabel *label in self.wordLetterArray) {
//        if([label.text isEqualToString:@""]) {
//            label.text = chooseBtn.titleLabel.text;
//            label.textColor = [UIColor yellowColor];
//            break;
//        }
//    }
//}
//
////布局
//- (void)layoutSubviews {
//    [super layoutSubviews];
//}
//
//
////懒加载
//- (NSMutableArray *)wordLetterArray {
//    if(!_wordLetterArray) {
//        _wordLetterArray = [NSMutableArray array];
//    }
//    return _wordLetterArray;
//}
//- (NSMutableArray *)chooseBtnArray {
//    if(!_chooseBtnArray) {
//        _chooseBtnArray = [NSMutableArray array];
//    }
//    return _chooseBtnArray;
//}
//@end
