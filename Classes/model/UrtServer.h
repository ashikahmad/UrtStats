//
//  UrtServer.h
//  UrTStats
//
//  Created by Ashik Ahmad on 7/29/12.
//  Copyright (c) 2012 WNeeds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordBook.h"

@interface UrtServer : NSObject

@property (nonatomic, retain) NSString* host;
@property (nonatomic, retain) RecordBook* currentGameRecord;
@property (nonatomic, assign) int port;
@property (nonatomic, assign) BOOL connected;

- (id)initWithHost:(NSString*) host portNumber:(int)port;
- (void)reload;

@end
