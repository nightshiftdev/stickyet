#import "Level12.h"

@implementation Level12

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level12.svg";
}

- (unsigned int) levelNumber {
	return 12;
}

- (NSString*)levelName {
	return @"level12.png";
}

@end
