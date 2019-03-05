//
//  LocationHelper.m
//  Pods
//
//  Created by Arcus Team on 10/2/15.
//
//

#import <i2app-Swift.h>
#import "LocationHelper.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationHelper () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end


@implementation LocationHelper {
    LocationCompletionSuccessBlock    _successBlock;
    LocationCompletionFailureBlock    _failureBlock;
}

- (void)startLocationManagerWithBlock:(LocationCompletionSuccessBlock)successBlock
                     withFailureBlock:(LocationCompletionFailureBlock)failureBlock {
    _successBlock = successBlock;
    _failureBlock = failureBlock;

    // Create the core location manager object
    _locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager setDelegate:self];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        _failureBlock([NSError errorWithDomain:@"Arcus" code:202 userInfo:@{NSLocalizedDescriptionKey : @"You have denied access to location services."}]);
        return;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
        
        [_locationManager startUpdatingLocation];
    }
    else {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||
            [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [_locationManager startUpdatingLocation];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [_locationManager stopUpdatingLocation];
    
    _successBlock(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a
    // timeout that will stop the location manager to save power.
    //
    _failureBlock(error);
}


@end
