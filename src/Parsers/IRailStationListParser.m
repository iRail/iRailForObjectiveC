//
//  IRailStationParser.m
//  iRail mobile
//
//  Created by Ben Van Houtven on 03/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "IRailStationListParser.h"


@implementation IRailStationListParser

- (id)finish {
    NSArray *arr = [[NSArray alloc] initWithArray:result];
    [result release];
    return arr;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    result = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"station"]) {
        
        currentStation = [[IRailStation alloc] init];
        [currentStation setSid: [attributeDict objectForKey:@"id"]];
        [currentStation setXCoord: [[attributeDict objectForKey:@"locationX"] doubleValue] ];
        [currentStation setYCoord: [[attributeDict objectForKey:@"locationY"] doubleValue] ];
        
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(!currentStationName) {
        currentStationName = [[NSMutableString alloc] init];
    }
    
    [currentStationName appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"station"]) {
        
        [currentStation setName: [NSString stringWithString:currentStationName]];
        [result addObject:currentStation];
        
        [currentStation release];
        [currentStationName release];
        currentStationName = nil;
        
    }
}

@end
