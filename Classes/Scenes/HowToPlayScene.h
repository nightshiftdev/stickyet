//
//  HowToPlayScene.h
//  StickyET
//
//  Created by pawel on 12/22/11.
//  Copyright 2011 __etcApps__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HowToPlayScene : CCLayer {
	float introStartDelay_;
	float introEndDelay_;
	BOOL returnToEpisodeSelector_;
}

@property (nonatomic, readwrite) BOOL returnToEpisodeSelector;

+(id) scene:(BOOL)returnToEpisodeSelectorScene;

@end
