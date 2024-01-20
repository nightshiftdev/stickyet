//
//  ProgressManager.m
//  StickyET
//
//  Created by pawel on 5/1/11.
//  Copyright 2011 __etcApps__. All rights reserved.
//

#import "ProgressManager.h"
#import "SimpleAudioEngine.h"
#import "GameConstants.h"


@implementation ProgressManager

@synthesize parts=parts_;
@synthesize levels=levels_;
@synthesize score=score_;
@synthesize airJumps=airJumps_;
@synthesize isBlueThemePlaying=isBlueThemePlaying_;
@synthesize isGreenThemePlaying=isGreenThemePlaying_;
@synthesize isRedThemePlaying=isRedThemePlaying_;
@synthesize isMainThemePlaying=isMainThemePlaying_;

static ProgressManager *_progressManager = nil;

+ (ProgressManager *)getOrInitProgress {
	if (!_progressManager) {
		_progressManager = [[self alloc] init];
	}
	return _progressManager;
}

- (void)dealloc {
	[super dealloc];
	self.parts = nil;
	self.levels = nil;
}

- (id)init {  
	if((self=[super init])) {		
		NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString* levelsFile = [documentsPath stringByAppendingPathComponent:@"progress.plist"];
		BOOL levelsFileExists = [[NSFileManager defaultManager] fileExistsAtPath:levelsFile];
		NSString *destinationPath = [documentsPath stringByAppendingPathComponent:@"progress.plist"];
		
		if (!levelsFileExists) {
			NSString *bundleLevelsFile = [[NSBundle mainBundle]pathForResource:@"progress" ofType:@"plist"];
			NSError *copyError = nil;
			[[NSFileManager defaultManager]copyItemAtPath:bundleLevelsFile toPath:destinationPath error:&copyError];
			if (copyError != nil) {
				NSLog(@"progress.plist copy error: %@", [copyError localizedFailureReason]);
				[copyError release];
			}
		}
		NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:destinationPath];

		self.parts = [[plistDict valueForKey:@"parts"] mutableCopy];
		self.levels = [[plistDict valueForKey:@"levels"] mutableCopy];
		self.score = [[plistDict valueForKey:@"score"] unsignedIntValue];
		self.airJumps = [[plistDict valueForKey:@"air_jumps"] unsignedIntValue];
		self.isRedThemePlaying = NO;
		self.isBlueThemePlaying = NO;
		self.isGreenThemePlaying = NO;
		self.isMainThemePlaying = NO;
	}
	return self;
}

- (void)unlockLevel:(NSUInteger) level {
	[self.levels replaceObjectAtIndex:level withObject:[NSNumber numberWithBool:YES]];
}

- (BOOL)isLevelUnlocked:(NSUInteger) level {
	return [[self.levels objectAtIndex:level] boolValue];
}

- (void)setParts:(stars) s forLevel: (int) level {
	[self.parts replaceObjectAtIndex:level withObject:[NSNumber numberWithInt:(int)s]];
}

- (stars)partsForLevel:(int) level {
	return (stars)[[self.parts objectAtIndex:level] intValue];
}

- (void)save {	
	NSString *error;
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"progress.plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: self.parts, self.levels, [NSNumber numberWithUnsignedInt:self.score], [NSNumber numberWithUnsignedInt:self.airJumps], nil]
														  forKeys:[NSArray arrayWithObjects: @"parts", @"levels", @"score", @"air_jumps", nil]];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
																   format:NSPropertyListXMLFormat_v1_0
														 errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    } else {
        NSLog(@"Save progress failed with error: %@", error);
        [error release];
    }
}

- (void)playBlueWorldTheme {
	if (![ProgressManager getOrInitProgress].isBlueThemePlaying) {
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic: kBlueTheme];
		[ProgressManager getOrInitProgress].isBlueThemePlaying = YES;
		[ProgressManager getOrInitProgress].isGreenThemePlaying = NO;
		[ProgressManager getOrInitProgress].isRedThemePlaying = NO;
		[ProgressManager getOrInitProgress].isMainThemePlaying = NO;
	}
}

- (void)playGreenWorldTheme {
	if (![ProgressManager getOrInitProgress].isGreenThemePlaying) {
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic: kGreenTheme];
		[ProgressManager getOrInitProgress].isBlueThemePlaying = NO;
		[ProgressManager getOrInitProgress].isGreenThemePlaying = YES;
		[ProgressManager getOrInitProgress].isRedThemePlaying = NO;
		[ProgressManager getOrInitProgress].isMainThemePlaying = NO;
	}
}

- (void)playRedWorldTheme {
	if (![ProgressManager getOrInitProgress].isRedThemePlaying) {
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic: kRedTheme];
		[ProgressManager getOrInitProgress].isBlueThemePlaying = NO;
		[ProgressManager getOrInitProgress].isGreenThemePlaying = NO;
		[ProgressManager getOrInitProgress].isRedThemePlaying = YES;
		[ProgressManager getOrInitProgress].isMainThemePlaying = NO;
	}
}

- (void)playMainTheme {
	if (![ProgressManager getOrInitProgress].isMainThemePlaying) {
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic: kMainTheme];
		[ProgressManager getOrInitProgress].isBlueThemePlaying = NO;
		[ProgressManager getOrInitProgress].isGreenThemePlaying = NO;
		[ProgressManager getOrInitProgress].isRedThemePlaying = NO;
		[ProgressManager getOrInitProgress].isMainThemePlaying = YES;
	}
}

- (void)playGameCompleteTheme {
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic: kGameCompleteTheme];
	[ProgressManager getOrInitProgress].isBlueThemePlaying = NO;
	[ProgressManager getOrInitProgress].isGreenThemePlaying = NO;
	[ProgressManager getOrInitProgress].isRedThemePlaying = NO;
	[ProgressManager getOrInitProgress].isMainThemePlaying = NO;
}

@end
