//
//  SettingsViewController.m
//  Hours
//
//  Created by Deni Bacic on 9. 02. 13.
//  Copyright (c) 2013 Deni Bacic. All rights reserved.
//

#import "SettingsViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

#define kPickerAnimationDuration 0.40

@interface SettingsViewController ()

@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation SettingsViewController
@synthesize hourRateTextField, cellStarts, cellEnds, cellVersion, delegate, calendarName, startDate, endDate, hourRate, calendarList, calendarPickerView, cellCalendar;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    // close keyboard when table clicked
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    
    // format the date
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // define first day of the month and today's date
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    [comp setDay:1];
    
    firstDayDate = [calendar dateFromComponents:comp];
    todayDate = [NSDate date];

    // Fill cell texts
    self.cellCalendar.detailTextLabel.text = calendarName;
    self.hourRateTextField.text = [NSString stringWithFormat:@"%.2f",hourRate];
    self.cellStarts.detailTextLabel.text = [self.dateFormatter stringFromDate:startDate];
    self.cellEnds.detailTextLabel.text = [self.dateFormatter stringFromDate:endDate];
    self.cellVersion.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    

    
//    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dark"]]];

    
    
    // set calendar picker value to appropriate calendar
    NSInteger calIndex =0;
    NSInteger i = 0;
    
    for (EKCalendar *calendar in calendarList) {
        if ([calendar.title isEqualToString:calendarName]) {
            calIndex = i;
        }
        i++;
    }
    
    [self.calendarPickerView selectRow:calIndex inComponent:0 animated:NO];
    

}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return calendarList.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    EKCalendar *cal = [calendarList objectAtIndex:row];
    return cal.title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    EKCalendar *cal = [calendarList objectAtIndex:row];
    calendarName = cal.title;
    UITableViewCell *targetCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    targetCell.detailTextLabel.text = calendarName;

}



- (void) hideKeyboard {
    
    //[self.calendarTextField resignFirstResponder];
    [self.hourRateTextField resignFirstResponder];

    
    if (self.datePickerView.superview != nil) {
        CGRect pickerFrame = self.datePickerView.frame;
        pickerFrame.origin.y = self.view.frame.size.height;
    
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kPickerAnimationDuration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
        self.datePickerView.frame = pickerFrame;
        [UIView commitAnimations];
	
        // deselect the current table row
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if (self.calendarPickerView.superview != nil) {
        CGRect pickerFrame = self.calendarPickerView.frame;
        pickerFrame.origin.y = self.view.frame.size.height;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kPickerAnimationDuration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(slidePickerDownDidStop)];
        self.calendarPickerView.frame = pickerFrame;
        [UIView commitAnimations];
        
        // deselect the current table row
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (([targetCell.textLabel.text isEqualToString:@"Starts"]) || ([targetCell.textLabel.text isEqualToString:@"Ends"])) {
        self.datePickerView.date = [self.dateFormatter dateFromString:targetCell.detailTextLabel.text];
	
        // the date picker might already be showing, so don't add it to our view
        if (self.datePickerView.superview == nil)
        {
            CGRect startFrame = self.datePickerView.frame;
            CGRect endFrame = self.datePickerView.frame;
        
            // the start position is below the bottom of the visible frame
            startFrame.origin.y = self.view.frame.size.height;
        
            // the end position is slid up by the height of the view
            endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
        
            self.datePickerView.frame = startFrame;
        
            [self.view addSubview:self.datePickerView];
            
            self.datePickerView.backgroundColor = [UIColor whiteColor];
        
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:kPickerAnimationDuration];
            self.datePickerView.frame = endFrame;
            [UIView commitAnimations];
        }
    }
    if ([targetCell.textLabel.text isEqualToString:@"Current Month"]) {
        self.cellStarts.detailTextLabel.text = [self.dateFormatter stringFromDate:firstDayDate];
        self.cellEnds.detailTextLabel.text = [self.dateFormatter stringFromDate:todayDate];
        startDate = firstDayDate;
        endDate = todayDate;
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (targetCell == [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]) {

        
        if (self.calendarPickerView.superview == nil)
        {
            CGRect startFrame = self.calendarPickerView.frame;
            CGRect endFrame = self.calendarPickerView.frame;
            
            // the start position is below the bottom of the visible frame
            startFrame.origin.y = self.view.frame.size.height;
            
            // the end position is slid up by the height of the view
            endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
            
            self.calendarPickerView.frame = startFrame;
            
            [self.view addSubview:self.calendarPickerView];
            self.calendarPickerView.backgroundColor = [UIColor whiteColor];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:kPickerAnimationDuration];
            self.calendarPickerView.frame = endFrame;
            [UIView commitAnimations];

        }
        
    }
}



#pragma mark - Actions

- (IBAction)dateAction:(id)sender
{
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //NSLog(@"%d, %d", indexPath.row, indexPath.section);
    if ([cell.textLabel.text isEqualToString:@"Starts"]) {
        startDate = self.datePickerView.date;
    } else if ([cell.textLabel.text isEqualToString:@"Ends"]) {
        endDate = self.datePickerView.date;
    }
	cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.datePickerView.date];
}


- (void)slideDownDidStop
{
	// the date picker has finished sliding downwards, so remove it from the view hierarchy
	[self.datePickerView removeFromSuperview];
}

- (void)slidePickerDownDidStop
{
	// the date picker has finished sliding downwards, so remove it from the view hierarchy
	[self.calendarPickerView removeFromSuperview];
}




- (IBAction)savePressed:(UIBarButtonItem *)sender {
    
    if([delegate respondsToSelector:@selector(settingsWithCalendarName:hourRate:dateStart:dateEnd:)]) {
        if ([endDate compare:startDate] == NSOrderedDescending) {

            calendarName = self.cellCalendar.detailTextLabel.text;
            hourRate = [self.hourRateTextField.text doubleValue];
        
        
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:calendarName forKey:@"calendarName"];
            [userDefaults setDouble:hourRate forKey:@"hourPay"];
            
            [userDefaults setObject:startDate forKey:@"startDate"];
            [userDefaults setObject:endDate forKey:@"endDate"];
            
            

            //send the delegate function with the amount entered by the user
            [delegate settingsWithCalendarName:calendarName hourRate:hourRate dateStart:startDate dateEnd:endDate];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            [self performSelectorOnMainThread:@selector(alertDateError) withObject:@"Error!" waitUntilDone:YES];
        }
    }
}

- (IBAction)returnPressed:(id)sender {
    
    NSLog(@"PRESS");
    //[self.calendarTextField resignFirstResponder];
    [self.hourRateTextField resignFirstResponder];
}

-(void) alertDateError {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                    message: @"Please check selected date range!"
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
}


@end
