//
//  IRailAPIAbstractCommand.h
//  iRail Mobile
//
//  Created by Ben Van Houtven on 04/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRailAPIDelegate.h"
#import "IRailParserModule.h"

@interface IRailAPIAbstractCommand : NSObject {
    NSMutableData           *apiResponseData;
    
    NSURL                   *commandURL;
    id<IRailAPIDelegate>    delegate;
    id<IRailParserModule>   parser;
}

- (id)initWithAPIDelegate:(id<IRailAPIDelegate>)aDelegate andCommandURL:(NSURL *)aUrl;
- (void)execute;

@end
