//
//  IRailVehicleInfoParser.m
//  iRail Mobile
//
//  Created by Ben Van Houtven on 04/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

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
