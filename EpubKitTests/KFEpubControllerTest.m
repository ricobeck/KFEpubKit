//
//  KFEpubControllerTest.m
//  KFEpubKit
//
//  Created by rick on 25.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
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


@end
