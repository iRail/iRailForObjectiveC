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

#import "IRailConnectionParser.h"
#import "IRailAbstractParser.h"

@implementation IRailConnectionParser

- (id)init {
    self = [super init];
    if (self) {
        _connection = [[IRailConnection alloc] init];
        _connections = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)finishedParsing {
    return self.connections;
}

- (void)foundElement:(IRailParserNode *)element {
    
    if ([element.name isEqualToString:@"connection"]) {
        [self.connections addObject:self.connection];
        
        self.connection = [[IRailConnection alloc] init];
        
    } else if ([element.name isEqualToString:@"arrival"] && [element.parent.name isEqualToString:@"connection"]) {
        self.connection.arrival = [IRailModelGenerator generateArrivalDepartureForNode:element];
    } else if ([element.name isEqualToString:@"departure"] && [element.parent.name isEqualToString:@"connection"]) {
        self.connection.departure = [IRailModelGenerator generateArrivalDepartureForNode:element];
    } else if ([element.name isEqualToString:@"duration"]) {
        self.connection.duration = [element.content intValue];
        if ([element.attributes objectForKey:@"delay"] != nil) {
            self.connection.delay = YES;
        } else {
            self.connection.delay = NO;
        }
        
    } else if ([element.name isEqualToString:@"vias"]) {
        self.connection.transfers = [IRailModelGenerator generateTransfersForNode:element];
    }
}

@end
