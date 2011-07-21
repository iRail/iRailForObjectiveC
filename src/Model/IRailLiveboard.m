//
//  IRailLiveboard.m
//  iRail Mobile
//
//  Created by Ben Van Houtven on 10/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "IRailLiveboard.h"


@implementation IRailLiveboard

@synthesize station, departureList;

- (void)dealloc {
    [station release];
    [departureList release];
    
    [super dealloc];
}

@end
