//
//  RomoController.h
//  SoBotRobot
//
//  Created by Laura on 29/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RMCore/RMCore.h>
#import <RMCharacter/RMCharacter.h>
#import "AppDelegate.h"

#define INITIAL_HEAD_ANGLE 130.0


@interface RomoController : UIViewController <RMCoreDelegate>

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) UIButton *settings;
@property (nonatomic, strong) UIButton *speech;


@end

