#import "Level7.h"

@implementation Level7

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level7.svg";
}

- (unsigned int) levelNumber {
	return 7;
}

- (NSString*)levelName {
	return @"level7.png";
}

@end
