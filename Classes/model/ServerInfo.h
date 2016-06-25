//
//  ServerInfo.h
//  UrTStats
//
//  Created by Ashik uddin Ahmad on 6/24/16.
//  Copyright © 2016 WNeeds. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UrTGameType) {
    UrTGameTypeFreeForAll = 0,
    UrTGameTypeLastManStanding = 1,
    UrTGameTypeTeamDeathMatch = 3,
    UrTGameTypeTeamSurvivor = 4,
    UrTGameTypeFollowTheLeader = 5,
    UrTGameTypeCaptureAndHold = 6,
    UrTGameTypeCaptureTheFlag = 7,
    UrTGameTypeBombMode = 8,
    UrTGameTypeJumpTraining = 9
};



@interface ServerInfo : NSObject

@property (assign, nonatomic) UrTGameType gameType; //g_gametype
@property (strong, nonatomic) NSString *mapName; // mapname
@property (assign, nonatomic) int timeLimit; //timelimit

- (id)initWithString:(NSString*) string;

- (NSString *) gameTypeString;

@end
