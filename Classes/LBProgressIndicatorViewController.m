//
//  ProgressIndicatorViewController.m
//  ProgressIndicator
//
//  Created by Girish Sawargi on 18/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LBProgressIndicatorViewController.h"

@implementation LBProgressIndicatorViewController


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	progressBar = [[LBProgressBar alloc] initWithFrame:CGRectMake(10.0f, 100.0f, 300.0f, 20.0f)];
	progressBar.progress = 0.5;
	[self.view addSubview:progressBar];
	[progressBar release];
}

- (IBAction)slider:(UISlider*)slider {
	progressBar.progress = slider.value;
}

- (IBAction)toggleAnimation:(UIButton*)sender {
	[progressBar isAnimating] ? [progressBar stopAnimation] : [progressBar startAnimation];
	sender.selected = !sender.selected;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
