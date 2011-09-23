//
//  GoogleDataObject.h
//  MorganResearch
//
//  Created by Josh Klobe on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoogleDataObject : NSObject {
//17-Nov-09,574.87,577.50,573.72,577.49,1920765
	//Date,Open,High,Low,Close,Volume
	
	NSString *date;
	NSString *open;
	NSString *high;
	NSString *low;
	NSString *close;
	NSString *volume;
}
-(id)initWithLine:(NSString *)line;

@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *open;
@property (nonatomic, retain) NSString *high;
@property (nonatomic, retain) NSString *low;
@property (nonatomic, retain) NSString *close;
@property (nonatomic, retain) NSString *volume;


@end
