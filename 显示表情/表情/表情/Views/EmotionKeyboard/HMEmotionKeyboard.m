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
#import "HMEmotionToolbar.h"


#import "HMEmotion.h"
#import "NSObject+MJKeyValue.h"

@interface HMEmotionKeyboard ()<HMEmotionToolbarDelegate>
/** 表情列表 */
@property (nonatomic, weak) HMEmotionListView *listView;
/** 表情工具条 */
@property (nonatomic, weak) HMEmotionToolbar *toollbar;
/**
 添加表情包
 */
/** 默认表情 */
@property (nonatomic, strong) NSArray *defaultEmotions;
/** emoji表情 */
@property (nonatomic, strong) NSArray *emojiEmotions;
/** 浪小花表情 */
@property (nonatomic, strong) NSArray *lxhEmotions;

@end

@implementation HMEmotionKeyboard


- (NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        self.defaultEmotions = [HMEmotion objectArrayWithFile:plist];
        [self.defaultEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/default"];
    }
    return _defaultEmotions;
}

- (NSArray *)emojiEmotions
{
    if (!_emojiEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        self.emojiEmotions = [HMEmotion objectArrayWithFile:plist];
//        [self.emojiEmotions makeObjectsPerformSelector:@selector(setDictionary:) withObject:@"EmotionIcons/emoji"];
    }
    return _emojiEmotions;
}

- (NSArray *)lxhEmotions
{
    if (!_lxhEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        self.lxhEmotions = [HMEmotion objectArrayWithFile:plist];
        [self.lxhEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/lxh"];

    }
    return _lxhEmotions;
}


+(instancetype)keyboard {
    
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"emoticon_keyboard_background"]];
        // 1.添加表情列表  (设置控件的大小需要在  layoutsubview中写)
        HMEmotionListView *listView = [[HMEmotionListView alloc] init];
        [self addSubview:listView];
        self.listView = listView;
        
        // 2.添加表情工具条
        HMEmotionToolbar *toollbar = [[HMEmotionToolbar alloc] init];
        [self addSubview:toollbar];
        toollbar.delegate = self;
        self.toollbar = toollbar;
        
    }
    return self;
}

#pragma mark - HMEmotionToolbarDelegate
- (void)emotionToolbar:(HMEmotionToolbar *)toolbar didSelectedButton:(HMEmotionType)emotionType
{
    switch (emotionType) {
        case HMEmotionTypeDefault:// 默认
            self.listView.emotions = self.defaultEmotions;
            break;
            
        case HMEmotionTypeEmoji: // Emoji
            self.listView.emotions = self.emojiEmotions;
            break;
            
        case HMEmotionTypeLxh: // 浪小花
            self.listView.emotions = self.lxhEmotions;
            break;
            
        default:
            break;
    }
    
    NSLog(@"%lu %@", (unsigned long)self.listView.emotions.count, [self.listView.emotions firstObject]);
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
    
}
@end
