//
//  SwitchViewController.m
//  BillSplit
//
//  Created by James Yu on 4/13/13.
//  Copyright (c) 2013 James Yu. All rights reserved.
//

#import "SwitchViewController.h"
#import "BSViewController.h"
#import "SettingViewController.h"

@interface SwitchViewController ()
@property (retain) UIViewController *billingViewController;
@property (retain) UIViewController *settingViewController;

@end

@implementation SwitchViewController

@synthesize billingViewController, settingViewController;

- (void)showBillingViewController
{
    if (settingViewController) {
        [settingViewController.view removeFromSuperview];
    }
    [self.view addSubview:billingViewController.view];
}


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
	// Do any additional setup after loading the view.
    self.billingViewController = [[BSViewController alloc] initWithNibName:@"Billing View" bundle:nil];
    [self.view insertSubview:self.billingViewController.view atIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
