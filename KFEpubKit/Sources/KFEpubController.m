//
//  KFEpubController.m
//  KFEpubKit
//
//  Created by rick on 24.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import "KFEpubController.h"
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


- (void)open
{
    self.extractor = [[KFEpubExtractor alloc] initWithEpubURL:self.epubURL andDestinationURL:self.destinationURL];
    self.extractor.delegate = self;
    [self.extractor start];
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
        self.contentModel.manifest = [self.parser manifestFromDocument:document];
        self.contentModel.spine = [self.parser spineFromDocument:document];
        
        [_contentModel.spine enumerateObjectsUsingBlock:^(NSString *item, NSUInteger idx, BOOL *stop)
        {
            if (idx > 0)
            {
                NSLog(@"%@", self.contentModel.manifest[item]);
            }
        }];
        
        if (self.delegate)
        {
            [self.delegate epubController:self didOpenEpub:self.contentModel];
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
