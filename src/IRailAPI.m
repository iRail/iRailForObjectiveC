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
#import "IRailAPILiveboardCommand.h"
#import "IRailAPIConnectionCommand.h"


@implementation IRailAPI

+ (IRailAPI *)shared
{
    //  Static local predicate must be initialized to 0
    static IRailAPI *shared = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        shared = [[IRailAPI alloc] initWithLanguage:@"en" andProviderURL:@"http://api.irail.be"];
    });
    return shared;
}


- (instancetype)initWithLanguage:(NSString *)aLang andProviderURL:(NSString *)aProvider {
    
    self = [super init];
    if(self) {
        [self setProviderUrl:aProvider];
        [self setLang:aLang];
    }
    
    return self;
}

- (NSURL *)generateUrlForPath:(NSString *)path andQueryParameters:(NSDictionary *)queryParameters {
    URLBuilder *urlBuilder = [[URLBuilder alloc] initWithBaseURL:self.providerUrl];
    
    [urlBuilder appendPath:path];
    [urlBuilder appendField:@"lang" withValue:self.lang];
    
    if(queryParameters != nil) {
        for(NSString *key in queryParameters) {
            NSString *value = [queryParameters objectForKey:key];
            [urlBuilder appendField:key withValue:value];
        }
    }
    
    return [urlBuilder getURL];
}

- (void)callStationListWithCompletion:(StationListCompletion)completion {
    
    NSURL *url = [self generateUrlForPath:@"stations/" andQueryParameters:nil];
    IRailAPIAbstractCommand *command = [[IRailAPIStationsCommand alloc] initWithCommandURL:url completion:completion];
    [command execute];
}

- (void)callInfoForVehicle:(NSString *)vehicleId withCompletion:(VehicleInfoCompletion)completion {
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    [query setValue:vehicleId forKey:@"id"];
    NSURL *url = [self generateUrlForPath:@"vehicle/" andQueryParameters:query];
    
    IRailAPIAbstractCommand *command = [[IRailAPIVehicleInfoCommand alloc] initWithCommandURL:url completion:completion];
    [command execute];
    
}

- (void)callLiveboardCommandForStation:(NSString *)station withCompletion:(LiveBoardCompletion)completion {

    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    [query setValue:station forKey:@"station"];
    NSURL *url = [self generateUrlForPath:@"liveboard/" andQueryParameters:query];

    IRailAPIAbstractCommand *command = [[IRailAPILiveboardCommand alloc] initWithCommandURL:url completion:completion];
    [command execute];

}

- (void)callConnectionCommandWithDepartureName:(NSString *)fromName arrivalName:(NSString *)toName date:(NSDate *)date andDateType:(IRailDateType)dateType completion:(ConnectionsCompletion)completion {
    
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    [query setValue:fromName forKey:@"from"];
    [query setValue:toName forKey:@"to"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMyy"];
    [query setValue:[dateFormatter stringFromDate:date] forKey:@"date"];
    
    [dateFormatter setDateFormat:@"hhmm"];
    [query setValue:[dateFormatter stringFromDate:date] forKey:@"time"];
    
    switch( dateType ) {
        case DATE_ARRIVAL:
            [query setValue:@"arrive" forKey:@"timeSel"];
            break;
        case DATE_DEPARTURE:
            [query setValue:@"depart" forKey:@"timeSel"];
            break;
    }
    
    NSURL *url = [self generateUrlForPath:@"connections/" andQueryParameters:query];
    
    IRailAPIAbstractCommand *command = [[IRailAPIConnectionCommand alloc] initWithCommandURL:url completion:completion];
    [command execute];
}

- (void)callConnectionCommandWithDepartureName:(NSString *)fromName andArrivalName:(NSString *)toName completion:(ConnectionsCompletion)completion {
    
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    [query setValue:fromName forKey:@"from"];
    [query setValue:toName forKey:@"to"];
    
    NSURL *url = [self generateUrlForPath:@"connections/" andQueryParameters:query];
    
    IRailAPIAbstractCommand *command = [[IRailAPIConnectionCommand alloc] initWithCommandURL:url completion:completion];
    [command execute];
}

@end
