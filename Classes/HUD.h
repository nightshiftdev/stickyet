//
//  HUD.h
//  LevelSVG
//
//  Created by Ricardo Quesada on 16/10/09.
//  Copyright 2009 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION
//

#import "cocos2d.h"


@protocol JoystickProtocol;
@class JumpButton;
@class GameNode;

@interface HUD : CCLayer {
	
	// game
	GameNode *game_;

	// joystick and joysprite. weak ref
	id<JoystickProtocol> joystick_;
	
	CCLabelBMFont *score_;
	CCLabelBMFont *airJumps_;
	CCMenu *pauseMenu_;
	BOOL isPauseMenuDisplayed_;
	BOOL isGameOver_;
	int levelShipParts_;
}

// creates and initializes a HUD
+(id) HUDWithGameNode:(GameNode*)game;

// initializes a HUD with a delegate
-(id) initWithGameNode:(GameNode*)game;
-(void) gameOver:(BOOL)didWin touchedFatalObject:(BOOL) fatalObjectTouched;
-(void) onUpdateScore:(int)newScore;
-(void) onUpdateAirJumps:(int)newAirJumps;
@end
