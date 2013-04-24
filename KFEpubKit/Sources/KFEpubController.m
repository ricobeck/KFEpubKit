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

@interface KFEpubController ()<KFEpubExtractorDelegate, KFEpubParserDelegate>


@property (nonatomic, strong) KFEpubExtractor *extractor;
@property (nonatomic, strong) KFEpubParser *parser;


@end


@implementation KFEpubController


- (instancetype)initWithEpubURL:(NSURL *)epubURL andDestinationFolder:(NSURL *)destinationURL
{
    self = [super init];
    if (self)
    {
        _destinationURL = destinationURL;
        
        self.extractor = [[KFEpubExtractor alloc] initWithEpubURL:epubURL andDestinationURL:destinationURL];
        self.extractor.delegate = self;
    }
    return self;
}


#pragma mark KFEpubExtractorDelegate Methods


- (void)epubExtractorDidStartExtracting:(KFEpubExtractor *)epubExtractor
{
    
}


- (void)epubExtractorDidFinishExtracting:(KFEpubExtractor *)epubExtractor
{
    self.parser = [[KFEpubParser alloc] initWithBaseURL:self.destinationURL];
    self.parser.delegate = self;
}


- (void)epubExtractor:(KFEpubExtractor *)epubExtractor didFailWithError:(NSError *)error
{
    
}


#pragma mark KFEpubParserDelegate Methods


- (void)epubParser:(KFEpubParser *)epubParser didFindRootPath:(NSString*)rootPath
{
    
}


- (void)epubParser:(KFEpubParser *)epubParser didFinishParsingContent:(KFEpubContentModel *)content
{
    
}


- (void)epubParser:(KFEpubParser *)epubPArser failedWithError:(NSError *)error
{
    
}


@end
