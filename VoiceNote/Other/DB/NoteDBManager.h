//
//  NoteDBManager.h
//  VoiceNote
//
//  Created by xjshi on 26/12/2016.
//  Copyright © 2016 sxj. All rights reserved.
//

#import "SXJDatabaseManager.h"

@class NoteModel;
@interface NoteDBManager : SXJDatabaseManager

+ (instancetype)sharedInstance;
- (NSArray<NoteModel *> *)queryAllNote;
- (void)createTable;
- (void)deleteNote:(NoteModel *)model;
- (BOOL)addNote:(NoteModel *)model;

@end
