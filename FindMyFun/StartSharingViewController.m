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
@property UIAlertController * alert;

@end

@implementation StartSharingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    // Do any additional setup after loading the view.
}



- (IBAction)clickedStartSharingButton:(id)sender {
    // go to home view controller

}


@end
