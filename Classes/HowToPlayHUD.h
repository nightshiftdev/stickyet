//
//  HowToPlayScene.h
//  StickyET
//
//  Created by pawel on 12/22/11.
//  Copyright 2011 __etcApps__. All rights reserved.
//

#import "cocos2d.h"

@interface HowToPlayHUD : CCLayer {
	BOOL returnToEpisodeSelector_;
}

@property (nonatomic, readwrite) BOOL returnToEpisodeSelector;

// creates and initializes a HUD
+(id) HowToPlayHUDScene;

@end
