//
//  Stickable.m
//  StickyET
//
//  Created by pawel on 3/6/11.
//  Copyright 2011 __etcApps__. All rights reserved.
//

#import <Box2d/Box2D.h>
#import "Stickable.h"

@implementation Stickable
-(id) initWithBody:(b2Body*)body game:(GameNode*)game
{
	if( (self=[super initWithBody:body game:game]) ) {
		preferredParent_ = BN_PREFERRED_PARENT_IGNORE;
		reportContacts_ = BN_CONTACT_ALL;
		//
		// TIP:
		// Tell the engine not to update the sprite. It will be updated manually
		//
		//properties_ = properties_;// & ~BN_PROPERTY_SPRITE_UPDATED_BY_PHYSICS;
		
		//
		// TIP: Static bodies won't collide with static and kinematic bodies
		//
		body->SetType(b2_staticBody);
		
	}
	return self;
}
@end
