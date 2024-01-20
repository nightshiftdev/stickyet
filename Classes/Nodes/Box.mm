//
//  Box.mm
//  StickyET
//
//  Created by pawel on 4/15/11.
//  Copyright 2011 __etcApps__. All rights reserved.
//

#import "Box.h"
#import <Box2d/Box2D.h>
//#import "cocos2d.h"
//#import "SimpleAudioEngine.h"
//
//#import "GameNode.h"
//#import "GameConstants.h"
//#import "Enemy.h"


@implementation Box
-(id) initWithBody:(b2Body*)body game:(GameNode*)game
{
	if( (self=[super initWithBody:body game:game]) ) {
		
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"box_e2.png"];
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
		shape.m_radius = 0.3f;		// 1 meter of diameter (optimized size)
		fd.friction		= 0.1f;
		fd.density		= 0.1f;
		fd.restitution	= 1.0f;
		fd.shape = &shape;
		
		body->CreateFixture(&fd);
		body->SetType(b2_dynamicBody);
	}
	return self;
}
@end
