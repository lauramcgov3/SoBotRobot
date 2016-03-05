//
//  AppDelegate.h
//  Sobot
//  Laura McGovern
//

#import <UIKit/UIKit.h>
#import "MCManager.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *romoController;
@property (nonatomic, strong) MCManager *mcManager;

@end
