//
//  LevelBase.h
//  StickyET
//
//  Created by pawel on 6/12/11.
//  Copyright 2011 __etcApps__. All rights reserved.
//

#import "GameNode.h"

@interface LevelBase : GameNode {
	CCSpriteBatchNode *spritesBatchNode_;
	CCSpriteBatchNode *platformBatchNode_;
	CCSpriteBatchNode *invisibleBatchNode_;
	CCSprite *background;
}

- (NSString*)levelName;
- (unsigned int)levelNumber;
@end
