//
//  StickyETAppDelegate.h
//  StickyET
//
//  Created by pawel on 3/22/11.
//  Copyright __etcApps__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface StickyETAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
