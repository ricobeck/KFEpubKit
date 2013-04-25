//
//  KFEpubExtractor.m
//  KFEpubKit
//
//  Created by rick on 24.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import "KFEpubExtractor.h"
#import <SSZipArchive.h>
#import "KFEpubConstants.h"


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



- (BOOL)start:(BOOL)asynchronous
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(epubExtractorDidStartExtracting:)])
        {
            [self.delegate epubExtractorDidStartExtracting:self];
        }
        
        if (asynchronous)
        {
            __block BOOL didSucceed;
            [self.extractingQueue addOperationWithBlock:^{
                
                didSucceed = [SSZipArchive unzipFileAtPath:self.epubURL.path toDestination:self.destinationURL.path];
            }];
            [self.extractingQueue addOperationWithBlock:^{
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [self performSelector:@selector(doneExtracting:) withObject:@(didSucceed) afterDelay:.0f];
                }];
            }];
            
            return YES;
        }
        else
        {
            BOOL didSucceed = [SSZipArchive unzipFileAtPath:self.epubURL.path toDestination:self.destinationURL.path];
            [self doneExtracting:@(didSucceed)];
            return YES;
        }
    }
    return NO;
}


- (void)doneExtracting:(NSNumber *)didSuceed
{
    if (didSuceed.boolValue)
    {
        [self.delegate epubExtractorDidFinishExtracting:self];
    }
    else
    {
        NSError *error = [NSError errorWithDomain:KFEpubKitErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: @"Could not extract ebup file."}];
        [self.delegate epubExtractor:self didFailWithError:error];
    }
}


- (void)cancel
{
    [self.extractingQueue cancelAllOperations];
    if ([self.delegate respondsToSelector:@selector(epubExtractorDidCancelExtraction:)])
    {
        [self.delegate epubExtractorDidCancelExtraction:self];
    }
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
