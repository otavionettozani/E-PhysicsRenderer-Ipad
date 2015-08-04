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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	RendererObject* object = [[RendererObject alloc] init];
	object.points = [[NSMutableArray alloc] init];
	object.type = TYPE_POLYGON;
	object.position = CGPointMake(100, 100);
	object.rotation = M_PI/3;
	object.rotationPoint = CGPointMake(1, 1);
	[object.points addObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
	[object.points addObject:[NSValue valueWithCGPoint:CGPointMake(0, 40)]];
	[object.points addObject:[NSValue valueWithCGPoint:CGPointMake(40, 0)]];
	
	((RendererView*)self.view).objects = [[NSMutableDictionary alloc] init];
	
	[((RendererView*)self.view).objects setObject:object forKey:@"0"];
	
	object = [[RendererObject alloc] init];
	object.type = TYPE_CIRCLE;
	object.position = CGPointMake(200, 200);
	object.rotation = M_PI/3;
	object.rotationPoint = CGPointMake(100, 100);
	object.radius = 30;

	
	[((RendererView*)self.view).objects setObject:object forKey:@"1"];
	
	
	[self.view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
