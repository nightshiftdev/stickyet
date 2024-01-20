//
//  HUD.m
//  LevelSVG

#import "HUD.h"
#import "GameConfiguration.h"
#import "GameNode.h"
#import "Stickyhero.h"
#import "SoundMenuItem.h"
#import "ProgressManager.h"
#import "GameCompleteScene.h"
#import "InputController.h"
#import "MarsIntroScene.h"
#import "VenusIntroScene.h"
#import "EarthLevelSelectorScene.h"
#import "MarsLevelSelectorScene.h"
#import "VenusLevelSelectorScene.h"


@implementation HUD

+(id) HUDWithGameNode:(GameNode*)game {
	return [[[self alloc] initWithGameNode:game] autorelease];
}

-(id) initWithGameNode:(GameNode*)aGame {
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		game_ = aGame;

		CGSize s = [[CCDirector sharedDirector] winSize];
		
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttons.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprites.plist"];
		
		CCLayerColor *color = [CCLayerColor layerWithColor:ccc4(32,32,32,1) width:s.width height:40];
		[color setPosition:ccp(0,s.height-40)];
		[self addChild:color z:0];
		
		// Menu Button
		CCMenuItem *itemPause = [SoundMenuItem itemFromNormalSpriteFrameName:@"btn-pause-normal.png" selectedSpriteFrameName:@"btn-pause-selected.png" target:self selector:@selector(buttonPause:)];
		CCMenu *menu = [CCMenu menuWithItems:itemPause,nil];
		[self addChild:menu z:1];
		[menu setPosition:ccp(30,s.height-20)];
		
		levelShipParts_ = 0;
		
		// Score Points
		score_ = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"SHIP PARTS :  %d / %d", levelShipParts_, 3] fntFile:@"sticky.fnt"];
		[score_.texture setAliasTexParameters];
		[self addChild:score_ z:1];
		[score_ setPosition:ccp(s.width/2 - 20, s.height-20.5f)];
		
		
		airJumps_ = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"AIR JUMPS :  %d", game_.airJumps] fntFile:@"sticky.fnt"];
		[airJumps_.texture setAliasTexParameters];
		[self addChild:airJumps_ z:1];
		[airJumps_ setPosition:ccp(s.width - 70, s.height-20.5f)];
		
		isPauseMenuDisplayed_ = NO;
		isGameOver_ = NO;
	}
	return self;
}

-(void) onUpdateScore:(int)newScore {
	levelShipParts_++;
	[score_ setString: [NSString stringWithFormat:@"SHIP PARTS :  %d / %d", levelShipParts_ , 3]];
	[score_ stopAllActions];
	id scaleTo = [CCScaleTo actionWithDuration:0.1f scale:1.2f];
	id scaleBack = [CCScaleTo actionWithDuration:0.1f scale:1];
	id seq = [CCSequence actions:scaleTo, scaleBack, nil];
	[score_ runAction:seq];
}

-(void) onUpdateAirJumps:(int)newAirJumps {
	[airJumps_ setString: [NSString stringWithFormat:@"AIR JUMPS :  %d", newAirJumps]];
	[airJumps_ runAction:[CCBlink actionWithDuration:0.5f blinks:5]];
}

-(void) pause {
	CGSize s = [[CCDirector sharedDirector] winSize];
	CCMenuItem *item0 = [SoundMenuItem itemFromNormalSpriteFrameName:@"btn-small-play-normal.png" selectedSpriteFrameName:@"btn-small-play-selected.png" target:self selector:@selector(resume:)];
	CCMenuItem *item1 = [SoundMenuItem itemFromNormalSpriteFrameName:@"btn-try-again-normal.png" selectedSpriteFrameName:@"btn-try-again-selected.png" target:self selector:@selector(playAgain:)];
	CCMenuItem *item2 = [SoundMenuItem itemFromNormalSpriteFrameName:@"btn-exit-normal.png" selectedSpriteFrameName:@"btn-exit-selected.png" target:self selector:@selector(mainMenu:)];
	pauseMenu_ = [CCMenu menuWithItems:item0, item1, item2, nil];
	[pauseMenu_ alignItemsVertically];
	[pauseMenu_ setPosition:ccp(s.width/2, s.height/2)];
	
	[self addChild:pauseMenu_ z:10];
}

-(void) gameOver:(BOOL)didWin touchedFatalObject:(BOOL) fatalObjectTouched {
	isGameOver_ = YES;
	CGSize s = [[CCDirector sharedDirector] winSize];
	NSString *gameResult = @"info-level-passed.png";
	if (!didWin) {
		if (fatalObjectTouched) {
			gameResult = @"info-level-failed.png";
		} else {
			gameResult = @"info-level-failed-ship-parts.png";
		}
	}	

	CCMenuItem *gameOverItem = [SoundMenuItem itemFromNormalSpriteFrameName:gameResult selectedSpriteFrameName:gameResult target:self selector:@selector(resume:)];
	[gameOverItem setIsEnabled:NO];
	CCMenu *gameOver = [CCMenu menuWithItems:gameOverItem, nil];
	[gameOver setPosition:ccp(s.width/2, s.height/2 + 60)];
	[self addChild:gameOver];
	
	int menuPosDivider = 3;
	if (didWin) {
		NSString *partResult = @"1-ship-part.png";
		switch (levelShipParts_) {
			case 2:
				partResult = @"2-ship-part.png";
				break;
			case 3:
				partResult = @"3-ship-part.png";
				break;
			default:
				break;
		}
		CCMenuItem *shipPartsItem = [SoundMenuItem itemFromNormalSpriteFrameName:partResult selectedSpriteFrameName:partResult target:self selector:@selector(resume:)];
		[shipPartsItem setIsEnabled:NO];
		CCMenu *shipParts = [CCMenu menuWithItems:shipPartsItem, nil];
		[shipParts setPosition:ccp(s.width/2, s.height/4 + 50)];
		[self addChild:shipParts];
		menuPosDivider = 5;
		
		if (levelShipParts_ >= 1) {
			CCLabelBMFont *bonusAirJumps = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"+ "] fntFile:@"sticky.fnt"];
			[bonusAirJumps.texture setAliasTexParameters];
			[self addChild:bonusAirJumps z:1];
			[bonusAirJumps setPosition:ccp(s.width / 2 + 35, s.height / 2 - 30)];
			
			CCSprite* airJumpIcon = [CCSprite spriteWithFile:@"hud_air_jump.png"];
			[airJumpIcon setPosition:ccp(s.width / 2 + 60, s.height / 2 - 30)];
			[self addChild:airJumpIcon z:1];
			
			if (levelShipParts_ >= 2) {
				CCSprite* airJumpIcon1 = [CCSprite spriteWithFile:@"hud_air_jump.png"];
				[airJumpIcon1 setPosition:ccp(s.width / 2 + 90, s.height / 2 - 30)];
				[self addChild:airJumpIcon1 z:1];
			}
			
			if (levelShipParts_ == 3) {
				CCSprite* airJumpIcon2 = [CCSprite spriteWithFile:@"hud_air_jump.png"];
				[airJumpIcon2 setPosition:ccp(s.width / 2 + 120, s.height / 2 - 30)];
				[self addChild:airJumpIcon2 z:1];
			}
		}
	}
	
	CCMenu *menu = nil;
	if (didWin) {
		CCMenuItem *item0 = [SoundMenuItem itemFromNormalSpriteFrameName:@"btn-next-normal.png" selectedSpriteFrameName:@"btn-next-selected.png" target:self selector:@selector(nextLevel:)];
		CCMenuItem *item1 = [SoundMenuItem itemFromNormalSpriteFrameName:@"btn-try-again-normal.png" selectedSpriteFrameName:@"btn-try-again-selected.png" target:self selector:@selector(playAgain:)];
		CCMenuItem *item2 = [SoundMenuItem itemFromNormalSpriteFrameName:@"btn-exit-normal.png" selectedSpriteFrameName:@"btn-exit-selected.png" target:self selector:@selector(mainMenu:)];
		menu = [CCMenu menuWithItems:item0, item1, item2, nil];
	} else {
		CCMenuItem *item0 = [SoundMenuItem itemFromNormalSpriteFrameName:@"btn-try-again-normal.png" selectedSpriteFrameName:@"btn-try-again-selected.png" target:self selector:@selector(playAgain:)];
		CCMenuItem *item1 = [SoundMenuItem itemFromNormalSpriteFrameName:@"btn-exit-normal.png" selectedSpriteFrameName:@"btn-exit-selected.png" target:self selector:@selector(mainMenu:)];
		menu = [CCMenu menuWithItems:item0, item1, nil];
	}
	[menu alignItemsHorizontallyWithPadding:0];
	[menu setPosition:ccp(s.width/2, s.height/menuPosDivider)];
	
	[self addChild:menu z:10];
}

-(void) setLevelScene:(Class)klass {
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1 scene:[klass scene]]];
}

-(void) nextLevel:(id)sender {
	int levelNumber = [game_ levelNumber] + 1;
	Class klass;
	if (levelNumber == 10) {
		klass = [MarsIntroScene class];
	} else if (levelNumber == 20) {
		klass = [VenusIntroScene class];
	} else if (levelNumber == 30) {
		klass = [GameCompleteScene class];
	} else {
		klass = NSClassFromString([NSString stringWithFormat:@"Level%d", levelNumber]);
	}	
	[self setLevelScene: klass];
}

-(void) playAgain:(id)sender {
	isPauseMenuDisplayed_ = NO;
	if ([[CCDirector sharedDirector] isPaused]) {
		[[CCDirector sharedDirector] resume];
	}
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[[game_ class] scene] ] ];
}

-(void) mainMenu:(id)sender {
	isPauseMenuDisplayed_ = NO;
	if ([[CCDirector sharedDirector] isPaused]) {
		[[CCDirector sharedDirector] resume];
	}
	int levelNumber = [game_ levelNumber] + 1; 
	if (levelNumber >= 0 && levelNumber <= 10) {
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[EarthLevelSelectorScene scene]]];
	} else if (levelNumber > 10 && levelNumber <= 20) {
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[MarsLevelSelectorScene scene]]];
	} else if (levelNumber > 20 && levelNumber <= 30) {
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[VenusLevelSelectorScene scene]]];
	}
}

-(void) resume:(id)sender {
	if (pauseMenu_ != nil &&
		isPauseMenuDisplayed_ == YES) {
		isPauseMenuDisplayed_ = NO;
		[[CCDirector sharedDirector] resume];
		[self removeChild:pauseMenu_ cleanup:NO];
	}
}

-(void) buttonPause:(id)sender {
	if (!isPauseMenuDisplayed_ &&
		!isGameOver_) {
		isPauseMenuDisplayed_ = YES;
		[[CCDirector sharedDirector] pause];
		[self pause];
	}
}

- (void) dealloc {
	[super dealloc];
}

#pragma mark Touch Handling

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event allTouches];
	
	// This has been changed to use only 1 finger to pan the scene...
	// If you want a two finger drag, make sure that [allTouches count] is 2 and change the [InputController wasSwipe****] to [InputController wasDrag***]
	if([allTouches count] != 2)
		return;
	
	{
		CGPoint previousLocation = [InputController previousFingerLocation:1:touches:event];
		CGPoint location = [InputController previousFingerLocation:2:touches:event];
		float initialDistance = [InputController distanceBetweenTwoPoints:previousLocation toPoint:location];
		
		previousLocation = [InputController fingerLocation:1:touches:event];
		location = [InputController fingerLocation:2:touches:event];
		float endDistance = [InputController distanceBetweenTwoPoints:previousLocation toPoint:location];
		
		if(fabsf(initialDistance - endDistance) > 5)
		{
			if([InputController wasZoomIn:touches:event])
			{
				[game_ zoomIn];
			}
			else if([InputController wasZoomOut:touches :event])
			{
				[game_ zoomOut];
			}			
		}
	}
}


@end
