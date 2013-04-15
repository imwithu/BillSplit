//
//  SettingViewController.m
//  BillSplit
//
//  Created by James Yu on 4/13/13.
//  Copyright (c) 2013 James Yu. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingsResult.h"

@interface SettingViewController ()
@property (strong, nonatomic) IBOutlet UILabel *taxRateLabel;
@property (strong, nonatomic) IBOutlet UISlider *taxRateSlider;
@property (strong, nonatomic) IBOutlet UILabel *tipRateLabel;
@property (strong, nonatomic) IBOutlet UISlider *tipRateFromSlider;
@property (strong, nonatomic) IBOutlet UISlider *tipRateToSlider;
@property (strong, nonatomic) IBOutlet UILabel *personsLabel;
@property (strong, nonatomic) IBOutlet UISlider *personsSlider;
@property (strong, nonatomic) IBOutlet UISwitch *taxRateSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *tipRateSwitch;

@property (strong, nonatomic) SettingsResult *settings;

@end

@implementation SettingViewController


- (SettingsResult *)settings
{
    if (!_settings) {
        _settings = [[SettingsResult alloc] init];
    }
    return _settings;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.settings = [SettingsResult giveMeTheSettings];
    if (self.settings.taxRate == 0) {
        [self.taxRateSwitch setOn:NO];
        [self.taxRateSlider setEnabled:NO];
    } else {
        [self.taxRateSwitch setOn:YES];
        [self.taxRateSlider setEnabled:YES];
    }
    if (self.settings.tipRateTo == 0) {
        [self.tipRateSwitch setOn:NO];
        [self.tipRateFromSlider setEnabled:NO];
        [self.tipRateToSlider setEnabled:NO];
    } else {
        [self.tipRateSwitch setOn:YES];
        [self.tipRateFromSlider setEnabled:YES];
        [self.tipRateToSlider setEnabled:YES];
    }
    
    [self updateUI];
}

- (void)updateUI
{
    self.taxRateLabel.text = [NSString stringWithFormat:@"%d.%02d%%",self.settings.taxRate/100, self.settings.taxRate%100];
    self.taxRateSlider.value = self.settings.taxRate;
    self.tipRateLabel.text = [NSString stringWithFormat:@"%d%% - %d%%",self.settings.tipRateFrom/100, self.settings.tipRateTo/100];
    self.tipRateFromSlider.value = self.settings.tipRateFrom;
    self.tipRateToSlider.value = self.settings.tipRateTo;
    self.personsLabel.text = [NSString stringWithFormat:@"%d人", self.settings.persons];
    self.personsSlider.value = self.settings.persons;
}


- (IBAction)taxRateChanged:(UISlider *)sender {
    int taxRate = sender.value;
    taxRate = taxRate-taxRate%25;
    self.settings.taxRate = taxRate;
    [self updateUI];
}

- (IBAction)tipRateFromChanged:(UISlider *)sender {
    int tipRateFrom = sender.value;
    if (tipRateFrom < 0) {
        tipRateFrom = 0;
    }else if (tipRateFrom > 4500) {
        tipRateFrom = 4500;
    }
    
    tipRateFrom = tipRateFrom - tipRateFrom%100;
    if (self.tipRateToSlider.value < tipRateFrom+500) {
        self.tipRateToSlider.value = tipRateFrom+500;
        self.settings.tipRateTo = tipRateFrom+500;
    }
    self.settings.tipRateFrom = tipRateFrom;
    [self updateUI];
}

- (IBAction)tipRateToChanged:(UISlider *)sender {
    int tipRateTo = sender.value;
    if (tipRateTo < 500) {
        tipRateTo = 500;
    } else if (tipRateTo > 5000) {
        tipRateTo = 5000;
    }
        
    tipRateTo = tipRateTo - tipRateTo%100;
    if (self.tipRateFromSlider.value > tipRateTo-500) {
        self.tipRateFromSlider.value = tipRateTo-500;
        self.settings.tipRateFrom = tipRateTo-500;
    }
    self.settings.tipRateTo = tipRateTo;
    [self updateUI];
}

- (IBAction)personsChanged:(UISlider *)sender {
    if (sender.value < 2) {
        sender.value = 2;
    }
    self.settings.persons = sender.value;
    [self updateUI];
}

#define DEFAULT_TAX_RATE 875
#define DEFAULT_TIP_RATE_FROM 1000
#define DEFAULT_TIP_RATE_TO 2000

- (IBAction)taxSwitchChanged:(UISwitch *)sender {
    if ([sender isOn]) {
        self.settings.taxRate = DEFAULT_TAX_RATE;
        [self.taxRateSlider setEnabled:YES];
    } else {
        self.settings.taxRate = 0;
        [self.taxRateSlider setEnabled:NO];

    }
    [self updateUI];
}

- (IBAction)tipSwitchChanged:(UISwitch *)sender {
    if ([sender isOn]) {
        self.settings.tipRateFrom = DEFAULT_TIP_RATE_FROM;
        self.settings.tipRateTo = DEFAULT_TIP_RATE_TO;
        [self.tipRateFromSlider setEnabled:YES];
        [self.tipRateToSlider setEnabled:YES];
    } else {
        self.settings.tipRateFrom = 0;
        self.settings.tipRateTo = 0;
        [self.tipRateFromSlider setEnabled:NO];
        [self.tipRateToSlider setEnabled:NO];
    }
    [self updateUI];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
