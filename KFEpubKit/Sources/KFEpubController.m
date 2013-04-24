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
        _destinationURL = destinationURL;
        
        self.extractor = [[KFEpubExtractor alloc] initWithEpubURL:epubURL andDestinationURL:destinationURL];
        self.extractor.delegate = self;
        [self.extractor start];
    }
    return self;
}


#pragma mark KFEpubExtractorDelegate Methods


- (void)epubExtractorDidStartExtracting:(KFEpubExtractor *)epubExtractor
{
    NSLog(@"epubExtractorDidStartExtracting");
}


- (void)epubExtractorDidFinishExtracting:(KFEpubExtractor *)epubExtractor
{
    NSLog(@"epubExtractorDidFinishExtracting");
    self.parser = [KFEpubParser new];
    NSURL *rootFile = [self.parser rootFileForBaseURL:self.destinationURL];
    NSError *error = nil;
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithContentsOfURL:rootFile options:kNilOptions error:&error];
    if (document)
    {
        NSDictionary *metaData = [self.parser metaDataFromDocument:document];
        NSLog(@"meta: %@", metaData);
        
        NSDictionary *manifest = [self.parser manifestFromDocument:document];
        NSArray *spine = [self.parser spineFromDocument:document];
        
        [spine enumerateObjectsUsingBlock:^(NSString *item, NSUInteger idx, BOOL *stop)
        {
            if (idx > 0)
            {
                NSLog(@"%@", manifest[item]);
            }
        }];
        
    }
}


- (void)epubExtractor:(KFEpubExtractor *)epubExtractor didFailWithError:(NSError *)error
{
    NSLog(@"epubExtractor:didFailWithError");
}


@end
