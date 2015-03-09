//
//  CustomSegmentedControl.h
//
//  Created by Tapha Media Ltd on 3/8/13.
//  Copyright (c) 2013 Tapha Media Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomSegmentedControl;
@protocol CustomSegmentedControlDelegate

- (UIButton*) buttonFor:(CustomSegmentedControl*)segmentedControl atIndex:(NSUInteger)segmentIndex;

@optional
- (void) touchUpInsideSegment:(CustomSegmentedControl*)segmentedControl index:(NSUInteger)segmentIndex;
@end

@interface CustomSegmentedControl : UIView
{
    id <CustomSegmentedControlDelegate> delegate;
    NSMutableArray* buttons;
}
@property (nonatomic, retain) NSMutableArray* buttons;

- (void) setSegmentWithCount:(NSUInteger)segmentCount segmentsize:(CGSize)segmentsize dividerImage:(UIImage*)dividerImage tag:(NSInteger)objectTag delegate:(id<CustomSegmentedControlDelegate>)dlgt;

@end
