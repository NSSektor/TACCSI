//
//  CustomSegmentedControl.m
//  
//
//  Created by Tapha Media Ltd on 3/8/13.
//  Copyright (c) 2013 Tapha Media Ltd. All rights reserved.
//

#import "CustomSegmentedControl.h"

@implementation CustomSegmentedControl
@synthesize buttons;

- (void) setSegmentWithCount:(NSUInteger)segmentCount segmentsize:(CGSize)segmentsize dividerImage:(UIImage*)dividerImage tag:(NSInteger)objectTag delegate:(id<CustomSegmentedControlDelegate>)dlgt
{
    // The tag allows callers withe multiple controls to distinguish between them
    self.tag = objectTag;
    
    delegate = dlgt;
    
    // Adjust our width based on the number of segments & the width of each segment and the sepearator
    self.frame = CGRectMake(0, 0, (segmentsize.width * segmentCount), segmentsize.height);
    
    // Initalize the array we use to store our buttons
    self.buttons = [[NSMutableArray alloc] initWithCapacity:segmentCount];
    
    // horizontalOffset tracks the proper x value as we add buttons as subviews
    CGFloat horizontalOffset = 0;
    
    // Iterate through each segment
    for (NSUInteger i = 0 ; i < segmentCount ; i++)
    {
        // Ask the delegate to create a button
        UIButton* button = [delegate buttonFor:self atIndex:i];
        
        // Register for touch events
        [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // Add the button to our buttons array
        [buttons addObject:button];
        
        [button setAdjustsImageWhenHighlighted:NO];
        
        // Set the button's x offset
        button.frame = CGRectMake(horizontalOffset, 0.0, button.frame.size.width, button.frame.size.height);
        
        // Add the button as our subview
        [self addSubview:button];
        
        
        // Advance the horizontal offset
        horizontalOffset = horizontalOffset + segmentsize.width - 1;
    }
}

-(void) dimAllButtonsExcept:(UIButton*)selectedButton
{
    NSUInteger index = [buttons indexOfObject:selectedButton];
    
    if (index == NSNotFound) {
        return;
    }
    
    selectedButton.selected = true;
    [selectedButton setUserInteractionEnabled:NO];
    
    for ( int i = 0; i < [buttons count]; i++) {
        if (i != index) {
            [[buttons objectAtIndex:i] setSelected:!selectedButton.selected];
            [[buttons objectAtIndex:i] setUserInteractionEnabled:YES];
        }
    }
}


- (void)touchUpInsideAction:(UIButton*)button
{
    [self dimAllButtonsExcept:button];

    if (delegate)
        [delegate touchUpInsideSegment:self index:[buttons indexOfObject:button]];
}




@end
