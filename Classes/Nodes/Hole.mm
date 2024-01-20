//
//  Hole.mm
//  LevelSVG
//
//  Created by Ricardo Quesada on 05/01/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION


#import <Box2d/Box2D.h>
#import "cocos2d.h"

#import "GameNode.h"
#import "GameConstants.h"
#import "Hole.h"

//
// Hole: an static object that can kill the Hero
//

@implementation Hole
-(id) initWithBody:(b2Body*)body game:(GameNode*)game
{
	if( (self=[super initWithBody:body game:game]) ) {
		
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hole-1_e3.png"];
		[self setDisplayFrame:frame];
		
		// bodyNode properties
		reportContacts_ = BN_CONTACT_NONE;
		preferredParent_ = BN_PREFERRED_PARENT_SPRITES_PNG;
		isTouchable_ = NO;
		
		NSString *holeFrame1 = @"hole-1_e3.png";
		NSString *holeFrame2 = @"hole-2_e3.png";
		NSString *holeFrame3 = @"hole-3_e3.png";
		NSString *holeFrame4 = @"hole-4_e3.png";
		NSString *holeFrame5 = @"hole-5_e3.png";
		NSString *holeFrame6 = @"hole-6_e3.png";
				
		CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame *frame1 = [cache spriteFrameByName:holeFrame1];
		CCSpriteFrame *frame2 = [cache spriteFrameByName:holeFrame2];
		CCSpriteFrame *frame3 = [cache spriteFrameByName:holeFrame3];
		CCSpriteFrame *frame4 = [cache spriteFrameByName:holeFrame4];
		CCSpriteFrame *frame5 = [cache spriteFrameByName:holeFrame5];
		CCSpriteFrame *frame6 = [cache spriteFrameByName:holeFrame6];
		NSArray *frames = [NSArray arrayWithObjects:frame1, frame2, frame3, frame4, frame5, frame6, nil];
		CCAnimation *animation = [CCAnimation animationWithFrames:frames];
		
		CCAnimate *animate = [CCAnimate actionWithDuration:2 animation:animation restoreOriginalFrame:NO];
		[self runAction:[CCRepeatForever actionWithAction:animate]];
	}
	return self;
}
@end
