//
//  FDViewController.h
//  Firebase Drawing
//
//  Created by Jonny Dimond on 8/14/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

#import "FDDrawView.h"

@protocol FDViewControllerDelegate <NSObject>

-(void)hideRealTimeViewAndCaptureWithImage:(UIImage*)image;;

@end

@interface FDViewController : UIViewController<FDDrawViewDelegate, UIScrollViewDelegate>
{
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL touchMoved;
    CGRect bounds;
    
    UIScrollView *colorScrollView;
    UIView *colorsView;
    UIButton *eraserButton;
}
@property(nonatomic) id<FDViewControllerDelegate>delegate;
@end
