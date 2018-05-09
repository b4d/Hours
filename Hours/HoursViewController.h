//
//  HoursViewController.h
//  Hours
//
//  Created by Deni Bacic on 8. 02. 13.
//  Copyright (c) 2013 Deni Bacic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>


@interface HoursViewController : UIViewController <SettingsEnteredDelegate> {
    
    Boolean currentPeriodDisplayed;
    
    double threadHours;
    double threadCash;
    double threadAvg;
    double threadMax;
    double threadMin;
    
    double threadOldHours;
    double threadOldCash;
    double threadOldAvg;
    double threadOldMax;
    double threadOldMin;
    
    UIColor *colorRed;
    UIColor *colorGreen;
    UIColor *colorLightBlue;
    
    
    NSDate *start;
    NSDate *end;
    
    NSString *calName;
    
    double pay;
    
    NSArray *calendarList;
    
}

@property (strong, nonatomic) NSArray *calendarList;
@property (strong, nonatomic) EKEventStore *store;

@property (weak, nonatomic) IBOutlet UILabel *labelHours;
@property (weak, nonatomic) IBOutlet UILabel *labelCash;
@property (weak, nonatomic) IBOutlet UILabel *labelHoursText;
@property (weak, nonatomic) IBOutlet UILabel *labelCashText;
@property (weak, nonatomic) IBOutlet UILabel *labelMax;
@property (weak, nonatomic) IBOutlet UILabel *labelMin;
@property (weak, nonatomic) IBOutlet UILabel *labelAvg;


- (IBAction)shareButton:(UIBarButtonItem *)sender;
- (IBAction)screenTapped:(UITapGestureRecognizer *)sender;



@end
