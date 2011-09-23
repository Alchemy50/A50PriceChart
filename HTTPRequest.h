//
//  HTTPRequest.h
//
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface HTTPRequest : ASIFormDataRequest {
	SEL parseReponseSelector;
	BOOL shouldUseLoggedInUserCredentials;
	int requestIdentification;
	id requestObject;
}

@property (assign) SEL parseReponseSelector;
@property (assign) BOOL shouldUseLoggedInUserCredentials;
@property (nonatomic, assign) 	int requestIdentification;
@property (nonatomic, retain) id requestObject;

- (void)setGetValue:(id <NSObject>)value forKey:(NSString *)key;

@end
