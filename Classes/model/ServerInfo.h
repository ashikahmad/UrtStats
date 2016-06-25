//
//  ServerInfo.h
//  UrTStats
//
//  Created by Ashik uddin Ahmad on 6/24/16.
//  Copyright © 2016 WNeeds. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UrTGameType) {
    FreeForAll = 0,
    LastManStanding = 1,
    TeamDeathMatch = 3,
    TeamSurvivor = 4,
    FollowTheLeader = 5,
    CaptureAndHold = 6,
    CaptureTheFlag = 7,
    BombMode = 8,
    JumpTraining = 9
};


@interface ServerInfo : NSObject

@property (assign, nonatomic) UrTGameType gameType; //g_gametype
@property (strong, nonatomic) NSString *mapName; // mapname
@property (assign, nonatomic) int timeLimit; //timelimit

- (id)initWithString:(NSString*) string;

@end
