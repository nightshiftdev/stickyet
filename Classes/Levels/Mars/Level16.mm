#import "Level16.h"

@implementation Level16

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level16.svg";
}

- (unsigned int) levelNumber {
	return 16;
}

- (NSString*)levelName {
	return @"level16.png";
}

@end
