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
@property (weak, nonatomic) IBOutlet UIButton *StartButton;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *circle;
@property (weak, nonatomic) IBOutlet UILabel *scrambleLabel;
@property int timerCountMillis;
@property NSString *scrambleType;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSTimer *startupTimer;
@property (strong, nonatomic) scrambler *scrambleGen;
@property BOOL timerOn;
@property BOOL timerReady;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timerOn = NO;
    self.timerReady = NO;
    self.scrambleType = @"3x3";
    
    self.scrambleGen = [[scrambler alloc]init];
    [self.scrambleGen seedScramblers:@"hellowesatonpoo"];
    [self updateScramble];
    
    

    
}

-(void) updateScramble{
    NSString *newScramble = [self.scrambleGen getScrambleOfType:self.scrambleType];
    [self.scrambleLabel setText:newScramble];
    
    
}
- (IBAction)StartButtonPressed:(id)sender {
    if (self.timerOn){
        //Stop Timer
        NSLog(@"STOP TIMER!");
        [self.circle setImage:[UIImage imageNamed: @"white_circle.png"]];
        self.timerOn = NO;
        self.timerReady = NO;
        [self.TimeLabel setText:[self formatMilliseconds:self.timerCountMillis]];
        self.timerCountMillis = 0;
        [self.timer invalidate];
        [self updateScramble];
    }else{
        [self.circle setImage:[UIImage imageNamed: @"red_circle.png"]];
        self.startupTimer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(setTimerReady)userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer: self.startupTimer forMode: NSDefaultRunLoopMode];
        
    }
}

- (void) setTimerReady{
    NSLog(@"TIMER READY!");
    [self.circle setImage:[UIImage imageNamed:@"green_circle"]];
    self.timerReady = YES;
}

- (void) updateTimerDisplay{
    self.timerCountMillis += 1;
    if (self.timerCountMillis % 37 == 0){
        [self.TimeLabel setText:[self formatMilliseconds:self.timerCountMillis]];
    }

    
    
    
}
- (IBAction)StartButtonReleased:(id)sender {
    if (self.timerReady){
        //Start Timer
        NSLog(@"START TIMER!");
        self.timerOn = YES;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateTimerDisplay )userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer: self.timer forMode: NSDefaultRunLoopMode];
    }else{
        [self.startupTimer invalidate];
        [self.circle setImage:[UIImage imageNamed:@"white_circle"]];
    }
}


- (NSString *)formatMilliseconds:(int)milliseconds{
    int millis = milliseconds % 1000;
    NSMutableString *millisStr = [NSMutableString stringWithFormat:@"%d",millis];
    if (millis < 10){
        [millisStr insertString:@"0" atIndex:0];
    }
    if (millis < 100){
        [millisStr insertString:@"0" atIndex:0];
    }
    int seconds = (milliseconds / 1000) % 60;
    NSMutableString *secondsStr = [NSMutableString stringWithFormat:@"%d",seconds];
    int minutes = (milliseconds / 1000) / 60;
    NSString *time;
    if (minutes > 0){
        time = [NSString stringWithFormat:@"%d:%d.%@",minutes, seconds, millisStr];
    }else{
        time = [NSString stringWithFormat:@"%@.%@", secondsStr, millisStr];
    }
    return time;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
