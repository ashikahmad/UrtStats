//
//  ServerInfo.m
//  UrTStats
//
//  Created by Ashik uddin Ahmad on 6/24/16.
//  Copyright © 2016 WNeeds. All rights reserved.
//

#import "ServerInfo.h"

@implementation ServerInfo

-(id)initWithString:(NSString *)string {
    if( (self = [super init]) )  {
        NSArray *values = [string componentsSeparatedByString:@"\\"];
        self.gameType = [[self retrieveValueForKey:@"g_gametype"
                                         fromArray:values] integerValue];
        self.mapName = [self retrieveValueForKey:@"mapname"
                                       fromArray:values];
        self.timeLimit = [[self retrieveValueForKey:@"timelimit"
                                          fromArray:values] intValue];
    }
    return self;
}

-(id)retrieveValueForKey:(NSString *)key fromArray:(NSArray *)array {
    NSInteger index = [array indexOfObject:key];
    if(index != NSNotFound && index < array.count-1) {
        return array[index+1];
    }
    return nil;
}

-(NSString *)gameTypeString {
    switch (self.gameType) {
        case UrTGameTypeFreeForAll: return @"Free for All";
        case UrTGameTypeLastManStanding: return @"Last Man Standing";
        case UrTGameTypeTeamDeathMatch: return @"Team Death match";
        case UrTGameTypeTeamSurvivor: return @"Team Survivor";
        case UrTGameTypeFollowTheLeader: return @"Follow The Leader";
        case UrTGameTypeCaptureAndHold: return @"Capture and Hold";
        case UrTGameTypeCaptureTheFlag: return @"Capture the Flag";
        case UrTGameTypeBombMode: return @"Bomb Mode";
        case UrTGameTypeJumpTraining: return @"Jump Training";
            
        default: return @"Unknown";
    }
}

@end
