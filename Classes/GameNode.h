//
//  GameNode.h
//  LevelSVG
//
//  Created by Ricardo Quesada on 12/08/09.
//  Copyright 2009 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"

#import "GLES-Render.h"
#import "Box2DCallbacks.h"
#import "GameConstants.h"
#import "ProgressManager.h"

// forward declarations
@class Stickyhero;
@class HUD;
@class BodyNode;
@class BonusNode;

// game state
typedef enum
{
	kGameStatePaused,
	kGameStatePlaying,
	kGameStateGameOver,
	kGameStateAiming,
} GameState;

#define kGameNodeFollowActionTag	1

// HelloWorld Layer
@interface GameNode : CCLayer
{
	// box2d world
	b2World		*world_;
	
	// game state
	GameState		gameState_;
	
	// the camera will be centered on the Hero
	// If you want to move the camera, you should move this value
	CGPoint		cameraOffset_;
	
	unsigned int score_;
	unsigned int airJumps_;
	unsigned int initAirJumps_;
	unsigned int collectedLevelParts_;
	
	// Hero weak ref
	Stickyhero	*hero_;
	
	// HUD weak ref
	HUD		*hud_;
	
	// Box2d: Used when dragging objects
	b2MouseJoint	* mouseJoint_;
	b2Body			* mouseStaticBody_;
	
	// box2d callbacks
	// In order to compile on SDK 2.2.x or older, they have to be pointers
	MyContactFilter			*m_contactFilter;
	MyContactListener		*m_contactListener;
	MyDestructionListener	*m_destructionListener;	
	
	// box2d iterations. Can be configured by each level
	int	worldPositionIterations_;
	int worldVelocityIterations_;
	
	// GameNode is responsible for removing "removed" nodes
	unsigned int nukeCount;
	b2Body* nuke[kMaxNodesToBeRemoved];
	
	BOOL heroJumping_;
	b2Vec2 jumpDirection_;
	
	float minZoomOut_;
	
	CCParticleSystem *emitter;
	ccTime elapsedTime_;
	
	BOOL retinaDisplay_;
	float dotSize_;
}

@property (readwrite,retain) CCParticleSystem *emitter;

@property (nonatomic, readwrite) BOOL heroJumping;

@property (readwrite,nonatomic) b2Vec2 jumpDirection;

/** Box2d World */
@property (readwrite,nonatomic) b2World *world;

@property (readonly,nonatomic) unsigned int score;

@property (readonly,nonatomic) unsigned int airJumps;

@property (readonly,nonatomic) unsigned int collectedLevelParts;

/** game state */
@property (readonly,nonatomic) GameState gameState;

/** weak ref to hero */
@property (readwrite,nonatomic,assign) Stickyhero *hero;

/** weak ref to HUD */
@property (readwrite, nonatomic, assign) HUD *hud;

/** offset of the camera */
@property (readwrite,nonatomic) CGPoint cameraOffset;

// returns a Scene that contains the GameLevel and a HUD
+(id) scene;

// initialize game with level
-(id) init;

/** returns the SVGFileName to be loaded */
-(NSString*) SVGFileName;

// mouse (touches)
-(BOOL) mouseDown:(b2Vec2)p;
-(void) mouseMove:(b2Vec2)p;
-(void) mouseUp:(b2Vec2)p;

// game events
-(void) gameOver:(BOOL)didWin touchedFatalObject:(BOOL) fatalObjectTouched;
-(void) increaseScore:(int)score;
-(void) increaseAirJumps:(int)aj;

// creates the foreground and background graphics
-(void) initGraphics;

// adds the BodyNode to the scene graph
-(void) addBodyNode:(BodyNode*)node z:(int)zOrder;

// schedule a b2Body to be removed
-(void) removeB2Body:(b2Body*)body;

// returns the content Rectangle of the Map
-(CGRect) contentRect;

-(unsigned int) levelNumber;
-(void)zoomIn;
-(void)zoomOut;
-(void)setEmitterPosition;
-(void) drawDottedLine:(CGPoint) origin destination:(CGPoint) destination dashLength:(float) dashLength;
@end
