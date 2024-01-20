//
//  Flyingenemy.m
//  LevelSVG
//
//  Created by Ricardo Quesada on 03/01/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION


#import <Box2d/Box2D.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

#import "GameNode.h"
#import "GameConstants.h"
#import "Flyingenemy.h"

//
// Enemy: An rounded enemy that is capable of killing the hero
//
// Supported parameters:
//	patrolTime (float): the time it takes to go from left to right. Default: 0 (no movement)
//  patrolSpeed (float): the speed of the patrol (the speed is in Box2d units). Default: 2
//

@implementation Flyingenemy
-(id) initWithBody:(b2Body*)body game:(GameNode*)game
{
	if( (self=[super initWithBody:body game:game]) ) {
	
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"E-1.png"];
		[self setDisplayFrame:frame];

		// bodyNode properties
		reportContacts_ = BN_CONTACT_NONE;
		preferredParent_ = BN_PREFERRED_PARENT_SPRITES_PNG;
		isTouchable_ = YES;
		
		// 1. destroy already created fixtures
		[self destroyAllFixturesFromBody:body];
		
		// 2. create new fixture
		b2FixtureDef	fd;
		b2CircleShape	shape;
		shape.m_radius = 0.5f;		// 1 meter of diameter (optimized size)
		fd.friction		= kPhysicsDefaultEnemyFriction;
		fd.density		= 0;
		fd.restitution	= kPhysicsDefaultEnemyRestitution;
		fd.shape = &shape;
		
		// filtering... in case you want to avoid collisions between enemies
//		fd.filter.groupIndex = - kCollisionFilterGroupIndexEnemy;
		
		body->CreateFixture(&fd);
		body->SetType(b2_dynamicBody);
		
		NSString *enemyFrame1 = @"E-1.png";
		NSString *enemyFrame2 = @"E-2.png";
		NSString *enemyFrame3 = @"E-3.png";
		NSString *enemyFrame4 = @"E-4.png";
		NSString *enemyFrame5 = @"E-5.png";
		NSString *enemyFrame6 = @"E-6.png";
		int gameLevelNum = [game_ levelNumber];
		if (gameLevelNum >= 10 && gameLevelNum <= 19) {
			enemyFrame1 = @"E-1_e2.png";
			enemyFrame2 = @"E-2_e2.png";
			enemyFrame3 = @"E-3_e2.png";
			enemyFrame4 = @"E-4_e2.png";
			enemyFrame5 = @"E-5_e2.png";
			enemyFrame6 = @"E-1_e2.png";
		} else if (gameLevelNum >= 20 && gameLevelNum <= 29) {
			enemyFrame1 = @"E-1_e3.png";
			enemyFrame2 = @"E-2_e3.png";
			enemyFrame3 = @"E-3_e3.png";
			enemyFrame4 = @"E-4_e3.png";
			enemyFrame5 = @"E-5_e3.png";
			enemyFrame6 = @"E-6_e3.png";
		}
		
		CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame *frame1 = [cache spriteFrameByName:enemyFrame1];
		CCSpriteFrame *frame2 = [cache spriteFrameByName:enemyFrame2];
		CCSpriteFrame *frame3 = [cache spriteFrameByName:enemyFrame3];
		CCSpriteFrame *frame4 = [cache spriteFrameByName:enemyFrame4];
		CCSpriteFrame *frame5 = [cache spriteFrameByName:enemyFrame5];
		CCSpriteFrame *frame6 = [cache spriteFrameByName:enemyFrame6];
		CCSpriteFrame *frame7 = [cache spriteFrameByName:enemyFrame1];
		CCSpriteFrame *frame8 = [cache spriteFrameByName:enemyFrame2];
		CCSpriteFrame *frame9 = [cache spriteFrameByName:enemyFrame3];
		CCSpriteFrame *frame10 = [cache spriteFrameByName:enemyFrame4];
		CCSpriteFrame *frame11 = [cache spriteFrameByName:enemyFrame5];
		CCSpriteFrame *frame12 = [cache spriteFrameByName:enemyFrame6];
		CCSpriteFrame *frame13 = [cache spriteFrameByName:enemyFrame1];
		CCSpriteFrame *frame14 = [cache spriteFrameByName:enemyFrame2];
		CCSpriteFrame *frame15 = [cache spriteFrameByName:enemyFrame3];
		CCSpriteFrame *frame16 = [cache spriteFrameByName:enemyFrame4];
		CCSpriteFrame *frame17 = [cache spriteFrameByName:enemyFrame5];
		CCSpriteFrame *frame18 = [cache spriteFrameByName:enemyFrame6];
		CCSpriteFrame *frame19 = [cache spriteFrameByName:enemyFrame1];
		CCSpriteFrame *frame20 = [cache spriteFrameByName:enemyFrame2];
		CCSpriteFrame *frame21 = [cache spriteFrameByName:enemyFrame3];
		CCSpriteFrame *frame22 = [cache spriteFrameByName:enemyFrame4];
		CCSpriteFrame *frame23 = [cache spriteFrameByName:enemyFrame5];
		CCSpriteFrame *frame24 = [cache spriteFrameByName:enemyFrame6];
		NSArray *frames = [NSArray arrayWithObjects:frame1, frame2, frame3, frame4, frame5, frame6, frame7,
						   frame8, frame9, frame10, frame11, frame12, frame13, frame14, frame15, frame16,
						   frame17, frame18, frame19, frame20, frame21, frame22, frame23, frame24, nil];
		CCAnimation *animation = [CCAnimation animationWithFrames:frames];
		
		CCAnimate *animate = [CCAnimate actionWithDuration:1 animation:animation restoreOriginalFrame:NO];
		[self runAction:[CCRepeatForever actionWithAction:animate]];
		
		patrolActivated_ = NO;
		
		[self schedule:@selector(update:)];
	}
	return self;
}

-(void) setParameters:(NSDictionary *)params
{
	[super setParameters:params];

	NSString *patrolTime = [params objectForKey:@"patrolTime"];
	NSString *patrolSpeed = [params objectForKey:@"patrolSpeed"];
	
	if( patrolTime ) {
		patrolTime_ = [patrolTime floatValue];
		
		patrolSpeed_ = 2; // default value
		if( patrolSpeed )
			patrolSpeed_ = [patrolSpeed floatValue];

		patrolActivated_ = YES;
	}
}

-(void) update:(ccTime)dt
{
	//
	// move the enemy if "patrol" is activated
	// In this example the enemy is moved using Box2d, and not cocos2d actions.
	//
	if( patrolActivated_ ) {
		patrolDT_ += dt;
		if( patrolDT_ >= patrolTime_ ) {
			patrolDT_ = 0;
			
			// This line eliminates the inertia
			body_->SetAngularVelocity(0);
			
			// Change the direction of the movement
			b2Vec2 gravity = [game_ world]->GetGravity();
			if( patrolDirectionLeft_ ) {
				body_->SetLinearVelocity( b2Vec2(-patrolSpeed_,1));
			} else {
				body_->SetLinearVelocity( b2Vec2(patrolSpeed_,1));
			}
			patrolDirectionLeft_ = ! patrolDirectionLeft_;
		}
	}	
}
-(void) touchedByBullet:(id)bullet
{
	[game_ removeB2Body:body_];
	[[SimpleAudioEngine sharedEngine] playEffect: @"enemy_killed.wav"];
	[game_ increaseScore:10];

}

@end