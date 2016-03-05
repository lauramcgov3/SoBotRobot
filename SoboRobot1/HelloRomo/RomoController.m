//
//  ViewController.m
//  HelloRomo
//

#import "RomoController.h"
#import <RMCore/RMCore.h>
#import <RMCharacter/RMCharacter.h>
#import "SettingsController.h"
#import "Macros.h"

@interface ViewController ()

//@property (nonatomic, strong) SettingsController *settingsView;
@property (nonatomic, strong) RMCoreRobotRomo3 *Romo3;
@property (nonatomic, strong) RMCharacter *Romo;

- (void)addGestureRecognizers;

@end

@implementation ViewController

#pragma mark - View Management
- (void)viewDidLoad
{
    //[self.navigationController setNavigationBarHidden:YES];
    [super viewDidLoad];
    
    // To receive messages when Robots connect & disconnect, set RMCore's delegate to self
    [RMCore setDelegate:self];
    
    // Grab a shared instance of the Romo character
    self.Romo = [RMCharacter Romo];
    [RMCore setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:NOTIFICATION_MC_DID_RECEIVE_DATA
                                               object:nil];
    
    [self addGestureRecognizers];
    
//    self.settings = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.settings setFrame:CGRectMake(270.0, 30.0, 40.0, 40.0)];
//    UIImage *buttonImage = [UIImage imageNamed:@"settings.png"];
//    self.settings.layer.cornerRadius = 10;
//    self.settings.clipsToBounds = YES;
//    [self.settings addTarget:self
//                      action:@selector(settingsButton)
//            forControlEvents:UIControlEventTouchUpInside];
//    [self.settings setImage:buttonImage forState:UIControlStateNormal];
//    [self.view addSubview:self.settings];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // Add Romo's face to self.view whenever the view will appear
    [self.Romo addToSuperview:self.view];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    self.settings = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.settings setFrame:CGRectMake(270.0, 30.0, 40.0, 40.0)];
    UIImage *buttonImage = [UIImage imageNamed:@"settings.png"];
    self.settings.layer.cornerRadius = 10;
    self.settings.clipsToBounds = YES;
    [self.settings addTarget:self
                      action:@selector(settingsButton:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.settings setImage:buttonImage forState:UIControlStateNormal];
    [self.view addSubview:self.settings];
    
}

#pragma mark - RMCoreDelegate Methods
- (void)robotDidConnect:(RMCoreRobot *)robot
{
    // Currently the only kind of robot is Romo3, so this is just future-proofing
    if ([robot isKindOfClass:[RMCoreRobotRomo3 class]]) {
        self.Romo3 = (RMCoreRobotRomo3 *)robot;
        
        // Change Romo's LED to be solid at 80% power
        [self.Romo3.LEDs setSolidWithBrightness:0.8];
        
        // When you plug Romo in, he gets excited
        self.Romo.expression = RMCharacterExpressionExcited;
    }
    
    self.settings.hidden= YES;
}

- (void)robotDidDisconnect:(RMCoreRobot *)robot
{
    self.settings.hidden=NO;
    if (robot == self.Romo3) {
        self.Romo3 = nil;
        
        // When you unplug Romo in, he gets sad
        self.Romo.expression = RMCharacterExpressionSad;
    }
}

#pragma mark - Gesture recognizers

- (void)addGestureRecognizers
{
    // Let's start by adding some gesture recognizers with which to interact with Romo
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedUp:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    UITapGestureRecognizer *tapReceived = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScreen:)];
    [self.view addGestureRecognizer:tapReceived];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2; //Adds double table
    [self.view addGestureRecognizer:doubleTap];
}


- (void)swipedLeft:(UIGestureRecognizer *)sender
{
    // When the user swipes left, Romo will turn in a circle to his left
    [self.Romo3 driveWithRadius:-1.0 speed:1.0];
    sleep(3);
    [self.Romo3 stopDriving];

}

- (void)swipedRight:(UIGestureRecognizer *)sender
{
    // When the user swipes right, Romo will turn in a circle to his right
    [self.Romo3 driveWithRadius:1.0 speed:1.0];
}

// Swipe up
- (void)swipedUp:(UIGestureRecognizer *)sender
{
    // Tilt up by ten degrees
    float tiltByAngleInDegrees = 10.0;
     
    [self.Romo3 tiltByAngle:tiltByAngleInDegrees
                  completion:^(BOOL success) {
                  }];
}

// Swipe down
- (void)swipedDown:(UIGestureRecognizer *)sender
{
    // Tilt up by ten degrees
    float tiltByAngleInDegrees = -10.0;
    
    [self.Romo3 tiltByAngle:tiltByAngleInDegrees
                 completion:^(BOOL success) {
                 }];
}

// Simply tap the screen to stop Romo
- (void)tappedScreen:(UIGestureRecognizer *)sender
{
    [self.Romo3 stopDriving];
}

- (void)doubleTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized)
    {
        // Constants for the number of expression & emotion enum values
        int numberOfExpressions = 28;
        int numberOfEmotions = 7;
        
        // Choose a random expression from 1 to numberOfExpressions
        RMCharacterExpression randomExpression = 1 + (arc4random() % numberOfExpressions);
        
        // Choose a random expression from 1 to numberOfEmotions
        RMCharacterEmotion randomEmotion = 1 + (arc4random() % numberOfEmotions);
        
        [self.Romo setExpression:randomExpression withEmotion:randomEmotion];
    }
}

-(void)match
{
    [self.Romo3 driveForwardWithSpeed:0.5];
    [self.Romo setExpression:RMCharacterExpressionExcited withEmotion:RMCharacterEmotionHappy];
    sleep(1);
    [self.Romo3 stopDriving];
}

-(void)mismatch
{
    [self.Romo3 driveBackwardWithSpeed:0.5];
    [self.Romo setExpression:RMCharacterExpressionLetDown withEmotion:RMCharacterEmotionHappy];
    sleep(1);
    [self.Romo3 stopDriving];
}

-(void)winner
{
    [self.Romo3 driveWithRadius:1.0 speed:1.5];
    [self.Romo setExpression:RMCharacterExpressionYippee withEmotion:RMCharacterEmotionHappy];
    sleep(3);
    [self.Romo3 stopDriving];
}

-(IBAction)settingsButton:(id)sender
{
    NSLog(@"SETTINGS");
    
    //UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    
    //SettingsController *settingsController = [[SettingsController alloc] initWithNibName:nil bundle:nil];
    
    SettingsController *settingsController = [[UIStoryboard storyboardWithName:@"Settings" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:settingsController animated:YES];
    
    
}

- (void) didReceiveDataWithNotification:(NSNotification *)notification
{
    MCPeerID *peerID = [[notification userInfo]objectForKey:SESSION_KEY_PEER_ID];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo]objectForKey:SESSION_KEY_DATA];
    NSString *receivedMessage = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"peerDisplayName = %@", peerDisplayName);
    NSLog(@"receivedMessage = %@", receivedMessage);
    
    NSString *match = @"match";
    NSString *mismatch = @"mismatch";
    NSString *winner = @"winner";
    
    
    [[NSOperationQueue mainQueue]addOperationWithBlock:
     ^{
         
         if ([receivedMessage isEqualToString:match]) {
             NSLog(@"Matching strings");
             [self match];
         }
         else if ([receivedMessage isEqualToString:mismatch])
         {
             NSLog(@"Mismatching strings");
             [self mismatch];
         }
         else if ([receivedMessage isEqualToString:winner])
         {
             [self winner];
         }
    }];
    
    
}


@end
