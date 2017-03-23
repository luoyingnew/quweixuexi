//
//  TCViewPager.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/28.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCViewPager.h"
#import "MJRefresh.h"
@interface TCViewPager ()
{
    NSArray *_titleArray;           /**< 菜单标题 */
    NSArray *_views;                /**< 视图 */
    NSArray *_titleIconsArray;      /**< 菜单标题左侧的小图标 */
    NSArray *_selectedIconsArray;   /**< 菜单被选中时左侧的小图标 */
    NSArray *_tipsCountArray;       /**< 菜单右上角的小红点显示的数量 */
    
    
    CGFloat _titlePageW;             /**<  pageController中每个Button的宽度*/
    CGFloat _selectedLabelScale;     /**<  被选中时的红色label与按钮的比例*/
    
    UILabel *_selectedLabel;         /**<  当前选中的label>*/
    
}
@end

@implementation TCViewPager
{
    TC_VP_SelectedBlock _block;
    NSInteger _pageNum;
}


//设置默认属性
- (void)configSelf
{
    self.userInteractionEnabled = YES;
    _tabBgColor = [UIColor whiteColor];
    _tabArrowBgColor = [UIColor colorWithRed:204/255.0 green:208/255.0 blue:210/255.0 alpha:1];
    _tabTitleColor = [UIColor colorWithRed:12/255.0 green:134/255.0 blue:237/255.0 alpha:1];
    _tabSelectedBgColor = [UIColor whiteColor];
    _tabSelectedTitleColor = [UIColor colorWithRed:12/255.0 green:134/255.0 blue:237/255.0 alpha:1];
    _tabSelectedArrowBgColor = [UIColor colorWithRed:12/255.0 green:134/255.0 blue:237/255.0 alpha:1];
    _showVLine = YES;
    _showAnimation = YES;
    _showBottomLine = YES;
    _showSelectedBottomLine = YES;
    _enabledScroll = YES;
}

//按钮的点击事件
- (void)tabBtnClicked:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    [self setSelectIndex:index];
}

//设置选择的按钮索引 触发的方法(里面主要做的就是修改下面红色label的滑动距离,并且使得上面的按钮选中状态发生改变)
- (void)setSelectIndex:(NSInteger)index
{
    if(_selectIndex!=index){
    }
    _selectIndex = index;
    for(NSInteger i = 0; i < _pageNum; i++) {
        UIButton *btn =    (UIButton *)[_pageControl viewWithTag:i + 100];
        btn.backgroundColor = [UIColor whiteColor];
        btn.selected = NO;
    }
    UIButton *button = (UIButton *)[_pageControl viewWithTag:index + 100];
    UILabel *selectedLabel = (UILabel *)[_pageControl viewWithTag:300];
    button.backgroundColor = _tabSelectedBgColor;
    button.selected = YES;
    if(_showAnimation) {
        [UIView animateWithDuration:0.3 animations:^{
            selectedLabel.centerX = button.centerX;
        }];
    } else {
        selectedLabel.centerX = button.centerX;
    }
    if(_block) {
        _block(self, index);
    }
    if(_showAnimation) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.contentOffset = CGPointMake(index * self.frame.size.width, 0);
        } completion:^(BOOL finished) {
            UIViewController *childVc = _views[index];
            if ([childVc isViewLoaded]) return;
            childVc.view.frame = _scrollView.bounds;
            [_scrollView addSubview:childVc.view];
        }];
        
        
    } else {
        _scrollView.contentOffset = CGPointMake(index * self.frame.size.width, 0);
        
        UIViewController *childVc = _views[index];
        if ([childVc isViewLoaded]) return;
        childVc.view.frame = _scrollView.bounds;
        childVc.view.height =  _scrollView.frame.size.height - PAGER_HEAD_HEIGHT + 2;
        childVc.view.top = 38;
        [_scrollView addSubview:childVc.view];
    }
    //让按钮居中
    [self setUpTitleCenter:button];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/self.frame.size.width;
    [self setSelectIndex:index];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}



// 设置标题居中
- (void)setUpTitleCenter:(UIButton *)centerButton
{
    // 计算偏移量
    CGFloat offsetX = centerButton.center.x - self.width * 0.5;
    
    if (offsetX < 0) offsetX = 0;
    
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.pageControl.contentSize.width - self.width;
    
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    
    
    // 滚动标题滚动条
    [self.pageControl setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

- (void)setTabSelectedBgColor:(UIColor *)tabSelectedBgColor
{
    _tabSelectedBgColor = tabSelectedBgColor;
    [self setNeedsDisplay];
}

- (void)didSelectedBlock:(TC_VP_SelectedBlock)block
{
    _block = block;
}

- (NSInteger)getLabelWidth:(NSString *)string fontSize:(CGFloat)size
{
    CGSize stringSize = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}];
    CGFloat width = stringSize.width;
    return width;
}

#pragma mark - version 2.0

- (id)initWithFrame:(CGRect)frame
             titles:(NSArray<NSString *> *)titles
              icons:(NSArray<UIImage *> *)icons
      selectedIcons:(NSArray<UIImage *> *)selectedIcons
              views:(NSArray *)views
         titlePageW:(CGFloat)width
 selectedLabelScale:(CGFloat)sclae
{
    self = [super initWithFrame:frame];
    if(self) {
        _titlePageW = width;
        _selectedLabelScale = sclae;
        
        _views = views;
        _titleArray = titles;
        _titleIconsArray = icons;
        _selectedIconsArray = selectedIcons;
        self.backgroundColor = [UIColor grayColor];
        [self configSelf];
    }
    return self;
}

- (void)setTitleIconsArray:(NSArray<UIImage *> *)icons
        selectedIconsArray:(NSArray<UIImage *> *)selectedIcons
{
    _titleIconsArray = icons;
    _selectedIconsArray = selectedIcons;
    
    [self setNeedsDisplay];
}

//设置菜单标题右上角小红点上显示的数字
- (void)setTipsCountArray:(NSArray *)tips
{
    _tipsCountArray = tips;
    [self setNeedsDisplay];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = self.bounds;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, PAGER_HEAD_HEIGHT, rect.size.width, rect.size.height - PAGER_HEAD_HEIGHT)];
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        CGRect frame;
        frame.origin.y = 38;
        frame.size.height = _scrollView.frame.size.height - PAGER_HEAD_HEIGHT;
        frame.size.width = rect.size.width;
    
        _pageControl = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, PAGER_HEAD_HEIGHT)];
        _pageNum = _views.count;
        _pageControl.backgroundColor = [UIColor whiteColor];
    _pageControl.showsHorizontalScrollIndicator = NO;
        //创建菜单按钮下划线
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _pageControl.frame.size.height - 1, _pageControl.frame.size.width, 1)];
        label.backgroundColor = _tabArrowBgColor;
        label.tag = 200;
    
        UILabel *selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _pageControl.frame.size.height -3, _titlePageW * _selectedLabelScale, 3)];
        selectedLabel.backgroundColor = _tabSelectedArrowBgColor;
        selectedLabel.tag = 300;
        if(!_showBottomLine) {
            CGRect labelFrame = label.frame;
            labelFrame.size.height = 0;
            label.frame = labelFrame;
        }
        if(!_showSelectedBottomLine) {
            CGRect selectedFrame = selectedLabel.frame;
            selectedFrame.size.height = 0;
            selectedLabel.frame = selectedFrame;
        }
    
        for(NSInteger i = 0; i < _views.count; i++) {
            CGRect _pageframe = _pageControl.frame;
            _pageframe.size.width = _titlePageW;//rect.size.width / _pageNum;
            _pageframe.origin.x = _pageframe.size.width * i;
    
            //创建菜单按钮
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
            [button setFrame:_pageframe];
            button.tag = 100 + i;
            [button setTitleColor:_tabTitleColor forState:UIControlStateNormal];
            [button setTitleColor:_tabSelectedTitleColor forState:UIControlStateSelected];
            [button setBackgroundColor:_tabBgColor];
            [button setTitle:_titleArray[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button addTarget:self action:@selector(tabBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            //创建菜单右侧小图标
            if(_titleIconsArray.count) {
                [button setImage:_titleIconsArray[i] forState:UIControlStateNormal];
            }
            if(_selectedIconsArray.count) {
                [button setImage:_selectedIconsArray[i] forState:UIControlStateSelected];
            }
    
            DebugLog(@"titleLabel.frame:x:%lf width:%lf height:%lf", button.titleLabel.frame.origin.x, button.titleLabel.frame.size.width, button.titleLabel.frame.size.height);
            //创建菜单按钮右上角的小红点
            UILabel *circleLabel = [[UILabel alloc] initWithFrame:CGRectMake([self getLabelWidth:_titleArray[i] fontSize:15]/2+button.titleLabel.frame.origin.x, 2, 16, 16)];
            circleLabel.backgroundColor = [UIColor redColor];
            circleLabel.textColor = [UIColor whiteColor];
            circleLabel.font = [UIFont systemFontOfSize:12];
            circleLabel.textAlignment = NSTextAlignmentCenter;
            circleLabel.tag = 600 +i;
            circleLabel.layer.cornerRadius = 8;
            circleLabel.layer.masksToBounds = YES;
            circleLabel.clipsToBounds = YES;
            if(_tipsCountArray == nil || _tipsCountArray.count == 0) {
                circleLabel.hidden = YES;
            } else if([_tipsCountArray[i] integerValue] <= 0) {
                circleLabel.hidden = YES;
            } else {
                circleLabel.hidden = NO;
                circleLabel.text = [_tipsCountArray[i] integerValue] > 99 ? @"99+" : [NSString stringWithFormat:@"%@", _tipsCountArray[i]];
                CGPoint center = circleLabel.center;
    
                CGRect cFrame = circleLabel.frame;
                cFrame.size.width = [self getLabelWidth:circleLabel.text fontSize:12]+6 > 16 ? [self getLabelWidth:circleLabel.text fontSize:12]+6 : 16;
    
                circleLabel.frame = cFrame;
                circleLabel.center = center;
            }
            if(_showVLine) {
                //创建中间分割线
                UILabel *vlabel = [[UILabel alloc] initWithFrame:CGRectMake(-1, 10, 1, button.frame.size.height - 20)];
                vlabel.backgroundColor = _tabArrowBgColor;
                [button addSubview:vlabel];
                if(!i) {
                    vlabel.hidden = YES;
                }
            }
            if(!i) {
                button.selected = YES;
            }
            if(button.selected) {
                [UIView animateWithDuration:0.3 animations:^{
                    //                CGRect sframe = selectedLabel.frame;
                    //                sframe.origin.x = button.frame.origin.x;
                    //                selectedLabel.frame = sframe;
                    selectedLabel.centerX = button.centerX;
                    [button setBackgroundColor:_tabSelectedBgColor];
                }];
            }
    
            [button addSubview:circleLabel];
            [_pageControl addSubview:button];
        }
    
        [_pageControl addSubview:label];
        [_pageControl addSubview:selectedLabel];
        if(_pageNum == 1) {
            _pageControl.hidden = YES;
        }
    
        //天成添加
        _pageControl.contentSize = CGSizeMake(_titlePageW * _views.count, 0);
    
        [_scrollView setContentSize:CGSizeMake(rect.size.width * _views.count + 1, 0)];
    
    
    if(_enabledScroll) {
        _scrollView.scrollEnabled = YES;
    } else {
        _scrollView.scrollEnabled = NO;
    }
    
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];

        self.scrollView.contentOffset = CGPointMake(self.frame.size.width*self.selectIndex, 0);
        [self setSelectIndex:self.selectIndex];
}


@end



