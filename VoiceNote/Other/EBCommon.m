//
//  EBCommon.m
//  VoiceNote
//
//  Created by xjshi on 26/12/2016.
//  Copyright © 2016 sxj. All rights reserved.
//

#import "EBCommon.h"

@implementation EBCommon

+ (NSString *)tmpAudioPath {
    return [self absolutelyAudioPathFromRelativelyPath:@"tmp"];
}

+ (BOOL)moveAudioAtPath:(NSString *)res toDestination:(NSString *)des {
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSError *err = nil;
//    if (![manager fileExistsAtPath:des]) {
//        [manager createFileAtPath:des contents:nil attributes:nil];
//    }
    BOOL r = [manager moveItemAtPath:res
                     toPath:des
                      error:&err];
    return r;
}

+ (NSString *)absolutelyAudioPathFromRelativelyPath:(NSString *)path {
    NSString *ducumentpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [ducumentpath stringByAppendingPathComponent:path];
}

+ (float)soundFilter:(float)power {
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = - 80.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels = power;
    
    if (decibels < minDecibels) {
        level = 0.0f;
    }else if (decibels >= 0.0f) {
        level = 1.0f;
    }else {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    return level;
}

@end
