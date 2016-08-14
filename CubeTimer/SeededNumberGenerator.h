//
//  SeededNumberGenerator.h
//  CubeTimer
//
//  Created by Weston Mizumoto on 8/13/16.
//  Copyright © 2016 Weston Mizumoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeededNumberGenerator : NSObject


- (void) seed:(NSString *) seedValue;
- (unsigned int) getIntBetweenMin:(int) min andMax:(int) max;

@end
