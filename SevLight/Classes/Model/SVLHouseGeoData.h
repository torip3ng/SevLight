//
//  SVLHouse.h
//  SevLight
//
//  Created by Yaroslav Bulda on 05/12/15.
//  Copyright © 2015 torip3ng. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GoogleMaps;

@interface SVLHouseGeoData : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic) CLLocationCoordinate2D coordinates;

+ (instancetype)houseGeoDataWithGeoObj:(NSArray *)geoObj;

@end
