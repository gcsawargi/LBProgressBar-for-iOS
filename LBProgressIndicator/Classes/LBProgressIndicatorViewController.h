//
//  ProgressIndicatorViewController.h
//  ProgressIndicator
//
//  Created by Girish Sawargi on 18/06/11.
//  Copyright 2011 __MyCompanyName__. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBProgressBar.h"
@interface LBProgressIndicatorViewController : UIViewController {
	LBProgressBar* progressBar;
}

- (IBAction)slider:(UISlider*)slider;
- (IBAction)toggleAnimation:(id)sender;

@end

