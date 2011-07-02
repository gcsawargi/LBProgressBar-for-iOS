//
//  ProgressIndicatorAppDelegate.h
//  ProgressIndicator
//
//  Created by Girish Sawargi on 18/06/11.
//  Copyright 2011 __MyCompanyName__. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBProgressIndicatorViewController;

@interface LBProgressIndicatorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    LBProgressIndicatorViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LBProgressIndicatorViewController *viewController;

@end

