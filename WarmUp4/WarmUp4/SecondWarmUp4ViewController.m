//
//  SecondWarmUp4ViewController.m
//  WarmUp4
//
//  Created by Wenhao Cen on 2/19/13.
//  Copyright (c) 2013 Wenhao Cen. All rights reserved.
//

#import "SecondWarmUp4ViewController.h"

@interface SecondWarmUp4ViewController ()

@end

@implementation SecondWarmUp4ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Logout:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
