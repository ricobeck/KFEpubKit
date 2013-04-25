//
//  KFEpubExtractorTest.m
//  KFEpubKit
//
//  Created by rick on 25.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import <GHUnitOSX/GHUnit.h>
#import <OCMock/OCMock.h>
#import "KFEpubTestUtils.h"
#import "KFEpubExtractor.h"

@interface KFEpubExtractorTest : GHTestCase


@property (nonatomic, strong) KFEpubExtractor *extractor;


@end


@implementation KFEpubExtractorTest


- (void)setUp
{
    self.extractor = [[KFEpubExtractor alloc] initWithEpubURL:[KFEpubTestUtils epubNamed:@"tolstoy-war-and-peace.epub"] andDestinationURL:[KFEpubTestUtils tempDirectory]];
}


- (void)tearDown
{
    self.extractor = nil;
}


- (void)testExtractValidFileToValidPath
{
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(KFEpubExtractorDelegate)];
    [[mockDelegate expect] epubExtractorDidStartExtracting:OCMOCK_ANY];
    [[mockDelegate reject] epubExtractor:OCMOCK_ANY didFailWithError:OCMOCK_ANY];
    self.extractor.delegate = mockDelegate;
    [self.extractor start:NO];

    GHAssertNoThrow([mockDelegate verify], @"epubExtractorDidFinishExtracting was not called");
    GHAssertNotNil(self.extractor.epubURL, @"epub url must not be nil.");
    GHAssertNotNil(self.extractor.destinationURL, @"destinationURL url must not be nil.");
}


- (void)testExtractValidFileToValidPathWithoutDelegate
{
    BOOL didStart = [self.extractor start:NO];
    GHAssertFalse(didStart, @"extraction did not start");
}


- (void)testCancelExtraction
{
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(KFEpubExtractorDelegate)];
    [[mockDelegate expect] epubExtractorDidStartExtracting:OCMOCK_ANY];
    [[mockDelegate expect] epubExtractorDidCancelExtraction:OCMOCK_ANY];
    self.extractor.delegate = mockDelegate;
    [self.extractor start:NO];
    [self.extractor cancel];
    GHAssertNoThrow([mockDelegate verify], @"epubExtractorDidFinishExtracting was not called");
}


@end
