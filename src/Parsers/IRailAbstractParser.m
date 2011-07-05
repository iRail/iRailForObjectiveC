//
//  IRailAbstractParser.m
//  iRail Mobile
//
//  Created by Ben Van Houtven on 04/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "IRailAbstractParser.h"


@implementation IRailAbstractParser

- (id)init {
    self = [super init];
    if (self) {
        error = nil;
    }
    
    return self;
}

- (id)parseData:(NSData *)data {
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    [parser release];
    
    if(!error) return [self finish];
    
    if(result) [result release];
    return error;    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //TODO: make useful error...?
    error = parseError;
}

- (id)finish {
    //ABSTRACT METHOD
    return nil;
}

@end
