#import "Level27.h"

@implementation Level27

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level27.svg";
}

- (unsigned int) levelNumber {
	return 27;
}

- (NSString*)levelName {
	return @"level27.png";
}

@end
