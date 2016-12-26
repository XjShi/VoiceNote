//
//  MD5Helper.h
//  OauthTool
//
//  Created by simon on 12-3-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5Tool : NSObject

/**
 *  MD5加密
 *  @param  str 要MD5的字符串
 *  @return MD5处理后的字符串
 */
+ (NSString *)md5:(NSString *)str;

/**
 *  MD5加密
 *  @param  data    要MD5的数据
 */
+ (NSString*)md5FromData:(NSString*)data;

@end
