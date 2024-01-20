//
//  CreditsScene.mm
//  StickyET
//
//  Created by pawel on 4/21/11.
//  Copyright 2011 __etcApps__. All rights reserved.
//

#import "CreditsScene.h"
#import "MainScene.h"
#import "SoundMenuItem.h"
#import "RainSpecialEffectParticle.h"

@implementation CreditsScene

@synthesize emitter;

+(id) scene {
	CCScene *scene = [CCScene node];
	id child = [CreditsScene node];
	
	[scene addChild:child];
	return scene;
}

-(id) init {
	if((self=[super init])) {
		CGSize s = [[CCDirector sharedDirector] winSize];
		CCSprite *background = [CCSprite spriteWithFile:@"credits-scene-background.png"];
		background.position = ccp(s.width/2, s.height/2);
		[self addChild:background z:-10];
		
		
		// back button
		SoundMenuItem *backButton = [SoundMenuItem itemFromNormalSpriteFrameName:@"btn-back-normal.png" selectedSpriteFrameName:@"btn-back-selected.png" target:self selector:@selector(backCallback:)];	
		backButton.position = ccp(5,s.height-5);
		backButton.anchorPoint = ccp(0,1);
		
		CCMenu *menu = [CCMenu menuWithItems:backButton, nil];
		menu.position = ccp(0,0);
		[self addChild: menu z:0];
		
	}
	
	return self;
}

-(void) onEnter {
	[super onEnter];
	
	self.emitter = [RainSpecialEffectParticle node];
	
	[self addChild: emitter z:10];
	
	if( CGPointEqualToPoint( emitter.sourcePosition, CGPointZero ) ) 
		emitter.position = ccp(240, 320);
}

-(void) backCallback:(id)sender {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:1 scene:[MainScene scene]]];
}

@end
