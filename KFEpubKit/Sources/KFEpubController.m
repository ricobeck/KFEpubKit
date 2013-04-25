//
//  KFEpubController.m
//  KFEpubKit
//
//  Created by rick on 24.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import "KFEpubController.h"
#import "KFEpubConstants.h"
#import "KFEpubExtractor.h"
#import "KFEpubParser.h"
#import "KFEpubContentModel.h"


@interface KFEpubController ()<KFEpubExtractorDelegate>


@property (nonatomic, strong) KFEpubExtractor *extractor;
@property (nonatomic, strong) KFEpubParser *parser;


@end


@implementation KFEpubController


- (instancetype)initWithEpubURL:(NSURL *)epubURL andDestinationFolder:(NSURL *)destinationURL
{
    self = [super init];
    if (self)
    {
        _epubURL = epubURL;
        _destinationURL = destinationURL;
    }
    return self;
}


- (void)openAsynchronous:(BOOL)asynchronous
{
    self.extractor = [[KFEpubExtractor alloc] initWithEpubURL:self.epubURL andDestinationURL:self.destinationURL];
    self.extractor.delegate = self;
    [self.extractor start:asynchronous];
}


#pragma mark KFEpubExtractorDelegate Methods


- (void)epubExtractorDidStartExtracting:(KFEpubExtractor *)epubExtractor
{
    if ([self.delegate respondsToSelector:@selector(epubController:willOpenEpub:)])
    {
        [self.delegate epubController:self willOpenEpub:self.epubURL];
    }
}


- (void)epubExtractorDidFinishExtracting:(KFEpubExtractor *)epubExtractor
{
    self.parser = [KFEpubParser new];
    NSURL *rootFile = [self.parser rootFileForBaseURL:self.destinationURL];
    NSError *error = nil;
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithContentsOfURL:rootFile options:kNilOptions error:&error];
    if (document)
    {
        _contentModel = [KFEpubContentModel new];
        
        self.contentModel.metaData = [self.parser metaDataFromDocument:document];
        
        if (!self.contentModel.metaData)
        {
            NSError *error = [NSError errorWithDomain:KFEpubKitErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: @"No meta data found"}];
            [self.delegate epubController:self didFailWithError:error];
        }
        else
        {
            self.contentModel.manifest = [self.parser manifestFromDocument:document];
            self.contentModel.spine = [self.parser spineFromDocument:document];
            self.contentModel.guide = [self.parser guideFromDocument:document];

            if (self.delegate)
            {
                [self.delegate epubController:self didOpenEpub:self.contentModel];
            }
        }
    }
}


- (void)epubExtractor:(KFEpubExtractor *)epubExtractor didFailWithError:(NSError *)error
{
    if (self.delegate)
    {
        [self.delegate epubController:self didFailWithError:error];
    }
}


@end
