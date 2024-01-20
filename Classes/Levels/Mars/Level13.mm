#import "Level13.h"

@implementation Level13

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level13.svg";
}

- (unsigned int) levelNumber {
	return 13;
}

- (NSString*)levelName {
	return @"level13.png";
}

@end
