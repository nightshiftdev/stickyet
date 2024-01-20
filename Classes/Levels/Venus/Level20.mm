#import "Level20.h"

@implementation Level20

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level20.svg";
}

- (unsigned int) levelNumber {
	return 20;
}

- (NSString*)levelName {
	return @"level20.png";
}

@end
