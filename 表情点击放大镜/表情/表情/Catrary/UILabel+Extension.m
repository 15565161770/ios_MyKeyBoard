//
//  UILabel+Extension.m
//  DocQian
//
//  Created by Apple on 16/8/3.
//  Copyright © 2016年 仝兴伟. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSzie:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName :font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
