#import <Foundation/Foundation.h>
#import "cocos2d.h"

// build each architecture with the optimal particle system
// ARMv7, Mac or Simulator use "Quad" particle
#if defined(__ARM_NEON__) || __MAC_OS_X_VERSION_MIN_REQUIRED || TARGET_IPHONE_SIMULATOR
#define ARCH_OPTIMAL_PARTICLE_SYSTEM CCParticleSystemQuad

// ARMv6 use "Point" particle
#elif __arm__
#define ARCH_OPTIMAL_PARTICLE_SYSTEM CCParticleSystemPoint
#else
#error(unknown architecture)
#endif

@interface RainSpecialEffectParticle : ARCH_OPTIMAL_PARTICLE_SYSTEM {

}

@end
