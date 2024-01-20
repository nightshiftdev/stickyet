//
//  VenusLevelSelectorScene.mm
//  StickyET
//
//  Created by pawel on 4/21/11.
//  Copyright 2011 __etcApps__. All rights reserved.
//

#import "VenusLevelSelectorScene.h"
#import "MarsLevelSelectorScene.h"
#import "SoundMenuItem.h"
#import "Level20.h"
#import "Level21.h"
#import "Level22.h"
#import "Level23.h"
#import "Level24.h"
#import "Level25.h"
#import "Level26.h"
#import "Level27.h"
#import "Level28.h"
#import "Level29.h"
#import "VenusIntroScene.h"
#import "ProgressManager.h"


@implementation VenusLevelSelectorScene

@synthesize emitter;

+(id) scene {
	CCScene *scene = [CCScene node];
	id child = [VenusLevelSelectorScene node];
	
	[scene addChild:child];
	return scene;
}

-(id) init {
	if((self=[super init])) {
		CGSize s = [[CCDirector sharedDirector] winSize];
		CCSprite *background = [CCSprite spriteWithFile:@"venus-level-selector-scene-background.png"];
		background.position = ccp(s.width/2, s.height/2);
		[self addChild:background z:-10];
		
		NSString *normalBtnName = @"locked-1.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:20]) {
			normalBtnName = @"fire-1-normal.png";
		}
		CCMenuItem *level0 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"fire-1-selected.png" target:self selector:@selector(level0:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:20]) {
			[level0 setIsEnabled:YES];
		} else {
			[level0 setIsEnabled:NO];
		}
		normalBtnName = @"locked-2.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:21]) {
			normalBtnName = @"fire-2-normal.png";
		}
		CCMenuItem *level1 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"fire-2-selected.png" target:self selector:@selector(level1:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:21]) {
			[level1 setIsEnabled:YES];
		} else {
			[level1 setIsEnabled:NO];
		}
		normalBtnName = @"locked-3.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:22]) {
			normalBtnName = @"fire-3-normal.png";
		}
		CCMenuItem *level2 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"fire-3-selected.png" target:self selector:@selector(level2:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:22]) {
			[level2 setIsEnabled:YES];
		} else {
			[level2 setIsEnabled:NO];
		}
		normalBtnName = @"locked-4.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:23]) {
			normalBtnName = @"fire-4-normal.png";
		}
		CCMenuItem *level3 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"fire-4-selected.png" target:self selector:@selector(level3:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:23]) {
			[level3 setIsEnabled:YES];
		} else {
			[level3 setIsEnabled:NO];
		}
		normalBtnName = @"locked-5.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:24]) {
			normalBtnName = @"fire-5-normal.png";
		}
		CCMenuItem *level4 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"fire-5-selected.png" target:self selector:@selector(level4:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:24]) {
			[level4 setIsEnabled:YES];
		} else {
			[level4 setIsEnabled:NO];
		}
		normalBtnName = @"locked-6.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:25]) {
			normalBtnName = @"fire-6-normal.png";
		}
		CCMenuItem *level5 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"fire-6-selected.png" target:self selector:@selector(level5:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:25]) {
			[level5 setIsEnabled:YES];
		} else {
			[level5 setIsEnabled:NO];
		}
		normalBtnName = @"locked-7.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:26]) {
			normalBtnName = @"fire-7-normal.png";
		}
		CCMenuItem *level6 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"fire-7-selected.png" target:self selector:@selector(level6:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:26]) {
			[level6 setIsEnabled:YES];
		} else {
			[level6 setIsEnabled:NO];
		}
		normalBtnName = @"locked-8.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:27]) {
			normalBtnName = @"fire-8-normal.png";
		}
		CCMenuItem *level7 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"fire-8-selected.png" target:self selector:@selector(level7:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:27]) {
			[level7 setIsEnabled:YES];
		} else {
			[level7 setIsEnabled:NO];
		}
		normalBtnName = @"locked-9.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:28]) {
			normalBtnName = @"fire-9-normal.png";
		}
		CCMenuItem *level8 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"fire-9-selected.png" target:self selector:@selector(level8:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:28]) {
			[level8 setIsEnabled:YES];
		} else {
			[level8 setIsEnabled:NO];
		}
		normalBtnName = @"locked-10.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:29]) {
			normalBtnName = @"fire-10-normal.png";
		}
		CCMenuItem *level9 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"fire-10-selected.png" target:self selector:@selector(level9:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:29]) {
			[level9 setIsEnabled:YES];
		} else {
			[level9 setIsEnabled:NO];
		}
		
		CCMenu *menu = [CCMenu menuWithItems: level0, 
						level1, 
						level2, 
						level3, 
						level4, 
						level5, 
						level6, 
						level7, 
						level8,
						level9,
						nil];
		menu.position = ccp(220,160);
		
		[menu alignItemsInColumns:
		 [NSNumber numberWithUnsignedInt:5],
		 [NSNumber numberWithUnsignedInt:5],
		 nil
		 ];
		
		[self addChild:menu];
		
		[self assignShipPartsRewardsForLevels];
		
		
		// back button
		SoundMenuItem *backButton = [SoundMenuItem itemFromNormalSpriteFrameName:@"btn-back-normal.png" selectedSpriteFrameName:@"btn-back-selected.png" target:self selector:@selector(backCallback:)];	
		backButton.position = ccp(5,s.height-5);
		backButton.anchorPoint = ccp(0,1);
		
		menu = [CCMenu menuWithItems:backButton, nil];
		menu.position = ccp(0,0);
		[self addChild: menu z:0];
		
		[[ProgressManager getOrInitProgress] playMainTheme];
	}
	
	return self;
}

-(void) onEnter {
	[super onEnter];
	self.emitter = [CCParticleFire node];
	[self addChild: emitter z:-5];
	if( CGPointEqualToPoint( emitter.sourcePosition, CGPointZero ) ) 
		emitter.position = ccp(240, 120);
}

-(void) assignShipPartsRewardsForLevels {
	NSString *partResult0 = [self graphicForLevel:20];
	CCMenuItem *shipPartsItem0 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult0 selectedSpriteFrameName:partResult0 target:nil selector:nil];
	[shipPartsItem0 setIsEnabled:NO];
	NSString *partResult1 = [self graphicForLevel:21];
	CCMenuItem *shipPartsItem1 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult1 selectedSpriteFrameName:partResult1 target:nil selector:nil];
	[shipPartsItem1 setIsEnabled:NO];
	NSString *partResult2 = [self graphicForLevel:22];
	CCMenuItem *shipPartsItem2 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult2 selectedSpriteFrameName:partResult2 target:nil selector:nil];
	[shipPartsItem2 setIsEnabled:NO];
	NSString *partResult3 = [self graphicForLevel:23];
	CCMenuItem *shipPartsItem3 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult3 selectedSpriteFrameName:partResult3 target:nil selector:nil];
	[shipPartsItem3 setIsEnabled:NO];
	NSString *partResult4 = [self graphicForLevel:24];
	CCMenuItem *shipPartsItem4 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult4 selectedSpriteFrameName:partResult4 target:nil selector:nil];
	[shipPartsItem4 setIsEnabled:NO];
	NSString *partResult5 = [self graphicForLevel:25];
	CCMenuItem *shipPartsItem5 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult5 selectedSpriteFrameName:partResult5 target:nil selector:nil];
	[shipPartsItem5 setIsEnabled:NO];
	NSString *partResult6 = [self graphicForLevel:26];
	CCMenuItem *shipPartsItem6 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult6 selectedSpriteFrameName:partResult6 target:nil selector:nil];
	[shipPartsItem6 setIsEnabled:NO];
	NSString *partResult7 = [self graphicForLevel:27];
	CCMenuItem *shipPartsItem7 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult7 selectedSpriteFrameName:partResult7 target:nil selector:nil];
	[shipPartsItem7 setIsEnabled:NO];
	NSString *partResult8 = [self graphicForLevel:28];
	CCMenuItem *shipPartsItem8 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult8 selectedSpriteFrameName:partResult8 target:nil selector:nil];
	[shipPartsItem8 setIsEnabled:NO];
	NSString *partResult9 = [self graphicForLevel:29];
	CCMenuItem *shipPartsItem9 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult9 selectedSpriteFrameName:partResult9 target:nil selector:nil];
	[shipPartsItem9 setIsEnabled:NO];
	CCMenu *shipParts1 = [CCMenu menuWithItems:shipPartsItem0,
						  shipPartsItem1, 
						  shipPartsItem2,
						  shipPartsItem3,
						  shipPartsItem4,
						  nil];
	[shipParts1 setPosition:ccp(210,205)];
	[shipParts1 alignItemsInColumns:
	 [NSNumber numberWithUnsignedInt:5],
	 nil
	 ];
	[self addChild:shipParts1];
	
	CCMenu *shipParts2 = [CCMenu menuWithItems:shipPartsItem5,
						  shipPartsItem6,
						  shipPartsItem7,
						  shipPartsItem8,
						  shipPartsItem9,
						  nil];
	[shipParts2 setPosition:ccp(210,120)];
	[shipParts2 alignItemsInColumns:
	 [NSNumber numberWithUnsignedInt:5],
	 nil
	 ];
	[self addChild:shipParts2];
}

-(NSString*) graphicForLevel:(int) level {
	stars levelStars = [[ProgressManager getOrInitProgress] partsForLevel:level];
	NSString *partResult = @"0-ship-part-small.png";
	switch (levelStars) {
		case 1:
			partResult = @"1-ship-part-small.png";
			break;
		case 2:
			partResult = @"2-ship-part-small.png";
			break;
		case 3:
			partResult = @"3-ship-part-small.png";
			break;
		default:
			partResult = @"0-ship-part-small.png";
			break;
	}
	return partResult;
}

-(void) setLevelScene:(Class)klass {
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1 scene:[klass scene]]];
}

-(void) introScene:(id)sender {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:1 scene:[VenusIntroScene scene]]];
}

-(void) level0:(id)sender {
	[self introScene:sender];
}

-(void) level1:(id)sender {
	[self setLevelScene:[Level21 class]];
}

-(void) level2:(id)sender {
	[self setLevelScene:[Level22 class]];
}

-(void) level3:(id)sender {
	[self setLevelScene:[Level23 class]];
}

-(void) level4:(id)sender {
	[self setLevelScene:[Level24 class]];
}

-(void) level5:(id)sender {
	[self setLevelScene:[Level25 class]];
}

-(void) level6:(id)sender {
	[self setLevelScene:[Level26 class]];
}

-(void) level7:(id)sender {
	[self setLevelScene:[Level27 class]];
}

-(void) level8:(id)sender {
	[self setLevelScene:[Level28 class]];
}

-(void) level9:(id)sender {
	[self setLevelScene:[Level29 class]];
}

-(void) backCallback:(id)sender {
	[self removeChild:self.emitter cleanup:NO];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:1 scene:[MarsLevelSelectorScene scene]]];
}
@end
