//
//  SplendensServerConnector.h
//  ServerConnector
//
//  Created by Otávio Netto Zani on 19/01/15.
//  Copyright (c) 2015 Otávio Netto Zani. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DEFAULT_PORT 10082 //server port
#define DEFAULT_HOST_NAME @"127.0.0.1" //server host

//do not use negative numbers to your own messages
typedef enum {
	MESSAGE_TYPE_CONNECTED = -1,	
} MessageType;

@protocol ServerConnectorDelegate <NSObject>


-(void)receivedMessageFromServer:(MessageType)type content:(NSDictionary*)content;


@end

//init will automatically connect with server DEFAULT_HOST_NAME:DEFAULT_PORT_SPLENDENS

@interface ServerConnector : NSObject

@property(nonatomic, weak)id<ServerConnectorDelegate> delegate;

#pragma mark - initialize the connections
//if port is null, port will be DEFAULT_PORT
-(instancetype) initWithHostName:(NSString*)host port:(UInt32)port;


@end
