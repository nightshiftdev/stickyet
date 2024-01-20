#import "Level6.h"

@implementation Level6

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level6.svg";
}

- (unsigned int) levelNumber {
	return 6;
}

- (NSString*)levelName {
	return @"level6.png";
}

@end
