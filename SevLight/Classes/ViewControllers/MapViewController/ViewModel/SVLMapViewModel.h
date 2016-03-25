//
//  SVLMapViewModel.h
//  SevLight
//
//  Created by Yaroslav Bulda on 05/12/15.
//  Copyright © 2015 torip3ng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVLHouse.h"

@interface SVLMapViewModel : NSObject

@property (nonatomic, strong, readonly) NSSet *houses;

@property (nonatomic, readonly) NSInteger electroPercentage;
@property (nonatomic, strong, readonly) NSString *lastUpdatedDate;

@property (nonatomic, strong, readonly) RACSubject *willUpdatedContentSignal;
@property (nonatomic, strong, readonly) RACSubject *didUpdatedContentSignal;

- (void)reloadData;

@end
