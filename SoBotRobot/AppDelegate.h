//
//  AppDelegate.h
//  SoBotRobot
//
//  Created by Laura on 29/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCManager.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIViewController *romoController;
@property (nonatomic, strong) MCManager *mcManager;


@end

