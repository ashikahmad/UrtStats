//
//  UrTStatsController.m
//  UrTStats
//
//  Created by Ashik Ahmad on 7/28/12.
//  Copyright (c) 2012 WNeeds. All rights reserved.
//

#import "UrTStatsController.h"
#import "PlayerViewController.h"
#import "PlayerView.h"

#define FIRST_SPLITTER_TAG 99
#define LAST_SPLITTER_TAG 100

@implementation UrTStatsController

@synthesize window,
            statusMenu,
            statusItem,
            statusImage, statusHighlightImage,
            stickyServer,
            txtURL, txtPort, txtInterval;

-(void)awakeFromNib {
    // create the NSStatusItem and set it's length
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem retain];
    
    // Used to detect where our files are
    NSBundle *bundle = [NSBundle mainBundle];
    
    statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TabIcon" ofType:@"png"]];
    statusHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TabIconSel" ofType:@"png"]];
    
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusHighlightImage];
    [statusItem setTitle:@"0"];
    
    [statusItem setHighlightMode:YES];
    
    [statusItem setMenu:statusMenu];
    
    long index = [self.statusMenu indexOfItemWithTag:LAST_SPLITTER_TAG];
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"No Players Connected!" action:nil keyEquivalent:@""];
    [self.statusMenu insertItem:item atIndex:index];
    [item release];
    
}

-(NSMenuItem *) getLastPlayer {
    long index = [statusMenu indexOfItemWithTag:LAST_SPLITTER_TAG];
    NSMenuItem *item = [statusMenu itemAtIndex:index-1];
    if(item.tag == FIRST_SPLITTER_TAG)
        return nil;
    return item;
}

-(void) addPlayerItem:(Player *) p {
    long index = [statusMenu indexOfItemWithTag:LAST_SPLITTER_TAG];
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:p.name action:nil keyEquivalent:@""];
    
    // Create PlayerItemView
    PlayerViewController *vc = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
    [vc view];
    [vc updatePlayerData:p];
    [vc.view needsDisplay];
    [vc.view display];
    [item setView:vc.view];
    [vc release];
    
    NSArray *infos = [NSArray arrayWithObjects:
                      p.name,
                      [NSString stringWithFormat:@"Kill:%d", p.kill],
                      [NSString stringWithFormat:@"Ping:%d", p.ping]
                      , nil];
    NSMenu *subMenu = [[NSMenu alloc] init];
    for(NSString *info in infos){
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:info
                                                      action:@selector(itemSelected:) keyEquivalent:@""];
        [subMenu addItem:item];
        [item release];
    }
    [item setSubmenu:subMenu];
    [subMenu release];
    
    [statusMenu insertItem:item atIndex:index];
    [item release];
}

-(void) updateInfo {
    if (!isRunning) {
        NSLog(@"I should not repeat!");
		return;
	}
	
    __block UrTStatsController *myself = self;
    dispatch_queue_t queue = dispatch_queue_create("com.urtbd.urtstat", 0);
    dispatch_async(queue, ^(void){
        if (myself.stickyServer.connected) {
            [myself.stickyServer reload];
        }
        NSLog(@"%@", strURL);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            // Remove Previous Player Info
            NSMenuItem *item;
            while ((item = [self getLastPlayer])) {
                [myself.statusMenu removeItem:item];
            }
            
            NSArray *players = [myself.stickyServer.currentGameRecord getPlayers:YES];
            [myself.statusItem setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)[players count]]];
            if ([players count]) {
                for (Player *p in players) {
                    [myself addPlayerItem:p];
                }
            } else {
                long index = [myself.statusMenu indexOfItemWithTag:LAST_SPLITTER_TAG];
                NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"No Players Connected!" action:nil keyEquivalent:@""];
                [myself.statusMenu insertItem:item atIndex:index];
                [item release];
            }
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, dInterval*NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [myself updateInfo];
            });
        });
    });
}

-(void) updateInfo2 {
    if (self.stickyServer) {
        [self.stickyServer reload];
    }
    // Remove Previous Player Info
    NSMenuItem *item;
    while ((item = [self getLastPlayer])) {
        [self.statusMenu removeItem:item];
    }
        
    NSArray *players = [self.stickyServer.currentGameRecord getPlayers:YES];
    [self.statusItem setTitle:[NSString stringWithFormat:@"%d",[players count]]];
    if ([players count]) {
        for (Player *p in players) {
            [self addPlayerItem:p];
        }
    } else {
        long index = [self.statusMenu indexOfItemWithTag:LAST_SPLITTER_TAG];
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"No Players Connected!" action:nil keyEquivalent:@""];
        [self.statusMenu insertItem:item atIndex:index];
        [item release];
    }
}

-(IBAction) showConnectDialog:(id)sender {
    [txtURL setTitleWithMnemonic:@"45.119.120.2"];
    [txtPort setTitleWithMnemonic:@"27960"];
    [txtInterval setTitleWithMnemonic:@"5"];
    [window orderFront:sender];
	[window makeKeyWindow];
	[window setLevel:NSFloatingWindowLevel];
}

-(IBAction)connect:(id)sender {
    strURL =    [txtURL stringValue];
    iPort  =    [[txtPort stringValue] intValue];
    dInterval = [[txtInterval stringValue] doubleValue];
    if (dInterval < 1) dInterval = 1;
    self.stickyServer = [[UrtServer alloc] initWithHost:strURL
                                        portNumber:iPort];
    
    [self.statusMenu removeItemAtIndex:0];
    
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:strURL.length>25?[NSString stringWithFormat:@"%@..", [strURL substringToIndex:25]]:strURL action:nil keyEquivalent:@""];
    NSMenu *submenu = [[NSMenu alloc] init];
    NSMenuItem *cItem = [[NSMenuItem alloc] init];
    cItem.title = @"Connect to Other..";
    cItem.target = self;
    cItem.action = @selector(showConnectDialog:);
    [submenu addItem:cItem];
    item.submenu = submenu;
    [self.statusMenu insertItem:item atIndex:0];
    
//    isRunning = YES;
//    [self updateInfo];
    [window close];
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:dInterval 
                                             target:self
                                           selector:@selector(updateInfo2)
                                           userInfo:nil
                                            repeats:YES];
}

-(void)itemSelected:(id)sender {
    
}

-(void)dealloc {
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    
    self.window = nil;
    self.statusMenu = nil;
    self.statusItem = nil;
    self.statusImage = nil;
    self.statusHighlightImage = nil;
    
    self.stickyServer = nil;
    
    self.txtURL = nil;
    self.txtPort = nil;
    self.txtInterval = nil;
    
    [super dealloc];
}

@end
