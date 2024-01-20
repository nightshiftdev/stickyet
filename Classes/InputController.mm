/*
 *  InputController.mm
 *  NinjaGames
 *
 *  Created by João Caxaria on 4/28/09.
 *  Copyright 2009 Feel Fine Games. All rights reserved.
 *
 */

#import "InputController.h"
#import "CCDirector.h"

@interface InputController (Helper)

+(void) rotateRealWorld:(float&) mX y:(float&) mY;
+(float) pointLineComparison:(CGPoint) point lineVertexA:(CGPoint)lineA lineVertexB:(CGPoint)lineB;

@end

@implementation InputController

+(int) fingerCount:(NSSet *) touches :(UIEvent *)event
{
	return [[event allTouches] count];
}


+(CGPoint) fingerLocation:(int) finger :(NSSet *) touches :(UIEvent *)event
{
	NSSet *allTouches = [event allTouches];
	
	if(finger == 0 || finger > [allTouches count])
	{
#ifdef ASSERT_DEBUG
		{
			@throw [[[NSException alloc] initWithName:@"InputController::fingerLocation" reason:@"No such finger" userInfo:nil] autorelease];
		}
#endif
		
		return CGPointZero;
	}
	
	UITouch *touch = [[allTouches allObjects] objectAtIndex:finger - 1];
	
	CGPoint location = [touch locationInView:[touch view]]; 
	
	[self rotateRealWorld:location.x y:location.y];
	
	return location;
}


+(CGPoint) previousFingerLocation:(int) finger :(NSSet *) touches :(UIEvent *)event
{
	NSSet *allTouches = [event allTouches];
	
	if(finger == 0 || finger > [allTouches count])
	{
#ifdef ASSERT_DEBUG
		{
			@throw [[[NSException alloc] initWithName:@"InputController::previousFingerLocation" reason:@"No such finger" userInfo:nil] autorelease];
		}
#endif
		
		return CGPointZero;
	}
	
	UITouch *touch = [[allTouches allObjects] objectAtIndex:finger - 1];
	
	CGPoint location = [touch previousLocationInView:[touch view]];
	
	[self rotateRealWorld:location.x y:location.y];
	
	return location;
}

+(bool) wasSwipeLeft:(NSSet *) touches :(UIEvent *)event
{
	NSSet *allTouches = [event allTouches];
	
	if(1 != [allTouches count])
		return false;
	
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
	
	CGPoint start = [touch previousLocationInView:[touch view]];
	CGPoint end = [touch locationInView:[touch view]];
	
	[self rotateRealWorld:start.x y:start.y];
	[self rotateRealWorld:end.x y:end.y];
	
	if(start.x > end.x)
	{
		return true;
	}
	
	return false;
}

+(bool) wasSwipeRight:(NSSet *) touches :(UIEvent *)event
{
	NSSet *allTouches = [event allTouches];
	
	if(1 != [allTouches count])
		return false;
	
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
	
	CGPoint start = [touch previousLocationInView:[touch view]];
	CGPoint end = [touch locationInView:[touch view]];
	[self rotateRealWorld:start.x y:start.y];
	[self rotateRealWorld:end.x y:end.y];
	
	if(start.x < end.x)
	{
		return true;
	}
	
	return false;
}

+(bool) wasSwipeUp:(NSSet *) touches :(UIEvent *)event
{
	NSSet *allTouches = [event allTouches];
	
	if(1 != [allTouches count])
		return false;
	
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
	
	CGPoint start = [touch previousLocationInView:[touch view]];
	CGPoint end = [touch locationInView:[touch view]];
	[self rotateRealWorld:start.x y:start.y];
	[self rotateRealWorld:end.x y:end.y];
	
	if(start.y < end.y)
	{
		return true;
	}
	
	return false;
}

+(bool) wasSwipeDown:(NSSet *) touches :(UIEvent *)event
{
	
	NSSet *allTouches = [event allTouches];
	
	if(1 != [allTouches count])
		return false;
	
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
	
	CGPoint start = [touch previousLocationInView:[touch view]];
	CGPoint end = [touch locationInView:[touch view]];
	[self rotateRealWorld:start.x y:start.y];
	[self rotateRealWorld:end.x y:end.y];
	
	if(start.y > end.y)
	{
		return true;
	}
	
	return false;
}

+(bool) wasDragLeft:(NSSet *) touches :(UIEvent *)event
{
	NSSet *allTouches = [event allTouches];
	
	if(2 != [allTouches count])
		return false;
	
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
	
	CGPoint start1 = [touch previousLocationInView:[touch view]];
	CGPoint end1 = [touch locationInView:[touch view]];
	[self rotateRealWorld:start1.x y:start1.y];
	[self rotateRealWorld:end1.x y:end1.y];
	
	touch = [[allTouches allObjects] objectAtIndex:1];
	
	CGPoint start2 = [touch previousLocationInView:[touch view]];
	CGPoint end2 = [touch locationInView:[touch view]];
	[self rotateRealWorld:start2.x y:start2.y];
	[self rotateRealWorld:end2.x y:end2.y];
	
	if(start1.x > end1.x && start2.x > end2.x)
	{
		return true;
	}
	
	return false;
}

+(bool) wasDragRight:(NSSet *) touches :(UIEvent *)event
{
	
	NSSet *allTouches = [event allTouches];
	
	if(2 != [allTouches count])
		return false;
	
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
	
	CGPoint start1 = [touch previousLocationInView:[touch view]];
	CGPoint end1 = [touch locationInView:[touch view]];
	[self rotateRealWorld:start1.x y:start1.y];
	[self rotateRealWorld:end1.x y:end1.y];
	
	touch = [[allTouches allObjects] objectAtIndex:1];
	
	CGPoint start2 = [touch previousLocationInView:[touch view]];
	CGPoint end2 = [touch locationInView:[touch view]];
	[self rotateRealWorld:start2.x y:start2.y];
	[self rotateRealWorld:end2.x y:end2.y];
	
	if(start1.x < end1.x && start2.x < end2.x)
	{
		return true;
	}
	
	return false;
}

+(bool) wasDragUp:(NSSet *) touches :(UIEvent *)event
{
	NSSet *allTouches = [event allTouches];
	
	if(2 != [allTouches count])
		return false;
	
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
	
	CGPoint start1 = [touch previousLocationInView:[touch view]];
	CGPoint end1 = [touch locationInView:[touch view]];
	[self rotateRealWorld:start1.x y:start1.y];
	[self rotateRealWorld:end1.x y:end1.y];
	
	touch = [[allTouches allObjects] objectAtIndex:1];
	
	CGPoint start2 = [touch previousLocationInView:[touch view]];
	CGPoint end2 = [touch locationInView:[touch view]];
	[self rotateRealWorld:start2.x y:start2.y];
	[self rotateRealWorld:end2.x y:end2.y];
	
	if(start1.y < end1.y && start2.y < end2.y)
	{
		return true;
	}
	
	return false;
	
}

+(bool) wasDragDown:(NSSet *) touches :(UIEvent *)event
{
	NSSet *allTouches = [event allTouches];
	
	if(2 != [allTouches count])
		return false;
	
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
	
	CGPoint start1 = [touch previousLocationInView:[touch view]];
	CGPoint end1 = [touch locationInView:[touch view]];
	[self rotateRealWorld:start1.x y:start1.y];
	[self rotateRealWorld:end1.x y:end1.y];
	
	touch = [[allTouches allObjects] objectAtIndex:1];
	
	CGPoint start2 = [touch previousLocationInView:[touch view]];
	CGPoint end2 = [touch locationInView:[touch view]];
	[self rotateRealWorld:start2.x y:start2.y];
	[self rotateRealWorld:end2.x y:end2.y];
	
	if(start1.y > end1.y && start2.y > end2.y)
	{
		return true;
	}
	
	return false;
}

+(bool) wasZoomIn:(NSSet *) touches :(UIEvent *)event
{
	NSSet *allTouches = [event allTouches];
	
	if(2 != [allTouches count])
		return false;
	
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
	
	CGPoint start1 = [touch previousLocationInView:[touch view]];
	CGPoint end1 = [touch locationInView:[touch view]];
	[self rotateRealWorld:start1.x y:start1.y];
	[self rotateRealWorld:end1.x y:end1.y];
	
	touch = [[allTouches allObjects] objectAtIndex:1];
	
	CGPoint start2 = [touch previousLocationInView:[touch view]];
	CGPoint end2 = [touch locationInView:[touch view]];
	[self rotateRealWorld:start2.x y:start2.y];
	[self rotateRealWorld:end2.x y:end2.y];
	
	float initialDistance = [self distanceBetweenTwoPoints:start1 toPoint:start2];
	float endDistance = [self distanceBetweenTwoPoints:end1 toPoint:end2];
	
	if(endDistance > initialDistance)
	{
		return true;
	}
	
	return false;
}

+(bool) wasZoomOut:(NSSet *) touches :(UIEvent *)event
{	
	NSSet *allTouches = [event allTouches];
	
	if(2 != [allTouches count])
		return false;
	
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
	
	CGPoint start1 = [touch previousLocationInView:[touch view]];
	CGPoint end1 = [touch locationInView:[touch view]];
	[self rotateRealWorld:start1.x y:start1.y];
	[self rotateRealWorld:end1.x y:end1.y];
	
	touch = [[allTouches allObjects] objectAtIndex:1];
	
	CGPoint start2 = [touch previousLocationInView:[touch view]];
	CGPoint end2 = [touch locationInView:[touch view]];
	[self rotateRealWorld:start2.x y:start2.y];
	[self rotateRealWorld:end2.x y:end2.y];
	
	
	float initialDistance = [self distanceBetweenTwoPoints:start1 toPoint:start2];
	float endDistance = [self distanceBetweenTwoPoints:end1 toPoint:end2];
	
	if(endDistance < initialDistance)
	{
		return true;
	}
	
	return false;
}

+(bool) wasAClick:(NSSet *) touches :(UIEvent *)event
{
	return [self wasAClickGeneric:touches :event : 1 : 1];
}

+(bool) wasADoubleClick:(NSSet *) touches :(UIEvent *)event
{
	return [self wasAClickGeneric:touches :event : 1 : 2];
}

+(bool) wasAClickGeneric:(NSSet *) touches :(UIEvent *)event :(int) fingers :(int) taps
{
	NSSet *allTouches = [event allTouches];
	
	if(fingers != [allTouches count])
		return false;
	
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
	
	return [touch phase] == UITouchPhaseEnded && [touch tapCount] == taps;
}

+(CGPoint) distance:(int) finger :(NSSet *) touches :(UIEvent *)event
{
	NSSet *allTouches = [event allTouches];
	
	if(finger == 0 || finger > [allTouches count])
		return CGPointZero;
	
	UITouch *touch = [[allTouches allObjects] objectAtIndex:finger - 1];
	
	CGPoint start1 = [touch previousLocationInView:[touch view]];
	CGPoint end1 = [touch locationInView:[touch view]];
	[self rotateRealWorld:start1.x y:start1.y];
	[self rotateRealWorld:end1.x y:end1.y];
	
	float xDistance = ( fabs(start1.x - end1.x));
	float yDistance =  ( fabs(start1.y - end1.y));
	return CGPointMake(xDistance, yDistance);
}

+(CGFloat) distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint 
{	
	float x = toPoint.x - fromPoint.x;
	float y = toPoint.y - fromPoint.y;
	return sqrt(x * x + y * y);
}


+(bool) isPointInside:(CGPoint) point :(CGRect) rect
{
	CGPoint pointA, pointB, pointC, pointD;
	pointA.x = rect.origin.x - (rect.size.width);
	pointA.y = rect.origin.y - (rect.size.height);
	
	pointB.x = rect.origin.x - (rect.size.width);
	pointB.y = rect.origin.y + (rect.size.height);
	
	pointC.x = rect.origin.x + (rect.size.width);
	pointC.y = rect.origin.y + (rect.size.height);
	
	pointD.x = rect.origin.x + (rect.size.width);
	pointD.y = rect.origin.y - (rect.size.height);
	return  [self pointLineComparison:point lineVertexA:pointA lineVertexB:pointB] < 0 &&
	[self pointLineComparison:point lineVertexA:pointB lineVertexB:pointC] < 0 &&
	[self pointLineComparison:point lineVertexA:pointC lineVertexB:pointD] < 0 &&
	[self pointLineComparison:point lineVertexA:pointD lineVertexB:pointA] < 0;
}

@end

@implementation InputController (Helper)


+(float) pointLineComparison:(CGPoint) point lineVertexA:(CGPoint)lineA lineVertexB:(CGPoint)lineB
{
	return (0.5) * (lineA.x*lineB.y - lineA.y*lineB.x -point.x*lineB.y + point.y*lineB.x + point.x*lineA.y - point.y*lineA.x);
}

+(void) rotateRealWorld:(float&) mX y:(float&) mY
{
	float tmp = mX;
	mX = mY;
	mY = tmp;
}

@end


