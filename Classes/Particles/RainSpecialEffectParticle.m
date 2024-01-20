#import "RainSpecialEffectParticle.h"


@implementation RainSpecialEffectParticle

-(id) init
{
	return [self initWithTotalParticles:1000];
}

-(id) initWithTotalParticles:(NSUInteger) p
{
	if( (self=[super initWithTotalParticles:p]) ) {
		
		// duration
		duration = kCCParticleDurationInfinity;
		
		self.emitterMode = kCCParticleModeGravity;
		
		// Gravity Mode: gravity
		self.gravity = ccp(0, -100);
		//self.gravity = ccp(0, 0);
		
		// Gravity Mode: radial
		self.radialAccel = 0;
		self.radialAccelVar = 0;
		
		// Gravity Mode: tagential
		self.tangentialAccel = 0;
		self.tangentialAccelVar = 0;
		
		// Gravity Mode: speed of particles
		self.speed = 130;
		self.speedVar = 30;
		
		// angle
		angle = -90;
		angleVar = 0;
		
		
		// emitter position
		self.position = (CGPoint) {
			[[CCDirector sharedDirector] winSize].width / 2,
			[[CCDirector sharedDirector] winSize].height
		};
		posVar = ccp( [[CCDirector sharedDirector] winSize].width, 0 );
		
		// life of particles
		life = 4.5f;
		lifeVar = 0;
		
		// size, in pixels
		startSize = 4.0f;
		startSizeVar = 2.0f;
		endSize = kCCParticleStartSizeEqualToEndSize;
		
		// emits per second
		emissionRate = 20;
		
		// color of particles
		startColor.r = 0.0f;
		startColor.g = 0.0f;
		startColor.b = 1.0f;
		startColor.a = 1.0f;
		startColorVar.r = 0.0f;
		startColorVar.g = 0.0f;
		startColorVar.b = 1.0f;
		startColorVar.a = 1.0f;
		endColor.r = 0.0f;
		endColor.g = 0.0f;
		endColor.b = 1.0f;
		endColor.a = 1.0f;
		endColorVar.r = 0.0f;
		endColorVar.g = 0.0f;
		endColorVar.b = 1.0f;
		endColorVar.a = 1.0f;
		
		self.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];
		
		// additive
		self.blendAdditive = NO;
	}
	
	return self;
}
@end
