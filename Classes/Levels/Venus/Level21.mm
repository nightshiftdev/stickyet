#import "Level21.h"

@implementation Level21

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level21.svg";
}

- (unsigned int) levelNumber {
	return 21;
}

- (NSString*)levelName {
	return @"level21.png";
}

@end
