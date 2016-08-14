//
//  scrambler.m
//  CubeTimer
//
//  Created by Weston Mizumoto on 8/13/16.
//  Copyright © 2016 Weston Mizumoto. All rights reserved.
//

#import "scrambler.h"
#import "2Scrambler.h"
#import "TwoPhaseScrambler.h"
@interface scrambler ()

//Properties here
@property(strong, nonatomic) _Scrambler *scrambler_2x2;
@property(strong, nonatomic) TwoPhaseScrambler *scrambler_3x3;

@end
@implementation scrambler


- (id) init{
    //Init all scramblers here
    self.scrambler_2x2 = [[_Scrambler alloc]init];
    self.scrambler_3x3 = [[TwoPhaseScrambler alloc] init];
    return self;
}
- (void) seedScramblers: (NSString *)seed{
    //Seed all scramblers here
    [self.scrambler_2x2 seedScrambler:seed];
    [self.scrambler_3x3 seedScrambler:seed];
}

- (NSString *)getScrambleOfType: (NSString *)type{
    if ([type isEqualToString:@"2x2"]){
        return [self.scrambler_2x2 genScramble2x2];
    }
    if ([type isEqualToString: @"3x3"]){
        return [self.scrambler_3x3 scramble:0];
    }
    return NULL;
}

@end
