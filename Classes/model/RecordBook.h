//
//  RecordBook.h
//  UrTStats
//
//  Created by Ashik Ahmad on 7/29/12.
//  Copyright (c) 2012 WNeeds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "ServerInfo.h"

@interface RecordBook : NSObject

@property (nonatomic, retain) ServerInfo *serverInfo;

@property (nonatomic, retain) NSMutableDictionary* record;
@property (nonatomic, retain) NSDictionary* lastRecord;

- (void) reset;
- (void) addPlayer: (Player*)player;
- (NSArray*) getPlayers:(BOOL)shouldSortByRank;

-(void) setUpdatedResponse:(NSString *) response;

@end
