//
//  SettingsResult.h
//  BillSplit
//
//  Created by James Yu on 4/13/13.
//  Copyright (c) 2013 James Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsResult : NSObject
@property (nonatomic) int taxRate;
@property (nonatomic) int tipRateFrom;
@property (nonatomic) int tipRateTo;
@property (nonatomic) int persons;

+ (SettingsResult *)giveMeTheSettings;

@end
