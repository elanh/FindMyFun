//
//  HomeViewController.h
//  FindMyFun
//
//  Created by Elan Halpern on 6/9/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface HomeViewController : UIViewController <UIAlertViewDelegate> 

- (void)checkIfUserLocationMatchesEvent:(NSNumber*) userLongitude : (NSNumber*) userLatitude;

- (void)alertUserCheckIn;


@end
