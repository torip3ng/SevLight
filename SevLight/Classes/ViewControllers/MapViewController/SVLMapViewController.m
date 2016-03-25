//
//  SVLMapViewController.m
//  SevLight
//
//  Created by Yaroslav Bulda on 05/12/15.
//  Copyright © 2015 torip3ng. All rights reserved.
//

#import "SVLMapViewController.h"
#import "SVLMapViewModel.h"

@import GoogleMaps;

@interface SVLMapViewController ()

@property (nonatomic, strong) SVLMapViewModel *viewModel;

@property (nonatomic, strong) NSMutableArray *markers;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) UIBarButtonItem *refreshButton;

@property (nonatomic, strong) UIImage *bulbIconImg;
@property (nonatomic, strong) UIImage *candleIconImg;

@end

@implementation SVLMapViewController

#pragma mark -
#pragma mark Lifecycle methods

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _markers = [NSMutableArray array];
        _viewModel = [SVLMapViewModel new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Где свет?";
    
    self.mapView.padding = UIEdgeInsetsMake(64.f, 0.f, 50.f, 0.f);
    GMSCameraPosition *camPosition = [GMSCameraPosition cameraWithLatitude:44.5678 longitude:33.501577 zoom:12.0f];
    self.mapView.camera = camPosition;
    
    self.bulbIconImg = [UIImage imageNamed:@"bulbIcon"];
    self.candleIconImg = [UIImage imageNamed:@"candleIcon"];
    
    self.refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonHandler:)];
    self.navigationItem.rightBarButtonItem = self.refreshButton;
    
    @weakify(self);
    [self.viewModel.willUpdatedContentSignal subscribeNext:^(id x) {
        @strongify(self);
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicator startAnimating];
        
        UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
        [self.navigationItem setRightBarButtonItem:activityItem animated:YES];
    }];
    
    [self.viewModel.didUpdatedContentSignal subscribeNext:^(id x) {
        @strongify(self);
        [self updateMarkers];
        [self.navigationItem setRightBarButtonItem:self.refreshButton animated:YES];
    } error:^(NSError *error) {
        @strongify(self);
        [[[UIAlertView alloc] initWithTitle:@"Ошибка обновления :("
                                   message:error.localizedDescription
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil] show];
        
        [self.navigationItem setRightBarButtonItem:self.refreshButton animated:YES];
    }];
    
    RAC(self.dateLabel, text) = [RACObserve(self.viewModel, lastUpdatedDate) filter:^BOOL(NSString *value) {
        return value.length != 0;
    }];
    
    RAC(self.percentLabel, text) = [[RACObserve(self.viewModel, electroPercentage) filter:^BOOL(NSNumber *value) {
        return value.integerValue != -1;
    }] map:^id(NSNumber *value) {
        return [NSString stringWithFormat:@"%@%%", value];
    }];
    
    [self.viewModel reloadData];
}

#pragma mark -
#pragma mark IBActions 

- (void)refreshButtonHandler:(id)sender {
    [self.viewModel reloadData];
}

#pragma mark -
#pragma mark Private

- (void)updateMarkers {
    NSMutableSet *addedHouses = [NSMutableSet setWithCapacity:self.viewModel.houses.count];
    NSMutableArray *toRemoveMarkers = [NSMutableArray arrayWithCapacity:self.markers.count];
    
    for (GMSMarker *marker in self.markers) {
        SVLHouse *house = [self.viewModel.houses member:marker.userData];
        if (house) {
            [addedHouses addObject:house];
        } else {
            marker.userData = nil;
            marker.map = nil;
            
            [toRemoveMarkers addObject:marker];
        }
        
        marker.icon = house.hasLight ? self.bulbIconImg : self.candleIconImg;
    }
    [self.markers removeObjectsInArray:toRemoveMarkers];
    
    NSMutableSet *toAdd = [NSMutableSet setWithSet:self.viewModel.houses];
    [toAdd minusSet:addedHouses];
    
    for (SVLHouse *house in toAdd) {
        GMSMarker *marker = [GMSMarker markerWithPosition:house.geoData.coordinates];
        marker.groundAnchor = CGPointMake(0.5f, 0.5f);
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.flat = YES;
        marker.icon = house.hasLight ? self.bulbIconImg : self.candleIconImg;
        marker.map = self.mapView;
        marker.userData = house;
        
        [self.markers addObject:marker];
    }
}

@end
