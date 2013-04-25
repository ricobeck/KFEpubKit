//
//  KFEpubExtractor.h
//  KFEpubKit
//
//  Created by rick on 24.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KFEpubExtractor;

@protocol KFEpubExtractorDelegate <NSObject>


- (void)epubExtractorDidFinishExtracting:(KFEpubExtractor *)epubExtractor;

- (void)epubExtractor:(KFEpubExtractor *)epubExtractor didFailWithError:(NSError *)error;

@optional

- (void)epubExtractorDidStartExtracting:(KFEpubExtractor *)epubExtractor;

- (void)epubExtractorDidCancelExtraction:(KFEpubExtractor *)epubExtractor;

@end


@interface KFEpubExtractor : NSObject


@property (nonatomic, weak) id<KFEpubExtractorDelegate> delegate;

@property (nonatomic, readonly) NSURL *epubURL;

@property (nonatomic, readonly) NSURL *destinationURL;


- (id)initWithEpubURL:(NSURL *)epubURL andDestinationURL:(NSURL *)destinationURL;

- (BOOL)start:(BOOL)asynchronous;

- (void)cancel;


@end
