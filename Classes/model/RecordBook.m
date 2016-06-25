//
//  RecordBook.m
//  UrTStats
//
//  Created by Ashik Ahmad on 7/29/12.
//  Copyright (c) 2012 WNeeds. All rights reserved.
//

#import "RecordBook.h"

@implementation RecordBook

@synthesize record, lastRecord;

- (id)init{
	self = [super init];
	if (self) {
		self.record = [NSMutableDictionary new];
		self.lastRecord = [NSMutableDictionary new];
	}
	return self;
}

- (void) reset{
	self.lastRecord = [NSDictionary dictionaryWithDictionary:self.record];
	[self.record removeAllObjects];
}

- (void) addPlayer: (Player*)player{
	Player* playerRecord = [self.lastRecord valueForKey:player.name];
	if (playerRecord) {
		player.lastKill = playerRecord.kill;		
		player.lastRank = playerRecord.currentRank;
	}	
	[record setValue:player forKey:player.name];
}

- (NSArray*) getPlayers:(BOOL)shouldSortByRank{
	NSMutableArray* players = [NSMutableArray new];
	[record enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL* stop){
		[players addObject:val];
	}];
	
	if (shouldSortByRank) {
		[players sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
			return [(Player*)obj1 kill] < [(Player*)obj2 kill];
		}];
	}
	int rank = 0;
	for (Player* player in players) {		
		player.currentRank = rank++;
	}
	return players;
}

-(void)setUpdatedResponse:(NSString *)response {
    [self reset];
    
    // 2nd line => Server Info
    NSArray* arr = [response componentsSeparatedByString:@"\n"];
    if ([arr count] > 1) {
        NSString *serverInfoString = [arr objectAtIndex:1];
        self.serverInfo = [[ServerInfo alloc] initWithString:serverInfoString];
    }
    
    // 3rd line to end => Player info per line
    if ([arr count] > 2) {
        int i = 2;
        for (; i< [arr count]; i++) {
            NSString* playerInfo = [arr objectAtIndex:i];
            if (playerInfo.length > 3) {
                Player* player = [[Player alloc] initWithString:playerInfo];
                [self addPlayer:player];
            }
        }
    }
}

@end
