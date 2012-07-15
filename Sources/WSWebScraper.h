//
//  WSWebScraper.h
//  GoogleSearchBridge
//
//  Created by  on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSWebScraper : NSObject <UIWebViewDelegate>

typedef void(^WSRequestHandler)(NSArray *elements, NSError *error);

@property (nonatomic, copy) WSRequestHandler completetion;

- (id)initWithViewController:(UIViewController *)aViewController;

- (void)scrapeWithSelector:(NSString *)aSelector;

- (void)scrape:(NSString *)url selector:(NSString *)aSelector;
- (void)scrape:(NSString *)url selector:(NSString *)aSelector handler:(WSRequestHandler)handler;


@end
