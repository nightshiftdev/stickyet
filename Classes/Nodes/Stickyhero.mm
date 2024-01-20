#import <Box2d/Box2D.h>
#import "cocos2d.h"

//#import "Joystick.h"
#import "GameNode.h"
#import "GameConfiguration.h"
#import "GameConstants.h"
#import "Stickyhero.h"
#import "Stickable.h"
#import "Stickableplatform.h"
#import "Leftstickableplatform.h"
#import "SpecialEffectParticle.h"
#import "SimpleAudioEngine.h"
//#import "Platform1.h"
//#import "BadGuy.h"
//#import "Princess.h"
//#import "BonusNode.h"
//#import "Ladder.h"

#define	JUMP_IMPULSE (1.0f)
#define STICK_TIME (2.0f)
#define IDLE_ANIMATION_DELAY (10.0f)

@interface Stickyhero ()
//-(void) readJoystick;
-(void) updateCollisions;
@end

//
// Hero: Base class of the Hero.
// The Hero is the main character, is the sprite that is controlled by the player.
// The base class handles all the collisions, and the input (d-pad or accelerometer)
//
@implementation Stickyhero

//@synthesize joystick=joystick_;
@synthesize isBlinking=isBlinking_;
@synthesize jumpAnim = jumpAnim_;
@synthesize splashAnim = splashAnim_;
@synthesize aimAnim = aimAnim_;
@synthesize idleAnim = idleAnim_;
@synthesize unstickAnim = unstickAnim_;

-(id) initWithBody:(b2Body*)body game:(GameNode*)game
{
	if( (self=[super initWithBody:body game:game]) ) {
		
		// listen to beginContact, endContact and presolve
		reportContacts_ = BN_CONTACT_BEGIN | BN_CONTACT_END | BN_CONTACT_PRESOLVE;
		
		// this body can't be dragged
		isTouchable_ = NO;
		
		// It only blinks after touching an enemy
		isBlinking_ = NO;

		// weak ref
		world_ = [game_ world];
		
		// Tell the game, that this instace is the Hero
		[game setHero:self];
		
		// hero collisions
		contactPointCount_ = 0;
		
		// hero 
		elapsedTime_ = lastTimeForceApplied_ = 0;
	
		// optimization: calculate the direction at init time
		controlDirection_ = [[GameConfiguration sharedConfiguration] controlDirection];

		gettimeofday(&timeJointCreated_, NULL);
		joint_ = NULL;
		
		// schedule the Hero main loop.
		// Do it "after" the GameNode game loop.
		// This is a workaround so that the bullets are not affected by gravity.
		[self scheduleUpdateWithPriority:10];
		
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"I-1.png"];
		[self setDisplayFrame:frame];
		
		preferredParent_ = BN_PREFERRED_PARENT_SPRITES_PNG;
		
		//
		// box2d stuff: Create the "correct" fixture
		//
		// 1. destroy already created fixtures
		[self destroyAllFixturesFromBody:body];
		
		// 2. create new fixture
		b2FixtureDef	fd;
		b2CircleShape	shape;
		shape.m_radius = 0.4f;		// 1 meter of diameter (optimized size)
		fd.friction		= 0.1f;
		fd.density		= 0.7f;
		fd.restitution	= 0.0f;		// don't bounce
		
		fd.shape = &shape;
		body->CreateFixture(&fd);
		
		// TIP: fixed rotation. The hero can't rotate. Very useful for Super Mario like games
		body->SetFixedRotation(true);
		
		// Collision filtering between Hero and Bullet
		// If the groupIndex is negative, then the fixtures NEVER collide.
		fd.filter.groupIndex = -kCollisionFilterGroupIndexHero;
		
		body->SetType(b2_dynamicBody);
		
		jumpImpulse_ = JUMP_IMPULSE;
		
		antiGravityForce_ = YES;
		touchingGround_ = YES;
		isTouchable_ = YES;
		
		
		// Animate jump
		CCSpriteFrameCache *jumpCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame *jFrame1 = [jumpCache spriteFrameByName:@"A-1.png"];
		CCSpriteFrame *jFrame2 = [jumpCache spriteFrameByName:@"A-2.png"];
		CCSpriteFrame *jFrame3 = [jumpCache spriteFrameByName:@"A-3.png"];
		CCSpriteFrame *jFrame4 = [jumpCache spriteFrameByName:@"A-4.png"];
		CCSpriteFrame *jFrame5 = [jumpCache spriteFrameByName:@"A-5.png"];
		CCSpriteFrame *jFrame6 = [jumpCache spriteFrameByName:@"A-6.png"];
		CCSpriteFrame *jFrame7 = [jumpCache spriteFrameByName:@"A-7.png"];
		CCSpriteFrame *jFrame8 = [jumpCache spriteFrameByName:@"A-8.png"];
		CCSpriteFrame *jFrame9 = [jumpCache spriteFrameByName:@"A-9.png"];
		CCSpriteFrame *jFrame10 = [jumpCache spriteFrameByName:@"A-10.png"];
		CCSpriteFrame *jFrame11 = [jumpCache spriteFrameByName:@"A-11.png"];
		CCSpriteFrame *jFrame12 = [jumpCache spriteFrameByName:@"A-12.png"];
		CCSpriteFrame *jFrame13 = [jumpCache spriteFrameByName:@"A-13.png"];
		CCSpriteFrame *jFrame14 = [jumpCache spriteFrameByName:@"A-14.png"];
		CCSpriteFrame *jFrame15 = [jumpCache spriteFrameByName:@"A-15.png"];
		CCSpriteFrame *jFrame16 = [jumpCache spriteFrameByName:@"A-16.png"];
		CCSpriteFrame *jFrame17 = [jumpCache spriteFrameByName:@"A-17.png"];
		CCSpriteFrame *jFrame18 = [jumpCache spriteFrameByName:@"A-18.png"];
		CCSpriteFrame *jFrame19 = [jumpCache spriteFrameByName:@"A-19.png"];
		CCSpriteFrame *jFrame20 = [jumpCache spriteFrameByName:@"A-20.png"];
		CCSpriteFrame *jFrame21 = [jumpCache spriteFrameByName:@"A-21.png"];
		CCSpriteFrame *jFrame22 = [jumpCache spriteFrameByName:@"A-22.png"];
		CCSpriteFrame *jFrame23 = [jumpCache spriteFrameByName:@"A-23.png"];
		CCSpriteFrame *jFrame24 = [jumpCache spriteFrameByName:@"A-24.png"];
		NSArray *jumpFrames = [NSArray arrayWithObjects:jFrame1, jFrame2, jFrame3, jFrame4, jFrame5, jFrame6, 
							   jFrame7, jFrame8, jFrame9, jFrame10, jFrame11, jFrame12, jFrame13, jFrame14, 
							   jFrame15, jFrame16, jFrame17, jFrame18, jFrame19, jFrame20, jFrame21, jFrame22,
							   jFrame23, jFrame24, nil];
		self.jumpAnim = [CCAnimation animationWithFrames:jumpFrames delay:0.1f];
		
		// Animate splash
		CCSpriteFrameCache *splashCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame *sFrame1 = [splashCache spriteFrameByName:@"J-1.png"];
		CCSpriteFrame *sFrame2 = [splashCache spriteFrameByName:@"J-2.png"];
		CCSpriteFrame *sFrame3 = [splashCache spriteFrameByName:@"J-3.png"];
		CCSpriteFrame *sFrame4 = [splashCache spriteFrameByName:@"J-4.png"];
		CCSpriteFrame *sFrame5 = [splashCache spriteFrameByName:@"J-5.png"];
		CCSpriteFrame *sFrame6 = [splashCache spriteFrameByName:@"J-6.png"];
		CCSpriteFrame *sFrame7 = [splashCache spriteFrameByName:@"J-7.png"];
		CCSpriteFrame *sFrame8 = [splashCache spriteFrameByName:@"J-8.png"];
		CCSpriteFrame *sFrame9 = [splashCache spriteFrameByName:@"J-9.png"];
		CCSpriteFrame *sFrame10 = [splashCache spriteFrameByName:@"J-10.png"];
		CCSpriteFrame *sFrame11 = [splashCache spriteFrameByName:@"J-11.png"];
		CCSpriteFrame *sFrame12 = [splashCache spriteFrameByName:@"J-12.png"];
		CCSpriteFrame *sFrame13 = [splashCache spriteFrameByName:@"J-13.png"];
		CCSpriteFrame *sFrame14 = [splashCache spriteFrameByName:@"J-14.png"];
		CCSpriteFrame *sFrame15 = [splashCache spriteFrameByName:@"J-15.png"];
		CCSpriteFrame *sFrame16 = [splashCache spriteFrameByName:@"J-16.png"];
		CCSpriteFrame *sFrame17 = [splashCache spriteFrameByName:@"J-17.png"];
		CCSpriteFrame *sFrame18 = [splashCache spriteFrameByName:@"J-18.png"];
		CCSpriteFrame *sFrame19 = [splashCache spriteFrameByName:@"J-19.png"];
		CCSpriteFrame *sFrame20 = [splashCache spriteFrameByName:@"J-20.png"];
		CCSpriteFrame *sFrame21 = [splashCache spriteFrameByName:@"J-21.png"];
		CCSpriteFrame *sFrame22 = [splashCache spriteFrameByName:@"J-22.png"];
		CCSpriteFrame *sFrame23 = [splashCache spriteFrameByName:@"J-23.png"];
		CCSpriteFrame *sFrame24 = [splashCache spriteFrameByName:@"J-24.png"];
		NSArray *splashFrames = [NSArray arrayWithObjects:sFrame1, sFrame2, sFrame3, sFrame4, sFrame5, sFrame6, sFrame7,
								 sFrame8, sFrame9, sFrame10, sFrame11, sFrame12, sFrame13, sFrame14, sFrame15, sFrame16,
								 sFrame17, sFrame18, sFrame19, sFrame20, sFrame21, sFrame22, sFrame23, sFrame24, nil];
		self.splashAnim = [CCAnimation animationWithFrames:splashFrames delay:0.05f];
		
		// Animate aim
		CCSpriteFrameCache *aimCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame *aFrame1 = [aimCache spriteFrameByName:@"A-13.png"];
		CCSpriteFrame *aFrame2 = [aimCache spriteFrameByName:@"A-12.png"];
		CCSpriteFrame *aFrame3 = [aimCache spriteFrameByName:@"A-11.png"];
		CCSpriteFrame *aFrame4 = [aimCache spriteFrameByName:@"A-10.png"];
		CCSpriteFrame *aFrame5 = [aimCache spriteFrameByName:@"A-9.png"];
		CCSpriteFrame *aFrame6 = [aimCache spriteFrameByName:@"A-8.png"];
		CCSpriteFrame *aFrame7 = [aimCache spriteFrameByName:@"A-7.png"];
		CCSpriteFrame *aFrame8 = [aimCache spriteFrameByName:@"A-6.png"];
		CCSpriteFrame *aFrame9 = [aimCache spriteFrameByName:@"A-5.png"];
		CCSpriteFrame *aFrame10 = [aimCache spriteFrameByName:@"A-4.png"];
		CCSpriteFrame *aFrame11 = [aimCache spriteFrameByName:@"A-3.png"];
		CCSpriteFrame *aFrame12 = [aimCache spriteFrameByName:@"A-2.png"];
		CCSpriteFrame *aFrame13 = [aimCache spriteFrameByName:@"A-1.png"];
		NSArray *aimFrames = [NSArray arrayWithObjects:aFrame1, aFrame2, aFrame3, aFrame4, aFrame5, aFrame6, aFrame7,
							  aFrame8, aFrame9, aFrame10, aFrame11, aFrame12, aFrame13, nil];
		self.aimAnim = [CCAnimation animationWithFrames:aimFrames delay:0.1f];
		
		// Animate idle
		CCSpriteFrameCache *idleCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame *iFrame1 = [idleCache spriteFrameByName:@"I-1.png"];
		CCSpriteFrame *iFrame2 = [idleCache spriteFrameByName:@"I-2.png"];
		CCSpriteFrame *iFrame3 = [idleCache spriteFrameByName:@"I-3.png"];
		CCSpriteFrame *iFrame4 = [idleCache spriteFrameByName:@"I-4.png"];
		CCSpriteFrame *iFrame5 = [idleCache spriteFrameByName:@"I-5.png"];
		CCSpriteFrame *iFrame6 = [idleCache spriteFrameByName:@"I-6.png"];
		CCSpriteFrame *iFrame7 = [idleCache spriteFrameByName:@"I-7.png"];
		CCSpriteFrame *iFrame8 = [idleCache spriteFrameByName:@"I-8.png"];
		CCSpriteFrame *iFrame9 = [idleCache spriteFrameByName:@"I-9.png"];
		CCSpriteFrame *iFrame10 = [idleCache spriteFrameByName:@"I-10.png"];
		CCSpriteFrame *iFrame11 = [idleCache spriteFrameByName:@"I-11.png"];
		CCSpriteFrame *iFrame12 = [idleCache spriteFrameByName:@"I-12.png"];
		CCSpriteFrame *iFrame13 = [idleCache spriteFrameByName:@"I-13.png"];
		CCSpriteFrame *iFrame14 = [idleCache spriteFrameByName:@"I-14.png"];
		CCSpriteFrame *iFrame15 = [idleCache spriteFrameByName:@"I-15.png"];
		CCSpriteFrame *iFrame16 = [idleCache spriteFrameByName:@"I-16.png"];
		CCSpriteFrame *iFrame17 = [idleCache spriteFrameByName:@"I-17.png"];
		CCSpriteFrame *iFrame18 = [idleCache spriteFrameByName:@"I-18.png"];
		CCSpriteFrame *iFrame19 = [idleCache spriteFrameByName:@"I-19.png"];
		CCSpriteFrame *iFrame20 = [idleCache spriteFrameByName:@"I-20.png"];
		CCSpriteFrame *iFrame21 = [idleCache spriteFrameByName:@"I-21.png"];
		CCSpriteFrame *iFrame22 = [idleCache spriteFrameByName:@"I-22.png"];
		CCSpriteFrame *iFrame23 = [idleCache spriteFrameByName:@"I-23.png"];
		CCSpriteFrame *iFrame24 = [idleCache spriteFrameByName:@"I-24.png"];
		CCSpriteFrame *iFrame25 = [idleCache spriteFrameByName:@"I-1.png"];
		NSArray *idleFrames = [NSArray arrayWithObjects:iFrame1, iFrame2, iFrame3, iFrame4, iFrame5, iFrame6, iFrame7, 
							   iFrame8, iFrame9, iFrame10, iFrame11, iFrame12, iFrame13, iFrame14, iFrame15,
							    iFrame16, iFrame17, iFrame18, iFrame19, iFrame20, iFrame21, iFrame22, iFrame23,
							    iFrame24, iFrame25, nil];
		self.idleAnim = [CCAnimation animationWithFrames:idleFrames delay:0.1f];
		
		// Animate unstick
//		CCSpriteFrameCache *unstickCache = [CCSpriteFrameCache sharedSpriteFrameCache];
//		CCSpriteFrame *uFrame1 = [unstickCache spriteFrameByName:@"J-6.png"];
//		CCSpriteFrame *uFrame2 = [unstickCache spriteFrameByName:@"J-5.png"];
//		CCSpriteFrame *uFrame3 = [unstickCache spriteFrameByName:@"J-4.png"];
//		CCSpriteFrame *uFrame4 = [unstickCache spriteFrameByName:@"J-3.png"];
//		CCSpriteFrame *uFrame5 = [unstickCache spriteFrameByName:@"J-2.png"];
		NSArray *unstickFrames = [NSArray arrayWithObjects:jFrame24, jFrame23, jFrame22, jFrame21, jFrame20, jFrame19,
								  jFrame18, jFrame17, jFrame16, jFrame15, jFrame14, jFrame13, jFrame12, jFrame11,
								  jFrame10, jFrame9, jFrame8, jFrame7, jFrame6, jFrame5, jFrame4, jFrame3, jFrame2, jFrame1, nil];
		self.unstickAnim = [CCAnimation animationWithFrames:unstickFrames delay:0.1f];
		
		nextIdleAnimation_ = 0;
	}
	return self;
}

-(void) dealloc {	
	[super dealloc];
}

#pragma mark Hero - Contact Listener

//
// To know at any moment the list of contacts of the hero, you should mantain a list based on being/endContact
//
-(void) beginContact:(b2Contact*)contact
{
	// 
	BOOL otherIsA = YES;
	
	b2Fixture* fixtureA = contact->GetFixtureA();
	b2Fixture* fixtureB = contact->GetFixtureB();
	NSAssert( fixtureA != fixtureB, @"Hero: Box2d bug");

	b2WorldManifold worldManifold;
	contact->GetWorldManifold(&worldManifold);
	
	b2Body *bodyA = fixtureA->GetBody();
	b2Body *bodyB = fixtureB->GetBody();
	
	NSAssert( bodyA != bodyB, @"Hero: Box2d bug");
	
	// Box2d doesn't guarantees the order of the fixtures
	otherIsA = (bodyA == body_) ? NO : YES;


	// find empty place
	int emptyIndex;
	for(emptyIndex=0; emptyIndex<kMaxContactPoints;emptyIndex++) {
		if( contactPoints_[emptyIndex].otherFixture == NULL )
			break;
	}
	NSAssert( emptyIndex < kMaxContactPoints, @"LevelSVG: Can't find an empty place in the contacts");
	
	b2Manifold* m = contact->GetManifold();
	ContactPoint* cp = contactPoints_ + emptyIndex;
	cp->otherFixture = ( otherIsA ? fixtureA :fixtureB );
	cp->position = m->localPoint;
	cp->normal = otherIsA ? worldManifold.normal : -worldManifold.normal;
	cp->state = b2_addState;
	contactPointCount_++;
}

-(void) endContact:(b2Contact*)contact
{
	b2Fixture* fixtureA = contact->GetFixtureA();
	b2Fixture* fixtureB = contact->GetFixtureB();
	b2Body *body = fixtureA->GetBody();
	
	b2Fixture *otherFixture = (body == body_) ? fixtureB : fixtureA;
	
	int emptyIndex;
	for(emptyIndex=0; emptyIndex<kMaxContactPoints;emptyIndex++) {
		if( contactPoints_[emptyIndex].otherFixture == otherFixture ) {
			contactPoints_[emptyIndex].otherFixture = NULL;
			contactPointCount_--;
			break;
		}
	}	
}

//
// Presolve is needed for one-sided platforms
// If you are not going to use them, you can disable this callback
//
-(void) preSolveContact:(b2Contact*)contact  manifold:(const b2Manifold*) oldManifold
{
//	b2WorldManifold worldManifold;
//	contact->GetWorldManifold(&worldManifold);
//	b2Fixture *fixtureA = contact->GetFixtureA();
//	b2Fixture *fixtureB = contact->GetFixtureB();
//	NSAssert( fixtureA != fixtureB, @"preSolveContact: BOX2D bug");
//	
//	b2Body	*bodyA = fixtureA->GetBody();
//	b2Body	*bodyB = fixtureB->GetBody();
//	NSAssert( bodyA != bodyB, @"preSolveContact: BOX2D bug");
//
//	BodyNode *dataA = (BodyNode*) bodyA->GetUserData();
//	BodyNode *dataB = (BodyNode*) bodyB->GetUserData();
//	
//	// check if the other fixture is a one-sided platform.
//	
//	Class p1 = [Platform1 class];
//	if( [dataA isKindOfClass:p1] ||
//	   [dataB isKindOfClass:p1] ) {
//
//		// Box2d doesn't guarantees the order of the fixtures
//		BOOL heroIsA = (bodyA == body_) ? YES : NO;
//		b2Fixture *otherFixture = heroIsA ? fixtureB : fixtureA;
//		
//		// check for normal
//		if( (!heroIsA && worldManifold.normal.y < 0) || (heroIsA && worldManifold.normal.y > 0) )
//		{
//			contact->SetEnabled(false);
//			
//		} else {
//			// update contact. Why ?
//			// Because if the sprite is passing through a "one sided platform" probably it will
//			// have a normal.y < 0, but after passing through, the normal.y won't be < 0 anymore since it
//			// has already passed trhough, and the "jump" logic depends on the normal
//			for( int i=0; i<kMaxContactPoints;i++ ) {
//				ContactPoint* point = contactPoints_ + i;
//				if( point && point->otherFixture == otherFixture ) {
//					point->normal = heroIsA ? -worldManifold.normal : worldManifold.normal;
//					break;
//				}
//			}
//		}
//	}	
}

-(void) freeze {
	body_->SetLinearVelocity(b2Vec2_zero);
	body_->SetAngularVelocity(0);
	b2Vec2 gravity = world_->GetGravity();
	b2Vec2 p = body_->GetLocalCenter();
	body_->ApplyForce(-body_->GetMass()*gravity, p);
}

#pragma mark Hero - Main Loop
-(void) update:(ccTime)dt
{
	elapsedTime_ += dt;
	
	GameState state = [game_ gameState];
	if (state == kGameStateAiming) {
		[self freeze];
	} else if(state == kGameStatePlaying) {
		[self updateCollisions];
		if (contactPointCount_ == 0) {
			lastStickableBodyPos_ = b2Vec2_zero;
		}
		if (joint_ != NULL) {
			struct timeval now;
			gettimeofday(&now, NULL);
			ccTime jointLifeTimeInterval = (now.tv_sec - timeJointCreated_.tv_sec) + (now.tv_usec - timeJointCreated_.tv_usec) / 1000000.0f;
			if (jointLifeTimeInterval > STICK_TIME) {
				[self destroyStickJoint];
			}
		} else if ([self numberOfRunningActions] <= 0) {
			if ((elapsedTime_ - nextIdleAnimation_ >= IDLE_ANIMATION_DELAY) && (touchingGround_)) {
				[self animateIdle];
			}
		}
	}	
}

-(void) createStickJoint:(b2Body*)collidingBody withAnchor:(b2Vec2)anchor {	
	b2DistanceJointDef jd;
	b2Vec2 heroAnchor = body_->GetPosition();
	b2Vec2 collidingBodyAnchor = collidingBody->GetPosition();
	jd.collideConnected = true;
	jd.length = 0.0;
	jd.Initialize(collidingBody, body_, anchor, anchor);
	joint_ = world_->CreateJoint(&jd);
	body_->SetLinearVelocity(b2Vec2_zero);
	body_->SetAngularVelocity(0.0);
}

-(void) destroyStickJoint {
	if (joint_ != NULL) {
		[[SimpleAudioEngine sharedEngine] playEffect:@"button-pressed.wav"];
		world_->DestroyJoint(joint_);
		joint_ = NULL;
		[self animateUnstick];
	}
}

-(void) updateCollisions
{
	isTouchingLadder_ = NO;
	
	// Traverse the contact results.
	int found = 0;
	for (int32 i = 0; i < kMaxContactPoints && found < contactPointCount_; i++)
	{
		ContactPoint* point = contactPoints_ + i;
		b2Fixture *otherFixture = point->otherFixture;
		
		if( otherFixture ) {
			
			found++;
			b2Body* body = otherFixture->GetBody();
			
			BodyNode *node = (BodyNode*) body->GetUserData();
			
			// Send the "touchByHero" message
			
			// special case for "BadGuy"
			//			if( [node isKindOfClass:[BadGuy class]]) {
			//				if( !isBlinking_  ) {
			//					[(BadGuy*) node performSelector:@selector(touchedByHero)];
			//					[self blinkHero];
			//				}
			//			}
			//			
			//			else if( [node isKindOfClass:[Ladder class]])
			//				isTouchingLadder_ = YES;
			//					
			//			
			//			else if( [node respondsToSelector:@selector(touchedByHero)] )
			//				[node performSelector:@selector(touchedByHero)];
			
			if([node respondsToSelector:@selector(touchedByHero)]) {
				[node performSelector:@selector(touchedByHero)];
			} else if ([node isKindOfClass:[Stickable class]] ||
					   [node isKindOfClass:[Stickableplatform class]] ||
					   [node isKindOfClass:[Leftstickableplatform class]]) {
				b2Vec2 currentStickableBodyPos = [node body]->GetWorldCenter();
				if ([game_ heroJumping] &&
					((lastStickableBodyPos_.x != currentStickableBodyPos.x &&
					  lastStickableBodyPos_.y != currentStickableBodyPos.y) || 
					 (lastStickableBodyPos_.x == 0 &&
					  lastStickableBodyPos_.y == 0))) {
						 [game_ setHeroJumping:NO];
						 if (joint_ == NULL) {
							 [self createStickJoint:[node body] withAnchor: body_->GetWorldPoint(point->position)];
							 gettimeofday(&timeJointCreated_, NULL);
							 [self animateSplash:point->normal];
						 }
					 } else {
						 lastStickableBodyPos_ = [node body]->GetWorldCenter();
					 }
			}
		}
	}	
}

#pragma mark Hero - Movements
-(void) move:(CGPoint)direction
{
	// override me
}

-(void) jump:(b2Vec2)jumpVector {
	
	touchingGround_ = NO;
	
	if( contactPointCount_ > 0 ) {
		
		int foundContacts=0;
		
		//
		// TIP:
		// only take into account the normals that have a Y component greater that 0.3
		// You might want to customize this value for your game.
		//
		// Explanation:
		// If the hero is on top of 100% horizontal platform, then Y==1
		// If it is on top of platform rotate 45 degrees, then Y==0.5
		// If it is touching a wall Y==0
		// If it is touching a ceiling then, Y== -1
		//
		
		for( int i=0; i<kMaxContactPoints && foundContacts < contactPointCount_;i++ ) {
			ContactPoint* point = contactPoints_ + i;
			if( point->otherFixture && ! point->otherFixture->IsSensor() ) {
				foundContacts++;
				touchingGround_ = YES;
				b2Vec2 playerPos = body_->GetPosition();
				body_->ApplyLinearImpulse(b2Vec2(jumpVector.x * jumpImpulse_ /25.0, jumpVector.y * jumpImpulse_/25.0), playerPos);
				break;
			}
		}
		
	} else if (! touchingGround_ && game_.airJumps > 0) {
		b2Vec2 p = body_->GetWorldPoint(b2Vec2(0.0f, 0.0f));
		float impY = jumpImpulse_ * jumpVector.y/25.0;
		float impX = jumpImpulse_ * jumpVector.x/25.0;
		body_->ApplyLinearImpulse( b2Vec2(impX, impY), p);
		[game_ increaseAirJumps:-1];
	} else if (! touchingGround_ && game_.airJumps == 0) {
		[game_ increaseAirJumps:0];
		[self cancelJump];
	}
}

-(void) cancelJump {
	b2Vec2 p = body_->GetWorldPoint(b2Vec2(0.0f, 0.0f));
	float impY = -0.1f;
	float impX = 0.0f;
	body_->ApplyLinearImpulse(b2Vec2(impX, impY), p);
}

-(void) onGameOver:(BOOL)winner
{
	body_->SetLinearVelocity(b2Vec2(0,0));
}

-(void) blinkHero
{
	CCBlink *blink = [CCBlink actionWithDuration:1.5f blinks:10];
	CCSequence *seq = [CCSequence actions:
					   blink,
					   [CCCallFuncN actionWithTarget:self selector:@selector(stopBlinking:)],
					   nil];
	isBlinking_ = YES;
	[self runAction:seq];
}

-(void) teleportTo:(CGPoint)point
{
	body_->SetTransform( b2Vec2( point.x / kPhysicsPTMRatio, point.y/kPhysicsPTMRatio), 0 );
}
	
-(void) stopBlinking:(id)sender
{
	isBlinking_ = NO;
}

-(void) updateFrames:(CGPoint)direction
{	
	const char *dir = "left";
	unsigned int index = 0;
	
	if( antiGravityForce_ ) {
		dir = "up";
		
		// There are 6 frames
		// And every 15 pixels a new frame should be displayed
		index = ((unsigned int)position_.y /15) % 6;
		
	}
	else {
		if( direction.x == 0 )
			return;
		
		dir = "left";
		
		if( direction.x > 0 )
			dir = "right";
		
		// There are 8 frames
		// And every 20 pixels a new frame should be displayed
		index = ((unsigned int)position_.x /20) % 8;
	}
	
	// increase frame index, since frame names start in "1" and not "0"
	index++;
	
	NSString *str = [NSString stringWithFormat:@"walk-%s_%02d.png", dir, index];
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:str];
	[self setDisplayFrame:frame];
}

#pragma mark Hero - Accelerometer
-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
	
	ControlType type = [[GameConfiguration sharedConfiguration] controlType];
	if( type==kControlTypeTilt ) {
		[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	}
}

-(void) onExit
{
	[super onExit];
	ControlType type = [[GameConfiguration sharedConfiguration] controlType];
	if( type==kControlTypeTilt ) {
		[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
	}
}

// will be called only if using Tilt controls
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	GameState state = [game_ gameState];
	// only update controls if game is "playing"
	if( state == kGameStatePlaying ) {
		float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
		float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
		
		prevX = accelX;
		prevY = accelY;
		
		// tilt control
		// accelerometer values are in "Portrait" mode. Change them to Landscape left
		float x = -accelY;
		float y = accelX;
		
		// if using tilt 2 way, then set y=0
		if(  controlDirection_ == kControlDirection2Way )
			y = 0;
		
		[self move:ccp(x,y)];
	}
}

- (void)animateJump:(b2Vec2)jumpVector {
	[[SimpleAudioEngine sharedEngine] playEffect:@"jump.wav"];
	[self stopAllActions];
	nextIdleAnimation_ = elapsedTime_;
    CGFloat jumpAngle = ccpToAngle(CGPointMake(jumpVector.x, jumpVector.y));
    CGFloat cocosAngle = CC_RADIANS_TO_DEGREES(-1 * jumpAngle);	
	CCAnimate *animate = [CCSequence actions:
						  [CCRotateTo actionWithDuration:0.0 angle:cocosAngle],
						  [CCAnimate actionWithDuration:0.6 animation:self.jumpAnim restoreOriginalFrame:NO],
						  nil];
	[self runAction:animate];
	
	SpecialEffectParticle * effect = [SpecialEffectParticle node];
	[game_ addChild:effect z:5];
	[effect setPosition:self.position];
	[effect runAction:[CCMoveBy actionWithDuration:1 position:ccp(0,-100)]];
}

- (void)animateAim:(float)angle {
	CCAnimate *animate = [CCSequence actions:
						  [CCRotateTo actionWithDuration:0.0 angle:angle + 180],
						  [CCAnimate actionWithDuration:0.3 animation:self.aimAnim restoreOriginalFrame:NO],
						  nil];
	[self runAction:animate];
}

- (void)animateSplash:(b2Vec2)contactVector {
	[[SimpleAudioEngine sharedEngine] playEffect:@"button-pressed.wav"];
	[self stopAllActions];
	CGFloat contactAngle = ccpToAngle(CGPointMake(contactVector.x, contactVector.y));
    CGFloat cocosAngle = CC_RADIANS_TO_DEGREES(-1 * contactAngle) + 180;
	if (contactVector.x == 0 && contactVector.y == 0) {
		cocosAngle = 90;
	}
	CCAnimate *animate = [CCSequence actions:
						  [CCRotateTo actionWithDuration:0.0 angle:cocosAngle],
						  [CCAnimate actionWithDuration:0.3 animation:self.splashAnim restoreOriginalFrame:NO],
						  nil];
	[self runAction:animate];
}

- (void)animateIdle {
	b2Vec2 idleVelocity = body_->GetLinearVelocity();
	CGFloat cocosAngle = 0;
	CCAnimate *animate = [CCSequence actions:
						  [CCRotateTo actionWithDuration:0.0 angle:cocosAngle],
						  [CCAnimate actionWithDuration:1.0 animation:self.idleAnim restoreOriginalFrame:NO],
						  [CCCallFunc actionWithTarget:self selector:@selector(idleAnimationEnded)],
						  nil];
	[self runAction:animate];
}

- (void)idleAnimationEnded {
	nextIdleAnimation_ = elapsedTime_;
}

- (void)animateUnstick {
	b2Vec2 fallVector = body_->GetLinearVelocity();
    CGFloat fallAngle = ccpToAngle(CGPointMake(fallVector.x, fallVector.y));
    CGFloat cocosAngle = CC_RADIANS_TO_DEGREES(-1 * fallAngle);
	CCAnimate *animate = [CCSequence actions:
						  [CCRotateTo actionWithDuration:0.0 angle:cocosAngle],
						  [CCAnimate actionWithDuration:0.6 animation:self.unstickAnim restoreOriginalFrame:NO],
						  [CCCallFunc actionWithTarget:self selector:@selector(unstickAnimationEnded)],
						  nil];
	animate.tag = kActionTagUnstick;
	[self runAction:animate];
}

- (void)unstickAnimationEnded {
	[self animateIdle];
}

@end
