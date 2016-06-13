//
//  MCManager.m
//  Test_MultipeerConnectivity
//
//  Created by Eduardo Flores on 4/9/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import "MCManager.h"
#import "Macros.h"

@implementation MCManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.peerID = nil;
        self.session = nil;
        self.browser = nil;
        self.advertiser = nil;
    }
    return self;
}

#pragma mark - Public methods
- (void)setupPeerAndSessionWithDisplayName:(NSString *)displayName
{
    self.peerID = [[MCPeerID alloc]initWithDisplayName:displayName];
    
    self.session = [[MCSession alloc]initWithPeer:self.peerID];
    self.session.delegate = self;
}

- (void)setupMCBrowser
{
    self.browser = [[MCBrowserViewController alloc]initWithServiceType:SERVICE_ID session:self.session];
}

- (void)advertiseItself:(BOOL)shouldAdvertise
{
    if (shouldAdvertise)
    {
        self.advertiser = [[MCAdvertiserAssistant alloc]initWithServiceType:SERVICE_ID
                                                              discoveryInfo:nil
                                                                    session:self.session];
        [self.advertiser start];
    }
    else
    {
        [self.advertiser stop];
        self.advertiser = nil;
    }
}

#pragma mark - Delegate methods
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSDictionary *dictionary = @{SESSION_KEY_DATA : data,
                                 SESSION_KEY_PEER_ID : peerID };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MC_DID_RECEIVE_DATA
                                                        object:nil
                                                      userInfo:dictionary];
    
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSDictionary *dictionary = @{SESSION_KEY_PEER_ID : peerID,
                                 SESSION_KEY_STATE : [NSNumber numberWithInt:state]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MC_DID_CHANGE_STATE
                                                        object:nil
                                                      userInfo:dictionary];
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}
@end




