//
//  GraphView.h
//  MorganResearch
//
//  Created by Josh Klobe on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphBackgroundView.h"

@interface GraphView : UIView {

	NSMutableArray *masterObjectArray;
	
	NSMutableArray *googleDataObjectArray;
	GraphBackgroundView *graphBackgroundView;
	float xStep;
	float yStep;
	CGPoint lastPointOnGraph;
	CGPoint highPointOnGraph;
	CGPoint lowPointOnGraph;
	NSMutableArray *xAxisLabelsArray;
	
	int offsetValue;
	int clipValue;
	
	NSArray *touchPointArray;
		
	
	float xAxesStepDistance; 
	float maxWidth;
	float viewHeight;
	float high;
	float low;
}

@property (nonatomic, retain) NSMutableArray *masterObjectArray;
@property (nonatomic, retain) NSMutableArray *googleDataObjectArray;
@property (nonatomic, retain) GraphBackgroundView *graphBackgroundView;
@property (nonatomic, assign) float xStep;
@property (nonatomic, assign) float yStep;
@property (nonatomic, assign) CGPoint lastPointOnGraph;
@property (nonatomic, assign) CGPoint highPointOnGraph;
@property (nonatomic, assign) CGPoint lowPointOnGraph;
@property (nonatomic, retain) NSMutableArray *xAxisLabelsArray;

@property (nonatomic, assign) int offsetValue;
@property (nonatomic, assign) int clipValue;

@property (nonatomic, retain) NSArray *touchPointArray;


@property (nonatomic, assign) float xAxesStepDistance; 
@property (nonatomic, assign) float maxWidth;
@property (nonatomic, assign) float viewHeight;
@property (nonatomic, assign) float high;
@property (nonatomic, assign) float low;


@end
