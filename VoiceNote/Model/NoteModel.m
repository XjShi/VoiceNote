//
//  NoteModel.m
//  VoiceNote
//
//  Created by xjshi on 26/12/2016.
//  Copyright © 2016 sxj. All rights reserved.
//

#import "NoteModel.h"

@implementation NoteModel

- (id)copy {
    NoteModel *note = [NoteModel new];
    note.ID = self.ID;
    note.name = self.name;
    note.date = self.date;
    note.duration = self.duration;
    note.resourceCategory = self.resourceCategory;
    return note;
}

@end
