//  KFEpubExtractor.m
//  KFEpubKit
//
// Copyright (c) 2013 Rico Becker | KF INTERACTIVE
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
