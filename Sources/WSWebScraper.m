//
//  WSWebScraper.m
//  GoogleSearchBridge
//
//  Created by  on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WSWebScraper.h"

#import <hpple/TFHpple.h>

@interface WSWebScraper(){
  UIViewController* _viewController;
}

@property (strong, nonatomic) UIWebView* webView;
@property (weak, nonatomic) UIViewController* viewController;

@property (assign, nonatomic) BOOL catchFlag;
@property (strong, nonatomic) NSURL* targetUrl;
@property (strong, nonatomic) NSString* selector;
@end

@implementation WSWebScraper

@synthesize completetion = _completetion;

@synthesize webView = _webView;
@synthesize targetUrl = _targetUrl;
@synthesize catchFlag = _catchFlag;
@synthesize selector = _selector;

- (UIViewController *)viewController
{
  return _viewController;
}

- (void)setViewController:(UIViewController *)aViewController
{
  _viewController = aViewController;
}

- (id)initWithViewController:(UIViewController *)aViewController
{
  self = [super init];
  if(!self){
    return nil;
  }
  
  self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1, 0)];
  self.webView.hidden = YES;  
  self.webView.delegate = self;
  
  self.viewController = aViewController;
  [self.viewController.view addSubview:self.webView];

  self.catchFlag = NO;
  self.selector = [NSString string];
  
  return self;
}

- (void)scrapeWithSelector:(NSString *)aSelector
{
  self.selector = aSelector;
  [self webViewDidFinishLoad:self.webView];
}

- (void)scrape:(NSString *)url selector:(NSString *)aSelector
{
  [self scrape:url selector:aSelector handler:self.completetion];
}

- (void)scrape:(NSString *)url selector:(NSString *)aSelector handler:(WSRequestHandler)handler
{
  self.targetUrl = [NSURL URLWithString:url];
  self.selector = aSelector;
  self.completetion = handler;
  self.catchFlag = YES;
  [self.webView loadRequest:[NSURLRequest requestWithURL:self.targetUrl]];
}

# pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{  
  if(![request.URL.scheme isEqualToString:@"http"] && ![request.URL.scheme isEqualToString:@"https"]){
    return NO;
  }
  
  /*
  if(!self.catchFlag){
    dispatch_async(dispatch_get_main_queue(), ^{
      NSURLResponse* response;
      NSError* error;
      NSData* responseData = [NSURLConnection sendSynchronousRequest:newRequest returningResponse:&response error:&error];
      self.catchFlag = YES;
      [self.webView loadData:responseData MIMEType:response.MIMEType textEncodingName:response.textEncodingName baseURL:newRequest.URL];
    });
    return NO;
  }
  */
  
  return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  if(![webView.request.URL.host hasSuffix:self.targetUrl.host]){
    return;
  }
  
  
  NSString* head = [webView stringByEvaluatingJavaScriptFromString:@"document.head.innerHTML"];
  NSString* body = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
  
  if(!body.length){
    return;
  }
  
  
  if(!self.catchFlag){
    return;
  }
  
  
  self.catchFlag = NO;
  NSString* html = [NSString stringWithFormat:@"<html><head>%@</head><body>%@</body></html>", head, body];
  TFHpple *hpple = [TFHpple hppleWithHTMLData:[html dataUsingEncoding:NSUTF8StringEncoding]];
  NSArray* elements = [hpple searchWithXPathQuery:self.selector];  
  
  if(!elements.count){
    self.completetion([NSArray array], nil);
    return;
  }
  
  
  NSMutableArray* result = [NSMutableArray arrayWithCapacity:elements.count];
  for (TFHppleElement* element in elements) {
    NSDictionary* item = [NSDictionary dictionaryWithObjectsAndKeys:
                          [element attributes], @"attributes", 
                          [element content], @"content",
                          nil];
    [result addObject:item];
  }
  self.completetion(result, nil);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  NSLog(@"[ERROR] %@", [error localizedDescription]);
  self.completetion(nil, error);
}

@end
