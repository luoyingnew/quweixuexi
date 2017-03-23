//
//  JJTabbaButton.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJTabbaButton.h"
#import "JJBageButton.h"

#define IWTabBarButtonRatio 0.6

@interface JJTabbaButton ()

@property (nonatomic, weak) JJBageButton *badgeBtn;

@end


@implementation JJTabbaButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = RandomColor;
        // 1.设置图片居中
        self.imageView.contentMode = UIViewContentModeBottom;
        // 2.设置文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 3.设置文字大小
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        
        // 设置默认状态按钮的文字颜色
        [self setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        // 设置选中状态按钮的文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        // 添加红色原点按钮
        JJBageButton *badgeBtn = [[JJBageButton alloc] init];
        [self addSubview:badgeBtn];
        badgeBtn.backgroundColor = [UIColor redColor];
        [badgeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [badgeBtn.layer setCornerRadius:10.0];
        [badgeBtn.layer setMasksToBounds:YES];
        badgeBtn.top = 3;
        badgeBtn.left = (SCREEN_WIDTH /4)-40;
        badgeBtn.width = 20;
        badgeBtn.height = 20;
        self.badgeBtn = badgeBtn;
        badgeBtn.hidden = YES;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //
    //    // 设置红色原点的位置
    //    self.badgeBtn.y = 0;
    //    self.badgeBtn.x = self.width - self.badgeBtn.width - 5;
}

// 控制按钮上图片显示的位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = self.width;
    // 让图片的高度是整个按钮高度的60%
    CGFloat imageH = self.height - 20;//* IWTabBarButtonRatio;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

// 控制按钮上标题显示的位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = self.height - 20;//* IWTabBarButtonRatio;
    CGFloat titleW = self.width;
    CGFloat titleH = 20;//self.height - titleY;
    return CGRectMake(titleX, titleY, titleW, titleH);
    
}

- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    [self setTitle:item.title forState:UIControlStateNormal];
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    
    // 让self监听_item的badgeValue属性的改变
    /*
     NSKeyValueObservingOptionNew = 返回最新的值给我们
     NSKeyValueObservingOptionOld = 返回原始的值给我们
     NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld 返回原始的和最新的值给我们
     */
    [_item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    
    //    [_item addObserver:self forKeyPath:@"title" options:0 context:nil];
}

- (void)dealloc
{
    //    [_item removeObserver:self forKeyPath:@"title"];
    [_item removeObserver:self forKeyPath:@"badgeValue"];
}

/**
 *  当监听的对象的属性发生改变的时候就会调用
 *
 *  @param keyPath 家庭的路径
 *  @param object  _item
 *  @param change  传递给我们的值
 *  @param context <#context description#>
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.badgeBtn.badgeValue = self.item.badgeValue;
    
    // 设置标题
    //    [self setTitle:self.item.title forState:UIControlStateNormal];
    //    [self setTitle:self.item.title forState:UIControlStateSelected];
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

@end
