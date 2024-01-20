#import "Level8.h"

@implementation Level8

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level8.svg";
}

- (unsigned int) levelNumber {
	return 8;
}

- (NSString*)levelName {
	return @"level8.png";
}

@end
