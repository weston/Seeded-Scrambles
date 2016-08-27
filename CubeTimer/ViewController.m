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
@property (weak, nonatomic) IBOutlet UILabel *seedLabel;
@property (weak, nonatomic) IBOutlet UITextView *TimeList;
@property (weak, nonatomic) IBOutlet UILabel *avg5label;
@property (weak, nonatomic) IBOutlet UILabel *avg12label;
@property (weak, nonatomic) IBOutlet UILabel *NumSolvesLabel;
@property (weak, nonatomic) IBOutlet UIButton *DeleteButton;
@property (weak, nonatomic) IBOutlet UIButton *ResetButton;
@property int timerCountMillis;
@property NSString *scrambleType;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSTimer *startupTimer;
@property (strong, nonatomic) NSTimer *deleteTimer;
@property (strong, nonatomic) NSTimer *resetTimer;
@property (strong, nonatomic) scrambler *scrambleGen;
@property (strong, nonatomic) NSMutableArray *times;
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    self.times = [[NSMutableArray alloc]init];
    NSLog(@"View did load\n");
}


- (void) viewDidAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *seed = [defaults objectForKey:@"seedValue"];
    if ([defaults boolForKey:@"reseed"]){
        [self.scrambleGen seedScramblers:seed];
        [self updateScramble];
        [defaults setBool:NO forKey:@"reseed"];
        [defaults synchronize];
    }
    [self.seedLabel setText:seed];
    
}
- (void) updateScramble{
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
        [self addTime:self.timerCountMillis];
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
    self.timerCountMillis += 3;
    if (self.timerCountMillis % 23 == 0){
        [self.TimeLabel setText:[self formatMilliseconds:self.timerCountMillis]];
    }

    
    
    
}
- (IBAction)StartButtonReleased:(id)sender {
    if (self.timerReady){
        //Start Timer
        NSLog(@"START TIMER!");
        self.timerOn = YES;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.003 target:self selector:@selector(updateTimerDisplay )userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer: self.timer forMode: NSDefaultRunLoopMode];
    }else{
        [self.startupTimer invalidate];
        [self.circle setImage:[UIImage imageNamed:@"white_circle"]];
    }
}


- (void) addTime: (int) timeMillis{
    NSNumber *num = [NSNumber numberWithInt:timeMillis];
    [self.times addObject:num];
    [self updateDisplays];
}

- (NSString *) computeAverageOf: (int) numSolves{
    if ([self.times count] < numSolves || numSolves < 3){
        return @"--";
    }
    int min = INT_MAX;
    int max = INT_MIN;
    int total = 0;
    for(int i = (int)[self.times count] - numSolves; i < [self.times count]; i++){
        NSNumber *c = [self.times objectAtIndex:i];
        int current = (int)[c integerValue];
        total += current;
        if (current < min){
            min = current;
        }
        if (current > max){
            max = current;
        }
    }
    return [self formatMilliseconds:(total - (max + min))/(numSolves - 2)];
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

-(void) updateDisplays{
    [self.avg5label setText:[self computeAverageOf:5]];
    [self.avg12label setText:[self computeAverageOf:12]];
    [self.NumSolvesLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)[self.times count]]];
    
    NSMutableString *list = [NSMutableString stringWithString:@""];
    for (int i = 0; i < [self.times count]; i++){
        if (i > 0){
            [list appendString:@", "];
        }
        int num = (int)[[self.times objectAtIndex:i] integerValue];
        [list appendString: [self formatMilliseconds:num]];
    }
    [self.TimeList setText: list];
}

- (IBAction)resetPressed:(id)sender {
    if (self.timerOn){
        return;
    }
    
    if ([[self.ResetButton currentTitle] isEqualToString:@"Reset"]){
        [self.ResetButton setTitle:@"Sure?" forState:UIControlStateNormal];
        self.resetTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(revertResetButton )userInfo:nil repeats:NO];
        return;
    }
    [self.resetTimer invalidate];
    self.times = [[NSMutableArray alloc]init];
    [self.TimeLabel setText:@"0.000"];
    [self updateDisplays];
    [self updateScramble];
    [self.ResetButton setTitle:@"Reset" forState:UIControlStateNormal];
    
}

- (void) revertResetButton{
    [self.ResetButton setTitle:@"Reset" forState:UIControlStateNormal];
}
- (void) revertDeleteButton{
    [self.ResetButton setTitle:@"Delete" forState:UIControlStateNormal];
}
- (IBAction)deleteLastPressed:(id)sender {
    if (self.timerOn){
        return;
    }
    if ([self.times count] == 0){
        return;
    }
    if ([[self.DeleteButton currentTitle]isEqualToString:@"Delete"]){
        [self.DeleteButton setTitle:@"Sure?" forState:UIControlStateNormal];
        self.deleteTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(revertDeleteButton )userInfo:nil repeats:NO];
        return;
    }
    [self.deleteTimer invalidate];
    [self.times removeLastObject];
    [self.DeleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [self updateDisplays];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
