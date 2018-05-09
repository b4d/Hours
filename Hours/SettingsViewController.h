//
//  SettingsViewController.h
//  Hours
//
//  Created by Deni Bacic on 9. 02. 13.
//  Copyright (c) 2013 Deni Bacic. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SettingsEnteredDelegate <NSObject>

-(void)settingsWithCalendarName:(NSString *)calendarName hourRate:(double)hourRate dateStart:(NSDate*)dateStart dateEnd:(NSDate *)dateEnd;

@end



@interface SettingsViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource> {

    NSDate *todayDate;
    NSDate *firstDayDate;

    double hourRate;
    
    NSArray *calendarList;
    
    UIPickerView *calendarPickerView;

@private
    __unsafe_unretained id<SettingsEnteredDelegate> delegate;
    
    
}

@property (weak, nonatomic) IBOutlet UITextField *hourRateTextField;

@property (weak, nonatomic) IBOutlet UITableViewCell *cellStarts;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellEnds;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellVersion;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellCalendar;


@property (nonatomic, retain) NSString *calendarName;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic) double hourRate;
@property (nonatomic, retain) NSArray *calendarList;

@property (retain, nonatomic) IBOutlet UIPickerView *calendarPickerView;

- (IBAction)savePressed:(UIBarButtonItem *)sender;

- (IBAction)returnPressed:(id)sender;

@property(nonatomic, assign)id <SettingsEnteredDelegate> delegate;

@end
