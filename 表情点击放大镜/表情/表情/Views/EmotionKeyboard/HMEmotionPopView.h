//
//  HMEmotionPopView.h
//  表情
//
//  Created by Apple on 16/12/13.
//  Copyright © 2016年 仝兴伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMEmotionView;
@interface HMEmotionPopView : UIView

+ (instancetype)popView;
/**
 *  显示表情弹出控件
 *
 *  @param emotionView 从哪个表情上面弹出
 */
-(void)showFromEmotionView:(HMEmotionView *)fromEmotionView;
- (void)dismiss;

@end
