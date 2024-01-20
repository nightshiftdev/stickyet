#import "Level26.h"

@implementation Level26

- (void) dealloc {
	[super dealloc];
}

- (CGRect) contentRect {
	return CGRectMake(0.0, 0.0, 1024.0, 1024.0);
}

- (NSString*) SVGFileName {
	return @"level26.svg";
}

- (unsigned int) levelNumber {
	return 26;
}

- (NSString*)levelName {
	return @"level26.png";
}

@end
