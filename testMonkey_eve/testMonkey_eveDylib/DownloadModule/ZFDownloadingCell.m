//
//  ZFDownloadingCell.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFDownloadingCell.h"

@interface ZFDownloadingCell ()

@end

@implementation ZFDownloadingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *fileNameLabel = [[UILabel alloc] init];
        fileNameLabel.font = [UIFont systemFontOfSize:13];
        fileNameLabel.textColor = [UIColor blackColor];
        fileNameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:fileNameLabel];
        _fileNameLabel = fileNameLabel;
        
        UIProgressView *progressView = [[UIProgressView alloc] init];
        progressView.progress = 0;
        progressView.progressTintColor = [UIColor orangeColor];
        progressView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:progressView];
        
        _progress = progressView;
        
        UILabel *downloadLabel = [[UILabel alloc] init];
        downloadLabel.font = [UIFont systemFontOfSize:13];
        downloadLabel.textColor = [UIColor blackColor];
        downloadLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:downloadLabel];
        _progressLabel = downloadLabel;
        
        UILabel *speedLabel = [[UILabel alloc] init];
        speedLabel.font = [UIFont systemFontOfSize:13];
        speedLabel.textColor = [UIColor blackColor];
        speedLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:speedLabel];
        _speedLabel = speedLabel;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"menu_pause"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateSelected];
        
        button.bounds = CGRectMake(0, 0, 30, 30);
        
        [self.contentView addSubview:button];
        
        _downloadBtn = button;
        
        [button addTarget:self action:@selector(clickDownload:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [self.fileNameLabel sizeToFit];
    self.fileNameLabel.frame = CGRectMake(10, 10, self.fileNameLabel.bounds.size.width, self.fileNameLabel.bounds.size.height);
    self.progressLabel.frame = CGRectMake(10, self.frame.size.height / 2 - 1, self.frame.size.width - 30 - 30, 2);
    
    [self.progressLabel sizeToFit];
    self.progressLabel.frame = CGRectMake(10, self.frame.size.height / 2 + 10, self.progressLabel.bounds.size.width, self.progressLabel.bounds.size.height);
    
    self.downloadBtn.frame = CGRectMake(self.frame.size.width - 40, (self.frame.size.height - 30) / 2, 30, 30);
    
    [self.speedLabel sizeToFit];
    
    self.speedLabel.frame = CGRectMake(CGRectGetMaxX(self.progressLabel.frame) - self.speedLabel.frame.size.width, CGRectGetMaxY(self.progressLabel.frame) + 10, self.speedLabel.frame.size.width, self.speedLabel.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  暂停、下载
 *
 *  @param sender UIButton
 */
- (void)clickDownload:(UIButton *)sender {
    // 执行操作过程中应该禁止该按键的响应 否则会引起异常
    sender.userInteractionEnabled = NO;
    ZFFileModel *downFile = self.fileInfo;
    ZFDownloadManager *filedownmanage = [ZFDownloadManager sharedDownloadManager];
    if(downFile.downloadState == ZFDownloading) { //文件正在下载，点击之后暂停下载 有可能进入等待状态
        self.downloadBtn.selected = YES;
        [filedownmanage stopRequest:self.request];
    } else {
         self.downloadBtn.selected = NO;
        [filedownmanage resumeRequest:self.request];
    }
    
    // 暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttpreqst控制Cell
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
    sender.userInteractionEnabled = YES;
}

- (void)setFileInfo:(ZFFileModel *)fileInfo {
    _fileInfo = fileInfo;
    self.fileNameLabel.text = fileInfo.fileName;
    // 服务器可能响应的慢，拿不到视频总长度 && 不是下载状态
    if ([fileInfo.fileSize longLongValue] == 0 && !(fileInfo.downloadState == ZFDownloading)) {
        self.progressLabel.text = @"";
        if (fileInfo.downloadState == ZFStopDownload) {
            self.speedLabel.text = @"已暂停";
        } else if (fileInfo.downloadState == ZFWillDownload) {
            self.downloadBtn.selected = YES;
            self.speedLabel.text = @"等待下载";
        }
        self.progress.progress = 0.0;
        return;
    }
    NSString *currentSize = [ZFCommonHelper getFileSizeString:fileInfo.fileReceivedSize];
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    // 下载进度
    float progress = (float)[fileInfo.fileReceivedSize longLongValue] / [fileInfo.fileSize longLongValue];
    
    self.progressLabel.text = [NSString stringWithFormat:@"%@ / %@ (%.2f%%)",currentSize, totalSize, progress*100];
    
    self.progress.progress = progress;

    // NSString *spped = [NSString stringWithFormat:@"%@/S",[ZFCommonHelper getFileSizeString:[NSString stringWithFormat:@"%lu",[ASIHTTPRequest averageBandwidthUsedPerSecond]]]];
    if (fileInfo.speed) {
        NSString *speed = [NSString stringWithFormat:@"%@ 剩余%@",fileInfo.speed,fileInfo.remainingTime];
        self.speedLabel.text = speed;
    } else {
        self.speedLabel.text = @"正在获取";
    }

    if (fileInfo.downloadState == ZFDownloading) { //文件正在下载
        self.downloadBtn.selected = NO;
    } else if (fileInfo.downloadState == ZFStopDownload&&!fileInfo.error) {
        self.downloadBtn.selected = YES;
        self.speedLabel.text = @"已暂停";
    }else if (fileInfo.downloadState == ZFWillDownload&&!fileInfo.error) {
        self.downloadBtn.selected = YES;
        self.speedLabel.text = @"等待下载";
    } else if (fileInfo.error) {
        self.downloadBtn.selected = YES;
        self.speedLabel.text = @"错误";
    }
    
    [self setNeedsLayout];
}

@end
