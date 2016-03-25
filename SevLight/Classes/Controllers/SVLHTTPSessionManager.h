//
//  SVLHTTPSessionManager.h
//  SevLight
//
//  Created by Yaroslav Bulda on 05/12/15.
//  Copyright © 2015 torip3ng. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#define SVLSharedHTTPSessionManager [SVLHTTPSessionManager sharedInstance]

@interface SVLHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

@end
