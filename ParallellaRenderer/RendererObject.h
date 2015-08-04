//
//  RendererObject.h
//  ParallellaRenderer
//
//  Created by Otávio Netto Zani on 04/08/15.
//  Copyright (c) 2015 Otávio Netto Zani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

typedef enum objType{
	TYPE_CIRCLE = 0,
	TYPE_POLYGON = 1,
}ObjectType;

@interface RendererObject : NSObject


@property(atomic) NSMutableArray* points;
@property(atomic) CGFloat radius;
@property(atomic) CGPoint position;
@property(atomic) CGFloat rotation;
@property(atomic) CGPoint rotationPoint;
@property(atomic) ObjectType type;

-(instancetype) initWithDictionary:(NSDictionary*)dictionary;

-(void)updateInformation:(NSDictionary*) dictionary;
@end
