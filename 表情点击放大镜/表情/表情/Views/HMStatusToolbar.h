//
//  HMStatusToolbar.h
//  表情
//
//  Created by Apple on 16/12/12.
//  Copyright © 2016年 仝兴伟. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    HMComposeToolbarleft, // 转发
    HMComposeToolbarButtonTypemodel, // 点赞
    HMComposeToolbarButtonTyperight // 评论
} HMComposeToolbarButtonType;

@class HMStatusToolbar;

@protocol HMStatusToolbarDelegate <NSObject>

@optional
- (void)composeTool:(HMStatusToolbar *)toolbar didClickedButton:(HMComposeToolbarButtonType)buttonType;

@end
@interface HMStatusToolbar : UIImageView
@property (nonatomic, weak) id<HMStatusToolbarDelegate> delegate;

/**
 *  设置某个按钮图片
 *
 *  @param image      图片名称
 *  @param buttonType 哪个按钮
 */
//- (void)setButtonImage:(NSString *)image buttonType:(HMComposeToolbarButtonType)buttonType;

/**
 *   是否显示表情按钮
 */
@property (nonatomic, assign)BOOL showEmotionButton;
@end
