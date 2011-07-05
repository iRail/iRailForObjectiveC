//
//  IRailStation.m
//  iRail mobile
//
//  Created by Ben Van Houtven on 03/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "IRailStation.h"


@implementation IRailStation

@synthesize sid, name, xCoord, yCoord;

- (void)dealloc {
    [sid release];
    [name release];
    
    [super dealloc];
}

@end
