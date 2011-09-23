//
//  A50PriceChartViewController.m
//  A50PriceChart
//
//  Created by Josh Klobe on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "A50PriceChartViewController.h"
#import "GoogleDataObject.h"


@implementation A50PriceChartViewController

@synthesize apiEngine, graphView;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor blackColor];
	
	
	apiEngine = [[APIEngine alloc] init];
	apiEngine.delegate = self;
	[apiEngine makeGoogleFinanceCall:@"AAPL"];
	
	graphView = [[GraphView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
	graphView.multipleTouchEnabled = YES;
	self.view.multipleTouchEnabled = YES;
	graphView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:graphView];
	

	
	
}



- (void)engine:(APIEngine *)engine succeededWithResponse:(id)response request:(id)request
{	
	NSArray *ar = [response componentsSeparatedByString:@"\n"];	
	
	NSMutableArray *dataObjectsArray = [NSMutableArray arrayWithCapacity:0];
	
	for (int i = [ar count]-1; i > 0; i--)
	{
		GoogleDataObject *obj = [[GoogleDataObject alloc] initWithLine:[ar objectAtIndex:i]];
		[dataObjectsArray addObject:obj];
		[obj release];
		
	}
	
	graphView.masterObjectArray = [[NSMutableArray alloc] initWithArray:dataObjectsArray];
	graphView.googleDataObjectArray = [[NSMutableArray alloc] initWithArray:dataObjectsArray];
	[graphView setNeedsDisplay];
	[graphView setNeedsLayout];
	graphView.alpha = 1;
	
	
	
	
}
- (void)engine:(APIEngine *)engine failedWithErrors:(NSArray *)errors request:(id)request
{
	NSLog(@"fail");
}






// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
