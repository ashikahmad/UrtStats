//
//  Player.h
//  UrTStats
//
//  Created by Ashik Ahmad on 7/29/12.
//  Copyright (c) 2012 WNeeds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property (nonatomic, retain) NSString* name;
@property (nonatomic, assign) int kill;
@property (nonatomic, assign) int ping;
@property (nonatomic, assign) int lastKill;
@property (nonatomic, assign) int currentRank;
@property (nonatomic, assign) int lastRank;

- (id)initWithString:(NSString*) string;
- (int)rankChange;

@end
