//
//  LBProgressBar.h
//  LBProgressBar
//
//  Created by Laurin Brandner on 05.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBProgressBar : UIProgressView {
    double progressOffset;
    NSTimer* animator;
}

@property (readwrite, retain) NSTimer* animator;
@property (readwrite) double progressOffset;

- (BOOL)isAnimating;
- (void)startAnimation;
- (void)stopAnimation;

@end
