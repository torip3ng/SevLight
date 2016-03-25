//
//  SVLHouse.h
//  SevLight
//
//  Created by Yaroslav Bulda on 06/12/15.
//  Copyright © 2015 torip3ng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVLHouseGeoData.h"

@interface SVLHouse : NSObject

@property (nonatomic, strong) SVLHouseGeoData *geoData;
@property (nonatomic) BOOL hasLight;

@end
