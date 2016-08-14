//
//  2Scrambler.m
//  CubeTimer
//
//  Created by Weston Mizumoto on 8/13/16.
//  Copyright © 2016 Weston Mizumoto. All rights reserved.
//

#import "2Scrambler.h"
#import "SeededNumberGenerator.h"

@interface _Scrambler ()
@property(strong, nonatomic) SeededNumberGenerator *srg;
@end
@implementation _Scrambler
- (id)init {
    if(self = [super init]) {
        [self calcPerm];
    }
    self.srg = [[SeededNumberGenerator alloc]init];
    return self;
}

- (void)seedScrambler:(NSString *) seedValue{
    [self.srg seed:seedValue];
}

- (NSString *)genScramble2x2 {
    int lim = 8;
    sol = [NSMutableArray new];
    
    do {
        // Generate random permutation
        //int q = arc4random()%5040;
        
        int q = [self.srg getIntBetweenMin:0 andMax:5040] % 5040;
        
        // Generate random orientation
        //int t = arc4random()%729;
        
        int t = [self.srg getIntBetweenMin:0 andMax:729] % 729;
        
        // Solve the scramble
        [sol removeAllObjects];
        if(q != 0 || t != 0) {
            // max length of solution is 11
            for(int l=0;l<=11;l++) {
                if([self search:0 q:q t:t l:l lm:-1])
                    break;
            }
        }
    }while(sol.count < lim);
    
    NSString *t = @"";
    
    for(int q=0;q<sol.count;q++) {
        NSString *first = [NSString stringWithFormat:@"%c", [@"URF" characterAtIndex:([[sol objectAtIndex:q] intValue]/10)]];
        NSString *second = [NSString stringWithFormat:@"%c", [@"2/'" characterAtIndex:([[sol objectAtIndex:q] intValue]%10)]];
        if([second isEqualToString:@"/"])second = @"";
        t = [NSString stringWithFormat:@"%@ %@%@", t, first, second];
        //t += " " + "URF".charAt(sol[q]/10) + " 2\'".charAt(sol[q]%10);		// [WARNING] WTF is this nonsense?
    }
    return t;
}

- (BOOL)search:(int)d q:(int)q t:(int)t l:(int)l lm:(int)lm {
    // searches for solution, from position q|t, in l moves exactly. last move was lm, current depth = d
    if(l == 0) {
        if(q == 0 && t == 0)
            return true;
    }
    else {
        if(perm[q] > l || twst[t] > l)
            return false;
        int p, s, a, m;
        for(m=0;m<3;m++) {
            if(m != lm) {
                p = q;
                s = t;
                for(a=0;a<3;a++) {
                    p = permmv[p][m];
                    s = twstmv[s][m];
                    [sol setObject:@(10*m+a) atIndexedSubscript:d];
                    if([self search:d+1 q:p t:s l:l-1 lm:m])
                        return true;
                }
            }
        }
    }
    return false;
}

- (void)calcPerm {
    // Calculate solving arrays
    // First permutation
    perm = malloc(10000 * sizeof(int));
    twst = malloc(10000 * sizeof(int));
    permmv = malloc(10000 * sizeof(int *));
    twstmv = malloc(10000 * sizeof(int *));
    
    for(int p=0;p<5040;p++) {
        perm[p] = -1;
        permmv[p] = malloc(10000 * sizeof(int));
        for(int m=0;m<3;m++)
            permmv[p][m] = [self getprmmv:p m:m];
    }
    perm[0] = 0;
    
    for(int l=0;l<=6;l++) {
        int n = 0;
        for(int p=0;p<5040;p++) {
            if(perm[p] == l) {
                for(int m=0;m<3;m++) {
                    int q = p;
                    for(int c=0;c<3;c++) {
                        // [WARNING] Might be some issue here, in other code variable q is defined twice
                        q = permmv[q][m];
                        if(perm[q] == -1) {
                            perm[q] = l+1;
                            n++;
                        }
                    }
                }
            }
        }
    }
    // then twist
    for(int p=0;p<729;p++) {
        twst[p] = -1;
        twstmv[p] = malloc(10000 * sizeof(int));
        for(int m=0;m<3;m++)
            twstmv[p][m] = [self gettwsmv:p m:m];
    }
    twst[0] = 0;
    
    for(int l=0;l<=5;l++) {
        int n=0;
        for(int p=0;p<729;p++) {
            if(twst[p] == l) {
                for(int m=0;m<3;m++) {
                    int q = p;
                    for(int c=0;c<3;c++) {
                        // [WARNING] Might be some issue here, in other code variable q is defined twice
                        q = twstmv[q][m];
                        if(twst[q] == -1) {
                            twst[q] = l+1;
                            n++;
                        }
                    }
                }
            }
        }
    }
}

- (int)getprmmv:(int)p m:(int)m {
    //given position p<5040 and move m<3, return new position number
    int a, b, c, q;
    //convert number into array;
    
    // [WARNING] Improve code here
    // Need to figure out what max value can be so I can make this array smaller
    int ps[10000];
    
    q = p;
    
    for(a=1;a<=7;a++) {
        b = q%a;
        q = (q-b)/a;
        for(c=a-1;c>=b;c--)
            ps[c+1] = ps[c];
        ps[b] = 7-a;
    }
    //perform move on array
    if(m == 0) {
        //U
        c = ps[0];
        ps[0] = ps[1];
        ps[1] = ps[3];
        ps[3] = ps[2];
        ps[2] = c;
    }
    else if(m == 1) {
        //R
        c = ps[0];
        ps[0] = ps[4];
        ps[4] = ps[5];
        ps[5] = ps[1];
        ps[1] = c;
    }
    else if(m == 2) {
        //F
        c = ps[0];
        ps[0] = ps[2];
        ps[2] = ps[6];
        ps[6] = ps[4];
        ps[4] = c;
    }
    //convert array back to number
    q = 0;
    for(a=0;a<7;a++) {
        b=0;
        for(c=0;c<7;c++) {
            if(ps[c] == a)
                break;
            if(ps[c] > a)
                b++;
        }
        q = q*(7-a)+b;
    }
    return q;
}

- (int)gettwsmv:(int)p m:(int)m {
    //given orientation p<729 and move m<3, return new orientation number
    int a, b, c, d, q;
    //convert number into array;
    // [WARNING] Improve code here
    // Need to figure out what max value can be so I can make this array smaller
    int ps[10000];
    for(int d=0;d<10000;d++)ps[d] = 0;
    
    q = p;
    d = 0;
    
    for(a=0;a<=5;a++) {
        c = floor((float)q/3.0f);
        b = q - 3 * c;
        q = c;
        ps[a] = b;
        d -= b;
        if(d < 0)
            d += 3;
    }
    ps[6] = d;
    
    //perform move on array
    if(m == 0) {
        //U
        c = ps[0];
        ps[0] = ps[1];
        ps[1] = ps[3];
        ps[3] = ps[2];
        ps[2] = c;
    }
    else if(m == 1) {
        //R
        c = ps[0];
        ps[0] = ps[4];
        ps[4] = ps[5];
        ps[5] = ps[1];
        ps[1] = c;
        
        ps[0] += 2;
        ps[1]++;
        ps[5] += 2;
        ps[4]++;
    }
    else if(m == 2) {
        //F
        c = ps[0];
        ps[0] = ps[2];
        ps[2] = ps[6];
        ps[6] = ps[4];
        ps[4] = c;
        
        ps[2] += 2;
        ps[0]++;
        ps[4] += 2;
        ps[6]++;
    }
    //convert array back to number
    q = 0;
    for(a=5;a>=0;a--) {
        q = q*3+(ps[a]%3);
    }
    return q;
}


@end