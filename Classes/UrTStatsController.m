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
}

-(NSMenuItem *) getLastPlayer {
    long index = [statusMenu indexOfItemWithTag:LAST_SPLITTER_TAG];
    NSMenuItem *item = [statusMenu itemAtIndex:index-1];
    if(item.tag == FIRST_SPLITTER_TAG)
        return nil;
    return item;
}

// Use -1 for length or position if not needed
-(NSMenuItem *) addMenuItemWithTitle:(NSString *) title trimLength:(int) length action:(SEL) action to:(NSMenu *) parentItem index:(int) index {
    NSString *trimmedTitle = title;
    if (length > 0 && title.length > length) {
        trimmedTitle = [title substringToIndex:length];
    }
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:title action:action keyEquivalent:@""];
    if (index >= 0) {
        [parentItem insertItem:item atIndex:index];
    } else {
        [parentItem addItem:item];
    }
    
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
    }
    [item setSubmenu:subMenu];
    
    [statusMenu insertItem:item atIndex:index];
}



-(void) updateInfo {
    dispatch_queue_t queue = dispatch_queue_create("com.urtbd.urtstat", 0);
    dispatch_async(queue, ^{
        if (self.stickyServer) {
            [self.stickyServer reload];
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            // Remove previous server info
            while ( [self.statusMenu itemAtIndex:1].tag != FIRST_SPLITTER_TAG) {
                [self.statusMenu removeItemAtIndex:1];
            }
            RecordBook *rBook = self.stickyServer.currentGameRecord;
            [self addMenuItemWithTitle:[NSString stringWithFormat:@"Map: %@", rBook.serverInfo.mapName]
                            trimLength:-1
                                action:nil
                                    to:self.statusMenu
                                 index:1];
            [self addMenuItemWithTitle:[NSString stringWithFormat:@"%@: %d min", rBook.serverInfo.gameTypeString, rBook.serverInfo.timeLimit]
                            trimLength:-1
                                action:nil
                                    to:self.statusMenu
                                 index:1];
            
            // Remove Previous Player Info
            NSMenuItem *item;
            while ((item = [self getLastPlayer])) {
                [self.statusMenu removeItem:item];
            }
            
            NSArray *players = [self.stickyServer.currentGameRecord getPlayers:YES];
            [self.statusItem setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[players count]]];
            if ([players count]) {
                for (Player *p in players) {
                    [self addPlayerItem:p];
                }
            } else {
                long index = [self.statusMenu indexOfItemWithTag:LAST_SPLITTER_TAG];
                NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"No Players Connected!" action:nil keyEquivalent:@""];
                [self.statusMenu insertItem:item atIndex:index];
            }
        });
    });
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
    
    [window close];
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:dInterval 
                                             target:self
                                           selector:@selector(updateInfo)
                                           userInfo:nil
                                            repeats:YES];
}

-(void)itemSelected:(id)sender {
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:strURL.length>25?[NSString stringWithFormat:@"%@..", [strURL substringToIndex:25]]:strURL action:nil keyEquivalent:@""];
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
}

@end
