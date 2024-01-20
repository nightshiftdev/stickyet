//
//  MarsLevelSelectorScene.mm
//  StickyET
//
//  Created by pawel on 4/21/11.
//  Copyright 2011 __etcApps__. All rights reserved.
//

#import "MarsLevelSelectorScene.h"
#import "EarthLevelSelectorScene.h"
#import "SoundMenuItem.h"
#import "Level10.h"
#import "Level11.h"
#import "Level12.h"
#import "Level13.h"
#import "Level14.h"
#import "Level15.h"
#import "Level16.h"
#import "Level17.h"
#import "Level18.h"
#import "Level19.h"
#import "MarsIntroScene.h"
#import "ProgressManager.h"
#import "VenusLevelSelectorScene.h"
#import "RainSpecialEffectParticle.h"

@implementation MarsLevelSelectorScene

@synthesize emitter;

+(id) scene {
	CCScene *scene = [CCScene node];
	id child = [MarsLevelSelectorScene node];
	
	[scene addChild:child];
	return scene;
}

-(id) init {
	if((self=[super init])) {
		CGSize s = [[CCDirector sharedDirector] winSize];
		CCSprite *background = [CCSprite spriteWithFile:@"mars-level-selector-scene-background.png"];
		background.position = ccp(s.width/2, s.height/2);
		[self addChild:background z:-10];
	
		NSString *normalBtnName = @"locked-1.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:10]) {
			normalBtnName = @"green-1-normal.png";
		}
		CCMenuItem *level0 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"green-1-selected.png" target:self selector:@selector(level0:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:10]) {
			[level0 setIsEnabled:YES];
		} else {
			[level0 setIsEnabled:NO];
		}
		normalBtnName = @"locked-2.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:11]) {
			normalBtnName = @"green-2-normal.png";
		}
		CCMenuItem *level1 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"green-2-selected.png" target:self selector:@selector(level1:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:11]) {
			[level1 setIsEnabled:YES];
		} else {
			[level1 setIsEnabled:NO];
		}
		normalBtnName = @"locked-3.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:12]) {
			normalBtnName = @"green-3-normal.png";
		}
		CCMenuItem *level2 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"green-3-selected.png" target:self selector:@selector(level2:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:12]) {
			[level2 setIsEnabled:YES];
		} else {
			[level2 setIsEnabled:NO];
		}
		normalBtnName = @"locked-4.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:13]) {
			normalBtnName = @"green-4-normal.png";
		}
		CCMenuItem *level3 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"green-4-selected.png" target:self selector:@selector(level3:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:13]) {
			[level3 setIsEnabled:YES];
		} else {
			[level3 setIsEnabled:NO];
		}
		normalBtnName = @"locked-5.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:14]) {
			normalBtnName = @"green-5-normal.png";
		}
		CCMenuItem *level4 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"green-5-selected.png" target:self selector:@selector(level4:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:14]) {
			[level4 setIsEnabled:YES];
		} else {
			[level4 setIsEnabled:NO];
		}
		normalBtnName = @"locked-6.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:15]) {
			normalBtnName = @"green-6-normal.png";
		}
		CCMenuItem *level5 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"green-6-selected.png" target:self selector:@selector(level5:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:15]) {
			[level5 setIsEnabled:YES];
		} else {
			[level5 setIsEnabled:NO];
		}
		normalBtnName = @"locked-7.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:16]) {
			normalBtnName = @"green-7-normal.png";
		}
		CCMenuItem *level6 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"green-7-selected.png" target:self selector:@selector(level6:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:16]) {
			[level6 setIsEnabled:YES];
		} else {
			[level6 setIsEnabled:NO];
		}
		normalBtnName = @"locked-8.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:17]) {
			normalBtnName = @"green-8-normal.png";
		}
		CCMenuItem *level7 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"green-8-selected.png" target:self selector:@selector(level7:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:17]) {
			[level7 setIsEnabled:YES];
		} else {
			[level7 setIsEnabled:NO];
		}
		normalBtnName = @"locked-9.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:18]) {
			normalBtnName = @"green-9-normal.png";
		}
		CCMenuItem *level8 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"green-9-selected.png" target:self selector:@selector(level8:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:18]) {
			[level8 setIsEnabled:YES];
		} else {
			[level8 setIsEnabled:NO];
		}
		normalBtnName = @"locked-10.png";
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:19]) {
			normalBtnName = @"green-10-normal.png";
		}
		CCMenuItem *level9 = [SoundMenuItem itemFromNormalSpriteFrameName:normalBtnName selectedSpriteFrameName:@"green-10-selected.png" target:self selector:@selector(level9:)];
		if ([[ProgressManager getOrInitProgress] isLevelUnlocked:19]) {
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
		
		// forward button
		SoundMenuItem *forwardButton = [SoundMenuItem itemFromNormalSpriteFrameName:@"btn-forward-normal.png" selectedSpriteFrameName:@"btn-forward-selected.png" target:self selector:@selector(forwardCallback:)];	
		backButton.position = ccp(5, s.height-5);
		backButton.anchorPoint = ccp(0,1);
		
		menu = [CCMenu menuWithItems:forwardButton, nil];
		menu.position = ccp(445,300);
		[self addChild: menu z:0];
		
		[[ProgressManager getOrInitProgress] playMainTheme];
	}
	
	return self;
}

-(void) onEnter {
	[super onEnter];
	self.emitter = [RainSpecialEffectParticle node];
	[self addChild: emitter z:-5];
	if( CGPointEqualToPoint( emitter.sourcePosition, CGPointZero ) ) 
		emitter.position = ccp(240, 320);
}

-(void) assignShipPartsRewardsForLevels {
	NSString *partResult0 = [self graphicForLevel:10];
	CCMenuItem *shipPartsItem0 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult0 selectedSpriteFrameName:partResult0 target:nil selector:nil];
	[shipPartsItem0 setIsEnabled:NO];
	NSString *partResult1 = [self graphicForLevel:11];
	CCMenuItem *shipPartsItem1 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult1 selectedSpriteFrameName:partResult1 target:nil selector:nil];
	[shipPartsItem1 setIsEnabled:NO];
	NSString *partResult2 = [self graphicForLevel:12];
	CCMenuItem *shipPartsItem2 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult2 selectedSpriteFrameName:partResult2 target:nil selector:nil];
	[shipPartsItem2 setIsEnabled:NO];
	NSString *partResult3 = [self graphicForLevel:13];
	CCMenuItem *shipPartsItem3 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult3 selectedSpriteFrameName:partResult3 target:nil selector:nil];
	[shipPartsItem3 setIsEnabled:NO];
	NSString *partResult4 = [self graphicForLevel:14];
	CCMenuItem *shipPartsItem4 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult4 selectedSpriteFrameName:partResult4 target:nil selector:nil];
	[shipPartsItem4 setIsEnabled:NO];
	NSString *partResult5 = [self graphicForLevel:15];
	CCMenuItem *shipPartsItem5 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult5 selectedSpriteFrameName:partResult5 target:nil selector:nil];
	[shipPartsItem5 setIsEnabled:NO];
	NSString *partResult6 = [self graphicForLevel:16];
	CCMenuItem *shipPartsItem6 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult6 selectedSpriteFrameName:partResult6 target:nil selector:nil];
	[shipPartsItem6 setIsEnabled:NO];
	NSString *partResult7 = [self graphicForLevel:17];
	CCMenuItem *shipPartsItem7 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult7 selectedSpriteFrameName:partResult7 target:nil selector:nil];
	[shipPartsItem7 setIsEnabled:NO];
	NSString *partResult8 = [self graphicForLevel:18];
	CCMenuItem *shipPartsItem8 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult8 selectedSpriteFrameName:partResult8 target:nil selector:nil];
	[shipPartsItem8 setIsEnabled:NO];
	NSString *partResult9 = [self graphicForLevel:19];
	CCMenuItem *shipPartsItem9 = [SoundMenuItem itemFromNormalSpriteFrameName:partResult9 selectedSpriteFrameName:partResult9 target:nil selector:nil];
	[shipPartsItem9 setIsEnabled:NO];
	CCMenu *shipParts1 = [CCMenu menuWithItems:shipPartsItem0,
						  shipPartsItem1, 
						  shipPartsItem2,
						  shipPartsItem3,
						  shipPartsItem4,
						  nil];
	[shipParts1 setPosition:ccp(225,205)];
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
	[shipParts2 setPosition:ccp(225,120)];
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
	[[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:1 scene:[MarsIntroScene scene]]];
}

-(void) level0:(id)sender {
	[self introScene:sender];
}

-(void) level1:(id)sender {
	[self setLevelScene:[Level11 class]];
}

-(void) level2:(id)sender {
	[self setLevelScene:[Level12 class]];
}

-(void) level3:(id)sender {
	[self setLevelScene:[Level13 class]];
}

-(void) level4:(id)sender {
	[self setLevelScene:[Level14 class]];
}

-(void) level5:(id)sender {
	[self setLevelScene:[Level15 class]];
}

-(void) level6:(id)sender {
	[self setLevelScene:[Level16 class]];
}

-(void) level7:(id)sender {
	[self setLevelScene:[Level17 class]];
}

-(void) level8:(id)sender {
	[self setLevelScene:[Level18 class]];
}

-(void) level9:(id)sender {
	[self setLevelScene:[Level19 class]];
}

-(void) backCallback:(id)sender {
	[self removeChild:self.emitter cleanup:NO];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:1 scene:[EarthLevelSelectorScene scene]]];
}

-(void) forwardCallback:(id)sender {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:1 scene:[VenusLevelSelectorScene scene]]];
}
@end
