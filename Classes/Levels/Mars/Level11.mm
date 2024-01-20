#import "Level11.h"

@implementation Level11

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level11.svg";
}

- (unsigned int) levelNumber {
	return 11;
}

- (NSString*)levelName {
	return @"level11.png";
}

@end
