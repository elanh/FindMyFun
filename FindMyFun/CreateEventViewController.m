//
//  CreateEventViewController.m
//  FindMyFun
//
//  Created by Elan Halpern on 6/6/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreateEventViewController.h"
#import "Event.h"
@import Firebase;

@interface CreateEventViewController ()
@property (weak, nonatomic) IBOutlet UITextField *eventTitleTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchPlacesButton;
@property (strong, nonatomic)FIRDatabaseReference *ref;



@end

@implementation CreateEventViewController
GMSAutocompleteFilter *_filter;
GMSPlace *eventLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];

    // Do any additional setup after loading the view.
}
- (IBAction)searchPlacesClicked:(UIButton *)sender {
    [self autocompleteClicked];
}

// Present the autocomplete view controller when the button is pressed.
- (void)autocompleteClicked {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    
    // Specify the place data types to return.
    GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldPlaceID);
    acController.placeFields = fields;
    
    // Specify a filter.
    _filter = [[GMSAutocompleteFilter alloc] init];
    _filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
    acController.autocompleteFilter = _filter;
    
    // Display the autocomplete view controller.
    [self presentViewController:acController animated:YES completion:nil];
}



- (IBAction)clickedSubmit:(UIButton *)sender {
    NSNumber *longitude = [NSNumber numberWithDouble:eventLocation.coordinate.longitude];
    NSNumber *latitude = [NSNumber numberWithDouble:eventLocation.coordinate.latitude];
    [[self.ref child:@"events"]
      setValue:@{
                 @"name": self->_eventTitleTextField.text,
                 @"longitude": longitude,
                 @"latitude": latitude,
                 }];
}

- (void)viewController:(nonnull GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(nonnull GMSPlace *)place { 
    [self dismissViewControllerAnimated:YES completion:nil];
    eventLocation = place;
    [self.searchPlacesButton setTitle:place.name forState:normal];
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place ID %@", place.placeID);
    NSLog(@"Place attributions %@", place.attributions.string);
}

- (void)viewController:(nonnull GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(nonnull NSError *)error { 
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

- (void)wasCancelled:(nonnull GMSAutocompleteViewController *)viewController { 
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
