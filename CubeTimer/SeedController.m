//
//  SeedController.m
//  CubeTimer
//
//  Created by Weston Mizumoto on 8/14/16.
//  Copyright © 2016 Weston Mizumoto. All rights reserved.
//

#import "SeedController.h"
@interface SeedController ()

@property (weak, nonatomic) IBOutlet UITextField *SeedText;
@property BOOL changed;
@end
@implementation SeedController


- (void) viewDidAppear:(BOOL)animated{
    self.changed = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.SeedText setText:[defaults objectForKey:@"seedValue"]];
    
    
}
- (IBAction)buttonPressed:(id)sender {
    //If seed text is blank, do nothing
    //Else
    if ([[self.SeedText text] length] == 0 ){
        return;
    }
    
    NSString *newSeed = [self.SeedText text];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:newSeed forKey:@"seedValue"];
    [defaults setBool:YES forKey:@"reseed"];
    if (self.changed){
        [defaults synchronize];
    }
    [self.SeedText resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)editingEnded:(id)sender {
    self.changed = YES;
}
@end
