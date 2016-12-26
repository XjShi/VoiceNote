//
//  ListViewController.m
//  VoiceNote
//
//  Created by xjshi on 26/12/2016.
//  Copyright © 2016 sxj. All rights reserved.
//

#import "ListViewController.h"
#import "RecordViewController.h"
#import "NoteListTableViewCell.h"
#import "NoteDBManager.h"
#import "AudioManager.h"
#import "EBCommon.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface ListViewController () <RecordViewControllerDelegate, NoteListTableViewCellDelegate, AudioManagerDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) AudioManager *audioManager;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ListViewController
{
    NoteListTableViewCell *_currentPlayingCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRecord)];
    self.dataSource = [[[NoteDBManager sharedInstance] queryAllNote] mutableCopy];
    self.tableView.rowHeight = [NoteListTableViewCell height];
    [self.tableView registerClass:[NoteListTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - accessor
- (AudioManager *)audioManager {
    if (!_audioManager) {
        _audioManager = [AudioManager sharedInstance];
        _audioManager.delegate = self;
    }
    return _audioManager;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.note = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NoteModel *note = self.dataSource[indexPath.row];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[NoteDBManager sharedInstance] deleteNote:note];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - RecordViewControllerDelegate
- (void)recordViewController:(RecordViewController *)vc finishRecordWithNote:(NoteModel *)note {
    [[NoteDBManager sharedInstance] addNote:note];
    [self.dataSource insertObject:note atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - NoteListTableViewCellDelegate
- (void)noteListTableViewCell:(NoteListTableViewCell *)cell play:(BOOL)play {
    if (play) {
        _currentPlayingCell = cell;
        NSString *path = [EBCommon absolutelyAudioPathFromRelativelyPath:cell.note.ID];
        [self.audioManager playAudioAtPath:path];
    } else {
        _currentPlayingCell = nil;
        [self.audioManager stopPlay];
        [cell.progressView setProgress:0.0 animated:YES];
    }
}

#pragma mark - AudioManagerDelegate
- (void)audioManager:(AudioManager *)manager didFinishPlaySuccessfully:(BOOL)success {
    [_currentPlayingCell.progressView setProgress:0.0 animated:YES];
    _currentPlayingCell.playButton.selected = NO;
    
}

- (void)audioManager:(AudioManager *)manager playProgress:(NSTimeInterval)progress totoalDuration:(NSTimeInterval)totalDuration {
    [_currentPlayingCell.progressView setProgress:progress/totalDuration animated:YES];
}

#pragma mark - Private Method
- (void)addRecord {
    [_audioManager stopPlay];
    
    RecordViewController *vc = [RecordViewController new];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:NULL];
}

@end
