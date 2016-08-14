//
//  2Scrambler.h
//  CubeTimer
//
//  Created by Weston Mizumoto on 8/13/16.
//  Copyright © 2016 Weston Mizumoto. All rights reserved.
//
/*		Authors: Jaap Scherphuis (www.jaapsch.net) and Conrad Rider (www.crider.co.uk)
	Cride5 is a user on the www.speedsolving.com forums
	He posted a solver here:
	https://www.speedsolving.com/forum/showthread.php?18598-Optimal-2x2-Scrambles-for-CCT-(for-versions-lt-0-9-4)/page6&p=361541#post361541
 
	This is my (Bryan Tremblay's) rewrite of his original .js script
 */



//Create scrambler
//Seed scrambler
//Call genScramble2x2
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface _Scrambler : NSObject {
    int *perm, *twst;
    int **permmv, **twstmv;
    NSMutableArray *sol;
}


- (void)seedScrambler:(NSString *) seedValue;
- (NSString *)genScramble2x2;
- (BOOL)search:(int)d q:(int)q t:(int)t l:(int)l lm:(int)lm;
- (void)calcPerm;
- (int)getprmmv:(int)p m:(int)m;
- (int)gettwsmv:(int)p m:(int)m;

@end