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

#import "IRailModelGenerator.h"


@implementation IRailModelGenerator

+ (IRailStation *)generateStationForNode:(IRailParserNode *)node {
    if ( ![node.name isEqualToString:@"station"] && ![node.name isEqualToString:@"direction"] ) return nil;
    
    IRailStation *station = [[IRailStation alloc] init];
    station.name = node.content;
		station.sid = [node.attributes objectForKey:@"id"];
    station.xCoord = [[node.attributes objectForKey:@"locationX"] doubleValue];
    station.yCoord = [[node.attributes objectForKey:@"locationY"] doubleValue];
    
    return station;
}

+ (IRailVehicle *)generateVehicleForNode:(IRailParserNode *)node {
    if( ![node.name isEqualToString:@"vehicle"] ) return nil;
    
    IRailVehicle *vehicle = [[IRailVehicle alloc] init];
    vehicle.vid = node.content;
    vehicle.xCoord = [[node.attributes objectForKey:@"locationX"] doubleValue];
    vehicle.yCoord = [[node.attributes objectForKey:@"locationY"] doubleValue];
		
    return vehicle;
}

+ (IRailVehicle *)generateVehicleInformationForVehicle:(IRailVehicle *) vehicle withNode:(IRailParserNode *)node {
    
    if ( [node.name isEqualToString:@"stops"] ) {
        
        NSMutableArray *stops = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [node.children count]; i++) {
            IRailParserNode *curnode = [node.children objectAtIndex:i];
            
            IRailVehicleStop *stop = [[IRailVehicleStop alloc] init];
            
            for(int j = 0; j < [curnode.children count]; j++) {
                IRailParserNode *curnode2 = [curnode.children objectAtIndex:j];
                if ([curnode2.name isEqualToString:@"station"]) {
                    stop.station = [IRailModelGenerator generateStationForNode:curnode2];
                } else if ([curnode2.name isEqualToString:@"time"]) {
                    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970: [curnode2.content longLongValue]];
                    stop.time = date;
                }
            }
            [stops addObject:stop];

        }
        
        vehicle.stops = [NSArray arrayWithArray:stops];
    }
    
    return vehicle;
}

+ (IRailArrivalDeparture *)generateArrivalDepartureForNode:(IRailParserNode *)node {
    if ( ![node.name isEqualToString:@"departure"] && ![node.name isEqualToString:@"arrival"] ) return nil;
    
    IRailArrivalDeparture *arrivalDeparture = [[IRailArrivalDeparture alloc] init];
    for (int i = 0; i < [node.children count]; i++) {
        IRailParserNode *curnode = [node.children objectAtIndex:i];
        
        if ( [curnode.name isEqualToString:@"station"] ) {
            arrivalDeparture.station = [IRailModelGenerator generateStationForNode:curnode];
        } else if ( [curnode.name isEqualToString:@"vehicle"] ) {
            arrivalDeparture.vehicleId = curnode.content;
        } else if ( [curnode.name isEqualToString:@"time"] ) {
            NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970: [curnode.content longLongValue]];
            arrivalDeparture.time = date;
        } else if ( [curnode.name isEqualToString:@"platform"] ) {
            arrivalDeparture.platform = curnode.content;
        } else if ([curnode.name isEqualToString:@"direction"]) {
					arrivalDeparture.direction = curnode.content;
				}
    }
    
    return arrivalDeparture;
}

+ (NSArray *)generateTransfersForNode:(IRailParserNode *)node {
    if ( ![node.name isEqualToString:@"vias"] ) return nil;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [node.children count]; i++) {
        IRailParserNode *curnode = [node.children objectAtIndex:i];
        
        IRailTransfer *transfer = [[IRailTransfer alloc] init];
        for (int j = 0; j < [curnode.children count]; j++) {
            IRailParserNode *curnode2 = [curnode.children objectAtIndex:j];
            
            if ([curnode2.name isEqualToString:@"arrival"]) {
                transfer.arrival = [IRailModelGenerator generateArrivalDepartureForNode:curnode2];
            } else if ([curnode2.name isEqualToString:@"departure"]) {
                transfer.departure = [IRailModelGenerator generateArrivalDepartureForNode:curnode2];
            } else if ([curnode2.name isEqualToString:@"timeBetween"]) {
                transfer.timeBetween = [curnode2.content intValue];
            } else if ([curnode2.name isEqualToString:@"station"]) {
                transfer.station = [IRailModelGenerator generateStationForNode:curnode2];
            } else if ([curnode2.name isEqualToString:@"direction"]) {
                transfer.trainDirection = [IRailModelGenerator generateStationForNode:curnode2];
            } else if ([curnode2.name isEqualToString:@"vehicle"]) {
                transfer.vehicle = [IRailModelGenerator generateVehicleForNode:curnode2];
            }
        }
        
        [array addObject:transfer];
    }
    
    return [NSArray arrayWithArray:array];
}

@end
