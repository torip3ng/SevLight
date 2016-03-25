//
//  SVLHouse.m
//  SevLight
//
//  Created by Yaroslav Bulda on 06/12/15.
//  Copyright © 2015 torip3ng. All rights reserved.
//

#import "SVLHouse.h"

@implementation SVLHouse

- (NSString *)description {
    return self.geoData.address;
}

- (BOOL)isEqual:(id)object {
    return [self.geoData isEqual:object];
}

- (NSUInteger)hash {
    return self.geoData.hash;
}

@end
