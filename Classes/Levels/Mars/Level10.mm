#import "Level10.h"

@implementation Level10

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level10.svg";
}

- (unsigned int) levelNumber {
	return 10;
}

- (NSString*)levelName {
	return @"level10.png";
}

@end
