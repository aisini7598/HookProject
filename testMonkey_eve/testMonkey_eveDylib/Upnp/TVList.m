//
//  TVList.m
//  testMonkey_eveDylib
//
//  Created by John on 2018/5/18.
//  Copyright © 2018年 js. All rights reserved.
//

#import "TVList.h"
#import "UpnpServer.h"
#import "UpnpDeviceInfo.h"

@interface TVList ()<UITableViewDelegate, UITableViewDataSource, UpnpServerDelegate>

@property (nonatomic) UITableView *listView;
@property (nonatomic, copy) NSArray *datas;

@end

@implementation TVList

- (void)dealloc {
    [[UpnpServer share] stop];
    [UpnpServer share].delegate = nil;
}

- (instancetype)initWithBounds:(CGRect)bounds {
    if (self = [super init]) {
        [self setupViews:bounds];
        [[UpnpServer share] start];
        [UpnpServer share].delegate = self;
    }
    return self;
}

- (void)setupViews:(CGRect)frame {
    UITableView *listView = [[UITableView alloc] initWithFrame:frame];
    listView.delegate = self;
    listView.dataSource = self;
    self.listView = listView;
    [listView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"upnpIdentifire"];
}

- (UIView *)view {
    return self.listView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"upnpIdentifire"];
    cell.textLabel.text = [self.datas[indexPath.row] friendlyName];
    return cell;
}

- (void)upnpDeviceListChanged:(UpnpServer *)server deviceList:(NSArray<UpnpDeviceInfo *> *)deviceList {
    self.datas = deviceList.copy;
    [self.listView reloadData];
}



@end
