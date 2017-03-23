//
//  XPADView.m
//  XPApp
//
//  Created by tangtiancheng on 15/10/25.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "TCADView.h"

@interface NSArray (ad_SafeOject)

- (id)ad_SafeObjectAtIndex:(NSUInteger)index;

@end

@implementation NSArray (ad_SafeOject)

- (id)ad_SafeObjectAtIndex:(NSUInteger)index {
    if ([self count] > 0 && [self count] > index)
        return [self objectAtIndex:index];
    else
        return nil;
}

@end

@interface TCADView ()<UIScrollViewDelegate>

@property (assign, nonatomic) BOOL isCircle;
@property (strong, nonatomic) UIScrollView *scrollview;
@property (assign, nonatomic) NSTimeInterval timeInterval;
@property (strong, nonatomic) NSMutableArray *unusedImageViewArray;
@property (strong, nonatomic) NSMutableArray *usedImageViewArray;
@property (strong, nonatomic) dispatch_source_t timer;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (readwrite, nonatomic) UIPageControl *pageControl;

//判断scrollerView是否仍在滚动
@property(nonatomic,assign,getter=isDidScroller)BOOL didScroller;

@end

@implementation TCADView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.didScroller = NO;
        self.isCircle    = YES;
        self.isWebImage  = YES;
        self.displayTime = 2;
        
        self.unusedImageViewArray = [NSMutableArray array];
        self.usedImageViewArray   = [NSMutableArray array];
        
        self.scrollview  = [[UIScrollView alloc]initWithFrame:CGRectZero];
        self.scrollview.frame  = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
        self.pageControl.currentPageIndicatorTintColor = NORMAL_COLOR;
        self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:self.scrollview];
        [self addSubview:self.pageControl];
        
        self.scrollview.delegate      = self;
        self.scrollview.scrollsToTop  = NO;
        self.scrollview.pagingEnabled = YES;
        [self.scrollview setShowsVerticalScrollIndicator:NO];
        
        [self.scrollview setShowsHorizontalScrollIndicator:NO];
        
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapGesture:)];
        [self.scrollview addGestureRecognizer:self.tapGestureRecognizer];
    }
    
    return self;
}

- (void)didTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.dataArray.count) {
        NSUInteger index = self.scrollview.contentOffset.x/self.scrollview.frame.size.width;
        if (self.isCircle) {
                index -= 1;
        }
        
        NSString    *imagePath = [self.dataArray ad_SafeObjectAtIndex:index];
        UIImageView *imageView = [self.usedImageViewArray ad_SafeObjectAtIndex:index];
        if (self.selectedBlock) {
            self.selectedBlock(imageView, imagePath, index);
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(adView:didSelectedAtIndex:imageView:imagePath:)]) {
            [self.delegate adView:self didSelectedAtIndex:index imageView:imageView imagePath:imagePath];
        }
    }
}

- (void)setDataArray:(NSArray *)dataArray {
    if (dataArray == _dataArray && dataArray != nil) {
        return;
    }
    _dataArray = nil;
    _dataArray = dataArray;
    if (dataArray == nil || dataArray.count == 0) {
        self.scrollview.hidden = YES;
        
        return;
    } else {
        self.scrollview.hidden = NO;
    }
    if(dataArray.count == 1) {
        self.scrollview.scrollEnabled = NO;
    }
    
    
    [self.unusedImageViewArray addObjectsFromArray:self.usedImageViewArray ];
    [self.usedImageViewArray removeAllObjects];
    NSUInteger count = dataArray.count;
    self.pageControl.numberOfPages = (int)count;
    if (self.isCircle == YES) {
        count += 2;
    }
    
    for (NSUInteger i = 0; i < count; i++) {
        UIImageView *imageView = [self.unusedImageViewArray ad_SafeObjectAtIndex:i];
        if (imageView == nil) {
            imageView = [[UIImageView alloc]init];
        } else {
        }
        
        imageView.frame = CGRectMake(i  * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        self.scrollview.contentSize = CGSizeMake((i +1)* self.frame.size.width, self.frame.size.height);
        [self.scrollview addSubview:imageView];
        [self.usedImageViewArray addObject:imageView];
        NSString *imagePath = [self.dataArray ad_SafeObjectAtIndex:i];
        if (self.isCircle) {
            if (i == 0) {
                imagePath = [self.dataArray lastObject];
            } else if (i == count-1) {
                imagePath = [self.dataArray firstObject];
            } else {
                imagePath = [self.dataArray ad_SafeObjectAtIndex:i-1];
            }
        }
        if (self.isWebImage) {
            imageView.image = self.defalutADImage;
            if (self.delegate && [self.delegate respondsToSelector:@selector(adView:lazyLoadAtIndex:imageView:imageURL:)]) {
                [self.delegate adView:self lazyLoadAtIndex:i imageView:imageView imageURL:imagePath];
            } else {
                imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
            }
        } else {
            imageView.image = [UIImage imageNamed:imagePath];
        }
    }
    [self.unusedImageViewArray removeObjectsInArray:self.scrollview.subviews];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    //先跳到第二张
    [self.scrollview setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    self.didScroller = NO;
    
//    DebugLog(@"%@",[NSThread currentThread]);
    if (_timeInterval == timeInterval) {
        return;
    }
    _timeInterval = timeInterval;
    
    __block int  timeout = timeInterval;
    dispatch_queue_t queue   = dispatch_get_global_queue(0, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, timeout*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        if (timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        } else {
            if (self.scrollview.tracking) {
                return;
            }
            if (  self.isDidScroller ) {
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self nextImage];
            });
        }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_resume(_timer);
    });
    
}
//跳到下一张
-(void)nextImage{
    NSInteger page = round(self.scrollview.contentOffset.x/self.scrollview.frame.size.width) + 1;
    //需要监控动画结束后，判断是否循环，scrollViewDidEndDecelerating这个协议方法只有用户手动操作才会触发,代码不会触发，所以需要调用
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollview.contentOffset = CGPointMake(page * self.scrollview.bounds.size.width, 0);
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.scrollview];
    }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.didScroller = NO;
    NSInteger page = round(scrollView.contentOffset.x/scrollView.frame.size.width);
//    DebugLog(@"%ld",page);
    // 户翻页到左边5时，需要瞬间切换到 右侧的第五张，完成循环
    if (page == 0) {
        [self.scrollview setContentOffset:CGPointMake((self.usedImageViewArray.count-2) * self.scrollview.bounds.size.width, 0) animated:NO];
        [self scrollViewDidEndDecelerating:scrollView];
    }
    //当用户翻页到右侧最后一张时,瞬间切为左侧第一张 完成换页操作
    if (page == self.usedImageViewArray.count-1) {
        [self.scrollview setContentOffset:CGPointMake(self.scrollview.bounds.size.width, 0) animated:NO];
        [self scrollViewDidEndDecelerating:scrollView];
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.didScroller = YES;
    if (self.isCircle) {
        CGFloat imageviewW=self.scrollview.frame.size.width;
        CGFloat X = self.scrollview.contentOffset.x;
        self.pageControl.currentPage=round(X/imageviewW)-1;


    } else {
        int page = scrollView.contentOffset.x/scrollView.frame.size.width;
        self.pageControl.currentPage = page;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollview.frame  = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.pageControl.frame = CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30);
    NSUInteger count = self.usedImageViewArray.count;
    self.scrollview.contentSize = CGSizeMake(count * self.frame.size.width, self.frame.size.height);
    for (NSUInteger i = 0; i < count; i++) {
        UIImageView *imageView = [self.usedImageViewArray ad_SafeObjectAtIndex:i];
//        imageView.backgroundColor = [UIColor purpleColor];
        if (imageView) {
            imageView.frame = CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
    }
}

- (void)perform {
    [self setTimeInterval:self.displayTime];
}

@end
