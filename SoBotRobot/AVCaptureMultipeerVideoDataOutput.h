//
//  AVCaptureMultipeerViewDataOutput.h
//  SoBotRobot
//
//  Created by Laura on 29/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@protocol AVCaptureMultipeerVideoDataOutputDelegate <NSObject>
@optional
- (void) raiseFramerate;
- (void) lowerFramerate;
@end

@interface AVCaptureMultipeerVideoDataOutput : AVCaptureVideoDataOutput

@property (strong, nonatomic) id delegate;

- (instancetype) initWithDisplayName:(NSString*) displayName;
- (instancetype) initWithDisplayName:(NSString*) displayName withAssistant:(BOOL) useAssistant;

@end
