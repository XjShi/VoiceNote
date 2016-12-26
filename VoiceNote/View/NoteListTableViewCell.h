//
//  NoteListTableViewCell.h
//  VoiceNote
//
//  Created by xjshi on 26/12/2016.
//  Copyright © 2016 sxj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"

@class NoteListTableViewCell;
@protocol NoteListTableViewCellDelegate <NSObject>

- (void)noteListTableViewCell:(NoteListTableViewCell *)cell play:(BOOL)play;

@end

@interface NoteListTableViewCell : UITableViewCell

@property (nonatomic, weak) id<NoteListTableViewCellDelegate> delegate;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) NoteModel *note;

+ (CGFloat)height;

@end
