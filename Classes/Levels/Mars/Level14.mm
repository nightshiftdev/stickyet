#import "Level14.h"

@implementation Level14

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level14.svg";
}

- (unsigned int) levelNumber {
	return 14;
}

- (NSString*)levelName {
	return @"level14.png";
}

@end
