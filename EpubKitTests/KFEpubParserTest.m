//  KFEpubParserTest.m
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
//

#import <GHUnitOSX/GHTestCase.h>
#import "KFEpubParser.h"

@interface KFEpubParserTest : GHTestCase

@property (nonatomic, strong) KFEpubParser *epubParser;

@end


@implementation KFEpubParserTest


- (void)setUp
{
    self.epubParser = [KFEpubParser new];
}


- (void)tearDown
{
    self.epubParser = nil;
}


- (NSXMLDocument *)documentNamed:(NSString *)name
{
    NSURL *opfURL = [[NSBundle bundleForClass:self.class] URLForResource:[name stringByDeletingPathExtension] withExtension:[name pathExtension]];
    NSError *error = nil;
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithContentsOfURL:opfURL options:kNilOptions error:&error];
    GHTestLog(@"document named %@: %@", name, document != nil ? @"found" : @"NOT found");
    return document;
}


- (void)testMetaDataFromValidDocument
{
    NSDictionary *metaData = [self.epubParser metaDataFromDocument:[self documentNamed:@"valid.opf"]];
    GHAssertNotNil(metaData[@"title"], @"title must not be nil");
}


- (void)testMetaDataFromValidDocumentWithComments
{
    NSDictionary *metaData = [self.epubParser metaDataFromDocument:[self documentNamed:@"valid-comments.opf"]];
    GHAssertNotNil(metaData[@"title"], @"title must not be nil");
}


- (void)testMetaDataFromNilDocument
{
    NSDictionary *metaData = [self.epubParser metaDataFromDocument:nil];
    GHAssertNil(metaData, @"When no document is given the resulting dictionary has to be a nil object");
}


- (void)testMetaDataFromDocumentWithoutMetaDataNode
{
    NSXMLDocument *document = [[NSXMLDocument alloc] init];
    NSDictionary *metaData = [self.epubParser metaDataFromDocument:document];
    GHAssertNil(metaData, @"when no meta data is found it has to result in a nil object");
}


- (void)testSpineFromValidDocument
{
    NSArray *spine = [self.epubParser spineFromDocument:[self documentNamed:@"valid.opf"]];
    GHAssertNotNil(spine, @"spine must not be nil for a valid document");
}


- (void)testSpineFromNilDocument
{
    NSArray *spine = [self.epubParser spineFromDocument:nil];
    GHAssertNil(spine, @"spine must be nil for nil as document parameter");
}


- (void)testSpineFromDocumentWithoutTOCAttribute
{
    NSXMLDocument *invalidTOCDocument = [self documentNamed:@"invalid-toc.opf"];
    NSArray *spine = [self.epubParser spineFromDocument:invalidTOCDocument];
    GHAssertNotNil(spine, @"spine must be nil for a document without toc attribute in spine node");
}


- (void)testManifestFromValidDocument
{
    NSDictionary *manifest = [self.epubParser manifestFromDocument:[self documentNamed:@"valid.opf"]];
    GHAssertNotNil(manifest, @"manifest must be nil for a valid document");
}


- (void)testManifestFromNilDocument
{
    NSDictionary *manifest = [self.epubParser manifestFromDocument:nil];
    GHAssertNil(manifest, @"manifest must be nil for nil as document parameter");
}


- (void)testManifestFromInvalidDocument
{
    NSDictionary *manifest = [self.epubParser manifestFromDocument:[self documentNamed:@"invalid-manifest.opf"]];
    GHAssertNotNil(manifest, @"manifest must not be nil for nil as document parameter");
}


- (void)testGuideFromValidDocument
{
    NSArray *guide = [self.epubParser guideFromDocument:[self documentNamed:@"valid.opf"]];
    GHAssertNotNil(guide, @"guide must not be nil for a valid document");
}


- (void)testGuideFromNilDocument
{
    NSArray *guide = [self.epubParser guideFromDocument:[self documentNamed:nil]];
    GHAssertNil(guide, @"guide must be nil for a valid document");
}


@end
