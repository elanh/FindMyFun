//
//  HomeViewController.m
//  FindMyFun
//
//  Created by Elan Halpern on 6/9/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeViewController.h"
#import <INTULocationManager/INTULocationManager.h>
@import Firebase;

@interface HomeViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property UIAlertController * alert;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    // Do any additional setup after loading the view.
    
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    
    // The block will execute indefinitely (even across errors, until canceled), once for every new updated location regardless of its accuracy.
    [locMgr subscribeToLocationUpdatesWithDesiredAccuracy:INTULocationAccuracyHouse
                                                    block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                                        if (status == INTULocationStatusSuccess) {
                                                            // A new updated location is available in currentLocation, and achievedAccuracy indicates how accurate this particular location is.
                                                            NSLog(@"%@", currentLocation);
                                                            
                                                            NSNumber *longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
                                                            NSNumber *latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
                                                            
                                                            NSLog(@" longitude %@", longitude);
                                                            NSLog(@" latitude %@", latitude);
                                                            
                                                            if ([FIRAuth auth].currentUser) {
                                                                // User is signed in.
                                                                [[[self.ref child:@"users"] child:[FIRAuth auth].currentUser.uid]
                                                                 setValue:@{@"longitude": longitude}];
                                                                [[[self.ref child:@"users"] child:[FIRAuth auth].currentUser.uid]
                                                                 setValue:@{@"latitude": latitude}];
                                                                [self checkIfUserLocationMatchesEvent:longitude :latitude];
                                                                
                                                            } else {
                                                                // No user is signed in.
                                                                // ...
                                                            }
                                                        }
                                                        else {
                                                            // An error occurred, more info is available by looking at the specific status returned. The subscription has been kept alive.
                                                            NSLog(@"Error");
                                                        }
                                                    }];

}

- (void)addUserToEventList: (NSString*) eventName {
    NSArray *userList = @[[FIRAuth auth].currentUser.email];

    [[_ref child:@"events"]
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
         // Loop over children
         NSEnumerator *children = [snapshot children];
         FIRDataSnapshot *child;
         while (child = [children nextObject]) {
             if ([child.value[@"name"] isEqualToString:eventName]) {
                 [[[self.ref child:@"events"] child:child.key]
                  setValue:@{@"userList": userList}];
             }
         }
     }];
}


- (void)alertUserCheckIn:(NSString*) eventName {
    // set up alert controller
    _alert = [UIAlertController
              alertControllerWithTitle:@"Event Arrival"
              message:[NSString stringWithFormat:@"Would you like to check in to %@", eventName]
              preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [self addUserToEventList:eventName];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Don't add user
                               }];
    
    //Add your buttons to alert controller
    
    [_alert addAction:yesButton];
    [_alert addAction:noButton];
    if (self.presentedViewController != _alert) {
        [self presentViewController:_alert animated:NO completion:nil];
    } else {
        NSLog(@"Already presented TZImagePickerController");
    }
    
}

- (void)checkIfUserLocationMatchesEvent:(NSNumber*) userLongitude : (NSNumber*) userLatitude {
    [[_ref child:@"events"]
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
         // Loop over children
         NSEnumerator *children = [snapshot children];
         FIRDataSnapshot *child;
         while (child = [children nextObject]) {
             NSNumber *eventLongitude = child.value[@"longitude"];
             NSNumber *eventLatitude = child.value[@"latitude"];
             if ([eventLatitude isEqual:userLatitude]  && [eventLongitude isEqual:userLongitude]) {
                 NSLog(@"We have a match!");
                 [self alertUserCheckIn:child.value[@"name"]];
             }
             NSLog(@" Event longitude %@", eventLongitude);
             NSLog(@" Event latitude %@", eventLatitude);
         }
     }];
}


@end
