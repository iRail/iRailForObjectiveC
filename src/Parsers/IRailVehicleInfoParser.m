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

- (id)finish {
    
    ((IRailVehicle*)result).stops = vehicleStops;
    
    [vehicleStops release];
    
    return result;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    result = [[IRailVehicle alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:@"vehicle"]) {
        
        currentNodeType = NODE_VEHICLE;
        
    } else if ([elementName isEqualToString:@"stops"]) {
        vehicleStops = [[NSMutableArray alloc] initWithCapacity: [[attributeDict objectForKey:@"number"] intValue]];
        
    } else if([elementName isEqualToString:@"stop"]) {
        
        currentNodeType = NODE_STOP;
        IRailVehicleStop *stop = [[IRailVehicleStop alloc] init];
        stop.delay = [[attributeDict objectForKey:@"delay"] intValue];
        [vehicleStops addObject:stop];
        
        [stop release];
        
    } else if([elementName isEqualToString:@"station"]) {
        
        currentNodeType = NODE_STATION;
        currentStation = [[IRailStation alloc] init];
        currentStation.xCoord = [[attributeDict objectForKey:@"locationX"] doubleValue];
        currentStation.yCoord = [[attributeDict objectForKey:@"locationY"] doubleValue];
        
    } else if([elementName isEqualToString:@"time"]) {
        currentNodeType = NODE_TIME;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentText) currentText = [[NSMutableString alloc] init];
    [currentText appendString: string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    switch (currentNodeType) {
        case NODE_VEHICLE:
            ((IRailVehicle*)result).vid = [NSString stringWithString:currentText];
            
        case NODE_STATION:
            currentStation.name = [NSString stringWithString:currentText];
            ((IRailVehicleStop*)[vehicleStops objectAtIndex:[vehicleStops count]-1]).station = currentStation;
            [currentStation release];
            
            break;
        case NODE_TIME:
            ((IRailVehicleStop*)[vehicleStops objectAtIndex:[vehicleStops count]-1]).date = [NSDate dateWithTimeIntervalSince1970:[currentText longLongValue]];
            break;
        default:
            break;
    }
    
    currentNodeType = NODE_IGNORE;

    if(currentText){
        [currentText release];
        currentText = nil;
    }
    
    
}

@end
