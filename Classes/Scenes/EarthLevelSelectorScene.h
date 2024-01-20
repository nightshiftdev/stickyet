//
//  EarthLevelSelectorScene.h
//  StickyET
//
//  Created by pawel on 4/21/11.
//  Copyright 2011 __etcApps__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EarthLevelSelectorScene : CCLayer {
	CCParticleSystem *emitter;
}
@property (readwrite,retain) CCParticleSystem *emitter;
+(id) scene;
-(NSString*) graphicForLevel:(int) level;
-(void) assignShipPartsRewardsForLevels;

@end
