//
//  IRailAPIVehicleInfoCommand.m
//  iRail Mobile
//
//  Created by Ben Van Houtven on 04/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "IRailAPIVehicleInfoCommand.h"
#import "IRailVehicleInfoParser.h"


@implementation IRailAPIVehicleInfoCommand

- (id)initWithAPIDelegate:(id<IRailAPIDelegate>)aDelegate andCommandURL:(NSURL *)aUrl {
    self = [super initWithAPIDelegate:aDelegate andCommandURL:aUrl];
    if (self) {
        self->parser = [[IRailVehicleInfoParser alloc] init];
    }
    
    return self;
}

- (void)finishWithResult:(id)result {
    if ([delegate respondsToSelector:@selector(iRailApiCommandDidFinishReceivingVehicleInfo:)]) {
        [delegate iRailApiCommandDidFinishReceivingVehicleInfo:result];
    }
}

@end
