#import "Level0.h"

@implementation Level0

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level0.svg";
}

- (unsigned int) levelNumber {
	return 0;
}

- (NSString*)levelName {
	return @"level0.png";
}

@end
