//
//  Jump.mm
//  LevelSVG
//
//  Created by Ricardo Quesada on 24/03/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION

#import <Box2d/Box2D.h>
#import "cocos2d.h"

#import "GameNode.h"
#import "GameConstants.h"
#import "Jump.h"
#import "SimpleAudioEngine.h"
#import "SpecialEffectParticle.h"

//
// Star: a sensor with the shape of an star.
// When touched, it will increase points in 10
//

@implementation Jump

-(id) initWithBody:(b2Body*)body game:(GameNode*)game
{
	if( (self=[super initWithBody:body game:game]) ) {
		
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump.png"];
		[self setDisplayFrame:frame];
		
	}
	return self;
}

-(void) touchedByHero
{
	[super touchedByHero];
	[game_ increaseAirJumps:1];
	[[SimpleAudioEngine sharedEngine] playEffect: @"pickup_jump.wav"];
	
	SpecialEffectParticle * effect = [SpecialEffectParticle node];
	[game_ addChild:effect z:5];
	[effect setPosition:self.position];
	[effect runAction:[CCMoveBy actionWithDuration:1 position:ccp(0,-100)]];
}

@end
