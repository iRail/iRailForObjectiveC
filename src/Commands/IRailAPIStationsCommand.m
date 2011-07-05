//
//  IRailAPIStationsCommand.m
//  iRail Mobile
//
//  Created by Ben Van Houtven on 04/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "IRailAPIStationsCommand.h"
#import "IRailStationListParser.h"

@implementation IRailAPIStationsCommand

- (id)initWithAPIDelegate:(id<IRailAPIDelegate>)aDelegate andCommandURL:(NSURL *)aUrl {
    self = [super initWithAPIDelegate:aDelegate andCommandURL:aUrl];
    if (self) {
        self->parser = [[IRailStationListParser alloc] init];
    }
    return self;
}

- (void)finishWithResult:(id)result {    
    if([delegate respondsToSelector:@selector(iRailApiCommandDidFinishReceivingStationList:)]) {
        [delegate iRailApiCommandDidFinishReceivingStationList:result];
    }
}

@end
