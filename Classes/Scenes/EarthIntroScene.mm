//
//  EarthIntroScene.mm
//  StickyET
//
//  Created by pawel on 4/21/11.
//  Copyright 2011 __etcApps__. All rights reserved.
//

#import "EarthIntroScene.h"
#import "HowToPlayScene.h"
#import "ProgressManager.h"


@implementation EarthIntroScene

+(id) scene {
	CCScene *scene = [CCScene node];
	id child = [EarthIntroScene node];
	
	[scene addChild:child];
	return scene;
}

-(id) init {
	if((self=[super init])) {
		isTouchEnabled_ = YES;
		introStartDelay_ = 3.0;
		introEndDelay_ = 3.0;
		CGSize s = [[CCDirector sharedDirector] winSize];
		CCSprite *background = [CCSprite spriteWithFile:@"earth-intro-scene.png"];
		background.position = ccp(s.width, s.height/2);
		[self addChild:background z:-10];
		[self schedule:@selector(updateCamera:)];
		
		[[ProgressManager getOrInitProgress] playBlueWorldTheme];
	}
	return self;
}

-(void) updateCamera:(ccTime)dt {
	CGPoint pos = position_;
	if (self.position.x < -480) {
		introEndDelay_ -= dt;
		if (introEndDelay_ <= 0) {
			[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1 scene:[HowToPlayScene scene:NO]]];
		}
	}else if (introStartDelay_ <= 0) {
		[self setPosition:ccp(pos.x - 50*dt,pos.y)];
	} else {
		introStartDelay_ -= dt;
	}
}

-(void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:100 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
		[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1 scene:[HowToPlayScene scene:NO]]];
}


@end
