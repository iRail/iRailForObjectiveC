//
//  IRailAPIAbstractCommand.m
//  iRail Mobile
//
//  Created by Ben Van Houtven on 04/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "IRailAPIAbstractCommand.h"


@implementation IRailAPIAbstractCommand

- (id)initWithAPIDelegate:(id<IRailAPIDelegate>)aDelegate andCommandURL:(NSURL *)aUrl {
    self = [super init];
    if (self) {
        self->delegate = [aDelegate retain];
        self->commandURL = [aUrl retain];
    }
    
    return self;
}

- (void)execute {
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:commandURL];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if (connection) {
        apiResponseData = [[NSMutableData alloc] init];
    }
    
    [request release];
}

- (void)finishWithResult:(id)result {
    //ABSTRACT METHOD
    //implement with correct delegate call...
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [delegate iRailApiCommandDidFailWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [apiResponseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    id result = [parser parseData:apiResponseData];
    
    if( [result isKindOfClass:[NSError class]] ) {
        [delegate iRailApiCommandDidFailWithError:result];
    } else {
        [self finishWithResult:result];
        [result release];
    }

    [apiResponseData release];
    [self release];
}

- (void)dealloc {
    [delegate release];
    [parser release];
    [commandURL release];
    [super dealloc];
}

@end
