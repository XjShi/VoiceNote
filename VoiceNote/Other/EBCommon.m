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

@end
