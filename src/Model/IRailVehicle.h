//
//  IRailVehicle.h
//  iRail Mobile
//
//  Created by Ben Van Houtven on 04/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRailVehicleStop.h"

@interface IRailVehicle : NSObject {
    NSString    *vid;
    NSArray     *stops;
}

@property(nonatomic, retain) NSString *vid;
@property(nonatomic, retain) NSArray *stops;

- (id) initWithVehicleId:(NSString *)aVid andStopList:(NSArray *)aStopList;

@end
