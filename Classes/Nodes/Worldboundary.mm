//
//  Worldboundary.mm
//  StickyET
//
//  Created by pawel on 3/25/11.
//  Copyright 2011 __etcApps__. All rights reserved.
//

#import <Box2d/Box2D.h>
#import "Worldboundary.h"
#import "GameNode.h"
#import "SimpleAudioEngine.h"

@implementation Worldboundary
-(id) initWithBody:(b2Body*)body game:(GameNode*)game {
	if( (self=[super initWithBody:body game:game]) ) {
		preferredParent_ = BN_PREFERRED_PARENT_IGNORE;
		reportContacts_ = BN_CONTACT_ALL;
		//
		// TIP:
		// Tell the engine not to update the sprite. It will be updated manually
		//
		//properties_ = properties_;
		
		//
		// TIP: Static bodies won't collide with static and kinematic bodies
		//
		body->SetType(b2_staticBody);
		
	}
	return self;
}

-(void) touchedByHero {
	[[SimpleAudioEngine sharedEngine] playEffect: @"you_loose.wav"];
	[game_ gameOver:NO touchedFatalObject:YES];
}

@end
