#import "Level2.h"

@implementation Level2

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (void) dealloc {
	[super dealloc];
}

- (NSString*) SVGFileName {
	return @"level2.svg";
}

- (unsigned int) levelNumber {
	return 2;
}

- (NSString*)levelName {
	return @"level2.png";
}

@end
