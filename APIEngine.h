//
//  APIEngine.h


#import "HTTPRequest.h"
#import <Foundation/Foundation.h>

#import "ASINetworkQueue.h"
#import <CoreLocation/CoreLocation.h>


#define GOOGLE_FINANCE_CALL 0
#define XIGNITE_MARKET_NEWS_CALL 1
#define XIGNITE_HISTORICAL_NEWS_CALL 2
#define XIGNITE_GLOBAL_QUOTE_CALL 3
#define XIGNITE_COMPANY_ICON_CALL 4
#define IMAGE_REQUEST 5
#define XIGNITE_EDGAR_DOCUMENT_LOOKUP_REUQEST 6

@class APIEngine;

@protocol APIEngineDelegate <NSObject>

- (void)engine:(APIEngine *)engine succeededWithResponse:(id)response request:(id)request;
- (void)engine:(APIEngine *)engine failedWithErrors:(NSArray *)errors request:(id)request;

@end


@interface APIEngine : NSObject {
	id<APIEngineDelegate> delegate;
	ASINetworkQueue *networkQueue;
}

-(void)requestImage:(NSString *)imageRef withReturnObject:(id)obj;

-(void)makeGoogleFinanceCall:(NSString *)identifier;


@property (retain) ASINetworkQueue *networkQueue; 
@property (assign) id<APIEngineDelegate> delegate;




@end
