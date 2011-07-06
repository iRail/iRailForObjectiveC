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

#import "IRailVehicleInfoParser.h"

@implementation IRailVehicleInfoParser

- (id)init {
    self = [super init];
    if (self) {
        vehicleStops = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)finishedParsing {
    
    IRailVehicle *vehicle = [[IRailVehicle alloc] init];
    vehicle.vid = vehicleId;
    vehicle.stops = [NSArray arrayWithArray:vehicleStops];
    
    
    return [vehicle autorelease];
}

- (void)foundElementWithName:(NSString *)name attributes:(NSDictionary *)attributes andContent:(NSString *)content {
    
    if ([name isEqualToString:@"vehicle"]) {
        vehicleId = [content retain];
        
    } else if([name isEqualToString:@"stop"]) {
        
        IRailVehicleStop *stop = [[IRailVehicleStop alloc] init];
        stop.delay = [[attributes objectForKey:@"delay"] intValue];
        stop.station = currentStation;
        stop.time = currentTime;
        
        [vehicleStops addObject:stop];
        
        [stop release];
        [currentStation release];
        [currentTime release];
        
    } else if([name isEqualToString:@"station"]) {
        
        currentStation = [[IRailStation alloc] init];
        currentStation.sid = [attributes objectForKey:@"id"];
        currentStation.name = content;
        currentStation.xCoord = [[attributes objectForKey:@"locationX"] doubleValue];
        currentStation.yCoord = [[attributes objectForKey:@"locationY"] doubleValue];
        
    } else if([name isEqualToString:@"time"]) {
        
        currentTime = [[NSDate alloc] initWithTimeIntervalSince1970:[content longLongValue]];
    
    }
}

- (void)dealloc {
    [vehicleStops release];
    [vehicleId release];
    [super dealloc];
}

@end
