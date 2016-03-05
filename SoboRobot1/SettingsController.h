//
//  SettingsController.h
//  SobotGame
//
//  Created by Laura on 29/02/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "AppDelegate.h"

@interface SettingsController : UIViewController <MCBrowserViewControllerDelegate>

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) UIButton *button_browseForDevices;

@end
