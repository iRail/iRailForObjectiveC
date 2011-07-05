//
//  IRailVehicle.m
//  iRail Mobile
//
//  Created by Ben Van Houtven on 04/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "IRailVehicle.h"


@implementation IRailVehicle

@synthesize vid, stops;

- (id)initWithVehicleId:(NSString *)aVid andStopList:(NSArray *)aStopList {
    self = [super init];
    if (self) {
        [self setVid:aVid];
        [self setStops:aStopList];
    }
    
    return self;
}

- (void)dealloc {
    [vid release];
    [stops release];
    
    [super dealloc];
}

@end
