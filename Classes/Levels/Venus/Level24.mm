#import "Level24.h"

@implementation Level24

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level24.svg";
}

- (unsigned int) levelNumber {
	return 24;
}

- (NSString*)levelName {
	return @"level24.png";
}

@end
