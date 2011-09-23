//
//  GraphBackgroundView.h
//  MorganResearch
//
//  Created by Josh Klobe on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GraphBackgroundView : UIView {

	float xCoord;
	UILabel *dataLabel;
}
@property (nonatomic, assign) float xCoord;
@property (nonatomic, retain) UILabel *dataLabel;
@end
