/*
 * Copyright (c) 2011 iRail vzw/asbl.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are
 * permitted provided that the following conditions are met:
 *
 *   1. Redistributions of source code must retain the above copyright notice, this list of
 *      conditions and the following disclaimer.
 *
 *   2. Redistributions in binary form must reproduce the above copyright notice, this list
 *      of conditions and the following disclaimer in the documentation and/or other materials
 *      provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * The views and conclusions contained in the software and documentation are those of the
 * authors and should not be interpreted as representing official policies, either expressed
 * or implied, of iRail vzw/asbl.
 */

#import "IRailAbstractParser.h"

@interface IRailAbstractParser ()

@property (nonatomic, strong) NSMutableArray *nodeStack;
@property (nonatomic, strong) NSMutableString *currentContent;
@property (nonatomic) BOOL error;

@end

@implementation IRailAbstractParser

- (instancetype)init {
    self = [super init];
    if (self) {
        self.error = NO;
    }
    
    return self;
}

- (id)parseData:(NSData *)data {
    
    [self startedParsing];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    
    if(!self.error) {
        return [self finishedParsing];
    }
    return nil;
}



- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.nodeStack = [[NSMutableArray alloc] init];
    [self startedParsing];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    IRailParserNode *node = [[IRailParserNode alloc] init];
    node.name = elementName;
    node.attributes = attributeDict;
    
    if ([self.nodeStack count] > 0) {
        IRailParserNode *lastNode = [self.nodeStack lastObject];
        
        [lastNode.children addObject:node];
        node.parent = lastNode;
    }
    
    [self.nodeStack addObject:node];
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(!self.currentContent) {
        self.currentContent = [NSMutableString new];
    }
    
    [self.currentContent appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    IRailParserNode *node = [self.nodeStack lastObject];
    
    NSString *contentString = nil;
    
    if(self.currentContent)contentString = [[NSString alloc] initWithString:self.currentContent];
    node.content = contentString;
    

    self.currentContent = nil;
    
    if ([node.name isEqualToString:@"error"]) {
        //do error stuff...
    } else {
        [self foundElement:[self.nodeStack lastObject]];
    }
    
    [self.nodeStack removeLastObject];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    self.error = YES;
    [self errorOccured];
}


- (void)startedParsing {
    //ABSTRACT METHOD
}

- (void)errorOccured {
    //ABSTRACT METHOD
}

- (id)finishedParsing {
    //ABSTRACT METHOD
    return nil;
}

- (void)foundElement:(IRailParserNode *)element {
    //ABSTRACT METHOD
}

@end
