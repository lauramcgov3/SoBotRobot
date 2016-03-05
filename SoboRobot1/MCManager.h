//
//  MCManager.h
//  SobotGame
//
//  Created by Laura on 27/02/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MCManager : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

- (void) setupPeerAndSessionWithDisplayName:(NSString *)displayName;
- (void) setupMCBrowser;
- (void) advertiseItself:(BOOL) shouldAdvertise;
@end

