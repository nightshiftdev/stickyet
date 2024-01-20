#import "Level23.h"

@implementation Level23

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level23.svg";
}

- (unsigned int) levelNumber {
	return 23;
}

- (NSString*)levelName {
	return @"level23.png";
}

@end
