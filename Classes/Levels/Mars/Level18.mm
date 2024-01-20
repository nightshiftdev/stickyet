#import "Level18.h"

@implementation Level18

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level18.svg";
}

- (unsigned int) levelNumber {
	return 18;
}

- (NSString*)levelName {
	return @"level18.png";
}

@end
