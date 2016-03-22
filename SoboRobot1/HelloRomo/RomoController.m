//
//  ViewController.m
//  HelloRomo
//

#import <AVFoundation/AVFoundation.h>
#import "AVCaptureMultipeerVideoDataOutput.h"
#import "RomoController.h"
#import <RMCore/RMCore.h>
#import <RMCharacter/RMCharacter.h>
#import "SettingsController.h"
#import "Macros.h"



@interface ViewController ()
{
    AVCaptureSession *_captureSession;
}

//@property (nonatomic, strong) SettingsController *settingsView;
@property (nonatomic, strong) RMCoreRobotRomo3 *Romo3;
@property (nonatomic, strong) RMCharacter *Romo;


@property NSString *question;
@property NSString *sentence;
@property NSString *talk;
@property NSString *word;
@property NSString *remoteCommand;
@property NSString *xCoord;
@property NSString *yCoord;

- (void)addGestureRecognizers;
- (void)resetTilt;

@end

@implementation ViewController

static bool isForward = false;
static bool isBackward = false;

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
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:NOTIFICATION_MC_DID_RECEIVE_DATA
                                               object:nil];
    

    
    [self addGestureRecognizers];
    
    
}

- (void) videoSession
{
    // Create the AVCaptureSession
    _captureSession = [[AVCaptureSession alloc] init];
    
    // Setup the preview view
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    NSLog(@"Display the preview layer");
    
    CGRect layerRect = [[[self view] layer] bounds];
    [captureVideoPreviewLayer setBounds:layerRect];
    [captureVideoPreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                      CGRectGetMidY(layerRect))];
    CGRect applicationFrame = [[UIScreen mainScreen] nativeBounds];
    UIView *newView = [[UIView alloc] initWithFrame:applicationFrame];
    [[self view] addSubview:newView];
    [self.view sendSubviewToBack:newView];
    [[newView layer] addSublayer:captureVideoPreviewLayer];
    captureVideoPreviewLayer.hidden = YES;
    //[self.view.layer addSublayer:captureVideoPreviewLayer];
    
    // Create video device input
    AVCaptureDevice *videoDevice = [self frontCamera];
    
    if (videoDevice) {
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        [_captureSession addInput:videoDeviceInput];
        
        // Create output
        AVCaptureMultipeerVideoDataOutput *multipeerVideoOutput = [[AVCaptureMultipeerVideoDataOutput alloc] initWithDisplayName:[[UIDevice currentDevice] name] withAssistant:NO];
        
        [_captureSession addOutput:multipeerVideoOutput];
        
        [self setFrameRate:15 onDevice:videoDevice];
        
        [_captureSession startRunning];
    } else {
        
        NSLog(@"Else");
    }
}

- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Add Romo's face to self.view whenever the view will appear
    [self.Romo addToSuperview:self.view];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    self.settings = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.settings setFrame:CGRectMake(260.0, 30.0, 50.0, 50.0)];
    UIImage *buttonImage = [UIImage imageNamed:@"romo-setting.png"];
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
        [self.Romo setExpression:RMCharacterExpressionTalking];
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
    [self.Romo3 driveWithLeftMotorPower:-3.0 rightMotorPower:3.0];
    [NSThread sleepForTimeInterval:0.2f];
    [self.Romo3 driveWithLeftMotorPower:3.0 rightMotorPower:-3.0];
    [NSThread sleepForTimeInterval:0.2f];
    [self.Romo3 driveWithLeftMotorPower:-3.0 rightMotorPower:3.0];
    [NSThread sleepForTimeInterval:0.2f];
    [self.Romo3 driveWithLeftMotorPower:3.0 rightMotorPower:-3.0];
    [NSThread sleepForTimeInterval:0.2f];
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
    return;
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

-(void) speechBubbleForAsk
{
    [self speechBubble];
    [self.Romo setExpression:RMCharacterExpressionTalking withEmotion:RMCharacterEmotionHappy];
    [self.Romo3 driveForwardWithSpeed:1.0];
    [NSThread sleepForTimeInterval:0.1f];
    [self.Romo3 stopDriving];
    [self sendMessage:self.question];
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(removeSpeechBubble)
                                   userInfo:nil
                                    repeats:NO];
    
}

-(void) speechBubbleForTalk
{
    [self speechBubble];
    [self.Romo setExpression:RMCharacterExpressionTalking withEmotion:RMCharacterEmotionHappy];
    [self.Romo3 driveForwardWithSpeed:1.0];
    [NSThread sleepForTimeInterval:0.1f];
    [self.Romo3 stopDriving];
    [self sendMessage:self.talk];
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(removeSpeechBubble)
                                   userInfo:nil
                                    repeats:NO];
    
}

- (void) speechBubble
{
    self.speech = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.speech setFrame:CGRectMake(50.0, 400.0, 200.0, 85.0)];
    UIImage *buttonImage = [UIImage imageNamed:@"speech-bubble.png"];
    self.speech.layer.cornerRadius = 10;
    self.speech.clipsToBounds = YES;
    [self.speech addTarget:self
                    action:@selector(settingsButton:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.speech setImage:buttonImage forState:UIControlStateNormal];
    [self.view addSubview:self.speech];
    return;
}

- (void) removeSpeechBubble
{
    self.speech.hidden = YES;
}

- (void) talkReaction
{
    NSLog(@"Self word: %@", self.word);
    
    if ([self.word isEqualToString:@"run"])
    {
        [self.Romo setExpression:RMCharacterExpressionProud];
        [self.Romo3 driveWithPower:2.0];
        [NSThread sleepForTimeInterval:2.0f];
        [self.Romo3 stopDriving];
        [self done];
        
    }
    else if ([self.word isEqualToString:@"hate"])
    {
        [self.Romo setExpression:RMCharacterExpressionStartled];
        [self.Romo3 driveBackwardWithSpeed:1.0];
        [NSThread sleepForTimeInterval:0.5];
        [self.Romo3 stopDriving];
        [self done];
    }
    else if ([self.word isEqualToString:@"love"])
    {
        [self.Romo setExpression:RMCharacterExpressionLove];
        [self.Romo3 driveWithLeftMotorPower:-1.0 rightMotorPower:1.0];
        [NSThread sleepForTimeInterval:0.3];
        [self.Romo3 driveWithLeftMotorPower:-1.0 rightMotorPower:1.0];
        [NSThread sleepForTimeInterval:0.3];
        [self.Romo3 stopDriving];
        [self done];
    }
    else if ([self.word isEqualToString:@"energy"])
    {
        [self.Romo setExpression:RMCharacterExpressionWee];
        [self.Romo3 driveWithRadius:3.0 speed:3.0];
        [NSThread sleepForTimeInterval:2.5f];
        [self.Romo3 stopDriving];
        [self done];
    }
    else if ([self.word isEqualToString:@"play"])
    {
        [self.Romo setExpression:RMCharacterExpressionChuckle];
        [self.Romo3 turnByAngle:360 withRadius:2.0 completion:^(BOOL success, float heading) {}];
        [NSThread sleepForTimeInterval:1.5f];
        [self.Romo3 stopDriving];
        [self done];
    }
    else if ([self.word isEqualToString:@"swimming"])
    {
        [self.Romo setExpression:RMCharacterExpressionSad];
        float tiltByAngleInDegrees = 80.0;
        [self.Romo3 tiltToAngle:tiltByAngleInDegrees
                     completion:^(BOOL success) {
                         sleep(1);
                         [self resetTilt];
                     }];
        [self done];
    }
    
    
}

- (void) done
{
    [self sendMessage:@"done"];
}

- (void)remoteCommand: (NSString *)str
{
    
    
    NSArray *points = [str componentsSeparatedByString:@" "];
    
    for (int i = 0; i<2; i++)
    {
        self.xCoord= [points objectAtIndex:0];
        self.yCoord= [points objectAtIndex:1];
        NSLog(@"X: %@", self.xCoord);
        NSLog(@"Y: %@", self.yCoord);
    }
    
    if ([self.xCoord isEqualToString:@"0"] && [self.yCoord isEqualToString:@"0"])
    {
        NSLog(@"stop");
    }
    else if ([self.yCoord isEqualToString:@"29"])
    {
        NSLog(@"Backward");
        isBackward = true;
        isForward = false;
    }
    else if ([self.yCoord isEqualToString:@"-29"])
    {
        NSLog(@"Forward");
        isForward = true;
        isBackward = false;
    }
    else if ([self.xCoord isEqualToString:@"-29"])
    {
        if (isBackward == true)
        {
            NSLog(@"Left backward");
        }
        else if (isForward == true)
        {
            NSLog(@"Left forward");
        }
    }
    else if ([self.xCoord isEqualToString:@"29"])
    {
        if (isBackward == true)
        {
            NSLog(@"Right backward");
        }
        else if (isForward == true)
        {
            NSLog(@"Right forward");
        }
    }


}



-(IBAction)settingsButton:(id)sender
{
    
    SettingsController *settingsController = [[UIStoryboard storyboardWithName:@"Settings" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:settingsController animated:YES];
    
    
}

- (void) setFrameRate:(int) framerate onDevice:(AVCaptureDevice*) videoDevice {
    if ([videoDevice lockForConfiguration:nil]) {
        videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1,framerate);
        videoDevice.activeVideoMinFrameDuration = CMTimeMake(1,framerate);
        [videoDevice unlockForConfiguration];
    }
}

-(void)sendMessage: (NSString *)str
{
    NSLog(@"Message: %@", str);
    NSString *message = str;
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = self.appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [self.appDelegate.mcManager.session sendData:data
                                         toPeers:allPeers
                                        withMode:MCSessionSendDataUnreliable
                                           error:&error];
    
    if (error)
        NSLog(@"Error sending data. Error = %@", [error localizedDescription]);
}

- (void) didReceiveDataWithNotification:(NSNotification *)notification
{
    //MCPeerID *peerID = [[notification userInfo]objectForKey:SESSION_KEY_PEER_ID];
    
    NSData *receivedData = [[notification userInfo]objectForKey:SESSION_KEY_DATA];
    NSString *receivedMessage = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    [[NSOperationQueue mainQueue]addOperationWithBlock:
     ^{
         
        if ([receivedMessage isEqualToString:@"winner"])
         {
             [self winner];
         }
         else if ([receivedMessage isEqualToString:@"match"]) {
             [self match];
         }
         else if ([receivedMessage isEqualToString:@"mismatch"])
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
         else if ([receivedMessage isEqualToString:@"Romo Ask"])
         {
             [self speechBubbleForAsk];
         }
         else if ([receivedMessage isEqualToString:@"the cat is sleeping"])
         {
             self.question = @"do you like sleeping ?";
         }
         else if ([receivedMessage isEqualToString:@"two dogs are playing"])
         {
             self.question = @"do you like playing ?";
         }
         else if ([receivedMessage isEqualToString:@"a cat drinks milk"])
         {
             self.question = @"do you like cats ?";
         }
         else if ([receivedMessage isEqualToString:@"the dog is running"])
         {
             self.question = @"do you like running ?";
         }
         else if ([receivedMessage isEqualToString:@"the dog goes swimming"])
         {
             self.question = @"do you go swimming ?";
         }
         else if ([receivedMessage isEqualToString:@"the dog is sitting"])
         {
             self.question = @"do you like dogs ?";
         }
         else if ([receivedMessage isEqualToString:@"Romo Talk"])
         {
             [self speechBubbleForTalk];
         }
         else if ([receivedMessage isEqualToString:@"yes running"] || [receivedMessage isEqualToString:@"no running"])
         {
             NSLog(@"%@", receivedMessage);
             self.talk = @"this is how i run";
             self.word = @"run";
         }
         else if ([receivedMessage isEqualToString:@"yes cats"] || [receivedMessage isEqualToString:@"no cats"])
         {
             NSLog(@"%@", receivedMessage);
             self.talk = @"i really hate cats !";
             self.word = @"hate";
         }
         else if ([receivedMessage isEqualToString:@"yes dogs"] || [receivedMessage isEqualToString:@"no dogs"])
         {
             NSLog(@"%@", receivedMessage);
             self.talk = @"dogs are my favourite animal";
             self.word = @"love";
         }
         else if ([receivedMessage isEqualToString:@"yes sleeping"] || [receivedMessage isEqualToString:@"no sleeping"])
         {
             NSLog(@"%@", receivedMessage);
             self.talk = @"sleep gives me more energy";
             self.word = @"energy";
         }
         else if ([receivedMessage isEqualToString:@"yes playing"] || [receivedMessage isEqualToString:@"no playing"])
         {
             NSLog(@"%@", receivedMessage);
             self.talk = @"i could play all day";
             self.word = @"play";
         }
         else if ([receivedMessage isEqualToString:@"yes swimming"] || [receivedMessage isEqualToString:@"no swimming"])
         {
             NSLog(@"%@", receivedMessage);
             self.talk = @"robots cannot go swimming !";
             self.word = @"swimming";
         }
         else if ([receivedMessage isEqualToString:@"buttons loaded"])
         {
             [self talkReaction];
         }
         else if ([receivedMessage isEqualToString:@"Remote"])
         {
             [self videoSession];
         }
         else if ([receivedMessage containsString:@"0"] && [receivedMessage containsString:@"29"])
         {
             [self remoteCommand:receivedMessage];
         }
         else if ([receivedMessage isEqualToString:@"0 0"])
         {
             [self remoteCommand:receivedMessage];
         }
         
    }];
    
    
}


@end
