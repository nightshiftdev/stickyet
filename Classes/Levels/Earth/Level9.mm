#import "Level9.h"

@implementation Level9

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level9.svg";
}

- (unsigned int) levelNumber {
	return 9;
}

- (NSString*)levelName {
	return @"level9.png";
}

@end
