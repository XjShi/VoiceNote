//
//  NSString+Extension.m
//  VoiceNote
//
//  Created by xjshi on 26/12/2016.
//  Copyright © 2016 sxj. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font constraintSize:(CGSize)size {
    NSDictionary *attr = @{NSFontAttributeName: font};
    return [self boundingRectWithSize:size
                              options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                           attributes:attr
                              context:nil].size;
}

@end
