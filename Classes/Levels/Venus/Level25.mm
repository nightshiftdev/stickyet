#import "Level25.h"

@implementation Level25

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level25.svg";
}

- (unsigned int) levelNumber {
	return 25;
}

- (NSString*)levelName {
	return @"level25.png";
}

@end
