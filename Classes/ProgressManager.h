//
//  ProgressManager.h
//  StickyET
//
//  Created by pawel on 5/1/11.
//  Copyright 2011 __etcApps__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	failed = 0,
	passed = 1,
	good = 2,
	excellent =3
}stars;

@interface ProgressManager : NSObject {
	NSMutableArray *parts_;
	NSMutableArray *levels_;
	unsigned int score_;
	unsigned int airJumps_;
	BOOL isBlueThemePlaying_;
	BOOL isGreenThemePlaying_;
	BOOL isRedThemePlaying_;
	BOOL isMainThemePlaying_;
}
@property (readwrite,nonatomic) unsigned int score;
@property (readwrite,nonatomic) unsigned int airJumps;
@property (readwrite,nonatomic) BOOL isBlueThemePlaying;
@property (readwrite,nonatomic) BOOL isGreenThemePlaying;
@property (readwrite,nonatomic) BOOL isRedThemePlaying;
@property (readwrite,nonatomic) BOOL isMainThemePlaying;
@property (retain, nonatomic) NSMutableArray *levels;
@property (retain, nonatomic) NSMutableArray *parts;

+ (ProgressManager *)getOrInitProgress;

- (void)unlockLevel:(NSUInteger) level;
- (BOOL)isLevelUnlocked:(NSUInteger) level;

- (void)setParts:(stars)s forLevel:(int)level;
- (stars)partsForLevel:(int)level;

- (void)save;

- (void)playBlueWorldTheme;
- (void)playGreenWorldTheme;
- (void)playRedWorldTheme;
- (void)playMainTheme;
- (void)playGameCompleteTheme;

@end
