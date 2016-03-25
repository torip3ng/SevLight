//
//  SVLHTTPSessionManager.m
//  SevLight
//
//  Created by Yaroslav Bulda on 05/12/15.
//  Copyright © 2015 torip3ng. All rights reserved.
//

#import "SVLHTTPSessionManager.h"
#import "GCDSingleton.h"
#import <AFNetworkActivityIndicatorManager.h>

@implementation SVLHTTPSessionManager

#pragma mark -
#pragma mark Session config

+ (NSURLSessionConfiguration *)sessionConfig {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 60.f;
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    config.allowsCellularAccess = YES;
    return config;
}

#pragma mark -
#pragma mark Singletone

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [self manager];
    });
}

+ (instancetype)manager {
    return [[self alloc] initWithBaseURL:nil sessionConfiguration:[self sessionConfig]];
}

#pragma mark -
#pragma mark Lifecycle methods

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    return self;
}

@end
