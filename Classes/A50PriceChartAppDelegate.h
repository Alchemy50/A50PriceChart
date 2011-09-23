//
//  A50PriceChartAppDelegate.h
//  A50PriceChart
//
//  Created by Josh Klobe on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class A50PriceChartViewController;

@interface A50PriceChartAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    A50PriceChartViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet A50PriceChartViewController *viewController;

@end

