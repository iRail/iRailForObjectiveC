//
//  IRailAPIDelegate.h
//  iRail Mobile
//
//  Created by Ben Van Houtven on 04/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRailVehicle;

@protocol IRailAPIDelegate <NSObject>

- (void)iRailApiCommandDidFailWithError:(NSError *)error;

@optional
- (void)iRailApiCommandDidFinishReceivingStationList:(NSArray *)stationList;
- (void)iRailApiCommandDidFinishReceivingVehicleInfo:(IRailVehicle *)vehicle;

@end