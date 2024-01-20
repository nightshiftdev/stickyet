//
//  Star.mm
//  LevelSVG
//
//  Created by Ricardo Quesada on 24/03/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION

#include <stdlib.h>
#import <Box2d/Box2D.h>
#import "cocos2d.h"

#import "GameNode.h"
#import "GameConstants.h"
#import "Star.h"
#import "SimpleAudioEngine.h"
#import "SpecialEffectParticle.h"

//
// Star: a sensor with the shape of an star.
// When touched, it will increase points in 10
//

@implementation Star

-(id) initWithBody:(b2Body*)body game:(GameNode*)game
{
	if( (self=[super initWithBody:body game:game]) ) {
		
		int iconIndex = arc4random() % 4;
		NSString *iconName;
		switch (iconIndex) {
			case 0:
				iconName = @"battery.png";
				break;
			case 1:
				iconName = @"gear.png";
				break;
			case 2:
				iconName = @"meter.png";
				break;
			case 3:
				iconName = @"scheme.png";
				break;
			default:
				iconName = @"battery.png";
				break;
		}
		
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:iconName];
		[self setDisplayFrame:frame];
		
	}
	return self;
}

-(void) touchedByHero
{
	[super touchedByHero];
	[game_ increaseScore:1];
	[[SimpleAudioEngine sharedEngine] playEffect: @"pickup_star.wav"];
	
	SpecialEffectParticle * effect = [SpecialEffectParticle node];
	[game_ addChild:effect z:5];
	[effect setPosition:self.position];
	[effect runAction:[CCMoveBy actionWithDuration:1 position:ccp(0,-100)]];
}

@end
