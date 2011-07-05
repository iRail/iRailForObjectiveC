//
//  IRailAbstractParser.h
//  iRail Mobile
//
//  Created by Ben Van Houtven on 04/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IRailAbstractParser : NSObject<NSXMLParserDelegate> {
    NSError *error;
    id result;
}

- (id)parseData:(NSData *)data;
- (id)finish;

@end
