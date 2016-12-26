//
//  NoteListTableViewCell.m
//  VoiceNote
//
//  Created by xjshi on 26/12/2016.
//  Copyright © 2016 sxj. All rights reserved.
//

#import "NoteListTableViewCell.h"
#import "Masonry.h"
#import "NSString+Extension.h"
#import "UIView+Extension.h"

static const CGFloat kSpacing = 10.0;

@interface NoteListTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *durationLabel;

@end

@implementation NoteListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGSize size = [@"abc" sizeWithFont:[UIFont systemFontOfSize:17]
                             constraintSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        self.nameLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kSpacing, kSpacing, kScreenWidth - 2*kSpacing, size.height)];
            label;
        });
        self.dateLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kSpacing, self.nameLabel.bottom + kSpacing, 200, size.height)];
            label;
        });
        self.durationLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - kSpacing - 100, self.dateLabel.top, 100, size.height)];
            label.textAlignment = NSTextAlignmentRight;
            label;
        });
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.durationLabel];
        
        self.playButton = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake((kScreenWidth - 44) / 2.0,
                                   ([[self class] height] - 44) / 2.0,
                                   44,
                                   44);
            [btn setTitle:@"播放" forState:UIControlStateNormal];
            [btn setTitle:@"停止" forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(playButtonclicked:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [self.contentView addSubview:self.playButton];
        
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        self.progressView.frame = CGRectMake(0, 2, kScreenWidth, 2);
        [self.contentView addSubview:self.progressView];
    }
    return self;
}

- (void)setNote:(NoteModel *)note {
    _note = note;
    self.nameLabel.text = note.name;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    self.dateLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:note.date]];
    self.durationLabel.text = [NSString stringWithFormat:@"%.2f s", note.duration];
}

+ (CGFloat)height {
    CGSize size = [@"abc" sizeWithFont:[UIFont systemFontOfSize:17]
                        constraintSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    return size.height*2 + kSpacing * 3;
}

#pragma mark - Private Method
- (void)playButtonclicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(noteListTableViewCell:play:)]) {
        [self.delegate noteListTableViewCell:self play:sender.selected];
    }
}

@end
