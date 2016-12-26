//
//  RecordViewController.m
//  VoiceNote
//
//  Created by xjshi on 26/12/2016.
//  Copyright © 2016 sxj. All rights reserved.
//

#import "RecordViewController.h"
#import "Masonry.h"
#import "AudioManager.h"
#import "NoteModel.h"
#import "EBCommon.h"
#import "MD5Tool.h"
#import "EBAppConfig.h"

@interface RecordViewController () <AudioManagerDelegate>

@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *completeBtn;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, strong) AudioManager *audioManager;

@property (nonatomic, strong) NoteModel *note;
@end

@implementation RecordViewController
{
    CADisplayLink *_displayLink;
    UISwipeGestureRecognizer *_gesture;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.stackView];
    if ([EBAppConfig isFirstLaunch]) {
        [self.view addSubview:self.promptLabel];
    }
    _gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    _gesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:_gesture];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.recordBtn.mas_top).with.offset(-30);
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(self.view);
        make.height.equalTo(@44);
        make.bottom.equalTo(self.view).with.offset(-40);
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_displayLink invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - accessor
- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_recordBtn setTitle:@"开始录音" forState:UIControlStateNormal];
        [_recordBtn setTitle:@"结束录音" forState:UIControlStateSelected];
        [_recordBtn addTarget:self
                          action:@selector(recordButtonClicked:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_playBtn setTitle:@"开始播放" forState:UIControlStateNormal];
        [_playBtn setTitle:@"停止播放" forState:UIControlStateSelected];
        [_playBtn addTarget:self
                     action:@selector(playButtonClicked:)
           forControlEvents:UIControlEventTouchUpInside];
        _playBtn.enabled = NO;
    }
    return _playBtn;
}

- (UIButton *)completeBtn {
    if (!_completeBtn) {
        _completeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_completeBtn addTarget:self
                         action:@selector(complete:)
               forControlEvents:UIControlEventTouchUpInside];
        _completeBtn.enabled = NO;
    }
    return _completeBtn;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"00";
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.playBtn, self.recordBtn, self.completeBtn]];
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.alignment = UIStackViewAlignmentCenter;
    }
    return _stackView;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200)/ 2.0, 150, 200, 150)];
        _promptLabel.numberOfLines = 0;
        _promptLabel.text = @"当录音结束时，您可以向下👇滑动来返回上一页";
        _promptLabel.textColor = [UIColor lightGrayColor];
    }
    return _promptLabel;
}

- (AudioManager *)audioManager {
    if (!_audioManager) {
        _audioManager = [AudioManager sharedInstance];
        [_audioManager requestRecordPermission];
        _audioManager.delegate = self;
    }
    return _audioManager;
}

- (NoteModel *)note {
    if (!_note) {
        _note = [NoteModel new];
        _note.date = [[NSDate date] timeIntervalSince1970];
        _note.resourceCategory = NoteResourceCategoryAudio;
    }
    return _note;
}

#pragma mark - AudioManagerDelegate
- (void)audioManager:(AudioManager *)manager didFinishPlaySuccessfully:(BOOL)success {
    _gesture.enabled = YES;
    _playBtn.selected = NO;
}

#pragma mark - Private Method
- (void)recordButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    _gesture.enabled = !sender.selected;
    if (sender.selected) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTimeLabel)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        self.playBtn.enabled = NO;
        self.completeBtn.enabled = NO;
        NSString *path = [EBCommon tmpAudioPath];
        [self.audioManager startRecordingWithPath:path];
    } else {
        [_displayLink invalidate];
        
        NSDictionary *dict = [self.audioManager stopRecording];
        self.note.duration = ((NSNumber *)[dict objectForKey:AudioManagerRecordTimeLength]).floatValue;
        self.playBtn.enabled = YES;
        self.completeBtn.enabled = YES;
    }
}
         
- (void)playButtonClicked:(UIButton *)sender {
    NSLog(@"%@", sender.titleLabel.text);
    sender.selected = !sender.selected;
    _gesture.enabled = !sender.selected;
    if (sender.selected) {
        NSString *path = [EBCommon tmpAudioPath];
        [self.audioManager playAudioAtPath:path];
        self.recordBtn.enabled = NO;
    } else {
        [self.audioManager stopPlay];
        self.recordBtn.enabled = YES;
    }
}

- (void)complete:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入名字"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"存储" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *text = alertController.textFields.firstObject.text;
        if (text.length == 0) {
            [self presentViewController:alertController animated:YES completion:NULL];
        } else {
            self.note.ID = [MD5Tool md5FromData:[EBCommon tmpAudioPath]];
            [EBCommon moveAudioAtPath:[EBCommon tmpAudioPath] toDestination:[EBCommon absolutelyAudioPathFromRelativelyPath:self.note.ID]];
            self.note.name = text;
            if ([self.delegate respondsToSelector:@selector(recordViewController:finishRecordWithNote:)]) {
                [self.delegate recordViewController:self finishRecordWithNote:[self.note copy]];
            }
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [self presentViewController:alertController animated:YES completion:NULL];
}
                        
- (void)updateTimeLabel {
    self.timeLabel.text = [NSString stringWithFormat:@"%.2f s", _audioManager.currentTimeOfRecording];
}

- (void)back:(UIGestureRecognizer *)gesture {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
