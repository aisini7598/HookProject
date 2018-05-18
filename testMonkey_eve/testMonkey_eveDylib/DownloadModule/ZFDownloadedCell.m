//
//  ZFDownloadedCell.m
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

#import "ZFDownloadedCell.h"

@implementation ZFDownloadedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *firstNameLabel = [[UILabel alloc] init];
        firstNameLabel.font = [UIFont systemFontOfSize:11];
        firstNameLabel.backgroundColor = [UIColor clearColor];
        firstNameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:firstNameLabel];
        _fileNameLabel = firstNameLabel;
        
        UILabel *sizeLabel = [[UILabel alloc] init];
        sizeLabel.font = [UIFont systemFontOfSize:11];
        sizeLabel.textColor = [UIColor blackColor];
        sizeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:sizeLabel];
        _sizeLabel = sizeLabel;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.fileNameLabel sizeToFit];
    
    self.fileNameLabel.center = CGPointMake(10 + self.fileNameLabel.frame.size.width / 2, self.frame.size.height / 2);
    
    
    [self.sizeLabel sizeToFit];
    
    self.sizeLabel.center = CGPointMake(self.frame.size.width - 10 - self.sizeLabel.frame.size.width / 2, self.frame.size.height / 2);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFileInfo:(ZFFileModel *)fileInfo {
    _fileInfo = fileInfo;
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    self.fileNameLabel.text = fileInfo.fileName;
    self.sizeLabel.text = totalSize;
}

@end
