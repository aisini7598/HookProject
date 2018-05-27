//
//  UpnpServer.m
//  testMonkey_eveDylib
//
//  Created by John on 2018/5/9.
//  Copyright © 2018年 js. All rights reserved.
//

#import "UpnpServer.h"

#import <GCDAsyncUdpSocket.h>
#import <GDataXMLNode.h>
#import "UpnpDeviceInfo.h"

static NSString *kNotifitionHost = @"239.255.255.250";
static NSInteger kNotificationPort = 1900;

NSString * kUpnpProtocol_AVTransport = @"urn:schemas-upnp-org:service:AVTransport:1";
NSString * serviceType_RenderingControl  = @"urn:schemas-upnp-org:service:RenderingControl:1";

@interface UpnpServer ()<GCDAsyncUdpSocketDelegate>

@property (nonatomic) GCDAsyncUdpSocket *udpSocket;

@property (nonatomic, copy) NSMutableDictionary *deviceList;

@end

static UpnpServer *instance = nil;
static dispatch_queue_t _queue = NULL;

@implementation UpnpServer

+ (UpnpServer *)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UpnpServer alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("com.everyday.see.queue", DISPATCH_QUEUE_SERIAL);
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
        _deviceList = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (NSString *)getString {
    return [NSString stringWithFormat:@"M-SEARCH * HTTP/1.1\r\nHOST: %@:%@\r\nMx: 5\r\nMAN: \"ssdp:discover\"\r\nST:%@/r/nUSER-AGENT: iOS UPnP/1.1 Tiaooo/1.0\r\n\r\n",kNotifitionHost,@(kNotificationPort),kUpnpProtocol_AVTransport];
}

- (void)start {
    
    NSError *error = nil;
    
    if (![self.udpSocket bindToPort:kNotificationPort error:&error]) {
        
    }
    
    if (![self.udpSocket beginReceiving:&error]) {
        
    }
    
    if (![self.udpSocket joinMulticastGroup:kNotifitionHost error:&error]) {
        
    }
    
    if (!error) {
        NSData *sendData = [[self getString] dataUsingEncoding:NSUTF8StringEncoding];
        [self.udpSocket sendData:sendData toHost:kNotifitionHost port:kNotificationPort withTimeout:-1 tag:1];
    }
}

- (void)stop {
    [self.udpSocket close];
}

- (void)searchDevice {
    [_deviceList removeAllObjects];
    
    [self onChange];
    
}

- (NSArray *)searchResult {
    return self.deviceList.allValues;
}

- (void)onChange {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(upnpDeviceListChanged:deviceList:)]) {
            [self.delegate upnpDeviceListChanged:self deviceList:self.deviceList.allValues];
        }
    });
    
}

#pragma GCDSOCKET delegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error {
    
    NSLog(@"not connect");
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    NSLog(@"closed");
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    
    
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    
    [self judgeDeviceWithData:data];
}

- (void)judgeDeviceWithData:(NSData *)data {
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([response hasPrefix:@"NOTIFY"]) {
        
        NSString *serverType = [self headerValueForKey:@"NT:" withData:response];
        if ([serverType isEqualToString:kUpnpProtocol_AVTransport]) {
            NSString *location = [self headerValueForKey:@"LOCATION:" withData:response];
            NSString *USN = [self headerValueForKey:@"USN:" withData:response];
            NSString *NTS = [self headerValueForKey:@"NTS:" withData:response];
            
            if (location.length == 0 || USN.length == 0 || NTS.length == 0) {
                return;
            }
            
            if ([NTS isEqualToString:@"ssdp:alive"]) {
                
                
                dispatch_async(_queue, ^{
                    if (![self.deviceList objectForKey:USN]) {
                        
                        [self addDevice:[self getDeviceWithLocation:location usn:USN] forKey:USN];
                    }
                });
                
            } else if ([NTS isEqualToString:@"ssdp:byebye"])
            {
                dispatch_async(_queue, ^{
                    [self removeDeviceWithUSN:USN];
                });
            }
            
        } else {
            
        }
        
    } else if ([response hasPrefix:@"HTTP/1.1"]) {
        NSString *location = [self headerValueForKey:@"Location" withData:response];
        NSString *usn = [self headerValueForKey:@"USN:" withData:response];
       
        dispatch_async(_queue, ^{
            if ([self.deviceList objectForKey:usn] == nil)
            {
                [self addDevice:[self getDeviceWithLocation:location usn:usn] forKey:usn];
            }
        });
    }
}



- (UpnpDeviceInfo *)getDeviceWithLocation:(NSString *)location usn:(NSString *)usn {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block UpnpDeviceInfo *deviceInfo = nil;
    
    NSURL *url = [NSURL URLWithString:location];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    request.HTTPMethod = @"GET";
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
        } else {
            if (response) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if ([httpResponse statusCode] == 200) {
                    deviceInfo = [[UpnpDeviceInfo alloc] init];
                    deviceInfo.Location = url.absoluteString;
                    deviceInfo.USN = usn;
                    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
                    GDataXMLElement *xmlEle = [xmlDoc rootElement];
                    NSArray *xmlArray = [xmlEle children];
                    for (int i = 0; i < [xmlArray count]; i++) {
                        GDataXMLElement *element = [xmlArray objectAtIndex:i];
                        if ([[element name] isEqualToString:@"device"]) {
                            continue;
                        }
                    }
                }
                
            }
        }
        
        dispatch_semaphore_signal(semaphore);
        
    }] resume];
    
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return deviceInfo;
}

- (void)addDevice:(UpnpDeviceInfo *)deviceInfo forKey:(NSString *)key {
    if (!deviceInfo) {
        return;
    }
    [self.deviceList setValue:deviceInfo forKey:key];
    [self onChange];
}

- (void)removeDeviceWithUSN:(NSString *)usn {
    
    [self.deviceList removeObjectForKey:usn];
    
    [self onChange];
}

- (NSString *)headerValueForKey:(NSString *)key withData:(NSString *)data {
    
    NSRange beginRange = [data rangeOfString:key options:NSCaseInsensitiveSearch];
    
    if (beginRange.location == NSNotFound) {
        return @"";
    }
    
    NSString *endString = [data.copy substringFromIndex:beginRange.location + beginRange.length];
    
    NSRange endRange = [endString rangeOfString:@"/r/n" options:NSCaseInsensitiveSearch];
    
    if (endRange.location == NSNotFound) {
        return @"";
    }
    
    endString = [[endString substringToIndex:endRange.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return endString;
    
}

@end
