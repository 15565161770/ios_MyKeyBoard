//
//  HMEmotionGridView.m
//  表情
//
//  Created by Apple on 16/12/13.
//  Copyright © 2016年 仝兴伟. All rights reserved.
//

#import "HMEmotionGridView.h"
#import "HMEmotion.h"

@implementation HMEmotionGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    // 添加新的表情
    int count = emotions.count;
    for (int i = 0; i<count; i++) {
        UIButton *emotionView = [[UIButton alloc] init];
        emotionView.adjustsImageWhenHighlighted = NO;
        HMEmotion *emotion = emotions[i];
        if (emotion.code) { // emoji表情
            // emotion.code == 0x1f603 --> \u54367
            // emoji的大小取决于字体大小
            emotionView.titleLabel.font = [UIFont systemFontOfSize:32];
            [emotionView setTitle:emotion.emoji forState:UIControlStateNormal];
        } else { // 图片表情
            NSString *icon = [NSString stringWithFormat:@"%@/%@", emotion.directory, emotion.png];
            [emotionView setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
        }
        [self addSubview:emotionView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat leftInset = 15;
    CGFloat topInset = 15;
    
    int count = self.emotions.count;
    CGFloat emotionViewW = (self.width - 2 * leftInset) / HMEmotionMaxCols;
    CGFloat emotionViewH = (self.height - topInset) / HMEmotionMaxRows;
    for (int i = 0; i<count; i++) {
        UIButton *emotionView = self.subviews[i];
        emotionView.x = leftInset + (i % HMEmotionMaxCols) * emotionViewW;
        emotionView.y = topInset + (i / HMEmotionMaxCols) * emotionViewH;
        emotionView.width = emotionViewW;
        emotionView.height = emotionViewH;
    }
}


@end
