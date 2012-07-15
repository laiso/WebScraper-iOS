#import <GHUnitIOS/GHUnit.h> 

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

@interface WebScraperTests : GHTestCase { }
@end

@implementation WebScraperTests

- (void)testStrings {       
  NSString *string1 = @"a string";
  GHTestLog(@"I can log to the GHUnit test console: %@", string1);
  
  assertThat(string1, equalTo(@"string1"));
  // Assert string1 is not NULL, with no custom error description
  
  
  // Assert equal objects, add custom error description
  NSString *string2 = @"a string";
  GHAssertEqualObjects(string1, string2, @"A custom error message. string1 should be equal to: %@.", string2);
}

@end