//
//  HoursViewController.m
//  Hours
//
//  Created by Deni Bacic on 8. 02. 13.
//  Copyright (c) 2013 Deni Bacic. All rights reserved.
//


#import "HoursViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface HoursViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

-(void)showActivityViewController;
//-(void)showActionSheet;

@end

@implementation HoursViewController

@synthesize labelCash, labelHours, labelCashText, labelHoursText, labelAvg, labelMax, labelMin, calendarList, store;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
 
    
    
    
    
    colorLightBlue = [UIColor colorWithRed:45/255.0f
                                     green:168/255.0f
                                      blue:255/255.0f
                                     alpha:1.0f];
    colorGreen = [UIColor colorWithRed:102/255.0f
                                 green:204/255.0f
                                  blue:102/255.0f
                                 alpha:1.0f];
    colorRed = [UIColor colorWithRed:255/255.0f
                               green:102/255.0f
                                blue:102/255.0f
                               alpha:1.0f];
    

    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:colorLightBlue];
    
    
    calendarList = [[NSArray alloc] init];
    store = [[EKEventStore alloc] init];
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light"]];
    
    currentPeriodDisplayed = YES;
    
    // format the date
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];

    [self readSettings];
    
    
    [self refreshLabelsForCalendar:calName withHourPay:pay startDate:start endDate:end];
    


}

-(void)readSettings {
    // Read settings
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    calName = [userDefaults stringForKey:@"calendarName"];
    pay = [userDefaults doubleForKey:@"hourPay"];
    start = [userDefaults objectForKey:@"startDate"];
    end = [userDefaults objectForKey:@"endDate"];
    
    
    if (calName == NULL) {
        [userDefaults setObject:@"Birthdays" forKey:@"calendarName"];
        [userDefaults setDouble:5.0f forKey:@"hourPay"];
        
        calName = [userDefaults stringForKey:@"calendarName"];
        pay = [userDefaults doubleForKey:@"hourPay"];
        
        
        
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
        [comp setDay:1];
        
        [userDefaults setObject:[calendar dateFromComponents:comp] forKey:@"startDate"];
        [userDefaults setObject:[NSDate date] forKey:@"endDate"];
        
    }
    
    calName = [userDefaults stringForKey:@"calendarName"];
    pay = [userDefaults doubleForKey:@"hourPay"];
    start = [userDefaults objectForKey:@"startDate"];
    end = [userDefaults objectForKey:@"endDate"];
}


-(void)updateLabels {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    
    
    if (currentPeriodDisplayed) {
        labelHours.text = [NSString stringWithFormat:@"%.1f h", threadHours];
        labelCash.text = [formatter stringFromNumber:[NSNumber numberWithDouble:threadCash]];
        labelMin.text = [NSString stringWithFormat:@"%.1f h", threadMin];
        labelMax.text = [NSString stringWithFormat:@"%.1f h", threadMax];
        labelAvg.text = [NSString stringWithFormat:@"%.1f h", threadAvg];
        
        labelHoursText.text = [NSString stringWithFormat:@"From %@ to %@, you have accumulated:", [self.dateFormatter stringFromDate:start], [self.dateFormatter stringFromDate:end]];
        
        labelCashText.text = @"That earns you:";
        
        labelHours.textColor = colorLightBlue;
        labelCash.textColor = colorLightBlue;
        labelMin.textColor = colorLightBlue;
        labelMax.textColor = colorLightBlue;
        labelAvg.textColor = colorLightBlue;
        
    
    } else {
        
        labelHoursText.text = @"Difference with one month in the past:";
        
        
        if (threadOldHours >= 0) {
            labelCash.textColor = colorGreen;
            labelHours.textColor = colorGreen;
            labelCash.text = [@"+" stringByAppendingString:[formatter stringFromNumber:[NSNumber numberWithDouble:threadOldCash]]];
            labelHours.text = [NSString stringWithFormat:@"+%.1f h",  threadOldHours];
        } else {
            labelCash.textColor = colorRed;
            labelHours.textColor = colorRed;
            labelCash.text = [formatter stringFromNumber:[NSNumber numberWithDouble:threadOldCash]]; //threadOldCash je ok vrednost, formatter ga svira
            
            
            labelHours.text = [NSString stringWithFormat:@"%.1f h",  threadOldHours];
            NSLog(@"%f", threadOldCash);
            NSLog(@"%@", labelCash.text);
        }
        
        if (threadOldMin >= 0.0f) {
            labelMin.textColor = colorGreen;
            labelMin.text = [NSString stringWithFormat:@"+%.1f h", threadOldMin];
        } else {
            labelMin.textColor = colorRed;
            labelMin.text = [NSString stringWithFormat:@"%.1f h", threadOldMin];
        }
        
        if (threadOldMax >= 0) {
            labelMax.textColor = colorGreen;
            labelMax.text = [NSString stringWithFormat:@"+%.1f h", threadOldMax];
        } else {
            labelMax.textColor = colorRed;
            labelMax.text = [NSString stringWithFormat:@"%.1f h", threadOldMax];
        }
        
        if (threadOldAvg >= 0) {
            labelAvg.textColor = colorGreen;
            labelAvg.text = [NSString stringWithFormat:@"+%.1f h", threadOldAvg];
        } else {
            labelAvg.textColor = colorRed;
            labelAvg.text = [NSString stringWithFormat:@"%.1f h", threadOldAvg];
        }
        
    }
    


    
    

    
}

-(void)refreshLabelsForCalendar:(NSString *)calendarName withHourPay:(int)hourPay startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    
    //EKEventStore *store = [[EKEventStore alloc] init];
    
    /* iOS 6 requires the user grant your application access to the Event Stores */
    if ([store respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        /* iOS Settings > Privacy > Calendars > MY APP > ENABLE | DISABLE */
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
         {
             if ( granted )
             {
                 NSLog(@"User has granted permission!");
                 // List all calendars by name
                 calendarList = [store calendarsForEntityType:EKEntityTypeEvent];
                               
                 NSArray * calendarForSearching;
                                  
                 for (EKCalendar *calendar in calendarList) {
                     if ([calendar.title isEqualToString:calendarName]) {
                         calendarForSearching = [[NSArray alloc] initWithObjects:calendar,nil];
                     }                     
                 }
                 
                 
                 // Create the predicate from the event store's instance method
                 NSPredicate *predicate = [store predicateForEventsWithStartDate:startDate
                                                                         endDate:endDate 
                                                                       calendars:calendarForSearching];
                 
                 // [endDate dateByAddingTimeInterval:60*60*24*1] adds a day
                 
                 // Fetch all events that match the predicate
                 NSArray *events = [store eventsMatchingPredicate:predicate];
                 
                 NSTimeInterval theTimeInterval = 0;
                 NSTimeInterval eventLength = 0;
                 int numberOfEvents = 0;
                 NSTimeInterval max = 0;
                 NSTimeInterval min = 0;
                 
                 for(EKEvent *event in events) {
                     if ([event.calendar.title isEqualToString:calendarName]) {
                         
                         eventLength = [event.endDate timeIntervalSinceDate:event.startDate];
                         theTimeInterval += eventLength;
                         
                         numberOfEvents++;
                         
                         if (eventLength > max)
                             max = eventLength;
                         
                         if (min == 0)
                             min = eventLength;
                         
                         if (eventLength < min)
                             min = eventLength;
                     }
                 }
                 

                 
                 double hours = (theTimeInterval/60)/60;
                 double payment = ((theTimeInterval/60)/60)*hourPay;
                 
                 threadHours = hours;

                 threadAvg = (hours/numberOfEvents);
                 threadMax = (max/60)/60;
                 threadMin = (min/60)/60;
                 
                 //NSLog(@"%@", @"test");
                 

                 threadCash = payment;
                 
                 
//////////////// Za prejsnji mesec brute force, potrebno dodelave
                 


                 NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                 NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                 [offsetComponents setMonth:-1]; // note that I'm setting it to -1
                 NSDate *startOldDate = [gregorian dateByAddingComponents:offsetComponents toDate:startDate options:0];
                 NSDate *endOldDate = [gregorian dateByAddingComponents:offsetComponents toDate:endDate options:0];
                 //NSLog(@"%@ %@", startOldDate, endOldDate);
                 
                 
  
                 predicate = [store predicateForEventsWithStartDate:startOldDate
                                                            endDate:endOldDate
                                                          calendars:calendarForSearching];
                 
                 
                 // Fetch all events that match the predicate
                 events = [store eventsMatchingPredicate:predicate];
                 
                 NSTimeInterval theTimeIntervalOld = 0;
                 NSTimeInterval eventLengthOld = 0;
                 int numberOfEventsOld = 0;
                 NSTimeInterval maxOld = 0;
                 NSTimeInterval minOld = 0;
                 
                 for(EKEvent *event in events) {
                     if ([event.calendar.title isEqualToString:calendarName]) {
                         
                         eventLengthOld = [event.endDate timeIntervalSinceDate:event.startDate];
                         theTimeIntervalOld += eventLengthOld;
                         
                         numberOfEventsOld++;
                         
                         if (eventLengthOld > maxOld)
                             maxOld = eventLengthOld;
                         
                         if (minOld == 0)
                             minOld = eventLengthOld;
                         
                         if (eventLengthOld < minOld)
                             minOld = eventLengthOld;
                     }
                 }
                 
                 
                 
                 double hoursOld = (theTimeIntervalOld/60)/60;
                 double paymentOld = ((theTimeIntervalOld/60)/60)*hourPay;
                 
                 threadOldHours = (hours-hoursOld);

                 threadOldAvg = ((hours/numberOfEvents)-(hoursOld/numberOfEventsOld));
                 threadOldMax = ((max/60)/60 - (maxOld/60)/60);
                 threadOldMin = ((min/60)/60 - (minOld/60)/60);
                 
                 //NSLog(@"%@", @"test");
                
                 threadOldCash = (payment-paymentOld);
                 
////////
                 
                 
                 
                 [self performSelectorOnMainThread:@selector(updateLabels)
                                        withObject:nil
                                     waitUntilDone:NO];         
             }
             else
             {
                 NSLog(@"User has not granted permission!");
                 [self performSelectorOnMainThread:@selector(alertPermissionError) withObject:@"Error!" waitUntilDone:YES];
             }
         }];
    }

    
}

-(void) alertPermissionError {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                    message: @"Please grant permission to access Calendar to Hours app!"
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

-(void)settingsWithCalendarName:(NSString *)calendarName hourRate:(double)hourRate dateStart:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd{
    
    start = dateStart;
    end = dateEnd;
    calName = calendarName;
    pay = hourRate;

    [self refreshLabelsForCalendar:calName withHourPay:pay startDate:start endDate:end];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Check the segue identifier
    if ([[segue identifier] isEqualToString:@"segueSettings"])
    {
        [[segue destinationViewController] setDelegate:self];
        
        SettingsViewController *settingsView = [segue destinationViewController];
        settingsView.calendarName = calName;
        settingsView.hourRate = pay;
        settingsView.startDate = start;
        settingsView.endDate = end;
        settingsView.calendarList = calendarList;

        
    }
}



- (IBAction)shareButton:(UIBarButtonItem *)sender {
    if(NSClassFromString(@"UIActivityViewController")!=nil){
        [self showActivityViewController];
    }else {
        NSLog(@"ios < 6.0");
    }
}

- (IBAction)screenTapped:(UITapGestureRecognizer *)sender {
    
    if (currentPeriodDisplayed)
        currentPeriodDisplayed = NO;
    else
        currentPeriodDisplayed = YES;
    
    [self updateLabels];
    
}


-(void)showActivityViewController
{
    //-- set up the data objects
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    
    
    NSString *textObject = [NSString stringWithFormat:@"With Hours Calculator app I have counted %@ and %@! https://itunes.apple.com/si/app/hours-calculator/id602098320?mt=8",
                            [NSString stringWithFormat:@"%.1f h", threadHours],
                            [formatter stringFromNumber:[NSNumber numberWithDouble:threadCash]]];
    //NSURL *url = [NSURL URLWithString:@"http://www.absoluteripple.com"];
    //UIImage *image = [UIImage imageNamed:@"hour114.png"];
    //NSArray *activityItems = [NSArray arrayWithObjects:textObject, url, image, nil];
    NSArray *activityItems = [NSArray arrayWithObjects:textObject, nil];
    
    //-- initialising the activity view controller
    UIActivityViewController *avc = [[UIActivityViewController alloc]
                                     initWithActivityItems:activityItems
                                     applicationActivities:nil];
    
    //-- define the activity view completion handler
    avc.completionHandler = ^(NSString *activityType, BOOL completed){
        NSLog(@"Activity Type selected: %@", activityType);
        if (completed) {
            NSLog(@"Selected activity was performed.");
        } else {
            if (activityType == NULL) {
                NSLog(@"User dismissed the view controller without making a selection.");
            } else {
                NSLog(@"Activity was not performed.");
            }
        }
    };
    
    //-- define activity to be excluded (if any)
    avc.excludedActivityTypes = [NSArray arrayWithObjects:UIActivityTypeAssignToContact, nil];
    
    //-- show the activity view controller
    [self presentViewController:avc
                       animated:YES completion:nil];
    
}
@end
