//
//  GraphView.m
//  MorganResearch
//
//  Created by Josh Klobe on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "GoogleDataObject.h"
//#import "GlobalStyleDictionary.h"

@implementation GraphView

@synthesize masterObjectArray, googleDataObjectArray, graphBackgroundView, xStep, yStep, lastPointOnGraph;
@synthesize highPointOnGraph, lowPointOnGraph, xAxisLabelsArray, offsetValue,clipValue, touchPointArray;

@synthesize xAxesStepDistance, maxWidth, viewHeight, high, low;
- (void)drawRect:(CGRect)rect
{
	float clipMultiple = 10;
	float offsetMultiple = 3;
	[googleDataObjectArray removeAllObjects];
	@try
	{
		
		if ([masterObjectArray count] > 0)
		{
			
			if (masterObjectArray != nil && ([masterObjectArray count] > 0))
			{
				
				id *objects;
				
				
				NSRange range = NSMakeRange((clipValue * clipMultiple), ([masterObjectArray count] - (clipValue * clipMultiple)) );	
				
				while (range.length == 0)
				{
					clipValue--;	
					range = NSMakeRange((clipValue * clipMultiple), ([masterObjectArray count] - (clipValue * clipMultiple)) );	
				}
				
				range.location += (offsetValue * offsetMultiple);
				while (range.location < 0)
				{
					offsetValue++;
					range.location += (offsetValue * offsetMultiple);
				}
				
				while (range.location + range.length > [masterObjectArray count])					
				{
					offsetValue--;
					range.location += (offsetValue * offsetMultiple);
				}
				
				objects = malloc(sizeof(id) * range.length);
				
				[masterObjectArray getObjects:objects range:range];
				
				
				for (int i = 0; i < range.length; i++) 
					[googleDataObjectArray addObject:objects[i]];		
			}
			else 
				[googleDataObjectArray addObjectsFromArray:masterObjectArray];			
			
			
			
			
			
			
			for (int i = 0; i < [xAxisLabelsArray count]; i++)
			{
				[((UILabel *)[xAxisLabelsArray objectAtIndex:i]) removeFromSuperview];
				
			}
			xAxisLabelsArray = [[NSMutableArray alloc] initWithCapacity:0];
			
			/// -------Draw chart axes
			
			
			maxWidth = 678;
			float width = 500;			
			viewHeight = self.frame.size.height;
			
			CGContextRef context = UIGraphicsGetCurrentContext();
			
			CGContextSetLineWidth(context,1);
			//CGContextSetStrokeColorWithColor(context,((UIColor *)[[GlobalStyleDictionary sharedGlobalStyleDictionary] getObjectWithKey:LineGraphAxesColor]).CGColor);		
			CGContextSetStrokeColorWithColor(context,[UIColor darkGrayColor].CGColor);		
			CGPoint pointA = CGPointMake(0, 0);
			CGPoint pointB = CGPointMake(0, viewHeight);
			CGContextMoveToPoint(context,pointA.x , pointA.y);
			CGContextAddLineToPoint(context, pointB.x, pointB.y);
			CGContextStrokePath(context);
			xAxesStepDistance = (viewHeight / 7);
			
			for (int i = 0; i < 7; i++)
			{
				pointA = CGPointMake(0, xAxesStepDistance * i);
				pointB = CGPointMake(width, pointA.y);
				CGContextMoveToPoint(context,pointA.x , pointA.y);
				CGContextAddLineToPoint(context, pointB.x, pointB.y);
			}
			pointA = CGPointMake(0, viewHeight);
			pointB = CGPointMake(maxWidth, viewHeight);
			CGContextMoveToPoint(context,pointA.x , pointA.y);
			CGContextAddLineToPoint(context, pointB.x, pointB.y);
			CGContextStrokePath(context);
			
			
			
			
			
			float total = 0.0;
			high = 0.0;
			low = 0.0;
			for (int i = 0; i < [googleDataObjectArray count]; i++)
			{
				GoogleDataObject *gdo = [googleDataObjectArray objectAtIndex:i];
				if (i == 0)
				{
					low = [gdo.close floatValue];
					high = [gdo.close floatValue]; 
				}
				
				float val = [gdo.close floatValue];
				total += val;
				
				if (val > high)
					high = val;
				if (val < low)
					low = val;
				
			}
			
			
			
			float lowHighSpreadDistance = high - low;
			
			xStep = width / [googleDataObjectArray count];
			yStep = self.frame.size.height / lowHighSpreadDistance;
			
			float midpoint = total / [googleDataObjectArray count];
			
			
			float normalizedHigh = 0.0;
			float normalizedLow = 0.0;
			NSMutableArray *positionOffsetArray = [NSMutableArray arrayWithCapacity:0];
			
			total  = 0;
			for (int i = 0; i < [googleDataObjectArray count]; i++)
			{
				GoogleDataObject *gdo = [googleDataObjectArray objectAtIndex:i];
				
				float diff = [gdo.close floatValue] - midpoint;
				if (i == 0)
				{
					normalizedLow = diff;
					normalizedHigh = diff;
				}
				if (diff < normalizedLow)
					normalizedLow = diff;
				if (diff > normalizedHigh)
					normalizedHigh = diff;
				
				[positionOffsetArray addObject:[NSNumber numberWithFloat:diff]];
			}
			
			/// -------Draw line graph	
			CGPoint fromPoint = CGPointMake(50,50);
			CGPoint toPoint = CGPointMake(0,midpoint);
			
			context = UIGraphicsGetCurrentContext();
			
			CGContextSetLineWidth(context,2);
			//	CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//			CGContextSetStrokeColorWithColor(context, ((UIColor *)[[GlobalStyleDictionary sharedGlobalStyleDictionary] getObjectWithKey:LineGraphLineColor]).CGColor);	
			CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);				
			for (int i = 0; i < [googleDataObjectArray count]; i++)
			{
				
				
				float val = [[positionOffsetArray objectAtIndex:i] floatValue];
				//	NSLog(@"normalized high: %f", normalizedHigh);
				//	NSLog(@"normalized value: %f", val);
				//	NSLog(@"divided: %f", (val / normalizedHigh));
				float yPos = (viewHeight / 2) -  ((val / high) * (viewHeight));
				
				//NSLog(@"yPos: %f", yPos);
				//	NSLog(@" ");
				
				
				
				fromPoint = toPoint;
				toPoint = CGPointMake(i * xStep, yPos);
				if (i == 0)
				{
					lowPointOnGraph = toPoint;
					highPointOnGraph = toPoint;
				}
				if (toPoint.y > highPointOnGraph.y)
					highPointOnGraph = toPoint;
				if (toPoint.y < lowPointOnGraph.y)
					lowPointOnGraph = toPoint;
				
				if (i == 0)
					fromPoint = toPoint;
				
				
				
				CGContextMoveToPoint(context,fromPoint.x , fromPoint.y);
				CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
				
				if (i == [googleDataObjectArray count] -1)
					lastPointOnGraph = toPoint;
			}
			CGContextStrokePath(context);
			
			/// -------End Draw line graph		
			
			
			
			//--------- Vertical axes	
			float labelWidth = 100;
			for (int i = 0; i < 5; i++)
			{
				
				CGPoint fromPoint = CGPointMake(i * (width / 5), 0);
				CGPoint toPoint = CGPointMake(fromPoint.x,self.frame.size.height);
				CGContextRef	context = UIGraphicsGetCurrentContext();
				
				CGContextSetLineWidth(context,1);
				//			CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//				CGContextSetStrokeColorWithColor(context,((UIColor *)[[GlobalStyleDictionary sharedGlobalStyleDictionary] getObjectWithKey:LineGraphAxesColor]).CGColor);					
				CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);				
				CGContextMoveToPoint(context,fromPoint.x , fromPoint.y);
				CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
				
				
				CGContextStrokePath(context);
				
				
				if ((i != 0) && (i != 10))
				{
					//	CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
					CGRect frame = CGRectMake(fromPoint.x - (.45 * labelWidth), 700, labelWidth, 20);
					NSString *dateString = ((GoogleDataObject *)[googleDataObjectArray objectAtIndex:[[NSNumber numberWithFloat:(i * (width / 10) / yStep)] intValue]]).date;								
					[dateString drawInRect:frame withFont:[UIFont systemFontOfSize:16]];
					CGContextStrokePath(context);										
				}
				
			}
			
			//---------------draw right section
			[self drawRightSection];
			
			//Draw touch points
			
			
			if ([touchPointArray count] > 0)
			{
				//show oval
				CGPoint touchPoint = [((UITouch *)[touchPointArray objectAtIndex:0]) locationInView:self];
				
				int indexValue = [[NSNumber numberWithFloat:lroundf(touchPoint.x / xStep)] intValue];
				if (indexValue < [googleDataObjectArray count])
				{
				//	GoogleDataObject *obj = [googleDataObjectArray objectAtIndex:indexValue];
					float val = [[positionOffsetArray objectAtIndex:indexValue] floatValue];					
					float yPos = (viewHeight / 2) -  ((val  / high) * (viewHeight));
					CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
					CGContextFillEllipseInRect(context, CGRectMake(xStep * indexValue -10, yPos - 10, 20, 20));
				}
				//end show oval
				
				context = UIGraphicsGetCurrentContext();
				CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
				for (int i =0 ; i < [touchPointArray count]; i++)
				{
					CGPoint touchPoint = [((UITouch *)[touchPointArray objectAtIndex:i]) locationInView:self];
					
					CGContextMoveToPoint(context,touchPoint.x, 0);
					CGContextAddLineToPoint(context, touchPoint.x, self.frame.size.height);
				}
				CGContextStrokePath(context);
				
				
				if ([touchPointArray count] > 1)
				{
					CGPoint touchPoint = [((UITouch *)[touchPointArray objectAtIndex:0]) locationInView:self];
					float minX = touchPoint.x;
					float maxX = touchPoint.x;
					for (int i = 1; i < [touchPointArray count]; i++)
					{
						touchPoint = [((UITouch *)[touchPointArray objectAtIndex:i]) locationInView:self];
						if (touchPoint.x < minX)
							minX = touchPoint.x;
						if (touchPoint.x > maxX)
							maxX = touchPoint.x;
						
						
						
					}			
					CGContextSetFillColorWithColor(context, [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:.4].CGColor);
					CGContextMoveToPoint(context, minX, 0);
					
					CGContextAddLineToPoint(context, minX, self.frame.size.height);					
					CGContextAddLineToPoint(context, maxX, self.frame.size.height);					
					CGContextAddLineToPoint(context, maxX, 0);										
					CGContextAddLineToPoint(context, minX, 0);
					CGContextClosePath(context);				
					CGContextFillPath(context);
				}
				
			}
			
			
		}	
	}
	@catch (NSException *e) {
		NSLog(@"%@.drawRect: %@", [self class], e);	
	}
	
}


-(void)drawRightSection
{
	
	
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setMaximumFractionDigits:2];
	[numberFormatter setMinimumFractionDigits:2];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	
	
	
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context,.25);
	CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
	CGPoint pointA;
	CGPoint pointB;
	for (int i = 1; i < 7; i++)
	{
		pointA = CGPointMake(550, xAxesStepDistance *i);
		pointB = CGPointMake(maxWidth, pointA.y);
		CGContextMoveToPoint(context,pointA.x , pointA.y);
		CGContextAddLineToPoint(context, pointB.x, pointB.y);
		CGContextStrokePath(context);
	}
	
	pointA = CGPointMake(maxWidth, 0);
	pointB = CGPointMake(maxWidth, viewHeight);
	CGContextMoveToPoint(context,pointA.x , pointA.y);
	CGContextAddLineToPoint(context, pointB.x, pointB.y);
	CGContextStrokePath(context);
	
	
	context = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBFillColor(context, 255, 0, 0, 0.3);
	CGContextFillEllipseInRect(context, CGRectMake(highPointOnGraph.x-10, highPointOnGraph.y-10, 20, 20));
	
	CGContextSetRGBFillColor(context, 0, 255, 0, 0.3);
	CGContextFillEllipseInRect(context, CGRectMake(lowPointOnGraph.x-10, lowPointOnGraph.y-10, 20, 20));
	
	
	
	context = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBFillColor(context, 0, 0, 255, 0.3);
	CGContextSetRGBStrokeColor(context, 0, 0, 255, 0.5);
	
	// Draw a circle (filled)
	CGContextFillEllipseInRect(context, CGRectMake(lastPointOnGraph.x-10, lastPointOnGraph.y-10, 20, 20));
	
	context = UIGraphicsGetCurrentContext();
	
	if ([googleDataObjectArray count] > 0)
	{
		
		float graphYCoordinateDifference = highPointOnGraph.y - lowPointOnGraph.y;			
		float lowHighActualDifference = high - low;			
		float positionRatio = lowHighActualDifference  /  graphYCoordinateDifference;
		
		float topXAxisValue = lowPointOnGraph.y * positionRatio + high;
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, -7, 100, 14)];
		label.textAlignment = UITextAlignmentLeft;
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor darkGrayColor];
		
		label.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:topXAxisValue]];
		label.font = [UIFont systemFontOfSize:11];
		[self addSubview:label];
		[xAxisLabelsArray addObject:label];
		for (int i = 1; i < 7; i++)
		{
			
			float axisValue = topXAxisValue - ((xAxesStepDistance * i) * positionRatio);
			label = [[UILabel alloc] initWithFrame:CGRectMake(-35, xAxesStepDistance * i-7, 100, 14)];
			label.textAlignment = UITextAlignmentLeft;
			label.backgroundColor = [UIColor clearColor];
			label.textColor = [UIColor darkGrayColor];
			label.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:axisValue]];
			label.font = [UIFont systemFontOfSize:11];
			[self addSubview:label];
			[xAxisLabelsArray addObject:label];
			
		}
		
		CGContextSetRGBFillColor(context, 255, 255, 255, 0.3);
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, lastPointOnGraph.x, lastPointOnGraph.y);
		
		
		CGContextSetLineWidth(context,1);
		CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
		
		pointA = CGPointMake(lastPointOnGraph.x, lastPointOnGraph.y);
		pointB = CGPointMake(maxWidth, lastPointOnGraph.y - (viewHeight*.2));
		CGContextMoveToPoint(context,pointA.x , pointA.y);
		CGContextAddLineToPoint(context, pointB.x, pointB.y);
		CGContextStrokePath(context);
		
		float axisValue = topXAxisValue - (pointB.y * positionRatio);
		label = [[UILabel alloc] initWithFrame:CGRectMake(maxWidth-85, pointB.y-7, 75, 14)];
		label.textAlignment = UITextAlignmentRight;
		label.backgroundColor = [UIColor clearColor];
		//label.textColor = [Utils getUpColor];
		
		label.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:axisValue]];
		label.font = [UIFont systemFontOfSize:11];
		[self addSubview:label];
		[xAxisLabelsArray addObject:label];
		
		axisValue = topXAxisValue - (pointB.y * positionRatio) - (viewHeight * .08);
		label = [[UILabel alloc] initWithFrame:CGRectMake(maxWidth-85, pointB.y-7 + (viewHeight * .08), 75, 14)];
		label.textAlignment = UITextAlignmentRight;
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor blueColor];
		
		label.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:axisValue]];
		label.font = [UIFont systemFontOfSize:11];
		[self addSubview:label];
		[xAxisLabelsArray addObject:label];
		
		
		
		CGPathAddLineToPoint(path, NULL, pointB.x, pointB.y);
		
		
		pointA = CGPointMake(lastPointOnGraph.x, lastPointOnGraph.y);
		pointB = CGPointMake(maxWidth, lastPointOnGraph.y + (viewHeight*.2));
		CGContextMoveToPoint(context,pointA.x , pointA.y);
		CGContextAddLineToPoint(context, pointB.x, pointB.y);
		CGContextStrokePath(context);
		
		axisValue = topXAxisValue - (pointB.y * positionRatio);
		label = [[UILabel alloc] initWithFrame:CGRectMake(maxWidth-85, pointB.y-7, 75, 14)];
		label.textAlignment = UITextAlignmentRight;
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor darkGrayColor];
		
		label.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:axisValue]];
		label.font = [UIFont systemFontOfSize:11];
		[self addSubview:label];
		[xAxisLabelsArray addObject:label];
		
		
		
		
		CGPathAddLineToPoint(path, NULL, pointB.x, pointB.y);
		CGPathAddLineToPoint(path, NULL, lastPointOnGraph.x, lastPointOnGraph.y);
		
		//		CGContextClosePath(context);
		CGContextAddPath(context, path);
		CGContextFillPath(context);
		
		
	}
	
	
	CGContextSetStrokeColorWithColor(context,[UIColor whiteColor].CGColor);		
	CGContextSetLineWidth(context,1);
	pointA = CGPointMake(0, self.frame.size.height-1);
	pointB = CGPointMake(self.frame.size.width, pointA.y);
	CGContextMoveToPoint(context,pointA.x , pointA.y);
	CGContextAddLineToPoint(context, pointB.x, pointB.y);
	CGContextStrokePath(context);
	
}


-(void)updateLabel:(UITouch *)touch
{
	
	int index = [[NSNumber numberWithFloat:([touch locationInView:self].x / xStep)] intValue];
	if ((index >= 0) && (index < [googleDataObjectArray count]))
	{
		GoogleDataObject *gdo = [googleDataObjectArray objectAtIndex:index];
		
		graphBackgroundView.dataLabel.text = gdo.close;
	}
	
}


@end
