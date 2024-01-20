#import "Level19.h"
#import "BodyNode.h"
#import "Box2dDebugDrawNode.h"
#import "ProgressManager.h"

@implementation Level19

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level19.svg";
}

- (unsigned int) levelNumber {
	return 19;
}

- (NSString*)levelName {
	return @"level19.png";
}

@end
