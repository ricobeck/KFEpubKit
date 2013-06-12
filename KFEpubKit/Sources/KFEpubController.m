//  KFEpubController.m
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
    _epubContentBaseURL = [rootFile URLByDeletingLastPathComponent];
    
    NSError *error = nil;
    NSString *content = [NSString stringWithContentsOfURL:rootFile encoding:NSUTF8StringEncoding error:&error];
    DDXMLDocument *document = [[DDXMLDocument alloc] initWithXMLString:content options:kNilOptions error:&error];
    if (document)
    {
        _contentModel = [KFEpubContentModel new];
        
        self.contentModel.bookType = [self.parser bookTypeForBaseURL:self.destinationURL];
        self.contentModel.bookEncryption = [self.parser contentEncryptionForBaseURL:self.destinationURL];
        self.contentModel.metaData = [self.parser metaDataFromDocument:document];
        self.contentModel.coverPath = [self.parser coverPathComponentFromDocument:document];
        
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
