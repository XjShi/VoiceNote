//
//  WaveView.m
//  VoiceNote
//
//  Created by xjshi on 27/12/2016.
//  Copyright © 2016 sxj. All rights reserved.
//

#import "WaveView.h"

@implementation WaveView
{
    NSMutableArray *_averagePointArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _averagePointArray = [[NSMutableArray alloc] initWithCapacity:frame.size.width];
        for (int i = 0; i < frame.size.width; ++i) {
            [_averagePointArray addObject:[NSNumber numberWithFloat:0.0f]];
        }
        self.clearsContextBeforeDrawing = YES;
    }
    return self;
}

- (void)addAveragePoint:(CGFloat)averagePoint {
    [_averagePointArray removeObjectAtIndex:0];
    [_averagePointArray addObject:[NSNumber numberWithFloat:averagePoint]];
    [self setNeedsDisplay];
}

- (void)clearAllPoint {
    for (int i = 0; i < _averagePointArray.count; i++) {
        [_averagePointArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:0.0f]];
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform t = CGContextGetCTM(context);
    CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    t = CGContextGetCTM(context);
    [self drawInContext:context];
}

- (void)drawInContext:(CGContextRef)context
{
    CGColorRef colorRef = [RGBCOLOR(70,202,253) CGColor];
    CGContextSetStrokeColorWithColor(context, colorRef);
    CGContextSetLineWidth(context, 1.0f);
    CGContextClearRect(context, self.bounds);
    
    CGPoint firstPoint = CGPointMake(0.0f,
                                     [[_averagePointArray objectAtIndex:0] floatValue]);
    CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
    
    for (int i = 1; i < [_averagePointArray count]; i++)
    {
        CGPoint point = CGPointMake(i,
                                    ([[_averagePointArray objectAtIndex:i] floatValue]
                                     *self.bounds.size.height));
        CGContextAddLineToPoint(context, point.x, point.y);
    } 
    CGContextStrokePath(context); 
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
