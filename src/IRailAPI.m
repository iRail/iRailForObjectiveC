//
//  IRailAPI.m
//  iRail mobile
//
//  Created by Ben Van Houtven on 03/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

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
