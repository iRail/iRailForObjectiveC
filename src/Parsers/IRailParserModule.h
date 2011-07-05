//
//  IRailParser.h
//  iRail mobile
//
//  Created by Ben Van Houtven on 03/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol IRailParserModule <NSObject>

- (id) parseData:(NSData *)data;

@end
