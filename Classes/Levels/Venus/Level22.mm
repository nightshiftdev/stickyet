#import "Level22.h"

@implementation Level22

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level22.svg";
}

- (unsigned int) levelNumber {
	return 22;
}

- (NSString*)levelName {
	return @"level22.png";
}

@end
