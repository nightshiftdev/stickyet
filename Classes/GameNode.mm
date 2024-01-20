//
//  GameNode.mm
//  LevelSVG
//
//  Created by Ricardo Quesada on 12/08/09.
//  Copyright 2009 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION
//

//
// This class implements the game logic like:
//
//	- scores
//	- lives
//	- updates the Box2d world
//  - object creation
//  - renders background and sprites
//  - register touch event: supports dragging box2d's objects
//

// sound imports
#import "SimpleAudioEngine.h"


// Import the interfaces
#import "GameNode.h"
#import "SVGParser.h"
#import "GameConstants.h"
#import "Box2DCallbacks.h"
#import "GameConfiguration.h"
#import "HUD.h"
#import "BodyNode.h"
#import "Stickyhero.h"
#import "Box2dDebugDrawNode.h"
#import "BonusNode.h"
#import "Stickable.h"
#import "Worldboundary.h"

#define DEBUG_MODE 0
#define TOUCH_RADIUS 35.0
#define LAUNCH_RADIUS 35.0
#define CANCEL_JUMP_THRESHOLD 20.0
#define MAX_ANGLE 360
#define MIN_ANGLE 0
#define EMITTER_CHANGE_POS_DELAY (10.0f)

@interface GameNode ()
-(void) initPhysics;
-(void) initGraphics;
-(void) updateSprites;
-(void) updateCamera;
-(void) removeB2Bodies;

@end

// HelloWorld implementation
@implementation GameNode

@synthesize world=world_;
@synthesize score=score_, airJumps=airJumps_;
@synthesize gameState=gameState_;
@synthesize hero=hero_;
@synthesize hud=hud_;
@synthesize cameraOffset=cameraOffset_;
@synthesize heroJumping=heroJumping_;
@synthesize jumpDirection=jumpDirection_;
@synthesize collectedLevelParts=collectedLevelParts_;
@synthesize emitter;

#pragma mark GameNode -Initialization

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'game' is an autorelease object.
	GameNode *game = [self node];
	
	// HUD
	HUD *hud = [HUD HUDWithGameNode:game];
	[scene addChild:hud z:10];
	
	// link gameScene with HUD
	game.hud = hud;
	
	// add game as a child to scene
	[scene addChild: game];
	
	// return the scene
	return scene;
}


// initialize your instance here
-(id) init
{
	if( (self=[super init])) {
		
		// enable touches
		self.isTouchEnabled = YES;
		
		score_ = [ProgressManager getOrInitProgress].score;
		airJumps_ = [ProgressManager getOrInitProgress].airJumps;
		initAirJumps_ = airJumps_;
		hero_ = nil;
		
		// game state
		gameState_ = kGameStatePaused;
		
		// camera
		cameraOffset_ = CGPointZero;
		
		CGSize s = [[CCDirector sharedDirector] winSize];
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
		// init box2d physics
		[self initPhysics];
		
		// Init graphics
		[self initGraphics];
		
		// default physics settings
		SVGParserSettings settings;
		settings.defaultDensity = kPhysicsDefaultDensity;
		settings.defaultFriction = kPhysicsDefaultFriction;
		settings.defaultRestitution = kPhysicsDefaultRestitution;
		settings.PTMratio = kPhysicsPTMRatio;
		settings.defaultGravity = ccp( kPhysicsWorldGravityX, kPhysicsWorldGravityY );
		settings.bezierSegments = kPhysicsDefaultBezierSegments;
		
		// create box2d objects from SVG file in world
		[SVGParser parserWithSVGFilename:[self SVGFileName] b2World:world_ settings:&settings target:self selector:@selector(physicsCallbackWithBody:attribs:)];	
		
		// Box2d iterations default values
		worldVelocityIterations_ = 6;
		worldPositionIterations_ = 1;
		
		// nodes to be removed
		nukeCount = 0;
		
		heroJumping_ = false;
		
		collectedLevelParts_ = 	failed;
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		CGRect rect = [self contentRect];
		minZoomOut_ = winSize.width/rect.size.width;
		elapsedTime_ = 0;
		
		retinaDisplay_ = NO;
		dotSize_ = 2.5f;
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
			retinaDisplay_ = YES;
			dotSize_ = 5.0f;
		}
		
		
		[self scheduleUpdateWithPriority:0];
		
		int gameLevelNum = [self levelNumber];
		if (gameLevelNum >= 0 && gameLevelNum <= 9) {
			[[ProgressManager getOrInitProgress] playBlueWorldTheme];
		} else if (gameLevelNum >= 10 && gameLevelNum <= 19) {
			[[ProgressManager getOrInitProgress] playGreenWorldTheme];
		} else if (gameLevelNum >= 20 && gameLevelNum <= 29) {
			[[ProgressManager getOrInitProgress] playRedWorldTheme];
		}
		
	}
	return self;
}

-(void) drawDottedLine:(CGPoint) origin destination:(CGPoint) destination dashLength:(float) dashLength
{
	CGPoint orig = CGPointMake(origin.x * CC_CONTENT_SCALE_FACTOR(), origin.y * CC_CONTENT_SCALE_FACTOR()); 
	CGPoint dest = CGPointMake(destination.x * CC_CONTENT_SCALE_FACTOR(), destination.y * CC_CONTENT_SCALE_FACTOR()); 
	
	float dx = dest.x - orig.x;
	float dy = dest.y - orig.y;
	float dist = sqrtf(dx * dx + dy * dy);
	float x = dx / dist * dashLength;
	float y = dy / dist * dashLength;
	
	CGPoint p1 = orig;
	NSUInteger segments = (int)(dist / dashLength);
	NSUInteger lines = (int)((float)segments / 2.0);
	
	CGPoint *vertices = (CGPoint*)malloc(sizeof(CGPoint) * segments);
	for(unsigned int i = 0; i < lines; i++) {
		vertices[i*2] = p1;
		p1 = CGPointMake((p1.x + x), (p1.y + y));
		vertices[i*2+1] = p1;
		p1 = CGPointMake((p1.x + x), (p1.y + y));
	}
	
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_POINT_SIZE_ARRAY_OES);
	
	glEnable(GL_POINT_SMOOTH);
	glPointSize(dotSize_);
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glPointSizePointerOES(GL_FLOAT,lines*sizeof(float), (GLvoid*) (sizeof(GL_FLOAT)*lines));
	glDrawArrays(GL_POINTS, 0, segments);
	
	// restore default state
	glDisable(GL_POINT_SMOOTH);
	glEnableClientState(GL_POINT_SIZE_ARRAY_OES);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
	
	free(vertices);
}

void drawDashedLine(CGPoint origin, CGPoint destination, float dashLength)
{
	CGPoint orig = CGPointMake(origin.x * CC_CONTENT_SCALE_FACTOR(), origin.y * CC_CONTENT_SCALE_FACTOR()); 
	CGPoint dest = CGPointMake(destination.x * CC_CONTENT_SCALE_FACTOR(), destination.y * CC_CONTENT_SCALE_FACTOR()); 
	
	float dx = dest.x - orig.x;
	float dy = dest.y - orig.y;
	float dist = sqrtf(dx * dx + dy * dy);
	float x = dx / dist * dashLength;
	float y = dy / dist * dashLength;
	
	CGPoint p1 = orig;
	NSUInteger segments = (int)(dist / dashLength);
	NSUInteger lines = (int)((float)segments / 2.0);
	
	CGPoint *vertices = (CGPoint*)malloc(sizeof(CGPoint) * segments);
	for(unsigned int i = 0; i < lines; i++)
	{
		vertices[i*2] = p1;
		p1 = CGPointMake((p1.x + x), (p1.y + y));
		vertices[i*2+1] = p1;
		p1 = CGPointMake((p1.x + x), (p1.y + y));
	}
	
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glDrawArrays(GL_LINES, 0, segments);
	
	// restore default state
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
	
	free(vertices);
}

-(void) draw {	
	b2Vec2 playerPos = [hero_ body]->GetPosition();
	if(gameState_ == kGameStateAiming){
		glColor4f(144.0/255.0, 75.0/253.0, 173.0/255.0, 255.0/255.0);  
		glEnable(GL_LINE_SMOOTH);
		//ccDrawCircle(ccp(playerPos.x * kPhysicsPTMRatio, playerPos.y * kPhysicsPTMRatio), TOUCH_RADIUS, 0.0, 20, NO);
		//ccDrawLine(ccp(playerPos.x * kPhysicsPTMRatio, playerPos.y * kPhysicsPTMRatio), ccp(jumpDirection_.x, jumpDirection_.y));
		
		float xPrim = (2 * (playerPos.x * kPhysicsPTMRatio) - jumpDirection_.x);
		float yPrim = (2 * (playerPos.y * kPhysicsPTMRatio) - jumpDirection_.y);
		
		float xSigma = 3 * (xPrim - (playerPos.x * kPhysicsPTMRatio)) + (playerPos.x * kPhysicsPTMRatio);
		float ySigma = 3 * (yPrim - (playerPos.y * kPhysicsPTMRatio)) + (playerPos.y * kPhysicsPTMRatio);
		
		float segments = 5.0;
		if (self.scale != 1.0f) {
			segments = 10.0;
			if (retinaDisplay_) {
				segments = 20.0;
			}
		} else {
			if (retinaDisplay_) {
				segments = 10.0;
			}
		}
		
		[self drawDottedLine:ccp(playerPos.x * kPhysicsPTMRatio, playerPos.y * kPhysicsPTMRatio) destination:ccp(xSigma, ySigma) dashLength:segments];
		
		//drawDashedLine(ccp(playerPos.x * kPhysicsPTMRatio, playerPos.y * kPhysicsPTMRatio), ccp(xSigma, ySigma), segments);
		
		//ccDrawCubicBezier(ccp(playerPos.x * kPhysicsPTMRatio, playerPos.y * kPhysicsPTMRatio), ccp(xPrim+25, yPrim+25), ccp(xPrim-25, yPrim-25), ccp(xSigma, ySigma), 100);
		//ccDrawLine(ccp(playerPos.x * kPhysicsPTMRatio, playerPos.y * kPhysicsPTMRatio), ccp(xSigma, ySigma));
	}
}

-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
	gameState_ = kGameStatePlaying;
	
	CGRect rect = [self contentRect];
	CCFollow *action = [CCFollow actionWithTarget:hero_ worldBoundary:rect];
	[action setTag:kGameNodeFollowActionTag];
	[self runAction:action];
}

-(void) initGraphics
{
	CCLOG(@"LevelSVG: GameNode#initGraphics: override me");
}

-(NSString*) SVGFileName
{
	CCLOG(@"LevelSVG: GameNode:SVGFileName: override me");
	return nil;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	
	// physics stuff
	if( world_ )
		delete world_;
	
	// delete box2d callback objects
	if( m_contactListener )
		delete m_contactListener;
	if( m_contactFilter )
		delete m_contactFilter;
	if( m_destructionListener )
		delete m_destructionListener;
	
	[emitter release];
	
	// don't forget to call "super dealloc"
	[super dealloc];	
}

-(void) registerWithTouchDispatcher
{
	// Priorities: lower number, higher priority
	// Joystick: 10
	// GameNode (dragging objects): 50
	// HUD (dragging screen): 100
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:50 swallowsTouches:YES];
}

-(void) initPhysics
{
	// Define the gravity vector.
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	
	// Do we want to let bodies sleep?
	// This will speed up the physics simulation
	bool doSleep = true;
	
	// Construct a world object, which will hold and simulate the rigid bodies.
	world_ = new b2World(gravity, doSleep);
	
	world_->SetContinuousPhysics(true);
	
	// contact listener
	m_contactListener = new MyContactListener();
	world_->SetContactListener( m_contactListener );
	
	// contact filter
	//	m_contactFilter = new MyContactFilter();
	//	world_->SetContactFilter( m_contactFilter );
	
	// destruction listener
	m_destructionListener = new MyDestructionListener();
	world_->SetDestructionListener( m_destructionListener );
	
	// init mouse stuff
	mouseJoint_ = NULL;
	b2BodyDef	bodyDef;
	mouseStaticBody_ = world_->CreateBody(&bodyDef);	
}

-(CGRect) contentRect
{
	NSLog(@"GameNode#contentRect");
	
	NSAssert( NO, @"You override this method in your Level class. It should return the rect that contains your map");
	return CGRectMake(0,0,0,0);
}

#pragma mark GameNode - MainLoop

-(void) update: (ccTime) dt
{
	elapsedTime_ += dt;
	// Only step the world if status is Playing or GameOver
	if( gameState_ != kGameStatePaused ) {
		
		//It is recommended that a fixed time step is used with Box2D for stability
		//of the simulation, however, we are using a variable time step here.
		//You need to make an informed choice, the following URL is useful
		//http://gafferongames.com/game-physics/fix-your-timestep/
		
		// Instruct the world to perform a single step of simulation. It is
		// generally best to keep the time step and iterations fixed.
		world_->Step(dt, worldVelocityIterations_, worldPositionIterations_ );
	}
	
	if (EMITTER_CHANGE_POS_DELAY - elapsedTime_ <= 0) {
		[self setEmitterPosition];
		elapsedTime_ = 0;
	}
	
	
	// removed box2d bodies scheduled to be removed
	[self removeB2Bodies];
	
	// update cocos2d sprites from box2d world
	[self updateSprites];
	
	// update camera
	[self updateCamera];
	
}

-(void) setEmitterPosition
{
	int randomX = arc4random() % 800;
	if (randomX < 200) {
		randomX =+ 200;
	}	
	int randomY = arc4random() % 800;
	if (randomY < 200) {
		randomY =+ 200;
	}
	if( CGPointEqualToPoint( emitter.sourcePosition, CGPointZero ) ) 
		emitter.position = ccp(randomX, randomY);
	int gameLevelNum = [self levelNumber];
	if (gameLevelNum >= 10 && gameLevelNum <= 19) {
		if( CGPointEqualToPoint( emitter.sourcePosition, CGPointZero ) ) 
			emitter.position = ccp(512, 1024);
	} else if (gameLevelNum >= 20 && gameLevelNum <= 29) {
		if( CGPointEqualToPoint( emitter.sourcePosition, CGPointZero ) ) 
			emitter.position = ccp(randomX, randomY);
	}
}

-(void) removeB2Body:(b2Body*)body
{
	NSAssert( nukeCount < kMaxNodesToBeRemoved, @"LevelSVG: Increase the kMaxNodesToBeRemoved in GameConstants.h");
	
	nuke[nukeCount++] = body;
	
}

-(void) removeB2Bodies
{
	// Sort the nuke array to group duplicates.
	std::sort(nuke, nuke + nukeCount);
	
	// Destroy the bodies, skipping duplicates.
	unsigned int i = 0;
	while (i < nukeCount)
	{
		b2Body* b = nuke[i++];
		while (i < nukeCount && nuke[i] == b)
		{
			++i;
		}
		
		// IMPORTANT: don't alter the order of the following commands, or it might crash.
		
		// 1. obtain a weak ref to the BodyNode
		BodyNode *node = (BodyNode*) b->GetUserData();
		
		// 2. destroy the b2body
		world_->DestroyBody(b);
		
		// 3. set the the body to NULL
		[node setBody:NULL];
		
		// 4. remove BodyNode
		[node removeFromParentAndCleanup:YES];
		
		
	}
	
	nukeCount = 0;
}

-(void) updateCamera
{
	if( hero_ ) {
		CGPoint pos = position_;
		
		if (self.scale != 1.0f) {
			pos.x = 0.0f;
			pos.y = pos.y * (self.scale * 0.5f);
		}
		[self setPosition:ccp(pos.x+cameraOffset_.x, pos.y+cameraOffset_.y)];
	}
}

-(void) updateSprites
{
	for (b2Body* b = world_->GetBodyList(); b; b = b->GetNext())
	{
		BodyNode *node = (BodyNode*) b->GetUserData();
		
		//
		// Only update sprites that are meant to be updated by the physics engine
		//
		if( node && (node->properties_ & BN_PROPERTY_SPRITE_UPDATED_BY_PHYSICS) ) {
			//Synchronize the sprites' position and rotation with the corresponding body
			b2Vec2 pos = b->GetPosition();
			node.position = ccp( pos.x * kPhysicsPTMRatio, pos.y * kPhysicsPTMRatio);
			if( ! b->IsFixedRotation() )
				node.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}	
}

- (void) giveBonusAirJumps {
	switch (collectedLevelParts_) {
		case passed:
			airJumps_ += 1;
			break;
		case good:
			airJumps_ += 2;
			break;
		case excellent:
			airJumps_ += 3;
			break;
		default:
			break;
	}
}

-(void) gameOver:(BOOL)didWin touchedFatalObject:(BOOL) fatalObjectTouched
{
	gameState_ = kGameStateGameOver;
	if (collectedLevelParts_ > failed) {
		[hud_ gameOver:didWin touchedFatalObject:fatalObjectTouched];
		if (didWin) {
			[ProgressManager getOrInitProgress].score = self.score;
			unsigned int prevCollectedLevelParts = [[ProgressManager getOrInitProgress] partsForLevel: [self levelNumber]];
			if (collectedLevelParts_ > prevCollectedLevelParts) {
				[[ProgressManager getOrInitProgress] setParts:(stars)collectedLevelParts_ forLevel:[self levelNumber]];
			}
			[self giveBonusAirJumps];
			[ProgressManager getOrInitProgress].airJumps = self.airJumps;
			[[ProgressManager getOrInitProgress] unlockLevel:[self levelNumber] + 1];
		} else {
			[ProgressManager getOrInitProgress].score = self.score - collectedLevelParts_;
			[ProgressManager getOrInitProgress].airJumps = initAirJumps_;
		}
		[[ProgressManager getOrInitProgress] save];
		[hero_ onGameOver:didWin];
	} else {
		[hud_ gameOver:false touchedFatalObject:fatalObjectTouched];
		[hero_ onGameOver:false];
	}
}

-(void) increaseAirJumps:(int)aj
{
	airJumps_ += aj;
	if (airJumps_ < 0) {
		airJumps_ = 0;
	}
	[hud_ onUpdateAirJumps:airJumps_];
}

-(void) increaseScore:(int)score
{
	if (collectedLevelParts_ < excellent) {
		collectedLevelParts_++;
	}
	score_ += score;
	[hud_ onUpdateScore:score_];
}

#pragma mark GameNode - Box2d Callbacks

// will be called for each created body in the parser
-(void) physicsCallbackWithBody:(b2Body*)body attribs:(NSString*)gameAttribs
{
	NSArray *values = [gameAttribs componentsSeparatedByString:@","];
	NSEnumerator *nse = [values objectEnumerator];
	
	if( ! values ) {
		CCLOG(@"LevelSVG: physicsCallbackWithBody: empty attribs");
		return;
	}
	
	BodyNode *node = nil;
	
	for( NSString *propertyValue in nse ) {
		NSArray *arr = [propertyValue componentsSeparatedByString:@"="];
		NSString *key = [arr objectAtIndex:0];
		NSString *value = [arr objectAtIndex:1];
		
		key = [key lowercaseString];
		
		if( [key isEqualToString:@"object"] ) {
			
			value = [value capitalizedString];
			Class klass = NSClassFromString( value );
			
			if( klass ) {
				// The BodyNode will be added to the scene graph at init time
				node = [[klass alloc] initWithBody:body game:self];
				
				[self addBodyNode:node z:0];
				[node release];
			} else {
				CCLOG(@"GameNode: WARNING: Don't know how to create class: %@", value);
			}
			
		} else if( [key isEqualToString:@"objectparams"] ) {
			// Format of parameters:
			// objectParams=direction:vertical;target:1;visible:NO;
			NSDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:10];
			NSArray *params = [value componentsSeparatedByString:@";"];
			for( NSString *param in params) {
				NSArray *keyVal = [param componentsSeparatedByString:@":"];
				[dict setValue:[keyVal objectAtIndex:1] forKey:[keyVal objectAtIndex:0]];
			}
			[node setParameters:dict];
			[dict release];
			
		} else
			NSLog(@"Game Scene callback: unrecognized key: %@", key);
	}
}

// This is the default behavior
-(void) addBodyNode:(BodyNode*)node z:(int)zOrder
{
	CCLOG(@"LevelSVG: GameNode#addBodyNode override me");
}

#pragma mark GameNode - Touch Events Handler

- (BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event {
	
	if (gameState_ == kGameStateGameOver) {
		return NO;
	}
	
	CGPoint pt = [self convertTouchToNodeSpace:touch];	
	float radiusSQ = TOUCH_RADIUS*TOUCH_RADIUS;
	
	b2Vec2 playerPos = [hero_ body]->GetPosition();
	
	CGPoint vector = ccpSub(ccp(playerPos.x * kPhysicsPTMRatio, playerPos.y * kPhysicsPTMRatio), pt); 
	if (ccpLengthSQ(vector) < radiusSQ) {
		gameState_ = kGameStateAiming;
		[[SimpleAudioEngine sharedEngine] playEffect:@"aim.wav"];
		jumpDirection_.x = pt.x;
		jumpDirection_.y = pt.y;
		return YES;
	} else {
		return NO;
	}
}

- (void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent*)event
{
	CGPoint pt = [self convertTouchToNodeSpace:touch];
	
	b2Vec2 playerPos = [hero_ body]->GetPosition();
	//Get the vector, angle, length, and normal vector of the touch
	CGPoint vector = ccpSub(pt, ccp(playerPos.x * kPhysicsPTMRatio, playerPos.y * kPhysicsPTMRatio));
	CGPoint normalVector = ccpNormalize(vector);
	float angleRads = ccpToAngle(normalVector);
	float aimAngle = CC_RADIANS_TO_DEGREES(-1 * angleRads);
	int angleDegs = (int)CC_RADIANS_TO_DEGREES(angleRads) % 360;
	float length = ccpLength(vector);
	
	//Correct the Angle; we want a positive one
	while (angleDegs < 0)
		angleDegs += 360;
	
	//Limit the length
	if (length > LAUNCH_RADIUS)
		length = LAUNCH_RADIUS;
	
	//Limit the angle
	if (angleDegs > MAX_ANGLE)
		normalVector = ccpForAngle(CC_DEGREES_TO_RADIANS(MAX_ANGLE));
	else if (angleDegs < MIN_ANGLE)
		normalVector = ccpForAngle(CC_DEGREES_TO_RADIANS(MIN_ANGLE));
	
	jumpDirection_.x = pt.x;
	jumpDirection_.y = pt.y;
	//Set the position
	CGPoint pos = ccpAdd(ccp(playerPos.x * kPhysicsPTMRatio, playerPos.y * kPhysicsPTMRatio), ccpMult(normalVector, length));
	jumpDirection_.x = pos.x;
	jumpDirection_.y = pos.y;
	
	[hero_ animateAim:aimAngle];
}

- (void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent*)event
{
	b2Vec2 playerPos = [hero_ body]->GetPosition();
	CGPoint vector = ccpSub(ccp(playerPos.x * kPhysicsPTMRatio, playerPos.y * kPhysicsPTMRatio), ccp(jumpDirection_.x, jumpDirection_.y));
	
	float length = ccpLength(vector);
	if (length <= CANCEL_JUMP_THRESHOLD) {
		gameState_ = kGameStatePlaying;
		[hero_ cancelJump];
	} else {
		[hero_ jump:b2Vec2(vector.x, vector.y)];
		heroJumping_ = YES;
		[hero_ destroyStickJoint];
		gameState_ = kGameStatePlaying;
		[hero_ animateJump:b2Vec2(vector.x, vector.y)];
	}
}

#pragma mark GameNode - Touches (Mouse simulation)

//
// mouse code based on Box2d TestBed example: http://www.box2d.org
//

// 'button' is being pressed.
// Attach a mouseJoint if we are touching a box2d body
-(BOOL) mouseDown:(b2Vec2) p
{
	bool ret = false;
	
	if (mouseJoint_ != NULL)
		return false;
	
	// Make a small box.
	b2AABB aabb;
	b2Vec2 d;
	d.Set(0.001f, 0.001f);
	aabb.lowerBound = p - d;
	aabb.upperBound = p + d;
	
	// Query the world for overlapping shapes.
	MyQueryCallback callback(p);
	world_->QueryAABB(&callback, aabb);
	
	// only return yes if the fixture is touchable.
	if (callback.m_fixture )
	{
		b2Body *body = callback.m_fixture->GetBody();
		BodyNode *node = (BodyNode*) body->GetUserData();
		if( node && node.isTouchable ) {
			//
			// Attach touched body to static body with a mouse joint
			//
			body = callback.m_fixture->GetBody();
			b2MouseJointDef md;
			md.bodyA = mouseStaticBody_;
			md.bodyB = body;
			md.target = p;
			md.maxForce = 1000.0f * body->GetMass();
			mouseJoint_ = (b2MouseJoint*) world_->CreateJoint(&md);
			body->SetAwake(true);
			
			ret = true;
		}
	}
	
	return ret;
}

//
// 'button' is not being pressed any more. Destroy the mouseJoint
//
-(void) mouseUp:(b2Vec2)p
{
	if (mouseJoint_)
	{
		world_->DestroyJoint(mouseJoint_);
		mouseJoint_ = NULL;
	}	
}

//
// The mouse is moving: drag the mouseJoint
-(void) mouseMove:(b2Vec2)p
{	
	if (mouseJoint_)
		mouseJoint_->SetTarget(p);
}

-(unsigned int) levelNumber {
	// override in subclass
	return 0;
}

-(void)zoomIn {
	self.scale = 1.0f;
}

-(void)zoomOut {
	self.scale = minZoomOut_;
	self.anchorPoint = CGPointMake(0.0f, 0.0f);
}
@end
