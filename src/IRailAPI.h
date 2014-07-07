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

#import <Foundation/Foundation.h>
#import "IRailConnection.h"

@class IRailVehicle;
@class IRailLiveboard;
@class IRailStation;

typedef void(^StationListCompletion)(NSArray *stationList, NSError *error);
typedef void(^VehicleInfoCompletion)(IRailVehicle *vehicle, NSError *error);
typedef void(^LiveBoardCompletion)(IRailLiveboard *liveboard, NSError *error);
typedef void(^ConnectionsCompletion)(NSArray *connections, NSError *error);

@interface IRailAPI : NSObject

+ (void)callStationListWithCompletion:(StationListCompletion)completion;
+ (void)callInfoForVehicle:(NSString *)vehicleId withCompletion:(VehicleInfoCompletion)completion;
+ (void)callLiveboardCommandForStation:(NSString *)station withCompletion:(LiveBoardCompletion)completion;
+ (void)callConnectionCommandWithDepartureName:(NSString *)fromName andArrivalName:(NSString *)toName completion:(ConnectionsCompletion)completion;
+ (void)callConnectionCommandWithDepartureName:(NSString *)fromName arrivalName:(NSString *)toName date:(NSDate *)date andDateType:(IRailDateType)dateType completion:(ConnectionsCompletion)completion;

@end

/**
 *  Separate object for settings
 */
@interface IRailAPISettings : NSObject

+ (IRailAPISettings *)sharedSettings;

@property (strong, nonatomic) NSString *language; // default: @"en"
@property (strong, nonatomic) NSString *baseUrl; // default: @"http://api.irail.be"

@end