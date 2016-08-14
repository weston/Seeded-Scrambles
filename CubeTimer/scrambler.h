//
//  scrambler.h
//  CubeTimer
//
//  Created by Weston Mizumoto on 8/13/16.
//  Copyright © 2016 Weston Mizumoto. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface scrambler : NSObject


- (void) seedScramblers: (NSString *)seed;
- (NSString *)getScrambleOfType: (NSString *)type;
@end
