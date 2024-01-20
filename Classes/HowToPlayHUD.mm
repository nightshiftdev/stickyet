//
//  HowToPlayScene.h
//  StickyET
//
//  Created by pawel on 12/22/11.
//  Copyright 2011 __etcApps__. All rights reserved.
//

#import "HowToPlayHUD.h"
#import "Level0.h"
#import "EarthLevelSelectorScene.h"
#import "SoundMenuItem.h"

@implementation HowToPlayHUD

@synthesize returnToEpisodeSelector=returnToEpisodeSelector_;

+(id) HowToPlayHUDScene {
	return [[[self alloc] init] autorelease];
}

-(id) init {
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		CGSize s = [[CCDirector sharedDirector] winSize];
		
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttons.plist"];
		
		CCLayerColor *color = [CCLayerColor layerWithColor:ccc4(32,32,32,1) width:s.width height:44];
		[color setPosition:ccp(0,s.height-44)];
		[self addChild:color z:0];
		
		// play button
		SoundMenuItem *howToPlayButton = [SoundMenuItem itemFromNormalSpriteFrameName:@"btn-small-play-normal.png" selectedSpriteFrameName:@"btn-small-play-selected.png" target:self selector:@selector(playCallback:)];	
		howToPlayButton.position = ccp(s.width - 110,s.height - 5);
		howToPlayButton.anchorPoint = ccp(0,1);
		
		CCMenu *menu = [CCMenu menuWithItems:howToPlayButton, nil];
		menu.position = ccp(0,0);
		[self addChild: menu z:0];

	}
	return self;
}

- (void) dealloc {
	[super dealloc];
}

-(void) playCallback:(id)sender {
	if (returnToEpisodeSelector_) {
		[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1 scene:[EarthLevelSelectorScene scene]]];
	} else { 
		[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1 scene:[Level0 scene]]];
	}
}

@end
