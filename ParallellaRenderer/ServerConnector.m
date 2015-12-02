//
//  SplendensServerConnector.m
//  ServerConnector
//
//  Created by Otávio Netto Zani on 19/01/15.
//  Copyright (c) 2015 Otávio Netto Zani. All rights reserved.
//

#import "ServerConnector.h"
#define SERVER_DEBUG YES

@interface ServerConnector()<NSStreamDelegate>

@property(nonatomic) NSString* hostName;
@property(nonatomic) UInt32 port;

@property(nonatomic) NSInputStream* inputStream;
@property(nonatomic) NSOutputStream* outputStream;
@property(nonatomic) NSMutableArray* outputBuffer;
@property(nonatomic) NSMutableData* inputBuffer;

@end

@implementation ServerConnector


#pragma mark - inits
//init methods
-(instancetype)init {
	self = [super init];
	
	if(self){
		
		self.hostName = DEFAULT_HOST_NAME;
		self.port = DEFAULT_PORT;
		
		self.inputBuffer = [[NSMutableData alloc] init];
		self.outputBuffer = [[NSMutableArray alloc] init];
		
		[self createStreamToHost];
		
		
	}
	
	return self;
	
}

-(instancetype)initWithHostName:(NSString *)host port:(UInt32)port{
	
	self = [super init];
	
	if(self){
		
		self.hostName = host;
		self.port = port? port: DEFAULT_PORT;
		
		self.inputBuffer = [[NSMutableData alloc] init];
		self.outputBuffer = [[NSMutableArray alloc] init];
		
		[self createStreamToHost];
		
	}
	
	return self;
}


#pragma mark - Creating the connections
//create the connections
-(void)createStreamToHost{
	
	
	CFReadStreamRef readStream;
	CFWriteStreamRef writeStream;
	CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.hostName, self.port, &readStream, &writeStream);
	self.inputStream = (__bridge_transfer NSInputStream*)readStream;
	self.outputStream = (__bridge_transfer NSOutputStream*)writeStream;
	
	[self.inputStream setDelegate:self];
	[self.outputStream setDelegate:self];
	[self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
	[self.inputStream open];
	[self.outputStream open];

}


#pragma mark - NSStreamDelegate
//nsstreamdelegate

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
	
	switch (eventCode) {
		case NSStreamEventOpenCompleted:{
			if(SERVER_DEBUG){
				NSLog(@"Connection open");
			}
			
		}
			break;
		
		case NSStreamEventEndEncountered:{
			NSLog(@"Connection Closed");
		}
			break;
			
		case NSStreamEventErrorOccurred:{
			NSLog(@"Connection Closed with Error");
		}
			break;
			
		case NSStreamEventHasBytesAvailable:{
			NSLog(@"Has Data for read");
			if(aStream == self.inputStream){
				[self readData];
			}

		}
			break;
		case NSStreamEventHasSpaceAvailable:{
			NSLog(@"Can Send Data");
		}
			break;
  default:
			break;
	}
	
	
}


#pragma mark - event handling functions

-(void)readData{
	uint8_t buffer[512];
	
	//get data from server
	NSInteger readLength;
	do{
		readLength = [self.inputStream read:buffer maxLength:512];
		[self.inputBuffer appendBytes:buffer length:readLength];
		
	}while (readLength == 512);
	
	
	
	//process the data
	if(self.inputBuffer.length<4){
		return;
	}
	
	
	uint8_t bytesDataSize[4];
	[self.inputBuffer getBytes:bytesDataSize length:4];
	
	NSInteger dataLength = (bytesDataSize[0]<<0) + (bytesDataSize[1]<<8) + (bytesDataSize[2]<<16) + (bytesDataSize[3]<<24);
	
	if(self.inputBuffer.length<4+dataLength){
		return;
	}
	
	NSData* jsonData = [self.inputBuffer subdataWithRange:NSMakeRange(4, dataLength)];
	
	NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
	
	if(!jsonObject){
		NSLog(@"received data is invalid - message has not been processed");
		return;
	}
	
	
	self.inputBuffer = [[self.inputBuffer subdataWithRange:NSMakeRange(4+dataLength, self.inputBuffer.length-(4+dataLength))] mutableCopy];
	
	[self.delegate receivedMessageFromServer:jsonObject];
	
}



@end
