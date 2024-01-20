//
//  HowToPlayScene.mm
//  StickyET
//
//  Created by pawel on 12/22/11.
//  Copyright 2011 __etcApps__. All rights reserved.
//

#import "HowToPlayScene.h"
#import "ProgressManager.h"
#import "HowToPlayHUD.h"


@implementation HowToPlayScene

@synthesize returnToEpisodeSelector=returnToEpisodeSelector_;

+(id) scene:(BOOL)returnToEpisodeSelectorScene {
	CCScene *scene = [CCScene node];
	id child = [HowToPlayScene node];
	
	HowToPlayScene *howToPlayScene = child;
	howToPlayScene.returnToEpisodeSelector = returnToEpisodeSelectorScene;
	
	// HUD
	HowToPlayHUD *hud = [HowToPlayHUD HowToPlayHUDScene];
	hud.returnToEpisodeSelector = returnToEpisodeSelectorScene;
	[scene addChild:hud z:10];
	
	[scene addChild:child];
	return scene;
}

-(id) init {
	if((self=[super init])) {
		isTouchEnabled_ = YES;
		introStartDelay_ = 5.0;
		introEndDelay_ = 5.0;
		CGSize s = [[CCDirector sharedDirector] winSize];
		CCSprite *background = [CCSprite spriteWithFile:@"how-to-play-scene.png"];
		background.position = ccp(s.width, s.height/2);
		[self addChild:background z:-10];
		
		[self schedule:@selector(updateCamera:)];
	}
	return self;
}

-(void) updateCamera:(ccTime)dt {
	CGPoint pos = position_;
	if (self.position.x < -480) {
		introEndDelay_ -= dt;
		if (introEndDelay_ <= 0) {
		}
	}else if (introStartDelay_ <= 0) {
		[self setPosition:ccp(pos.x - 15*dt,pos.y)];
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
}

- (void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent*)event {
	CGPoint pt = [self convertTouchToNodeSpace:touch];
	
	CGPoint prevPT = [touch previousLocationInView:touch.view];
	CGPoint currPT = [touch locationInView:touch.view];
	
	CGFloat panX = self.position.x - (prevPT.x - currPT.x);
	
	if (panX > 0) {
		panX = 0;
	}
	
	if (panX < -480.0f) {
		panX = -480.0f;
	}
	
	[self setPosition:ccp(panX,0)];
	
}

@end
