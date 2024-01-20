#import "Level28.h"

@implementation Level28

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level28.svg";
}

- (unsigned int) levelNumber {
	return 28;
}

- (NSString*)levelName {
	return @"level28.png";
}

@end
