//
//  RootViewController.m
//  WebScraper
//
//  Created by  on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopularPhotosViewController.h"

#import "WSWebScraper.h"

#import "UIViewController+WebScraper.h"

@interface PopularPhotosViewController ()
@property (strong, nonatomic) NSMutableArray* imageURLs;
@end

@implementation PopularPhotosViewController


static NSInteger kIndicatorTag = 100;
static NSInteger kImageCellTag = 200;

@synthesize imageURLs = _imageURLs;

-(id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if(!self){
    return nil;
  }
  
  self.imageURLs = [NSMutableArray array];
    
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.tableView.dataSource = self;
  
  UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [indicator startAnimating];
  self.tableView.tableHeaderView = indicator;
  
  [self.webScraper scrape:@"http://m.pinterest.com/popular/" 
                 selector:@"//div[@id=\"wrapper\"]//div[@class=\"image\"]//a/img"
                  handler:^(NSArray *elements, NSError *error) {
                    NSLog(@"Load %d elements.", elements.count);
                    
                    for (NSDictionary* img in elements) {
                      NSString* url = [[img objectForKey:@"attributes"] objectForKey:@"src"];
                      [self.imageURLs addObject:url];
                    }
                    
                    [self.tableView.tableHeaderView removeFromSuperview]; 
                    [self.tableView reloadData];
                  }];
}

# pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [[UIScreen mainScreen] bounds].size.height/2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.imageURLs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString* cellID = [NSString stringWithFormat:@"PopularPhoto-%d", indexPath.row];
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if(!cell){
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.contentMode = UIViewContentModeCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  
  if(![cell.contentView viewWithTag:kImageCellTag]){
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.tag = kIndicatorTag;
    [indicator startAnimating];
    [cell.contentView addSubview:indicator];
    
    NSString* url = [self.imageURLs objectAtIndex:indexPath.row];
    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSLog(@"Load request: %@", url);
    [NSURLConnection sendAsynchronousRequest:req 
                                       queue:[NSOperationQueue mainQueue] 
                           completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                             UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:responseData]];
                             imageView.contentMode = UIViewContentModeScaleAspectFit;
                             imageView.frame = cell.contentView.frame;
                             imageView.tag = kImageCellTag;
                             [cell.contentView addSubview:imageView];
                             
                             UIView* v = [cell.contentView viewWithTag:kIndicatorTag];
                             if([v isKindOfClass:[UIActivityIndicatorView class]]){
                               [(UIActivityIndicatorView *)v removeFromSuperview];
                             }
                           }];
  }
  
  return cell;
}
@end
