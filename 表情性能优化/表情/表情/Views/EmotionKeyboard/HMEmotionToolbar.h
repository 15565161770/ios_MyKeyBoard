//
//  HMEmotionToolbar.h
//  表情
//
//  Created by Apple on 16/12/12.
//  Copyright © 2016年 仝兴伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMEmotionToolbar;
typedef enum {
    HMEmotionTypeRecent, // 最近
    HMEmotionTypeDefault, // 默认
    HMEmotionTypeEmoji, // Emoji
    HMEmotionTypeLxh // 浪小花
} HMEmotionType;

@protocol HMEmotionToolbarDelegate <NSObject>

@optional
- (void)emotionToolbar:(HMEmotionToolbar *)toolbar didSelectedButton:(HMEmotionType)emotionType;
@end

@interface HMEmotionToolbar : UIView
@property (nonatomic, weak) id<HMEmotionToolbarDelegate> delegate;

@end
