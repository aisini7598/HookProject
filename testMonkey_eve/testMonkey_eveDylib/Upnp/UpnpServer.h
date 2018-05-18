//
//  UpnpServer.h
//  testMonkey_eveDylib
//
//  Created by John on 2018/5/9.
//  Copyright © 2018年 js. All rights reserved.
//

#import <Foundation/Foundation.h>


@class UpnpDeviceInfo;
@class UpnpServer;


extern  NSString * kUpnpProtocol_AVTransport;
extern  NSString * serviceType_RenderingControl;

@protocol UpnpServerDelegate <NSObject>

- (void)upnpDeviceListChanged:(UpnpServer *)server deviceList:(NSArray<UpnpDeviceInfo *> *)deviceList;

@end

@interface UpnpServer : NSObject

@property (nonatomic, weak) id <UpnpServerDelegate> delegate;

+ (UpnpServer *)share;



- (void)start;

- (void)stop;

- (NSArray *)searchResult;


@end
