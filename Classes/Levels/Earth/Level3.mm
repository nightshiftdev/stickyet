#import "Level3.h"

@implementation Level3

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level3.svg";
}

- (unsigned int) levelNumber {
	return 3;
}

- (NSString*)levelName {
	return @"level3.png";
}

@end
