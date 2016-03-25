//
//  SVLMapViewModel.m
//  SevLight
//
//  Created by Yaroslav Bulda on 05/12/15.
//  Copyright © 2015 torip3ng. All rights reserved.
//

#import "SVLMapViewModel.h"
#import "SVLHousesGeoDataLoader.h"

#import "SVLHTTPSessionManager.h"

@interface SVLMapViewModel ()

@property (nonatomic, strong) NSSet *houses;
@property (nonatomic, strong) NSSet *housesGeoData;
@property (nonatomic, strong) NSString *lastUpdatedDate;
@property (nonatomic) NSInteger electroPercentage;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) RACSubject *willUpdatedContentSignal;
@property (nonatomic, strong) RACSubject *didUpdatedContentSignal;

@end

@implementation SVLMapViewModel

#pragma mark -
#pragma mark Lifecycle methods

- (instancetype)init {
    self = [super init];
    if (self) {
        _housesGeoData = [SVLHousesGeoDataLoader loadHousesGeoData];
        _houses = [NSSet set];
        _electroPercentage = -1;
        
        _didUpdatedContentSignal = [[RACSubject subject] setNameWithFormat:@"SVLMapViewModel didUpdatedContentSignal"];
        _willUpdatedContentSignal = [[RACSubject subject] setNameWithFormat:@"SVLMapViewModel willUpdatedContentSignal"];
        
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
        _dateFormatter.dateStyle = NSDateFormatterShortStyle;
    }
    return self;
}

#pragma mark -
#pragma mark Manage

- (void)reloadData {
    NSUInteger timestamp = (NSUInteger)(NSDate.date.timeIntervalSince1970 * 1000.f);
    NSString *route = [NSString stringWithFormat:@"http://sevstar.net/map/houses.js?_=%lui",(unsigned long)timestamp];
    
    [self.willUpdatedContentSignal sendNext:@YES];
    
    @weakify(self);
    [SVLSharedHTTPSessionManager GET:route
                          parameters:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                 @strongify(self);
                                 NSString *temp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                 temp = [temp stringByReplacingOccurrencesOfString:@"sevstar_coverage_map.houses_states = "
                                                                                        withString:@""];
                                 NSString *jsonString = [temp substringToIndex:temp.length-(temp.length>0)];
                                 NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                 
                                 NSError *error = nil;
                                 NSDictionary *info = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                      options:kNilOptions
                                                                                        error:&error];
                                 if (error) {
                                     [self.didUpdatedContentSignal sendError:error];
                                     return;
                                 }
                                 
                                 [self updateHouses:info];
                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 @strongify(self);
                                 [self.didUpdatedContentSignal sendNext:error];
                             }];
}

#pragma mark -
#pragma mark Private 

- (void)updateHouses:(NSDictionary *)info {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableSet *tHouses = [NSMutableSet set];
        
        NSInteger hasLightCount = 0;
        
        for (NSString *address in info.allKeys) {
            SVLHouse *house = [self.houses member:address];
            
            if (house) {
                [tHouses addObject:house];
            } else {
                SVLHouseGeoData *geodata = [self.housesGeoData member:address];
                
                if (!geodata) {
                    continue;
                }
                
                house = [SVLHouse new];
                house.geoData = geodata;
                
                [tHouses addObject:house];
            }
            if (house) {
                house.hasLight = ![info[address] boolValue];
                if (house.hasLight) {
                    hasLightCount++;
                }
            }
        }
        
        self.houses = tHouses.copy;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.electroPercentage = (NSUInteger)(hasLightCount / (float)self.houses.count * 100.f);
            
            self.updatedDate = [NSDate date];
            self.lastUpdatedDate = [self.dateFormatter stringFromDate:self.updatedDate];
            [self.didUpdatedContentSignal sendNext:@YES];
        });
    });
}

@end
