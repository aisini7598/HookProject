//
//  PFHostSwitcherURLProtocol.m
//  PFastCalculation
//
//  Created by Aslan on 7/6/16.
//  Copyright © 2016 Knowin. All rights reserved.
//


#import "PFHostSwitcherURLProtocol.h"
#import <objc/runtime.h>

@interface PFHostSwitcherURLProtocol ()

@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation PFHostSwitcherURLProtocol

+ (void)registerProtocol {
    [NSURLProtocol registerClass:[PFHostSwitcherURLProtocol class]];
}

+ (NSURLSessionConfiguration *)pfDefaultSessionConfiguration{
    NSURLSessionConfiguration *configuration = [PFHostSwitcherURLProtocol pfDefaultSessionConfiguration];
    NSArray *protocolClasses = @[[PFHostSwitcherURLProtocol class]];
    configuration.protocolClasses = protocolClasses;
    return configuration;
}

+ (void)load{
    Method systemMethod = class_getClassMethod([NSURLSessionConfiguration class], @selector(defaultSessionConfiguration));
    Method pfMethod = class_getClassMethod([self class], @selector(pfDefaultSessionConfiguration));
    method_exchangeImplementations(systemMethod, pfMethod);
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return ![[NSURLProtocol propertyForKey:@"PFHostSwitcherProcessed" inRequest:request] boolValue];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    NSMutableURLRequest *request = [self.request mutableCopy];
//    request.URL = [[NSURL alloc] initWithString:[[self class] switchedRequestURLString:[request.URL absoluteString]]];
    [NSURLProtocol setProperty:@YES forKey:@"PFHostSwitcherProcessed" inRequest:request];
    
    NSLog(@"___actual___url__%@",request.URL.absoluteString);
    
    self.connection = [NSURLConnection connectionWithRequest:[request copy] delegate:self];
}

- (void)stopLoading
{
    [self.connection cancel];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.client URLProtocol:self didFailWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    if (response != nil) {
        // for redirect requests
        [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
        return nil;
    }
    return request;
}

//+ (NSString *)switchedRequestURLString:(NSString *)requestURLString
//{
//    NSArray *modelSwitchItems = [PFSwitchHostRegistrar modelSwitchItems];
//    NSArray *matchedItems =  [modelSwitchItems filter:^BOOL(PFModelSwitchItem *object, NSUInteger index) {
//        return [requestURLString rangeOfString:object.original].length > 0;
//    }];
//    PFModelSwitchItem *optimalItem = [matchedItems reduce:^id(PFModelSwitchItem *accumulated, PFModelSwitchItem *object) {
//        return object.original.length > accumulated.original.length ? object : accumulated;
//    }];
//    if (optimalItem.current.length > 0) {
//        NSString *replacedRequestURLString = [requestURLString stringByReplacingOccurrencesOfString:optimalItem.original withString:optimalItem.current];
//        return replacedRequestURLString;
//    }
//    return requestURLString;
//}

+ (NSString *)switchedURLString:(NSString *)URLString
{
//    return [[self class] switchedRequestURLString:URLString];
    return @"";
}

@end

