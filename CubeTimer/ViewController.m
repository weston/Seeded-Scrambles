//
//  ViewController.m
//  CubeTimer
//
//  Created by Weston Mizumoto on 8/13/16.
//  Copyright © 2016 Weston Mizumoto. All rights reserved.
//

#import "ViewController.h"
#import "SeededNumberGenerator.h"
#import "scrambler.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];



    
    scrambler *s = [[scrambler alloc]init];
    [s seedScramblers:@"hellowesatonpoo"];
    
    NSLog(@"%@\n",[s getScrambleOfType: @"3x3"]);
    NSLog(@"%@\n",[s getScrambleOfType: @"3x3"]);
    NSLog(@"%@\n",[s getScrambleOfType: @"3x3"]);
    NSLog(@"%@\n",[s getScrambleOfType: @"3x3"]);
    NSLog(@"%@\n",[s getScrambleOfType: @"3x3"]);
    NSLog(@"%@\n",[s getScrambleOfType: @"3x3"]);
    NSLog(@"%@\n",[s getScrambleOfType: @"3x3"]);
    NSLog(@"%@\n",[s getScrambleOfType: @"3x3"]);
    NSLog(@"%@\n",[s getScrambleOfType: @"3x3"]);
    NSLog(@"%@\n",[s getScrambleOfType: @"3x3"]);

  

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
