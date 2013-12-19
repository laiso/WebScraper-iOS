WebScraper-iOS
==============

a Web Scraping Utility with embed UIwebView context engine.

```objc
  #import "UIViewController+WebScraper.h"

  [self.webScraper scrape:@"http://m.pinterest.com/popular/" 
                 selector:@"//div[@id=\"wrapper\"]//div[@class=\"image\"]//a/img"
                  handler:^(NSArray *elements, NSError *error) {
                    NSLog(@"Load %d elements.", elements.count);
                    
                    for (NSDictionary* img in elements) {
                      NSString* url = [[img objectForKey:@"attributes"] objectForKey:@"src"];
                      [self.imageURLs addObject:url]; // NSMutableArray* imageURLs;
                    }
                  }];
```

Document(Japanese)
===================

http://iphone-dev.g.hatena.ne.jp/laiso/20120715/1342350160
