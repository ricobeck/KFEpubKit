//  KFEpubControllerTest.m
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
#import "GHTestCase.h"
#import <OCMock/OCMock.h>
#import "KFEpubTestUtils.h"
#import "KFEpubController.h"
#import "KFEpubConstants.h"
#import "KFEpubContentModel.h"


@interface KFEpubControllerTest : GHTestCase


@end


@implementation KFEpubControllerTest



- (void)testOpenEpub
{
    KFEpubController *epubController = [[KFEpubController alloc] initWithEpubURL:[KFEpubTestUtils epubNamed:@"tolstoy-war-and-peace.epub"] andDestinationFolder:[KFEpubTestUtils tempDirectory]];
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(KFEpubControllerDelegate)];
    [[mockDelegate expect] epubController:OCMOCK_ANY willOpenEpub:OCMOCK_ANY];
    epubController.delegate = mockDelegate;
    
    [epubController openAsynchronous:NO];
    GHAssertNoThrow([mockDelegate verify], @"epubController:willOpenEpub: was not called");
}


- (void)testOpenEpubWithInvalidEpubURL
{
    KFEpubController *epubController = [[KFEpubController alloc] initWithEpubURL:nil andDestinationFolder:[KFEpubTestUtils tempDirectory]];
    
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(KFEpubControllerDelegate)];
    [[mockDelegate expect] epubController:epubController didFailWithError:OCMOCK_ANY];
    epubController.delegate = mockDelegate;
    
    [epubController openAsynchronous:NO];
    GHAssertNoThrow([mockDelegate verify], @"epubController:didFailWithError: was not called");
}


- (void)testBookTypeFromEpub
{
    KFEpubController *epubController = [[KFEpubController alloc] initWithEpubURL:[KFEpubTestUtils epubNamed:@"tolstoy-war-and-peace.epub"] andDestinationFolder:[KFEpubTestUtils tempDirectory]];
    [epubController openAsynchronous:NO];
    
    KFEpubKitBookType bookType = epubController.contentModel.bookType;
    GHAssertEquals(bookType, KFEpubKitBookTypeEpub2, @"book type should be epub");
}


- (void)testEncryptionDetectionWithFairplay
{
    KFEpubController *epubController = [[KFEpubController alloc] initWithEpubURL:[KFEpubTestUtils epubNamed:@"Winnie-the-Pooh.epub"] andDestinationFolder:[KFEpubTestUtils tempDirectory]];
    [epubController openAsynchronous:NO];
    
    KFEpubKitBookEncryption bookEncryption = epubController.contentModel.bookEncryption;
    GHAssertEquals(bookEncryption, KFEpubKitBookEnryptionFairplay, @"book encryption must be fairplay");
}


- (void)testEncryptionDetectionWithUnencryptedBook
{
    KFEpubController *epubController = [[KFEpubController alloc] initWithEpubURL:[KFEpubTestUtils epubNamed:@"tolstoy-war-and-peace.epub"] andDestinationFolder:[KFEpubTestUtils tempDirectory]];
    [epubController openAsynchronous:NO];
    
    KFEpubKitBookEncryption bookEncryption = epubController.contentModel.bookEncryption;
    GHAssertEquals(bookEncryption, KFEpubKitBookEnryptionNone, @"book encryption must be none");
}


- (void)testCoverImagePathWithBookContainingMetaElement
{
    KFEpubController *epubController = [[KFEpubController alloc] initWithEpubURL:[KFEpubTestUtils epubNamed:@"Winnie-the-Pooh.epub"] andDestinationFolder:[KFEpubTestUtils tempDirectory]];
    [epubController openAsynchronous:NO];
    
    NSString *coverImage = epubController.contentModel.coverPath;
    GHAssertNotNil(coverImage, @"cover path must not be nil for a book containing valid meta data");
    GHAssertEqualStrings(coverImage, @"images/cover.jpg", @"cover image path is wrong.");
}


@end
