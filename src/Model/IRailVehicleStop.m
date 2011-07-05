//
//  IRailStop.m
//  iRail Mobile
//
//  Created by Ben Van Houtven on 04/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "IRailVehicleStop.h"


@implementation IRailVehicleStop

@synthesize station, date, delay;

- (id)initWithStation:(IRailStation *)aStation date:(NSDate *)aDate andDelay:(int)aDelay {
    self = [super init];
    if (self) {
        
        [self setStation:aStation];
        [self setDate:aDate];
        [self setDelay:aDelay];
    }
    
    return self;
}

- (void)dealloc {
    [station release];
    [date release];
    
    [super dealloc];
}

@end
