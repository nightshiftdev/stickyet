#import "SpecialEffectParticle.h"


@implementation SpecialEffectParticle

-(id) init
{
	return [self initWithTotalParticles:144];
}

-(id) initWithTotalParticles:(NSUInteger) p
{
	if( (self=[super initWithTotalParticles:p]) ) {
		
	
		self.texture = [[CCTextureCache sharedTextureCache] addImage: @"special-effect-particle.png"];
		
		// duration
		self.duration = 0.3;
		
		// Set "Radius" mode (default one)
		self.emitterMode = kCCParticleModeRadius;
		
		self.startRadius =60;
		self.startRadiusVar =53;
		self.endRadius =0;
		self.rotatePerSecond=0;
		self.rotatePerSecondVar =360;
		
		
		// self position
		self.position = ccp(160,240);
		
		// angle
		self.angle = 360;
		self.angleVar = 205;
		
		// life of particles
		self.life = 0.55;
		self.lifeVar = 0.15;
		
		// color of particles
		ccColor4F sColor = {0.15f, 1.0f, 0.65f, 1.0f};
		self.startColor = sColor;
		
		ccColor4F sColorVar = {1,1,1,0};
		self.startColorVar = sColorVar;
		
		ccColor4F eColor = {0.0f, 1.0f, 0, 0};
		self.endColor = eColor;
		
		ccColor4F eColorVar = {0.0f, 1.0f, 0, 0};
		self.endColorVar = eColorVar;
		
		// size, in pixels
		self.startSize = 12.0f;
		self.startSizeVar = 05.0f;
		self.endSize = 0;
		self.endSizeVar = 39;
		
		// emits per second
		self.emissionRate = self.totalParticles/self.life;
		
		// additive
		self.blendAdditive = NO;
		
		self.autoRemoveOnFinish =YES;
	}
	
	return self;
}
@end
