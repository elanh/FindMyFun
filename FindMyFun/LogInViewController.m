//
//  ViewController.m
//  FindMyFun
//
//  Created by Elan Halpern on 6/6/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

#import "LogInViewController.h"
@import Firebase;

@interface LogInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;
@property (strong, nonatomic)FIRDatabaseReference *ref;

@end

@implementation LogInViewController

- (void)viewWillAppear:(BOOL)animated {
    self.handle = [[FIRAuth auth]
                   addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
                       // ...
                   }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];

    // Do any additional setup after loading the view.
}

- (IBAction)clickedSignUpButton:(UIButton *)sender {
    [[FIRAuth auth] createUserWithEmail:_emailTextField.text
                               password:_passwordTextField.text
                             completion:^(FIRAuthDataResult * _Nullable authResult,
                                          NSError * _Nullable error) {
                                 if (authResult) {
                                     [self performSegueWithIdentifier:@"goToHome" sender:self];
                                     [[[self.ref child:@"users"] child:authResult.user.uid]
                                      setValue:@{@"email": self->_emailTextField.text}];
                                 }
                                 else {
                                     NSLog(@"Error! %@", error);
                                 }
                             }];

}

- (IBAction)clickedLoginButton:(UIButton *)sender {
    [[FIRAuth auth] signInWithEmail:self->_emailTextField.text
                           password:self->_passwordTextField.text
                         completion:^(FIRAuthDataResult * _Nullable authResult,
                                      NSError * _Nullable error) {
                             if (authResult) {
                                 [self performSegueWithIdentifier:@"goToHome" sender:self];

                             }
                             else {
                                 NSLog(@"Error! %@", error);
                             }
                         }];
}

@end
