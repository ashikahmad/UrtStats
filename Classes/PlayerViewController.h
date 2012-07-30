//
//  PlayerViewController.h
//  UrTStats
//
//  Created by Ashik Ahmad on 7/30/12.
//  Copyright (c) 2012 WNeeds. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Player;

@interface PlayerViewController : NSViewController

@property (nonatomic, retain) IBOutlet NSImageView *icon;
@property (nonatomic, retain) IBOutlet NSTextField *name;
@property (nonatomic, retain) IBOutlet NSTextField *stat;

-(void) updatePlayerData:(Player *) p;

@end
