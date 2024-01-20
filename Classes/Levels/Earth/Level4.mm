#import "Level4.h"

@implementation Level4

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level4.svg";
}

- (unsigned int) levelNumber {
	return 4;
}

- (NSString*)levelName {
	return @"level4.png";
}

@end
