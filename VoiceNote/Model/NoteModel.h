//
//  NoteModel.h
//  VoiceNote
//
//  Created by xjshi on 26/12/2016.
//  Copyright © 2016 sxj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NoteResourceCategory) {
    NoteResourceCategoryAudio
};

@interface NoteModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSTimeInterval date;
@property (nonatomic, assign) float duration;
@property (nonatomic, assign) NoteResourceCategory resourceCategory;

@end
