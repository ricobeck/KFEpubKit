//  KFEpubExtractorTest.m
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
