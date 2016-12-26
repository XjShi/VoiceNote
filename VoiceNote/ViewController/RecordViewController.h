//
//  RecordViewController.h
//  VoiceNote
//
//  Created by xjshi on 26/12/2016.
//  Copyright © 2016 sxj. All rights reserved.
//

#import "BaseViewController.h"

@class RecordViewController;
@class NoteModel;
@protocol RecordViewControllerDelegate <NSObject>

- (void)recordViewController:(RecordViewController *)vc finishRecordWithNote:(NoteModel *)note;

@end

@interface RecordViewController : BaseViewController

@property (nonatomic,weak) id<RecordViewControllerDelegate> delegate;

@end
