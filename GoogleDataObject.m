//
//  GoogleDataObject.m
//  MorganResearch
//
//  Created by Josh Klobe on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GoogleDataObject.h"


@implementation GoogleDataObject

@synthesize date, open, high,low, close, volume;

-(id) initWithLine:(NSString *)line
{
	NSArray *ar = [line componentsSeparatedByString:@","];

	if ([ar count] >=6)
	{
	
	self.date = [ar objectAtIndex:0];
	self.open = [ar objectAtIndex:1];
	self.high = [ar objectAtIndex:2];
	self.low = [ar objectAtIndex:3];
	self.close = [ar objectAtIndex:4];
	self.volume = [ar objectAtIndex:5];
	}
	return self;
}

- (NSString *)description
{
	

	return [NSString stringWithFormat:@"date:%@\nopen: %@\nhigh: %@\nlow: %@\nclose: %@\nvolume: %@\n", date, open, high,low, close, volume];
}
@end
