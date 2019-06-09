//
//  CreateEventViewController.m
//  FindMyFun
//
//  Created by Elan Halpern on 6/6/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreateEventViewController.h"

@interface CreateEventViewController ()
@property (weak, nonatomic) IBOutlet UITextField *eventTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventLocationTextField;

@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)clickedSubmit:(UIButton *)sender {
    // create event object using text field info
    // send event obj to database
}

@end
