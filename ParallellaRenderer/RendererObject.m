//
//  RendererObject.m
//  ParallellaRenderer
//
//  Created by Otávio Netto Zani on 04/08/15.
//  Copyright (c) 2015 Otávio Netto Zani. All rights reserved.
//

#import "RendererObject.h"

@implementation RendererObject


-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
	
	self = [super init];
	
	if(self){
		self.rotation = [[dictionary objectForKey:@"Rotation"] floatValue];
		self.position = [(NSValue *)[dictionary objectForKey:@"Position"] CGPointValue];
		self.rotationPoint = [(NSValue *)[dictionary objectForKey:@"RotationPoint"] CGPointValue];
		self.type = (ObjectType)[[dictionary objectForKey:@"Type"] integerValue];
		switch (self.type) {
			case TYPE_CIRCLE:
				self.radius = [[dictionary objectForKey:@"Radius"] floatValue];
			break;
				
			case TYPE_POLYGON:
				self.points = [dictionary objectForKey:@"Points"];
			break;
		}
		
	}
	
	
	return self;
}


-(void)updateInformation:(NSDictionary *)dictionary{
	
	self.rotation = [[dictionary objectForKey:@"Rotation"] floatValue];
	self.position = [(NSValue *)[dictionary objectForKey:@"Position"] CGPointValue];
}


@end
