//
//  BSViewController.m
//  BillSplit
//
//  Created by James Yu on 4/12/13.
//  Copyright (c) 2013 James Yu. All rights reserved.
//

#import "BSViewController.h"
#import "SettingsResult.h"

@interface BSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *billText;
@property (weak, nonatomic) IBOutlet UILabel *taxText;
@property (weak, nonatomic) IBOutlet UILabel *tipText;
@property (weak, nonatomic) IBOutlet UILabel *totalText;
@property (weak, nonatomic) IBOutlet UILabel *avgText;
@property (weak, nonatomic) IBOutlet UILabel *taxRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *personsLabel;
@property (weak, nonatomic) IBOutlet UILabel *Infor;

@property (nonatomic) int billNumber;
@property (nonatomic) int taxNumber;
@property (nonatomic) int tipNumber;
@property (nonatomic) int totalNumber;
@property (nonatomic) int avgNumber;

@property (strong,nonatomic) SettingsResult *settings;

@end

@implementation BSViewController

- (SettingsResult *)settings
{
    if (!_settings) {
        _settings = [[SettingsResult alloc] init];
    }
    return _settings;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.settings = [SettingsResult giveMeTheSettings];
    [self updateNumbers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLabelText:(UILabel *)label number:(int)number
{
    if (number < 0) {
        number = 0;
    }
    label.text = [NSString stringWithFormat:@"%d.%02d",number/100, number%100];
}


- (void)setBillText:(UILabel *)billText
{
    _billText = billText;
    [self setLabelText:billText number:self.billNumber];
}

- (void)setTaxText:(UILabel *)taxText
{
    _taxText = taxText;
    [self setLabelText:taxText number:self.taxNumber];
}

- (void)setTipText:(UILabel *)tipText
{
    _tipText = tipText;
    [self setLabelText:tipText number:self.tipNumber];
}

- (void)setTotalText:(UILabel *)totalText
{
    _totalText = totalText;
    [self setLabelText:totalText number:self.totalNumber];
}

- (void)setAvgText:(UILabel *)avgText
{
    _avgText = avgText;
    [self setLabelText:avgText number:self.avgNumber];
}

- (void)setTaxRateLabel:(UILabel *)taxRateLabel
{
    _taxRateLabel = taxRateLabel;
    if (self.settings.taxRate == 0) {
        self.taxRateLabel.text = [NSString stringWithFormat:@"0%%"];
    } else {
        self.taxRateLabel.text = [NSString stringWithFormat:@"%d.%02d%%", self.settings.taxRate/100, self.settings.taxRate%100];
    }
}

- (void)setTipRateLabel:(UILabel *)tipRateLabel
{
    _tipRateLabel = tipRateLabel;
    if (self.settings.tipRateTo <= 0) {
        self.tipRateLabel.text = [NSString stringWithFormat:@"0%%"];
    } else {
        if (self.billNumber == 0) {
            self.tipRateLabel.text = [NSString stringWithFormat:@"%d%% - %d%%", self.settings.tipRateFrom/100, self.settings.tipRateTo/100];
        } else {
            int tipRate = self.tipNumber * 10000 / self.billNumber;
            self.tipRateLabel.text = [NSString stringWithFormat:@"%d.%02d%%",tipRate/100, tipRate%100];
        }
    }
}

- (void)setPersonsLabel:(UILabel *)personsLabel
{
    _personsLabel = personsLabel;
    self.personsLabel.text = [NSString stringWithFormat:@"%d人", self.settings.persons ];
}

- (void)updateUI
{
    [self setBillText:self.billText];
    [self setTaxText:self.taxText];
    [self setTipText:self.tipText];
    [self setTotalText:self.totalText];
    [self setAvgText:self.avgText];
    [self setTaxRateLabel:self.taxRateLabel];
    [self setTipRateLabel:self.tipRateLabel];
    [self setPersonsLabel:self.personsLabel];
}

- (int)getRoundNumber:(int)number1 number2:(int)number2
{
    int number = number1 * number2 / 10000;
    if ((number1*number2)%10000>=5000) {
        number += 1;
    }
    return number;
}

- (IBAction)buttonPressed:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqual: @"c"]) {
        self.billNumber = 0;
    } else if ([sender.titleLabel.text isEqual: @"<"]) {
        self.billNumber /= 10;
    } else {
        self.billNumber *= 10;
        self.billNumber += [sender.titleLabel.text integerValue];
    }
    if (self.billNumber >= 100000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Too expensive!!"
                                                        message:@"有没有搞错？这么贵！"
                                                       delegate:nil
                                              cancelButtonTitle:@"对不起我手贱~"
                                              otherButtonTitles:nil];
        [alert show];
        self.billNumber -= [sender.titleLabel.text integerValue];
        self.billNumber /= 10;
    }
    [self updateNumbers];
}

- (void)updateNumbers
{
    self.taxNumber = [self getRoundNumber:self.billNumber number2:self.settings.taxRate];
    if (self.settings.tipRateTo > 0) {
        int tipFrom = [self getRoundNumber:self.billNumber number2:self.settings.tipRateFrom];
        int tipTo = [self getRoundNumber:self.billNumber number2:self.settings.tipRateTo];
        
        for (self.tipNumber = tipFrom; self.tipNumber <= tipTo; self.tipNumber++) {
            int total = self.billNumber + self.taxNumber + self.tipNumber;
            if (total%100 == 0 && (total/100)%self.settings.persons == 0) {
                break;
            }
        }
        if (self.tipNumber > tipTo){
            self.tipNumber = tipFrom;
            self.Infor.text = [NSString stringWithFormat:@"此设置无法均分"];
        } else {
            self.Infor.text = [NSString stringWithFormat:@""];
        }
    } else {
        self.tipNumber = 0;
    }
    self.totalNumber = self.billNumber + self.taxNumber + self.tipNumber;
    if (self.settings.persons>=2) {
        self.avgNumber = self.totalNumber / self.settings.persons;
    } else {
        self.avgNumber = self.totalNumber;
    }
    [self updateUI];

}

@end
