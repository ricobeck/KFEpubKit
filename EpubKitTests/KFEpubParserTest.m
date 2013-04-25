//
//  KFEpubParserTest.m
//  KFEpubKit
//
//  Created by rick on 25.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
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
    GHAssertNotNil(manifest, @"manifest must be nil for nil as document parameter");
}


@end
