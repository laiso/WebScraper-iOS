//
//  UIViewController+WebScraper.m
//  GoogleSearchBridge
//
//  Created by  on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+WebScraper.h"

#import "WSWebScraper.h"

@implementation UIViewController (WebScraper)

- (WSWebScraper *)webScraper
{
  static WSWebScraper *__webScraper;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __webScraper = [[WSWebScraper alloc] initWithViewController:self];
  });
  return __webScraper;
}

- (WSWebScraper *)createWebScraper
{
  return [[WSWebScraper alloc] initWithViewController:self];
}

@end
