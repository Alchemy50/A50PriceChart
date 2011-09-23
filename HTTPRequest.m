//
//  HTTPRequest.m



#import "HTTPRequest.h"

#import "ASIDownloadCache.h"


@implementation HTTPRequest
@synthesize parseReponseSelector, shouldUseLoggedInUserCredentials, requestIdentification, requestObject;

- (id)initWithURL:(NSURL *)newURL {
	if(self = [super initWithURL:newURL]) {
		[self setTimeOutSeconds:100];
		[self setPersistentConnectionTimeoutSeconds:100];
		[self setUseSessionPersistence:NO]; // There are no "sessions", we'll manage user/pass when it's required.
//#ifdef HAW_ENV_STAGING
		[self setValidatesSecureCertificate:NO];
//#endif
	}
	return self;
}

- (void)addPostValue:(id <NSObject>)value forKey:(NSString *)key
{
	// Adding support for passing in arrays
	if ([value isKindOfClass:[NSArray class]])
	{
		NSArray *ar = (NSArray *)value;
		for (int i = 0; i < [ar count]; i++)
		{
			[super addPostValue:[[ar objectAtIndex:i] description] forKey:key];
			NSLog(@"request.post, key: %@=%@", key, [[ar objectAtIndex:i] description]);
		}
	}
	else // Otherwise just call super to add
	{
		[super addPostValue:value forKey:key];
		NSLog(@"request.post, key: %@, value: %@", key, value);
	}
	
	
}



- (void)setGetValue:(id <NSObject>)value forKey:(NSString *)key
{

	//url string building
	NSString *delimeter = @"?";
	if ([self.url.absoluteString rangeOfString:delimeter].length > 0)
		delimeter = @"&";
	
	NSString *newUrlString = [NSString stringWithFormat:@"%@%@%@=%@", self.url.absoluteString, delimeter, key, value];
	NSLog(@"newUrlString: %@", newUrlString);
	NSURL *newURL = [NSURL URLWithString:newUrlString];

	[self setURL:newURL];		
}


@end
