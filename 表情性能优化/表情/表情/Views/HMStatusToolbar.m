//
//  HMStatusToolbar.m
//  表情
//
//  Created by Apple on 16/12/12.
//  Copyright © 2016年 仝兴伟. All rights reserved.
//

#import "HMStatusToolbar.h"
#import "UIImage+Extension.h"
#import "UIView+WLFrame.h"
#import "UIView+Extension.h"
@interface HMStatusToolbar()
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *dividers;

@property (nonatomic, weak) UIButton *emotionButton;

@end
@implementation HMStatusToolbar

- (NSMutableArray *)btns
{
    if (_btns == nil) {
        self.btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)dividers
{
    if (_dividers == nil) {
        self.dividers = [NSMutableArray array];
    }
    return _dividers;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizedImage:@"timeline_card_bottom_background"];
        
        [self setupBtnWithIcon:@"timeline_icon_retweet" title:@"转发" tag:HMComposeToolbarleft];
        [self setupBtnWithIcon:@"timeline_icon_comment" title:@"评论" tag:HMComposeToolbarButtonTypemodel];
         self.emotionButton = [self setupBtnWithIcon:@"timeline_icon_unlike" title:@"赞" tag:HMComposeToolbarButtonTyperight];
        
        [self setupDivider];
        [self setupDivider];
    }
    return self;
}


-(void)setShowEmotion:(BOOL)showEmotionButton {
    _showEmotionButton = showEmotionButton; // 将bool值存起来 以备后面使用
    
    if (showEmotionButton) { // 如果是yes就显示表情
        [self.emotionButton setImage:[UIImage imageWithName:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
        [self.emotionButton setImage:[UIImage imageWithName:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
    } else {
        [self.emotionButton setImage:[UIImage imageWithName:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [self.emotionButton setImage:[UIImage imageWithName:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }
    
}

/**
 *  分割线
 */
- (void)setupDivider
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageWithName:@"timeline_card_bottom_line"];
    divider.contentMode = UIViewContentModeCenter;
    [self addSubview:divider];
    [self.dividers addObject:divider];
}

/**
 *  添加按钮
 *
 *  @param icon  图标
 *  @param title 标题
 */
- (UIButton *)setupBtnWithIcon:(NSString *)icon title:(NSString *)title tag:(HMComposeToolbarButtonType)tag
{
    UIButton *btn = [[UIButton alloc] init];
    btn.tag = tag;
    [btn setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    // 设置高亮时的背景
    [btn setBackgroundImage:[UIImage resizedImage:@"common_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.adjustsImageWhenHighlighted = NO;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [self addSubview:btn];
    
    [self.btns addObject:btn];
    return btn;
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(composeTool:didClickedButton:)]) {
        [self.delegate composeTool:self didClickedButton:button.tag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    int btnCount = self.btns.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.btns[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.y = 0;
        btn.x = i * btnW;
    }
    
    // 设置分割线的frame
    int dividerCount = self.dividers.count;
    for (int i = 0; i<dividerCount; i++) {
        UIImageView *divider = self.dividers[i];
        divider.width = 4;
        divider.height = btnH;
        divider.centerX = (i + 1) * btnW;
        divider.centerY = btnH * 0.5;
    }
}

@end
