//
//  Leftmovingplatform.h
//  LevelSVG
//
//  Created by Ricardo Quesada on 05/01/10.
//  Copyright 2010 Sapus Media. All rights reserved.
//
//  DO NOT DISTRIBUTE THIS FILE WITHOUT PRIOR AUTHORIZATION

//#import "KinematicNode.h"
#import "BodyNode.h"
#import "b2Math.h"
#import "Movingplatform.h"


//
// TIP:
// If you want to move the platforms using cocos2d actions
// then you must make it a subclass of StaticNode
//
//@interface Movingplatform : StaticNode {
//

@interface Leftmovingplatform : BodyNode {

	int		direction_;
	float	duration_;
	float	translationInPixels_;
	b2Vec2	origPosition_;
	b2Vec2	finalPosition_;
	b2Vec2	velocity_;
	BOOL	goingForward_;
}

//-(CCAction*) getAction;
@end
