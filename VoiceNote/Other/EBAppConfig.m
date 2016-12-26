//
//  EBAppConfig.m
//  VoiceNote
//
//  Created by xjshi on 26/12/2016.
//  Copyright © 2016 sxj. All rights reserved.
//

#import "EBAppConfig.h"

@implementation EBAppConfig
+ (BOOL)isFirstLaunch {
    NSString *key = @"launchTime";
    NSInteger times = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    if (times == 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:times+1 forKey:key];
        return YES;
    } else {
        return NO;
    }
}
@end
