//
//  KFEpubExtractor.m
//  KFEpubKit
//
//  Created by rick on 24.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import "KFEpubExtractor.h"
#import <SSZipArchive.h>

@interface KFEpubExtractor ()

@property (nonatomic, strong) NSOperationQueue *extractingQueue;


@end

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
        if ([self.delegate respondsToSelector:@selector(epubExtractorDidStartExtracting:)])
        {
            [self.delegate epubExtractorDidStartExtracting:self];
        }
        self.extractingQueue = [[NSOperationQueue alloc] init];
        [self.extractingQueue addOperationWithBlock:^{
            
            [SSZipArchive unzipFileAtPath:self.epubURL.path toDestination:self.destinationURL.path];
        }];
        [self.extractingQueue addOperationWithBlock:^{
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self performSelector:@selector(doneExtracting) withObject:nil afterDelay:.0f];
            }];
        }];
        
        return YES;
    }
    return NO;
}


- (void)doneExtracting
{
    [self.delegate epubExtractorDidFinishExtracting:self];
}


- (void)cancel
{
    [self.extractingQueue cancelAllOperations];
}


- (NSOperationQueue *)extractingQueue
{
    if (!_extractingQueue)
    {
        _extractingQueue = [[NSOperationQueue alloc] init];
        _extractingQueue.maxConcurrentOperationCount = 1;
    }
    return _extractingQueue;
}


@end
