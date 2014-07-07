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

- (instancetype)initWithCommandURL:(NSURL *)url completion:(GeneralCompletion)completion {
    self = [super init];
    if (self) {
        self.completion = completion;
        self.commandURL = url;
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
    [self callCompletionWithResult:nil error:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.apiResponseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    IRailAbstractParser *parser = [[[[self class] parserClass] alloc] init];
    
    if (![parser isKindOfClass:[IRailAbstractParser class]]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"Provided parserClass \"%@\" must be a sublass of IRailAbstractParser", NSStringFromClass([parser class])]
                                     userInfo:nil];
    }

    @autoreleasepool {
        id result = [parser parseData:self.apiResponseData];
        
        if( !result ) {
            self.completion(nil,[NSError errorWithDomain:@"iRail" code:1 userInfo:nil]);
        } else {
            [self callCompletionWithResult:result error:nil];
        }
    }
    
}

+ (Class)parserClass {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)callCompletionWithResult:(id)result error:(NSError *)error {
    if (self.completion) {
        self.completion(result,error);
    }
}

@end
