//
//  UIViewController+WebScraper.h
//  GoogleSearchBridge
//
//  Created by  on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WSWebScraper.h"

@class WSWebScraper;
@interface UIViewController (WebScraper)

@property (readonly, strong, nonatomic) WSWebScraper* webScraper;

- (WSWebScraper *)createWebScraper;

@end
