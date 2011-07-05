//
//  IRailStationParser.h
//  iRail mobile
//
//  Created by Ben Van Houtven on 03/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRailAbstractParser.h"
#import "IRailStation.h"

@interface IRailStationListParser : IRailAbstractParser {
    IRailStation *currentStation;
    NSMutableString *currentStationName;
}

@end
