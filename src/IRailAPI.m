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

#import "IRailAPI.h"
#import "URLBuilder.h"

#import "IRailAPIStationsCommand.h"
#import "IRailAPIVehicleInfoCommand.h"

@interface IRailAPI(Private)
- (NSURL *)generateUrlForPath:(NSString *)path andQueryParameters:(NSDictionary *)queryParameters;
@end


@implementation IRailAPI

@synthesize delegate, providerUrl, lang;

-(id) initWithDelegate:(id<IRailAPIDelegate>)aDelegate {
    [self initWithDelegate:aDelegate language:@"en" andProviderURL:@"http://api.irail.be"];
    return self;
}

- (id)initWithDelegate:(id<IRailAPIDelegate>)aDelegate andLanguage:(NSString *)aLang {
    
    [self initWithDelegate:aDelegate language:aLang andProviderURL:@"http://api.irail.be"];
    
    return self;
}

- (id)initWithDelegate:(id<IRailAPIDelegate>)aDelegate language:(NSString *)aLang andProviderURL:(NSString *)aProvider {
    
    self = [super init];
    if(self) {
        [self setDelegate:aDelegate];
        [self setProviderUrl:aProvider];
        [self setLang:aLang];
    }
    
    return self;
}

- (NSURL *)generateUrlForPath:(NSString *)path andQueryParameters:(NSDictionary *)queryParameters {
    URLBuilder *urlBuildler = [[URLBuilder alloc] initWithBaseURL:providerUrl];
    
    [urlBuildler appendPath:path];
    [urlBuildler appendField:@"lang" withValue:lang];
    
    if(queryParameters != nil) {
        for(NSString *key in queryParameters) {
            NSString *value = [queryParameters objectForKey:key];
            [urlBuildler appendField:key withValue:value];
        }
    }
    
    NSURL *url = [urlBuildler getURL];
    [urlBuildler release];
    
    return url;    
}

- (void)getStationList {

    NSURL *url = [self generateUrlForPath:@"stations/" andQueryParameters:nil];
    
    IRailAPIAbstractCommand *command = [[IRailAPIStationsCommand alloc] initWithAPIDelegate:delegate andCommandURL:url];
    [command execute];
    
    [url release];    
}

- (void)getInfoForVehicleWithId:(NSString *)vehicleId {
    
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    [query setValue:vehicleId forKey:@"id"];
    NSURL *url = [self generateUrlForPath:@"vehicle/" andQueryParameters:query];
    
    IRailAPIAbstractCommand *command = [[IRailAPIVehicleInfoCommand alloc] initWithAPIDelegate:delegate andCommandURL:url];
    [command execute];
    
    [url release];
    [query release];
}
@end
