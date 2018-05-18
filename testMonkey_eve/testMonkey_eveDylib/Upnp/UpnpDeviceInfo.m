//
//  UpnpDeviceInfo.m
//  testMonkey_eveDylib
//
//  Created by John on 2018/5/14.
//  Copyright © 2018年 js. All rights reserved.
//

#import "UpnpDeviceInfo.h"
#import <GDataXMLNode.h>

@implementation UpnpDeviceInfo

- (NSString *)responseHeader {
    if (!_responseHeader) {
        NSURL *URL = [NSURL URLWithString:self.Location];
        _responseHeader = [NSString stringWithFormat:@"%@://%@:%@", [URL scheme], [URL host], [URL port]];
    }
    return _responseHeader;
}

- (UpnpServiceInfo *)AVTransport {
    if (!_AVTransport) {
        _AVTransport = [[UpnpServiceInfo alloc] init];
    }
    return _AVTransport;
}

- (UpnpServiceInfo *)RenderingControl {
    if (!_RenderingControl) {
        _RenderingControl = [UpnpServiceInfo new];
    }
    return _RenderingControl;
}

- (void)setArray:(NSArray *)array {
    for (NSInteger i = 0; i < array.count; i++) {
        GDataXMLElement *needEle = [array objectAtIndex:i];
        
        if ([needEle.name isEqualToString:@"friendlyName"]) {
            self.friendlyName = [needEle stringValue];
        }
        if ([needEle.name isEqualToString:@"modelName"]) {
            self.modelName = [needEle stringValue];
        }
        
        if ([needEle.name isEqualToString:@"serviceList"]) {
            
            NSArray *serviceListArray = [needEle children];
            for (int k = 0; k < [serviceListArray count]; k++) {
                GDataXMLElement *listEle = [serviceListArray objectAtIndex:k];
                if ([listEle.name isEqualToString:@"service"]) {
                    NSString *serviceString = [listEle stringValue];
                    if ([serviceString rangeOfString:kUpnpProtocol_AVTransport].location != NSNotFound || [serviceString rangeOfString:kUpnpProtocol_AVTransport].location != NSNotFound) {
                        
                        [self.AVTransport setArray:[listEle children]];
                        
                    }else if ([serviceString rangeOfString:serviceType_RenderingControl].location != NSNotFound || [serviceString rangeOfString:serviceType_RenderingControl].location != NSNotFound){
                        
                        [self.RenderingControl setArray:[listEle children]];
                    }
                }
            }
            continue;
            
        }
        
    }
}

@end

@implementation UpnpServiceInfo

- (void)setArray:(NSArray *)array {
    @autoreleasepool {
        for (int m = 0; m < array.count; m++) {
            GDataXMLElement *needEle = [array objectAtIndex:m];
            if ([needEle.name isEqualToString:@"serviceType"]) {
                self.serviceType = [needEle stringValue];
            }
            if ([needEle.name isEqualToString:@"serviceId"]) {
                self.serviceId = [needEle stringValue];
            }
            if ([needEle.name isEqualToString:@"controlURL"]) {
                self.controlUrl = [needEle stringValue];
            }
            if ([needEle.name isEqualToString:@"eventSubURL"]) {
                self.eventSubURL = [needEle stringValue];
            }
            if ([needEle.name isEqualToString:@"SCPDURL"]) {
                self.SCPDURL = [needEle stringValue];
            }
        }
    }
    
}

@end
