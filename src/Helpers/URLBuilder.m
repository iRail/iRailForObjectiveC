//
//  URLBuilder.m
//  iRail Mobile
//
//  Created by Ben Van Houtven on 04/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "URLBuilder.h"


@implementation URLBuilder

- (id)initWithBaseURL:(NSString *)aUrl {
    self = [super init];
    if (self) {
        self->baseURL = aUrl;
        self->path = [[NSMutableString alloc] init];
        self->query = [[NSMutableString alloc] init];
    }
    
    return self;
}

- (void)appendPath:(NSString *)aPath {
    if([path length] > 0 && [path characterAtIndex:[path length]-1] != '/') [path appendString:@"/"];
    [path appendString:aPath];
}

- (void)appendField:(NSString *)field withValue:(NSString *)value {
    if([query length] > 0) [query appendString:@"&"];
    
    [query appendString:field];
    [query appendString:@"="];
    [query appendString:value];
}

- (void)reset {
    [query release];
    self->query = [[NSMutableString alloc] init];
    
    [path release];
    self->path = [[NSMutableString alloc] init];
}

- (NSURL *)getURL {
    
    NSMutableString *newURL = [[NSMutableString alloc] initWithString:baseURL];
    
    if([baseURL characterAtIndex: [baseURL length]-1] != '/') [newURL appendString:@"/"];
    [newURL appendString:path];
    [newURL appendString:@"?"];
    [newURL appendString:query];
    
    NSURL *theURL = [[NSURL alloc] initWithString:newURL];
    
    [newURL release];
    return theURL;
}

- (void)dealloc {
    [baseURL release];
    [path release];
    [query release];
    
    [super dealloc];
}

@end
