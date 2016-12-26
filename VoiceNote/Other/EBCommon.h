//
//  EBCommon.h
//  VoiceNote
//
//  Created by xjshi on 26/12/2016.
//  Copyright © 2016 sxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBCommon : NSObject

+ (NSString *)tmpAudioPath;
+ (BOOL)moveAudioAtPath:(NSString *)res toDestination:(NSString *)des;
+ (NSString *)absolutelyAudioPathFromRelativelyPath:(NSString *)path;

@end
