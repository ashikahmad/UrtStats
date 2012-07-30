//
//  PlayerViewController.m
//  UrTStats
//
//  Created by Ashik Ahmad on 7/30/12.
//  Copyright (c) 2012 WNeeds. All rights reserved.
//

#import "PlayerViewController.h"
#import "Player.h"

@implementation PlayerViewController

@synthesize icon, name, stat;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) updatePlayerData:(Player *) p{
    int rank = [p rankChange];
    if(rank != 0)
        [self.icon setImage:[NSImage imageNamed:(rank > 0? @"up.png":@"down.png")]];
    [self.name setStringValue:p.name];
    [self.stat setStringValue:[NSString stringWithFormat:@"%d", p.kill]];
}

@end
