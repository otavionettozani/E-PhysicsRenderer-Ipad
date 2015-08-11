//
//  ViewController.m
//  ParallellaRenderer
//
//  Created by Otávio Netto Zani on 04/08/15.
//  Copyright (c) 2015 Otávio Netto Zani. All rights reserved.
//

#import "ViewController.h"
#import "RendererObject.h"
#import "RendererView.h"
#import "ServerConnector.h"

@interface ViewController ()<ServerConnectorDelegate>

@property(nonatomic) ServerConnector* connector;


@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	
	self.connector = [[ServerConnector alloc] init];
	
	self.connector.delegate = self;
	
	((RendererView*)self.view).objects = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


-(void)receivedMessageFromServer:(NSDictionary *)content{
	
	if(content[@"Type"]){
		//is a new object
		
		RendererObject* object = [[RendererObject alloc] initWithDictionary:content];
		[((RendererView*)self.view).objects setValue:object forKey:content[@"ID"]];
		
		
	}else{
		//just an update of an old object
		
		
		
	}
	
	[self.view setNeedsDisplay];
	
}

@end
