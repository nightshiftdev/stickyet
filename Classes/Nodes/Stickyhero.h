#import <Box2D/Box2D.h>
#import "BodyNode.h"
#import "GameConfiguration.h"


// forward declarations
@class GameScene;
@protocol JoystickProtocol;

const int32 kMaxContactPoints = 128;

struct ContactPoint
{
	b2Fixture*	otherFixture;
	b2Vec2		normal;
	b2Vec2		position;
	b2PointState state;
};

enum {
	kActionTagUnstick,
};

@interface Stickyhero : BodyNode <UIAccelerometerDelegate> {
	
	// b2 world. weak ref
	b2World *world_;
	
	// sprite is blinking
	BOOL isBlinking_;
	
	// weak ref. The joystick status is read by the hero
	id<JoystickProtocol> joystick_;

	// elapsed time on the game
	ccTime elapsedTime_;
	
	// last time that a forced was applied to our hero
	ccTime lastTimeForceApplied_;
	
	// collision detection stuff
	ContactPoint contactPoints_[kMaxContactPoints];
	int32 contactPointCount_;	
	
	// is the hero touching a ladder
	BOOL isTouchingLadder_;

	// optimization
	ControlDirection controlDirection_;
	
	float jumpImpulse_;
	//float				moveForce_;
	
	b2Joint	*joint_;
	b2Vec2 lastStickableBodyPos_;
	struct timeval timeJointCreated_;
	
	BOOL antiGravityForce_;
	BOOL touchingGround_;
	
	ccTime nextIdleAnimation_;
	
	CCAnimation *jumpAnim_;
	CCAnimation *splashAnim_;
	CCAnimation *aimAnim_;
	CCAnimation *idleAnim_;
	CCAnimation *unstickAnim_;
}

/** HUD should set the joystick */
//@property (nonatomic,readwrite,assign) id<JoystickProtocol> joystick;

/** Is the hero blinking */
@property (nonatomic, readonly) BOOL isBlinking;
@property (nonatomic, retain) CCAnimation *jumpAnim;
@property (nonatomic, retain) CCAnimation *splashAnim;
@property (nonatomic, retain) CCAnimation *aimAnim;
@property (nonatomic, retain) CCAnimation *idleAnim;
@property (nonatomic, retain) CCAnimation *unstickAnim;

// Hero movements
//-(void) jump;
//-(void) fire;
//-(void) move:(CGPoint)direction;
-(void) jump:(b2Vec2)jumpVector;
-(void) cancelJump;
-(void) createStickJoint:(b2Body*)collidingBody withAnchor:(b2Vec2)anchor;
-(void) destroyStickJoint;
-(void) blinkHero;
-(void) teleportTo:(CGPoint)point;

-(void) update:(ccTime)dt;

// update sprite frames
-(void) updateFrames:(CGPoint)direction;

// called when the game is over. YES if winner, NO if loser
-(void) onGameOver:(BOOL)winner;

- (void)animateJump:(b2Vec2)jumpVector;
- (void)animateAim:(float)angle;
- (void)animateSplash:(b2Vec2)contactVector;
- (void)animateIdle;
- (void)animateUnstick;

@end
