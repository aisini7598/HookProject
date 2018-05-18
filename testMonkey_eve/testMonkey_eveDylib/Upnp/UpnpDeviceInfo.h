//
//  UpnpDeviceInfo.h
//  testMonkey_eveDylib
//
//  Created by John on 2018/5/14.
//  Copyright © 2018年 js. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpnpServer.h"

@interface UpnpServiceInfo : NSObject

@property (nonatomic, copy) NSString *serviceType;
@property (nonatomic, copy) NSString *serviceId;
@property (nonatomic, copy) NSString *controlUrl;
@property (nonatomic, copy) NSString *eventSubURL;
@property (nonatomic, copy) NSString *SCPDURL;

- (void)setArray:(NSArray *)array;

@end


@interface UpnpDeviceInfo : NSObject

@property (nonatomic, copy) NSString *Location;
@property (nonatomic) NSTimeInterval timeInterval;
@property (nonatomic, copy) NSString *USN;
@property (nonatomic) NSInteger ST;
@property (nonatomic, copy) NSString *friendlyName;
@property (nonatomic, copy) NSString *modelName;

@property (nonatomic, copy) NSString *responseHeader;

@property (nonatomic) UpnpServiceInfo *AVTransport;
@property (nonatomic) UpnpServiceInfo *RenderingControl;

- (void)setArray:(NSArray *)array;

@end
