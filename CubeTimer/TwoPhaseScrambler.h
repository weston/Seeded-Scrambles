//
//  TwoPhaseScrambler.h
//  DCTimer scramble
//
//  Created by MeigenChou on 13-4-15.
//
//

#import <Foundation/Foundation.h>

@interface TwoPhaseScrambler : NSObject
-(NSString*)scramble: (int) type;
-(void)seedScrambler: (NSString *)seedValue;
@end
