//
//  HMEmotionListView.m
//  表情
//
//  Created by Apple on 16/12/12.
//  Copyright © 2016年 仝兴伟. All rights reserved.
//   表情列表

#import "HMEmotionListView.h"
#import "HMEmotionGridView.h"

@interface HMEmotionListView() <UIScrollViewDelegate>
/** 显示所有表情的UIScrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 显示页码的UIPageControl */
@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation HMEmotionListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // 1.显示所有表情的UIScrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        // 滚动条是UIScrollView的子控件
        // 隐藏滚动条，可以屏蔽多余的子控件
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES; // 为了能分页
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        // 2.显示页码的UIPageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [pageControl setValue:[UIImage imageWithName:@"compose_keyboard_dot_selected"] forKeyPath:@"_currentPageImage"];
        [pageControl setValue:[UIImage imageWithName:@"compose_keyboard_dot_normal"] forKeyPath:@"_pageImage"];
        [self addSubview:pageControl];
        self.pageControl = pageControl;

    }
    return self;
}


/** 传过来的表情数组*/
-(void)setEmotions:(NSArray *)emotions {
    _emotions = emotions;
    
    // 设置总页数
    int totalPages = (emotions.count + HMEmotionMaxCountPerPage - 1) / HMEmotionMaxCountPerPage;
    int currentGridViewCount = self.scrollView.subviews.count;
    self.pageControl.numberOfPages = totalPages;
    self.pageControl.currentPage = 0;
    
    self.pageControl.hidden = totalPages <= 1;
    
    // 决定scrollView显示多少页表情
    // 移除所有的表情
//    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i< totalPages; i++) {
        
        // 获得i位置对应的HMEmotionGridView
        HMEmotionGridView *gridView = nil;
        if (i >= currentGridViewCount) { // 说明HMEmotionGridView的个数不够
            gridView = [[HMEmotionGridView alloc] init];
            [self.scrollView addSubview:gridView];
        } else { // 说明HMEmotionGridView的个数足够，从self.scrollView.subviews中取出HMEmotionGridView
            gridView = self.scrollView.subviews[i];
        }
        
        // 给HMEmotionGridView设置表情数据
        int loc = i * HMEmotionMaxCountPerPage;
        int len = HMEmotionMaxCountPerPage;
        if (loc + len > emotions.count) { // 对越界进行判断处理
            len = emotions.count - loc;
        }
        NSRange gridViewEmotionsRange = NSMakeRange(loc, len);
        NSArray *gridViewEmotions = [emotions subarrayWithRange:gridViewEmotionsRange];
        gridView.emotions = gridViewEmotions;
        gridView.hidden = NO;
    }
    
    //  隐藏不需要的gridView
    for (int i = totalPages ; i < currentGridViewCount; i++) {
        HMEmotionGridView *gridView = self.scrollView.subviews[i];
        gridView.hidden = YES;
    }
    
    // 重新布局子控件
    [self setNeedsLayout];
    
    // 表情滚动到最前面
    self.scrollView.contentOffset = CGPointZero;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.UIPageControl的frame
    self.pageControl.width = self.width;
    self.pageControl.height = 35;
    self.pageControl.y = self.height - self.pageControl.height;
    
    // 2.UIScrollView的frame
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    
    // 3.设置UIScrollView内部控件的尺寸
    int count = self.pageControl.numberOfPages;
    CGFloat gridW = self.scrollView.width;
    CGFloat gridH = self.scrollView.height;
    self.scrollView.contentSize = CGSizeMake(count * gridW, 0);
    for (int i = 0; i<count; i++) {
        UIView *gridView = self.scrollView.subviews[i];
        gridView.width = gridW;
        gridView.height = gridH;
        gridView.x = i * gridW;
    }

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.width + 0.5);
}


@end
