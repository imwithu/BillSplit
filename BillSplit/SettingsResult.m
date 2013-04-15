//
//  SettingsResult.m
//  BillSplit
//
//  Created by James Yu on 4/13/13.
//  Copyright (c) 2013 James Yu. All rights reserved.
//

#import "SettingsResult.h"

@interface SettingsResult()

@end

@implementation SettingsResult


- (id)init
{
    self = [super init];
    return self;
}

#define USER_SETTING_KEY @"Bill_split_user_settings"
#define TAX_RATE_KEY @"TaxRate"
#define TIP_RATE_FROM_KEY @"TipRateFrom"
#define TIP_RATE_TO_KEY @"TipRateTo"
#define PERSONS_KEY @"Persons"

+ (SettingsResult *)giveMeTheSettings
{
    id plist = [[NSUserDefaults standardUserDefaults] dictionaryForKey:USER_SETTING_KEY];
    SettingsResult *result = [[SettingsResult alloc] initFromPropertyList:plist];
    return result;
}

-(id)initFromPropertyList:(id)plist
{
    self = [self init];
    if (self) {
        if ([plist isKindOfClass:[NSDictionary class]]) {
            NSDictionary *setting = (NSDictionary *)plist;
            _taxRate = [setting[TAX_RATE_KEY] intValue];
            _tipRateFrom = [setting[TIP_RATE_FROM_KEY] intValue];
            _tipRateTo = [setting[TIP_RATE_TO_KEY] intValue];
            _persons = [setting[PERSONS_KEY] intValue];
        }
    }
    return self;
}

-(void)synchronize
{
    NSDictionary *userSetting = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:USER_SETTING_KEY] copy];
    if (!userSetting) {
        userSetting = [[NSDictionary alloc] init];
        _taxRate = 875;
        _tipRateFrom = 1000;
        _tipRateTo = 2000;
        _persons = 2;
    }
    userSetting = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:userSetting forKey:USER_SETTING_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(id)asPropertyList
{
    //NSLog(@"%d/%d/%d/%d", self.taxRate, self.tipRateFrom, self.tipRateTo, self.persons);
    return @{ TAX_RATE_KEY : @(self.taxRate), TIP_RATE_FROM_KEY : @(self.tipRateFrom), TIP_RATE_TO_KEY : @(self.tipRateTo), PERSONS_KEY : @(self.persons) };
}


-(void)setTaxRate:(int)taxRate
{
    _taxRate = taxRate;
    [self synchronize];
}

-(void)setTipRateFrom:(int)tipRateFrom
{
    _tipRateFrom = tipRateFrom;
    [self synchronize];
}

-(void)setTipRateTo:(int)tipRateTo
{
    _tipRateTo = tipRateTo;
    [self synchronize];
}

-(void)setPersons:(int)persons
{
    _persons = persons;
    [self synchronize];
}

@end
