//
//  HoursAppDelegate.h
//  Hours
//
//  Created by Deni Bacic on 8. 02. 13.
//  Copyright (c) 2013 Deni Bacic. All rights reserved.
//

/*
 
 TODO:
    - Picker expansion
    - Title color to white
    - Status bar color to white
 
 Version 1.1:
    - iOS 7 SDK
    - Redesign with iOS 7 in mind
    -
 
 Version 1.0.4:
    - Tap on the main view displays comparison with current period minus one month
 
 Version 1.0.3:
    - Calendar picker now displays selected calendar when opened
    - Changed splash image, to improve user experience
 
 
 Version 1.0.2:
    - Added average, maximum and minimum hours per day
    - Added sharing option
 
 
 Version 1.0.1:
    - Settings: check if dates are set right
    - Settings: improved visualization
    - Settings: Added slot machine picker to select calendar from available calendars
    - Optimization of the code
 
 
 Ideas:
    - side menu bar for settings with slide support
    - period selection
 
 */

#import <UIKit/UIKit.h>

@interface HoursAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
