//
//  HMEmotionKeyboard.m
//  表情
//
//  Created by Apple on 16/12/12.
//  Copyright © 2016年 仝兴伟. All rights reserved.
//   自定义键盘

#import "HMEmotionKeyboard.h"
#import "UIImage+Extension.h"
#import "UIView+WLFrame.h"
#import "UIView+Extension.h"
#import "HMEmotionListView.h" // 自定义表情

#define HMEmotionToolbarButtonMaxCount 4

@interface HMEmotionKeyboard ()
/** 表情列表 */
@property (nonatomic, weak) HMEmotionListView *listView;
/** 表情工具条 */
@property (nonatomic, weak) UIView *toollbar;
/** 记录当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
@end

@implementation HMEmotionKeyboard

+(instancetype)keyboard {
    
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 1.添加表情列表  (设置控件的大小需要在  layoutsubview中写)
        HMEmotionListView *listView = [[HMEmotionListView alloc] init];
        listView.backgroundColor = [UIColor greenColor];
        listView.backgroundColor = [UIColor blackColor];
        [self addSubview:listView];
        self.listView = listView;
        
        // 2.添加表情工具条
        UIView *toollbar = [[UIView alloc] init];
        [self addSubview:toollbar];
        self.toollbar = toollbar;
        
        // 3.添加4个工具条按钮
        [self setupToolbarButton:@"最近"];
        UIButton *defaultButton = [self setupToolbarButton:@"默认"];
        [self setupToolbarButton:@"Emoji"];
        [self setupToolbarButton:@"浪小花"];

        // 4.默认选中“默认”按钮
        [self toolbarButtonClick:defaultButton];

    }
    return self;
}

/**
 *  添加工具条按钮
 *
 *  @param title 按钮文字
 */
- (UIButton *)setupToolbarButton:(NSString *)title
{
    UIButton *button = [[UIButton alloc] init];
    // 文字
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(toolbarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    
    // 添加按钮
    [self.toollbar addSubview:button];
    
    // 设置背景图片
    int count = self.toollbar.subviews.count;
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

/**
 *  监听工具条按钮点击
 */
- (void)toolbarButtonClick:(UIButton *)button
{
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}


// 对控件的frame进行设置
-(void)layoutSubviews {
    [super layoutSubviews];

    // 设置工具条的frame
    self.toollbar.x = 0;
    self.toollbar.width = self.width;
    self.toollbar.height = 35;
    self.toollbar.y = self.height - self.toollbar.height;
    
    // 设置表情列表的frame
    self.listView.width = self.width;
    self.listView.height = self.toollbar.y;
    
    // 3.设置工具条按钮的frame
    CGFloat buttonW = self.toollbar.width / HMEmotionToolbarButtonMaxCount;
    CGFloat buttonH = self.toollbar.height;
    for (int i = 0; i<HMEmotionToolbarButtonMaxCount; i++) {
        UIButton *button = self.toollbar.subviews[i];
        button.width = buttonW;
        button.height = buttonH;
        button.x = i * buttonW;
    }

}

@end
