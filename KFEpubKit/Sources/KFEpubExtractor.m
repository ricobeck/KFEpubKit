//
//  KFEpubExtractor.m
//  KFEpubKit
//
//  Created by rick on 24.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import "KFEpubExtractor.h"

@implementation KFEpubExtractor


- (id)initWithEpubURL:(NSURL *)epubURL andDestinationURL:(NSURL *)destinationURL
{
    self = [super init];
    if (self)
    {
        _epubURL = epubURL;
        _destinationURL = destinationURL;
    }
    return self;
}



- (BOOL)start
{
    if (self.delegate)
    {
        return YES;
    }
    return NO;
}


- (void)cancel
{
    
}


@end
