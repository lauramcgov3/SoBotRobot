//
//  MCManager.h
//  Test_MultipeerConnectivity
//
//  Created by Eduardo Flores on 4/9/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

// Tutorial from here: http://www.appcoda.com/intro-multipeer-connectivity-framework-ios-programming/

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