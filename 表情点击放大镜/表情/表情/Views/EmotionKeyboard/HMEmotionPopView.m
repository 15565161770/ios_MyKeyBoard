//
//  HMEmotionPopView.m
//  表情
//
//  Created by Apple on 16/12/13.
//  Copyright © 2016年 仝兴伟. All rights reserved.
//  放大镜

#import "HMEmotionPopView.h"
#import "HMEmotionView.h"
#import "HMEmotion.h"
@interface HMEmotionPopView ()
@property (weak, nonatomic) IBOutlet HMEmotionView *emotionView;

@end

@implementation HMEmotionPopView

+ (instancetype)popView{
    return [[[NSBundle mainBundle]loadNibNamed:@"HMEmotionPopView" owner:nil options:nil]lastObject];
}


-(void)showFromEmotionView:(HMEmotionView *)fromEmotionView{
  // 1 显示表情
    self.emotionView.emotion = fromEmotionView.emotion;
    // 2   添加到窗口上，类似alertview
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    // 3 设置表情位置 (将list的坐标转化成window的坐标)
    CGFloat centerX = fromEmotionView.centerX;
    CGFloat centerY = fromEmotionView.centerY - self.height * 0.5;
    CGPoint center = CGPointMake(centerX, centerY);
    self.center = [window convertPoint:center fromView:fromEmotionView.superview];

}


- (void)dismiss
{
    [self removeFromSuperview];
}

/**
 *  当控件显示之前被调用(只调用一次，如果控件在显示之前没有尺寸，不会调用)
 *
 *  @param rect 控件的boudns
 */

- (void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:@"emoticon_keyboard_magnifier"] drawInRect:rect];
}
@end
