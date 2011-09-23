//
//  A50PriceChartViewController.h
//  A50PriceChart
//
//  Created by Josh Klobe on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIEngine.h"
#import "GraphView.h"

@interface A50PriceChartViewController : UIViewController <APIEngineDelegate> {

	APIEngine *apiEngine;
	GraphView *graphView; 
}
@property (nonatomic, retain) APIEngine *apiEngine;
@property (nonatomic, retain) GraphView *graphView; 
@end

