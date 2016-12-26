//
//  UIView+Extension.h
//  VoiceNote
//
//  Created by xjshi on 26/12/2016.
//  Copyright © 2016 sxj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic,assign) CGFloat top;       //frame.origin.y
@property (nonatomic,assign) CGFloat left;      //frame.origin.x
@property (nonatomic,assign) CGFloat bottom;    //frame.origin.y + frame.size.height
@property (nonatomic,assign) CGFloat right;     //frame.origin.x + frame.size.widht
@property (nonatomic,assign) CGFloat width;     //frame.size.width
@property (nonatomic,assign) CGFloat height;    //frame.size.height
@property (nonatomic,assign) CGFloat centerX;   //frame.center.x
@property (nonatomic,assign) CGFloat centerY;   //frame.center.y
@property (nonatomic,assign) CGPoint origin;    //frame.originn
@property (nonatomic,assign) CGSize size;       //frame.size
- (CGFloat)midX;
- (CGFloat)midY;
- (void)addTapGestureRecognizerForResignFirstResponder;

@end
