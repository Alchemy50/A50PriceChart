//
//  GraphBackgroundView.m
//  MorganResearch
//
//  Created by Josh Klobe on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GraphBackgroundView.h"


@implementation GraphBackgroundView

@synthesize xCoord, dataLabel;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,50,100,20)];
		dataLabel.backgroundColor = [UIColor clearColor];
		dataLabel.textColor = [UIColor blackColor];
		[self addSubview:dataLabel];
		 
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}



- (void)dra2wRect:(CGRect)rect
{
	
	
	CGContextRef	context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context,1);
	CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
	
	CGPoint fromPoint = CGPointMake(xCoord,self.frame.size.height);
	CGPoint toPoint = CGPointMake(xCoord, 0);
	
	if (xCoord > 0.0)
	{
	CGContextMoveToPoint(context,fromPoint.x , fromPoint.y);
	CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
		

	CGContextStrokePath(context);
	}
}


@end
