//
//  StartSharingViewController.m
//  FindMyFun
//
//  Created by Elan Halpern on 6/6/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StartSharingViewController.h"
#import <INTULocationManager/INTULocationManager.h>
@import Firebase;

@interface StartSharingViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation StartSharingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    // Do any additional setup after loading the view.
}

- (void)checkIfUserLocationMatchesEvent:(NSNumber*) userLongitude : (NSNumber*) userLatitude {
    
}

- (IBAction)clickedStartSharingButton:(id)sender {
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
                                                            
                                                            
                                                            /*
                                                             
                                                             */
                                                    
                                                            // Check if the currentLocation matches an event location
                                                            // if so, check if user.locationstatus != nil then compare user.locationstatus to currentlocation
                                                                // if user.locationstatus == currentlocation do nothing
                                                                // otherwise update user location doing steps below
                                                            // if user.locationstatus == nil or if the user moves to a different event location alert the user and ask them to check in at the Event Name
                                                            // If they say yes then add their name to list of atendees at Event
                                                            // update the user.locationstatus to hold the location
                                                            // If they say no then do nothing
                                                        }
                                                        else {
                                                            // An error occurred, more info is available by looking at the specific status returned. The subscription has been kept alive.
                                                            NSLog(@"Error");
                                                        }
                                                    }];
}


@end
