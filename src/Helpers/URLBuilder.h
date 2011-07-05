//
//  URLBuilder.h
//  iRail Mobile
//
//  Created by Ben Van Houtven on 04/07/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface URLBuilder : NSObject {
    NSString *baseURL;
    NSMutableString *path;
    NSMutableString *query;
}

- (id)initWithBaseURL:(NSString *)aUrl;
- (void)appendPath:(NSString *)path;
- (void)appendField:(NSString *)parameters withValue:(NSString *)value;
- (void)reset;
- (NSURL *)getURL;

@end
