//
//  IRailVehicleInfoParser.h
//  iRail Mobile
//
//  Created by Ben Van Houtven on 04/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRailAbstractParser.h"

#import "IRailVehicle.h"
#import "IRailVehicleStop.h"

typedef enum {
    NODE_VEHICLE,
    NODE_STOP,
    NODE_STATION,
    NODE_TIME,
    NODE_IGNORE
} IRailVehicleInfoNodeType;


@interface IRailVehicleInfoParser : IRailAbstractParser {
    NSMutableArray              *vehicleStops;
    NSMutableString             *currentText;
    
    IRailStation                *currentStation;
    
    IRailVehicleInfoNodeType    currentNodeType;
}

@end
