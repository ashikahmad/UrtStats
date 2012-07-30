//
//  UrTStatsController.h
//  UrTStats
//
//  Created by Ashik Ahmad on 7/28/12.
//  Copyright (c) 2012 WNeeds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UrtServer.h"

@interface UrTStatsController : NSObject//<NSTextFieldDelegate>
{
    NSString *strURL;
    int iPort;
    double dInterval;
    
    BOOL isRunning;
    
    NSTimer *timer;
}

@property (nonatomic, retain) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property (nonatomic, retain) NSStatusItem *statusItem;
@property (nonatomic, retain) NSImage *statusImage;
@property (nonatomic, retain) NSImage *statusHighlightImage;

@property (nonatomic, retain) UrtServer *stickyServer;

@property (nonatomic, retain) IBOutlet NSTextField *txtURL;
@property (nonatomic, retain) IBOutlet NSTextField *txtPort;
@property (nonatomic, retain) IBOutlet NSTextField *txtInterval;

-(IBAction)showConnectDialog:(id)sender;
-(IBAction)connect:(id)sender;

-(void) itemSelected:(id) sender;

@end
