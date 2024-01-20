//
//  LevelBase.mm
//  StickyET
//
//  Created by pawel on 6/12/11.
//  Copyright 2011 __etcApps__. All rights reserved.
//

#import "LevelBase.h"
#import "BodyNode.h"
#import "Box2dDebugDrawNode.h"
#import "ProgressManager.h"
#import "GameConfiguration.h"
#import "RainSpecialEffectParticle.h"

@implementation LevelBase

-(void) initGraphics {
	// sprites
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprites.plist"];
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"platforms.plist"];
	
	// TIP: Disable this node in release mode
	// Box2dDebug draw in front of background
	if( [[GameConfiguration sharedConfiguration] enableWireframe] ) {
		Box2dDebugDrawNode *b2node = [Box2dDebugDrawNode nodeWithWorld:world_];
		[self addChild:b2node z:30];
	}
	
	// weak ref
	spritesBatchNode_ = [CCSpriteBatchNode batchNodeWithFile:@"sprites.png" capacity:10];
	[self addChild:spritesBatchNode_ z:10];
	
	platformBatchNode_ = [CCSpriteBatchNode batchNodeWithFile:@"platforms.png" capacity:10];
	ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
	[platformBatchNode_.texture setTexParameters:&params];
	[self addChild:platformBatchNode_ z:5];
	
	invisibleBatchNode_ = [CCSpriteBatchNode batchNodeWithTexture:nil];
	invisibleBatchNode_.visible = NO;
	[self addChild:invisibleBatchNode_ z:10];
	
	// The physics world is drawn using 1 big image
	background = [CCSprite spriteWithFile:[self levelName]];
	[background setAnchorPoint:ccp(0,0)];
	// TIP: The correct postion can be obtained from Inkscape
	[background setPosition:ccp(0.0f, 0.0f)];
	[self addChild:background z:-10];
}

-(void) onEnter {
	[super onEnter];

	self.emitter = [CCParticleGalaxy node];
	
	[self setEmitterPosition];
	int gameLevelNum = [self levelNumber];
	if (gameLevelNum >= 10 && gameLevelNum <= 19) {
		self.emitter = [RainSpecialEffectParticle node];
		CGPoint p = emitter.position;
		emitter.position = ccp(p.x, p.y);
		emitter.life = 4;
	} else if (gameLevelNum >= 20 && gameLevelNum <= 29) {
		self.emitter = [CCParticleFire node];
		CGPoint p = emitter.position;
		emitter.position = ccp(p.x, 100);
	}
	
	[background addChild: emitter z:10];
	[self setEmitterPosition];
}

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0, 0, contentSize_.width, contentSize_.height);
}

// This is the default behavior
- (void) addBodyNode:(BodyNode*)node z:(int)zOrder {
	switch (node.preferredParent) {
		case BN_PREFERRED_PARENT_SPRITES_PNG:
			
			// Add to sprites batch node
			[spritesBatchNode_ addChild:node z:zOrder];
			break;
			
		case BN_PREFERRED_PARENT_PLATFORMS_PNG:
			// Add to platform batch node
			[platformBatchNode_ addChild:node z:zOrder];
			break;
			
		case BN_PREFERRED_PARENT_IGNORE:
			[invisibleBatchNode_ addChild:node z:zOrder];
			break;
			
		default:
			CCLOG(@"LevelBase: Unknonw preferred parent");
			break;
	}
}

- (void) gameOver:(BOOL)didWin touchedFatalObject:(BOOL)fatalObjectTouched {	
	if (didWin) {
		[spritesBatchNode_ removeChild:(CCSprite*)hero_ cleanup: NO];
	}
	[super gameOver:didWin touchedFatalObject:fatalObjectTouched];
}

- (NSString*)levelName {
	// Override
	return @"";
}

- (unsigned int) levelNumber {
	// Override
	return 0;
}

- (NSString*) SVGFileName {
	// Override
	return @"";
}

@end
