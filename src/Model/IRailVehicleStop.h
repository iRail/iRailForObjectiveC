//
//  IRailStop.h
//  iRail Mobile
//
//  Created by Ben Van Houtven on 04/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRailStation.h"

@interface IRailVehicleStop : NSObject {
    IRailStation *station;
    NSDate *date;
    int delay;
}

@property(nonatomic, retain) IRailStation *station;
@property(nonatomic, retain) NSDate *date;
@property(nonatomic, assign) int delay;

- (id)initWithStation:(IRailStation *)aStation date:(NSDate *)aDate andDelay:(int)aDelay;

@end
