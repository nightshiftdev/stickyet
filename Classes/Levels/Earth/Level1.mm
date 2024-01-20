#import "Level1.h"

@implementation Level1

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level1.svg";
}

- (unsigned int) levelNumber {
	return 1;
}

- (NSString*)levelName {
	return @"level1.png";
}

@end
