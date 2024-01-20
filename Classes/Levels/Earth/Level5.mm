#import "Level5.h"

@implementation Level5

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level5.svg";
}

- (unsigned int) levelNumber {
	return 5;
}

- (NSString*)levelName {
	return @"level5.png";
}

@end
