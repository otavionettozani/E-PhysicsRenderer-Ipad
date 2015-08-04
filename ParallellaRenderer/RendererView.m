//
//  RendererView.m
//  ParallellaRenderer
//
//  Created by Otávio Netto Zani on 04/08/15.
//  Copyright (c) 2015 Otávio Netto Zani. All rights reserved.
//

#import "RendererView.h"
#import "RendererObject.h"

@implementation RendererView

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		self.objects = [[NSMutableDictionary alloc] init];
	}
	return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	
	//rotate and translate in this specific order
	

	for(RendererObject* object in self.objects.objectEnumerator){
		
		
		UIBezierPath* bezier;
		bezier = [UIBezierPath bezierPath];
		
		switch (object.type) {
			case TYPE_POLYGON:{
				BOOL firstElement = YES;
				for(NSValue* value in object.points){
					
					CGPoint point = [value CGPointValue];
					
					point = [self realCoordinatesOfPoint:point atposition:object.position rotatedBy:object.rotation overPoint:object.rotationPoint];
					
					if(firstElement){
						[bezier moveToPoint:point];
						firstElement = NO;
					}else{
						[bezier addLineToPoint:point];
					}
					
				}
			}
			break;
				
			case TYPE_CIRCLE:{
				CGPoint point;
				
				point = [self realCoordinatesOfPoint:CGPointMake(0, 0) atposition:object.position rotatedBy:object.rotation overPoint:object.rotationPoint];
				
				[bezier addArcWithCenter:point radius:object.radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
				
			}
			break;
		}
		
		
		
		[bezier closePath];
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextSaveGState(context);
		
		UIColor* color = [UIColor redColor];
		
		
		[color setFill];
		[bezier fill];
		
		
		CGContextRestoreGState(context);
		
		
		
		
	}
}


-(CGPoint)realCoordinatesOfPoint:(CGPoint)point atposition:(CGPoint)position rotatedBy:(CGFloat)rotation overPoint:(CGPoint) rotationPoint{
	
	CGFloat c1 = cos(rotation);
	CGFloat s1 = sin(rotation);
	CGFloat offsetx = rotationPoint.x*(1-c1)+rotationPoint.y*s1+position.x;
	CGFloat offsety = rotationPoint.y*(1-c1)-rotationPoint.x*s1+position.y;
	
	return CGPointMake(c1*point.x-s1*point.y+offsetx, s1*point.x+c1*point.y+offsety);
}



@end
