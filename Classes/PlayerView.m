//
//  PlayerView.m
//  UrTStats
//
//  Created by Ashik Ahmad on 7/30/12.
//  Copyright (c) 2012 WNeeds. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

@synthesize isEven;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#define menuItem ([self enclosingMenuItem])
- (void) drawRect: (NSRect) rect {
    BOOL isHighlighted = [menuItem isHighlighted];
    if (isHighlighted) {
        [[NSColor selectedMenuItemColor] set];
        [NSBezierPath fillRect:rect];
    } else if(self.isEven){
        [[NSColor selectedTextBackgroundColor] set];
        [NSBezierPath fillRect:rect];
    }
    else {
        [super drawRect: rect];
    }
}

@end
