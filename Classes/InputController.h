/*
 *  InputController.h
 *  NinjaGames
 *
 *  Created by João Caxaria on 4/28/09.
 *  Copyright 2009 Feel Fine Games. All rights reserved.
 *
 */

@interface InputController : NSObject
{
}

+(int) fingerCount:(NSSet *) touches :(UIEvent *)event;
+(CGPoint) fingerLocation:(int) finger :(NSSet *) touches :(UIEvent *)event;
+(CGPoint) previousFingerLocation:(int) finger :(NSSet *) touches :(UIEvent *)event;
+(bool) wasSwipeLeft:(NSSet *) touches :(UIEvent *)event;
+(bool) wasSwipeRight:(NSSet *) touches :(UIEvent *)event;
+(bool) wasSwipeUp:(NSSet *) touches :(UIEvent *)event;
+(bool) wasSwipeDown:(NSSet *) touches :(UIEvent *)event;
+(bool) wasDragLeft:(NSSet *) touches :(UIEvent *)event;
+(bool) wasDragRight:(NSSet *) touches :(UIEvent *)event;
+(bool) wasDragUp:(NSSet *) touches :(UIEvent *)event;
+(bool) wasDragDown:(NSSet *) touches :(UIEvent *)event;
+(bool) wasZoomIn:(NSSet *) touches :(UIEvent *)event;
+(bool) wasZoomOut:(NSSet *) touches :(UIEvent *)event;
+(bool) wasAClick:(NSSet *) touches :(UIEvent *)event;
+(bool) wasADoubleClick:(NSSet *) touches :(UIEvent *)event;
+(bool) wasAClickGeneric:(NSSet *) touches :(UIEvent *)event :(int) fingers :(int) taps;
+(CGPoint) distance:(int) finger :(NSSet *) touches :(UIEvent *)event;
+(CGFloat) distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
+(bool) isPointInside:(CGPoint) point :(CGRect) rect;

@end
