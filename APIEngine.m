
#import "APIEngine.h"


@implementation APIEngine
@synthesize delegate, networkQueue;

- (id) init {
	self = [super init];
	if (self != nil) {
		self.networkQueue = [[ASINetworkQueue alloc] init];
		[networkQueue go]; 
	}
	return self;
}



/////////////////////////////////////////////////////////////////////////////
-(void)makeGoogleFinanceCall:(NSString *)identifier
{
	NSString *urlString = [NSString stringWithFormat:@"http://www.google.com/finance/historical?q=NASDAQ:%@&output=csv", identifier];
	
	HTTPRequest *request =  [HTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
	request.requestIdentification = GOOGLE_FINANCE_CALL;
	[request setParseReponseSelector:@selector(parseGoogleFinanceCall:)];
	[request setDelegate:self];
	[networkQueue addOperation:request];	
	
}


-(id)parseGoogleFinanceCall:(id)response 
{
//	NSLog(@"response: %@", response);
	return [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
}




#pragma mark HTTPRequest delegates
- (void)requestFinished:(HTTPRequest *)request {
	// Use when fetching text data
	//	NSLog(@"Request headers: %@", [request postData]);
	//	NSLog(@"Reponse headers: %@", [request responseString]);
	
	// Check to make sure the delegate wasn't unset during the call
	if(delegate == nil) {	
		return;
	}
	
	// Successful response does not indicate an error-free response. Let's check for HTTP errors here:
	id parsedResponse;
	UIAlertView *alert;

	
//	[Utils debugLog:[NSString stringWithFormat:@"requst[%@].statusCode: %d", request.originalURL, [request responseStatusCode]] requestingObject:self];
	switch ([request responseStatusCode]) {
		case 200: // OK

			if([request parseReponseSelector] != nil) {

				parsedResponse = [self performSelector:[request parseReponseSelector] withObject:[request responseData]];
			}
			if (delegate != nil)
			{
				[delegate engine:self succeededWithResponse:parsedResponse request:request];
			}
			break;
			
		case 400: // Bad request			
			[delegate engine:self failedWithErrors:parsedResponse request:request];
			break;
			
		case 401: // Unauthorized
			[delegate engine:self failedWithErrors:nil request:request];
			
			// Ask the user to log in or show an error?
			break;
			
		case 404: // Not Found
			
			[delegate engine:self failedWithErrors:nil request:request];
			break;
			
		case 500: // Application Exception
			
			alert = [[UIAlertView alloc] 
					 initWithTitle:@"Remote Exception" 
					 message:[request responseStatusMessage] 
					 delegate:nil 
					 cancelButtonTitle:nil 
					 otherButtonTitles:@"OK", nil];
			
			[alert show];
			
			[alert release];
			
			break;
		default:
			alert = [[UIAlertView alloc] 
					 initWithTitle:@"HTTP Error" 
					 message:[request responseStatusMessage] 
					 delegate:nil 
					 cancelButtonTitle:nil 
					 otherButtonTitles:@"OK", nil];
			
			[alert show];
			
			[alert release];
			break;
	}
	
}

- (void)requestFailed:(HTTPRequest *)request {
	

	NSLog(@"request[%@] error: %@", request.originalURL,  [request error]);
	
	[delegate engine:self failedWithErrors:[NSArray arrayWithObject:[request error]] request:request];

}

- (void) dealloc {
	[networkQueue reset];
	[networkQueue release];
	[super dealloc];
}



@end
