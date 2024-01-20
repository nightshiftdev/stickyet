#import "Level15.h"

@implementation Level15

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level15.svg";
}

- (unsigned int) levelNumber {
	return 15;
}

- (NSString*)levelName {
	return @"level15.png";
}

@end
