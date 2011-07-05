//
//  IRailAPI.h
//  iRail mobile
//
//  Created by Ben Van Houtven on 03/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRailAPIDelegate.h"

#import "IRailStation.h"
#import "IRailVehicle.h"

@interface IRailAPI : NSObject {
    id<IRailAPIDelegate> delegate;
    NSString *providerUrl;
    NSString *lang;
}

@property(nonatomic, retain) id<IRailAPIDelegate> delegate;
@property(nonatomic, retain) NSString* lang;
@property(nonatomic, retain) NSString* providerUrl;

- (id)initWithDelegate:(id<IRailAPIDelegate>)aDelegate;
- (id)initWithDelegate:(id<IRailAPIDelegate>)aDelegate andLanguage:(NSString *)aLang;
- (id)initWithDelegate:(id<IRailAPIDelegate>)aDelegate language:(NSString *)aLang andProviderURL:(NSString *)aProvider;

- (void)getStationList;
- (void)getInfoForVehicleWithId:(NSString *)vehicleId;

@end
