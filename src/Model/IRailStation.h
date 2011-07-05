//
//  IRailStation.h
//  iRail mobile
//
//  Created by Ben Van Houtven on 03/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IRailStation : NSObject {
    NSString    *sid;
    NSString    *name;
    double      xCoord, yCoord;
}

@property(nonatomic, retain) NSString *sid;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, assign) double xCoord;
@property(nonatomic, assign) double yCoord;

@end
