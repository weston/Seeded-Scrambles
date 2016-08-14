//
//  SeededNumberGenerator.m
//  CubeTimer
//
//  Created by Weston Mizumoto on 8/13/16.
//  Copyright © 2016 Weston Mizumoto. All rights reserved.
//

#import "SeededNumberGenerator.h"
#import <CommonCrypto/CommonDigest.h>
@interface SeededNumberGenerator ()

@property(strong, nonatomic) NSString *seed;

@end
@implementation SeededNumberGenerator

- (id)init {
    self.seed = NULL;
    return self;
    
}
- (void) seed:(NSString *) seedValue{
    self.seed = seedValue;
}


//Inclusive range
- (unsigned int) getIntBetweenMin:(int) min andMax:(int) max{
    if (self.seed == NULL){
        NSLog(@"TRYING TO GENERATE RANDOM NUMBER FROM WITHOUT SEED.");
        return 0;
    }
    NSString *hash = [SeededNumberGenerator sha256:self.seed];
    self.seed = hash;
    unsigned int result;
    hash = [hash substringToIndex:8];
    NSScanner *scanner = [NSScanner scannerWithString:hash];
    [scanner scanHexInt:&result];
    int range = (max - min) + 1;
    int retval =(result % range) + min;
    return retval;
}


+ (NSString*)sha256:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}
@end



