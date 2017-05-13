//
//  HMEmotionView.m
//  表情
//
//  Created by Apple on 16/12/13.
//  Copyright © 2016年 仝兴伟. All rights reserved.
//

#import "HMEmotionView.h"
#import "HMEmotion.h"
@implementation HMEmotionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (void)setEmotion:(HMEmotion *)emotion
{
    _emotion = emotion;
    
    if (emotion.code) { // emoji表情
        // emotion.code == 0x1f603 --> \u54367
        // emoji的大小取决于字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        [self setTitle:emotion.emoji forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
    } else { // 图片表情
        NSString *icon = [NSString stringWithFormat:@"%@/%@", emotion.directory, emotion.png];
        [self setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
    }
}


@end
