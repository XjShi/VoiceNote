//
//  NoteDBManager.m
//  VoiceNote
//
//  Created by xjshi on 26/12/2016.
//  Copyright © 2016 sxj. All rights reserved.
//

#import "NoteDBManager.h"
#import "NoteModel.h"

@implementation NoteDBManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static NoteDBManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)createTable {
    [self createTable:[NoteModel class]];
}

- (BOOL)addNote:(NoteModel *)model {
    BOOL r = [self insertModel:model];
    return r;
}

- (NSArray<NoteModel *> *)queryAllNote {
    return [self selectAllRecord:[NoteModel class]];
}

- (void)deleteNote:(NoteModel *)model {
    [self deleteRecordFromTable:[NoteModel class] condition:@{@"ID": model.ID}];
}

@end
