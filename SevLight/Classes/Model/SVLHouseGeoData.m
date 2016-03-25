//
//  SVLHouse.m
//  SevLight
//
//  Created by Yaroslav Bulda on 05/12/15.
//  Copyright © 2015 torip3ng. All rights reserved.
//

#import "SVLHouseGeoData.h"

@implementation SVLHouseGeoData

+ (instancetype)houseGeoDataWithGeoObj:(NSArray *)geoObj {
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake([geoObj[1] floatValue], [geoObj[0] floatValue]);
    
    SVLHouseGeoData *house = [self new];
    
    house.coordinates = coordinates;
    house.address = geoObj[3];
    
    return house;
}

- (BOOL)isEqual:(id)object {
    return [self.address isEqualToString:object];
}

- (NSUInteger)hash {
    return self.address.hash;
}

@end
