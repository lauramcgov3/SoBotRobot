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
- (void)resetTilt;

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
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // Add Romo's face to self.view whenever the view will appear
    [self.Romo addToSuperview:self.view];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    self.settings = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.settings setFrame:CGRectMake(260.0, 30.0, 50.0, 50.0)];
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

}



-(void)match
{
    [self.Romo setExpression:RMCharacterExpressionExcited withEmotion:RMCharacterEmotionHappy];
    [self.Romo3 driveForwardWithSpeed:1.0];
    sleep(1);
    [self.Romo3 stopDriving];
}

-(void)mismatch
{

    float tiltByAngleInDegrees = 80.0;
    [self.Romo setExpression:RMCharacterExpressionLetDown withEmotion:RMCharacterEmotionHappy];
    [self.Romo3 tiltToAngle:tiltByAngleInDegrees
                 completion:^(BOOL success) {
                     sleep(1);
                     [self resetTilt];
                 }];
}

-(void) resetTilt
{
    [self.Romo3 tiltToAngle:INITIAL_HEAD_ANGLE
                 completion:^(BOOL success) {
                 }];
}

-(void)winner
{
    [self.Romo3 driveWithRadius:1.0 speed:2.0];
    [self.Romo setExpression:RMCharacterExpressionYippee withEmotion:RMCharacterEmotionHappy];
    sleep(4);
    [self.Romo3 stopDriving];
}

-(void) happy
{
    [self.Romo setExpression:RMCharacterExpressionHappy withEmotion:RMCharacterEmotionHappy];
}

-(void) excited
{
    [self.Romo setExpression:RMCharacterExpressionExcited withEmotion:RMCharacterEmotionExcited];
}

-(void) sad
{
    [self.Romo setExpression:RMCharacterExpressionSad withEmotion:RMCharacterEmotionSad];
}

-(void) angry
{
    [self.Romo setExpression:RMCharacterExpressionAngry withEmotion:RMCharacterEmotionBewildered];
}

-(void) confused
{
    [self.Romo setExpression:RMCharacterExpressionBewildered withEmotion:RMCharacterEmotionBewildered];
}

-(void) tired
{
    [self.Romo setExpression:RMCharacterExpressionSleepy withEmotion:RMCharacterEmotionSleepy];
}

-(void) bored
{
    [self.Romo setExpression:RMCharacterExpressionBored withEmotion:RMCharacterEmotionIndifferent];
}

-(void) afraid
{
    [self.Romo setExpression:RMCharacterExpressionScared withEmotion:RMCharacterEmotionScared];
}


-(IBAction)settingsButton:(id)sender
{
    
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
         
        if ([receivedMessage isEqualToString:winner])
         {
             [self winner];
         }
         else if ([receivedMessage isEqualToString:match]) {
             [self match];
         }
         else if ([receivedMessage isEqualToString:mismatch])
         {
             [self mismatch];
         }
         else if ([receivedMessage isEqualToString:@"happy"])
         {
             [self happy];
         }
         else if ([receivedMessage isEqualToString:@"excited"])
         {
             [self excited];
         }
         else if ([receivedMessage isEqualToString:@"sad"])
         {
             [self sad];
         }
         else if ([receivedMessage isEqualToString:@"angry"])
         {
             [self angry];
         }
         else if ([receivedMessage isEqualToString:@"confused"])
         {
             [self confused];
         }
         else if ([receivedMessage isEqualToString:@"tired"])
         {
             [self tired];
         }
         else if ([receivedMessage isEqualToString:@"bored"])
         {
             [self bored];
         }
         else if ([receivedMessage isEqualToString:@"afraid"])
         {
             [self afraid];
         }
    }];
    
    
}


@end
