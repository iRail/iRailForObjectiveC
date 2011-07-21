//
//  IRailLiveboard.h
//  iRail Mobile
//
//  Created by Ben Van Houtven on 10/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRailStation.h"
#import "IRailArrivalDeparture.h"

@interface IRailLiveboard : NSObject {
    IRailStation    *station;
    NSArray         *departureList;
}

@property(nonatomic, retain) IRailStation *station;
@property(nonatomic, retain) NSArray *departureList;

@end
