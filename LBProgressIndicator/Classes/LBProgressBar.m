//
//  LBProgressBar.m
//  LBProgressBar
//
//  Created by Laurin Brandner on 05.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//

#import "LBProgressBar.h"

#define DEFAULT_radius 10
#define DEFAULT_angle 30

#define DEFAULT_inset 2
#define DEFAULT_stripeWidth 7

#define DEFAULT_barColor [UIColor colorWithRed:25.0/255.0 green:29.0/255.0 blue:33.0/255.0 alpha:1.0]
#define DEFAULT_lighterProgressColor [UIColor colorWithRed:223.0/255.0 green:237.0/255.0 blue:180.0/255.0 alpha:1.0]
#define DEFAULT_darkerProgressColor [UIColor colorWithRed:156.0/255.0 green:200.0/255.0 blue:84.0/255.0 alpha:1.0]
#define DEFAULT_lighterStripeColor [UIColor colorWithRed:182.0/255.0 green:216.0/255.0 blue:86.0/255.0 alpha:1.0]
#define DEFAULT_darkerStripeColor [UIColor colorWithRed:126.0/255.0 green:187.0/255.0 blue:55.0/255.0 alpha:1.0]
#define DEFAULT_shadowColor [UIColor colorWithRed:223.0/255.0 green:238.0/255.0 blue:181.0/255.0 alpha:1.0]

@interface LBProgressBar (Private)
-(void)drawBezel;
-(void)drawProgressWithBounds:(CGRect)bounds;
-(void)drawStripesInBounds:(CGRect)bounds;
-(void)drawShadowInBounds:(CGRect)bounds;
-(UIBezierPath*)stripeWithOrigin:(CGPoint)origin bounds:(CGRect)frame;
@end


@implementation LBProgressBar

@synthesize progressOffset;

#pragma mark Accessors
//-(void)setDoubleValue:(double)value {
//    [super setDoubleValue:value];
//    if (![self isDisplayedWhenStopped] && value == [self maxValue]) {
//        [self stopAnimation:self];
//    }
//}

- (void)setProgress:(float)inProgress {
	[super setProgress:inProgress];
	[self setNeedsDisplay];		
}

-(NSTimer*)animator {
    return animator;
}

-(void)setAnimator:(NSTimer *)value {
    if (animator != value) {
        [animator invalidate];
        [animator release];
        animator = [value retain];
    }
}

#pragma mark Initialization

-(id)initWithFrame:(CGRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        self.progressOffset = 0;
        self.animator = nil;
    }
    return self;
}

#pragma mark -
#pragma mark Memory

-(void)dealloc {
    self.progressOffset = 0;
    self.animator = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Drawing

-(void)drawShadowInBounds:(CGRect)bounds {
    [DEFAULT_shadowColor set];
    
    UIBezierPath* shadow = [UIBezierPath bezierPath];
    
    [shadow moveToPoint:CGPointMake(0, 2)];
    [shadow addLineToPoint:CGPointMake(CGRectGetWidth(bounds), 2)];
    
    [shadow stroke];
}

- (UIBezierPath*)stripeWithOrigin:(CGPoint)origin bounds:(CGRect)frame {    
    float height = frame.size.height;
    UIBezierPath* rect = [[UIBezierPath alloc] init];
    [rect moveToPoint:origin];
    [rect addLineToPoint:CGPointMake(origin.x+DEFAULT_stripeWidth, origin.y)];
    [rect addLineToPoint:CGPointMake(origin.x+DEFAULT_stripeWidth-8, origin.y+height)];
    [rect addLineToPoint:CGPointMake(origin.x-8, origin.y+height)];
    [rect addLineToPoint:origin];
    return rect;
}

-(void)drawStripesInBounds:(CGRect)frame {
//  NSGradient* gradient = [[NSGradient alloc] initWithStartingColor:DEFAULT_lighterStripeColor endingColor:DEFAULT_darkerStripeColor];
	CGColorSpaceRef colrSpace = CGColorSpaceCreateDeviceRGB();
	CGFloat colorLocations[2] = {0, 1};	
    CGGradientRef gradient = CGGradientCreateWithColors(colrSpace, (CFArrayRef)[NSArray arrayWithObjects:(id)[DEFAULT_lighterStripeColor CGColor], (id)[DEFAULT_darkerStripeColor CGColor], nil], colorLocations);//[[NSGradient alloc] initWithStartingColor:DEFAULT_lighterProgressColor endingColor:DEFAULT_darkerProgressColor];	
    UIBezierPath* allStripes = [[UIBezierPath alloc] init];
    
    for (int i = 0; i <= frame.size.width/(2*DEFAULT_stripeWidth)+(2*DEFAULT_stripeWidth); i++) {
        UIBezierPath* stripe = [self stripeWithOrigin:CGPointMake(i*2*DEFAULT_stripeWidth + self.progressOffset, DEFAULT_inset) bounds:frame];
        [allStripes appendPath:stripe];
        [stripe release];
    }
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    //clip
    //UIBezierPath* clipPath = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:DEFAULT_radius];
	CGContextAddPath(context, allStripes.CGPath);
	CGContextClip(context);
	CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame)), CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame)), kCGGradientDrawsBeforeStartLocation);
	//[gradient drawInBezierPath:bounds angle:90];
    CGGradientRelease(gradient);
    [allStripes release];
//	[gradient release];
}

-(void)drawBezel {
    CGContextRef context = (CGContextRef)UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGFloat maxX = CGRectGetMaxX(self.bounds);
    
    //white shadow
    UIBezierPath* shadow = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.5, 0, self.bounds.size.width, self.bounds.size.height) cornerRadius:DEFAULT_radius];
    [shadow addClip];//:NSMakeRect(0, self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height/2)];
    [[UIColor colorWithWhite:1.0 alpha:0.4] set];
    [shadow stroke];
    
    CGContextRestoreGState(context);
    //rounded rect
    UIBezierPath* roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 1) cornerRadius:DEFAULT_radius];
    [DEFAULT_barColor set];
    [roundedRect fill];
    
    //inner glow
    CGMutablePathRef glow = CGPathCreateMutable();
    CGPathMoveToPoint(glow, NULL, DEFAULT_radius, 0);
    CGPathAddLineToPoint(glow, NULL, maxX-DEFAULT_radius, 0);
    
    [[UIColor colorWithRed:17.0/255.0 green:20.0/255.0 blue:23.0/255.0 alpha:1.0] set];
    CGContextAddPath(context, glow);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(glow);
}

- (void)drawProgressWithBounds:(CGRect)frame {
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIBezierPath* roundedBounds = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:DEFAULT_radius];
	CGColorSpaceRef colrSpace = CGColorSpaceCreateDeviceRGB();
	CGFloat colorLocations[2] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colrSpace, (CFArrayRef)[NSArray arrayWithObjects:(id)[DEFAULT_lighterProgressColor CGColor], (id)[DEFAULT_darkerProgressColor CGColor], nil], colorLocations);//[[NSGradient alloc] initWithStartingColor:DEFAULT_lighterProgressColor endingColor:DEFAULT_darkerProgressColor];
	CGColorSpaceRelease(colrSpace);
	CGContextAddPath(context, roundedBounds.CGPath);
	CGContextClip(context);
	CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame)), CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame)), kCGGradientDrawsBeforeStartLocation);
   //[gradient drawInBezierPath:bounds angle:90];
    CGGradientRelease(gradient);
}

- (void)drawRect:(CGRect)dirtyRect {
	if( animator ) {
		self.progressOffset = (self.progressOffset > (2*DEFAULT_stripeWidth)-1) ? 0 : ++self.progressOffset;	
	}

//    float distance = 1.0f - [self progress];
//    float value = ([self progress]) ? [self progress] / distance : 0;
    
    [self drawBezel];
    CGFloat currentProgress = [self progress];
	
	//Lazy patch for an UI glitch.
	if(currentProgress < 0.06) {
		currentProgress = 0.06;
	}
	
    if ( currentProgress > 0 ) {
        CGRect selfBounds = CGRectMake(DEFAULT_inset, DEFAULT_inset, (self.frame.size.width*currentProgress) - 2 * DEFAULT_inset, (self.frame.size.height-2*DEFAULT_inset)-1);
        
        [self drawProgressWithBounds:selfBounds];
        [self drawStripesInBounds:selfBounds];
        [self drawShadowInBounds:selfBounds];
    }
}

#pragma mark -
#pragma mark Actions
- (BOOL)isAnimating {
	return self.animator ? YES : NO;
}

- (void)startAnimation {
    if (!self.animator) {
        self.animator = [NSTimer scheduledTimerWithTimeInterval:1.0/20 target:self selector:@selector(activateAnimation:) userInfo:nil repeats:YES];
    }
}

-(void)stopAnimation {
    self.animator = nil;
}

-(void)activateAnimation:(NSTimer*)timer {
    [self setNeedsDisplay];
}

#pragma mark -

@end
