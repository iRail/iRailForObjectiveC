/*
 * Copyright (c) 2011 iRail vzw/asbl.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are
 * permitted provided that the following conditions are met:
 *
 *   1. Redistributions of source code must retain the above copyright notice, this list of
 *      conditions and the following disclaimer.
 *
 *   2. Redistributions in binary form must reproduce the above copyright notice, this list
 *      of conditions and the following disclaimer in the documentation and/or other materials
 *      provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * The views and conclusions contained in the software and documentation are those of the
 * authors and should not be interpreted as representing official policies, either expressed
 * or implied, of iRail vzw/asbl.
 */

#import "IRailLiveboardParser.h"


@implementation IRailLiveboardParser

- (id)init {
    self = [super init];
    if (self) {
        departureList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)finishedParsing {
    IRailLiveboard *liveboard = [[IRailLiveboard alloc] init];
    liveboard.station = departureStation;
    liveboard.departureList = departureList;
    
    return [liveboard autorelease];
}

- (void)foundElement:(IRailParserNode *)element {
    
    if ([element.name isEqualToString:@"station"]) {
        
        IRailStation *station = [[IRailStation alloc] init];
        station.name = element.content;
        station.xCoord = [[element.attributes objectForKey:@"locationX"] doubleValue];
        station.yCoord = [[element.attributes objectForKey:@"locationY"] doubleValue];
        
        if ([element.parent.name isEqualToString:@"departure"]) {
            currentStation = [station retain];
        } else {
            departureStation = [station retain];
        }
        
        [station release];
        
    } else if([element.name isEqualToString:@"vehicle"]) {        
        currentVehicleId = [element.content retain];
        
    } else if([element.name isEqualToString:@"time"]) {
        currentTime = [[NSDate alloc] initWithTimeIntervalSince1970:[element.content longLongValue]];
        
    } else if([element.name isEqualToString:@"platform"]) {
        currentPlatform = [element.content intValue];
        
    } else if([element.name isEqualToString:@"departure"]) {
    
        IRailArrivalDeparture *departure = [[IRailArrivalDeparture alloc] init];
        departure.vehicleId = currentVehicleId;
        departure.station = currentStation;
        departure.time = currentTime;
        departure.delay = [[element.attributes objectForKey:@"delay"] intValue];
        departure.platform = currentPlatform;
        
        [departureList addObject:departure];
        
        [currentVehicleId release];
        [currentStation release];
        [currentTime release];
        [departure release];
    }
}

- (void)dealloc {
    [departureStation release];
    [departureList release];
    [super dealloc];
}

@end
