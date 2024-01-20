//
//  CreditsScene.h
//  StickyET
//
//  Created by pawel on 8/14/11.
//  Copyright 2011 __etcApps__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CreditsScene : CCLayer {
	CCParticleSystem *emitter;
}
@property (readwrite,retain) CCParticleSystem *emitter;
+(id) scene;

@end
