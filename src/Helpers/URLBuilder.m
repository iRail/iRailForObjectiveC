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

#import "URLBuilder.h"


@implementation URLBuilder

- (id)initWithBaseURL:(NSString *)aUrl {
    self = [super init];
    if (self) {
        _baseURL = aUrl;
        _path = [[NSMutableString alloc] init];
        _query = [[NSMutableString alloc] init];
    }
    
    return self;
}

- (void)appendPath:(NSString *)aPath {
    if([self.path length] > 0 && [self.path characterAtIndex:[self.path length]-1] != '/') [self.path appendString:@"/"];
    [self.path appendString:aPath];
}

- (void)appendField:(NSString *)field withValue:(NSString *)value {
    if([self.query length] > 0) [self.query appendString:@"&"];
    
    [self.query appendString:field];
    [self.query appendString:@"="];
    [self.query appendString:value];
}

- (void)reset {
    self.query = [[NSMutableString alloc] init];
    self.path = [[NSMutableString alloc] init];
}

- (NSURL *)getURL {
    
    NSMutableString *newURL = [[NSMutableString alloc] initWithString:self.baseURL];
    
    if([self.baseURL characterAtIndex:[self.baseURL length]-1] != '/') [newURL appendString:@"/"];
    [newURL appendString:self.path];
    [newURL appendString:@"?"];
    [newURL appendString:self.query];
    
    return [NSURL URLWithString:newURL];
}

@end
