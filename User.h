//
//  User.h
//  FindMyFun
//
//  Created by Elan Halpern on 6/7/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (nonatomic, strong) *NSString name;
@property *CLLocation locationStatus;

@end
