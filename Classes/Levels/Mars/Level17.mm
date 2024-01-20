#import "Level17.h"

@implementation Level17

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level17.svg";
}

- (unsigned int) levelNumber {
	return 17;
}

- (NSString*)levelName {
	return @"level17.png";
}

@end
