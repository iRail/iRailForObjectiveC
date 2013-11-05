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

#import "IRailAPIAbstractCommand.h"

@implementation IRailAPIAbstractCommand

- (id)initWithAPIDelegate:(id<IRailAPIDelegate>)aDelegate andCommandURL:(NSURL *)aUrl {
    self = [super init];
    if (self) {
        _delegate = aDelegate;
        _commandURL = aUrl;
    }
    
    return self;
}

- (void)execute {
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.commandURL];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if (connection) {
        self.apiResponseData = [[NSMutableData alloc] init];
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.delegate iRailApiCommandDidFailWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.apiResponseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    @autoreleasepool {
        id result = [self.parser parseData:self.apiResponseData];
        
        if( !result ) {
            //TODO: Proper NSError object...
            [self.delegate iRailApiCommandDidFailWithError:nil];
        } else {
            [self finishWithResult:result];
        }
    }
    
}

- (void)finishWithResult:(id)result {
    //ABSTRACT METHOD
    //implement with correct delegate call...
}

@end
