//
//  SVLHousesLoader.m
//  SevLight
//
//  Created by Yaroslav Bulda on 05/12/15.
//  Copyright © 2015 torip3ng. All rights reserved.
//

#import "SVLHousesGeoDataLoader.h"
#import "SVLHouseGeoData.h"

@implementation SVLHousesGeoDataLoader

+ (NSSet *)loadHousesGeoData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"geoData" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    NSArray *geoDataObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    NSMutableSet *temp = [NSMutableSet setWithCapacity:geoDataObjects.count];
    
    for (NSArray *geoDataObject in geoDataObjects) {
        NSInteger type = [geoDataObject[2] integerValue];
        
        if ((type >= 0 && type <= 3) || type == 5 || type == 43) {
            SVLHouseGeoData *house = [SVLHouseGeoData houseGeoDataWithGeoObj:geoDataObject];
            [temp addObject:house];
        }
    }
    
    return temp.copy;
}

@end
