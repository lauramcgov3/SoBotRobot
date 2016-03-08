//
//  ViewController.h
//  HelloRomo
//

#import <UIKit/UIKit.h>
#import <RMCore/RMCore.h>
#import <RMCharacter/RMCharacter.h>
#import "AppDelegate.h"

#define INITIAL_HEAD_ANGLE 120.0


@interface ViewController : UIViewController <RMCoreDelegate>

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) UIButton *settings;


@end