//
//  HMEmotionToolbar.m
//  表情
//
//  Created by Apple on 16/12/12.
//  Copyright © 2016年 仝兴伟. All rights reserved.
//

#import "HMEmotionToolbar.h"


#define HMEmotionToolbarButtonMaxCount 4

@interface HMEmotionToolbar ()
/** 记录当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
@end
@implementation HMEmotionToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        // 1.添加4个按钮
        [self setupButton:@"最近" tag:HMEmotionTypeRecent];
        [self setupButton:@"默认" tag:HMEmotionTypeDefault];
        [self setupButton:@"Emoji" tag:HMEmotionTypeEmoji];
        [self setupButton:@"浪小花" tag:HMEmotionTypeLxh];
        
        // 2.监听表情选中的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:HMEmotionDidSelectedNotification object:nil];
    }
    return  self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/**
 *  表情选中
 */
- (void)emotionDidSelected:(NSNotification *)note
{
    if (self.selectedButton.tag == HMEmotionTypeRecent) {
        [self buttonClick:self.selectedButton];
    }
}

/**
 *  添加工具条按钮
 *  @param title 按钮文字
 */
- (UIButton *)setupButton:(NSString *)title tag:(HMEmotionType)tag{
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    // 文字
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    
    // 添加按钮
    [self addSubview:button];
    
    // 设置背景图片
    int count = self.subviews.count;
    if (count == 1) { // 第一个按钮
        //  其中图片需要拉伸
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_left_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_left_selected"] forState:UIControlStateSelected];
    } else if (count == HMEmotionToolbarButtonMaxCount) { // 最后一个按钮
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_right_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_right_selected"] forState:UIControlStateSelected];
    } else { // 中间按钮
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_mid_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_mid_selected"] forState:UIControlStateSelected];
    }
    
    return button;
}

//  设置代理
- (void)setDelegate:(id<HMEmotionToolbarDelegate>)delegate
{
    _delegate = delegate;
    
    // 获得“默认”按钮
    UIButton *defaultButton = (UIButton *)[self viewWithTag:HMEmotionTypeDefault];
    // 默认选中“默认”按钮
    [self buttonClick:defaultButton];
}


/**
 *  监听工具条按钮点击
 */
- (void)buttonClick:(UIButton *)button
{
    // 1.控制按钮状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    // 2.通知代理
    if ([self.delegate respondsToSelector:@selector(emotionToolbar:didSelectedButton:)]) {
        [self.delegate emotionToolbar:self didSelectedButton:button.tag];
    }
}

// 对控件的frame进行设置
-(void)layoutSubviews {
    [super layoutSubviews];
    // 3.设置工具条按钮的frame
    CGFloat buttonW = self.width / HMEmotionToolbarButtonMaxCount;
    CGFloat buttonH = self.height;
    for (int i = 0; i<HMEmotionToolbarButtonMaxCount; i++) {
        UIButton *button = self.subviews[i];
        button.width = buttonW;
        button.height = buttonH;
        button.x = i * buttonW;
    }
    
}

@end
