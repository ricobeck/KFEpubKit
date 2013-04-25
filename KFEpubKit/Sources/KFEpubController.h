//
//  KFEpubController.h
//  KFEpubKit
//
//  Created by rick on 24.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>


@class KFEpubController;
@class KFEpubContentModel;


@protocol KFEpubControllerDelegate <NSObject>


- (void)epubController:(KFEpubController *)controller didOpenEpub:(KFEpubContentModel *)contentModel;

- (void)epubController:(KFEpubController *)controller didFailWithError:(NSError *)error;

@optional

- (void)epubController:(KFEpubController *)controller willOpenEpub:(NSURL *)epubURL;


@end


@interface KFEpubController : NSObject


@property (nonatomic, weak) id<KFEpubControllerDelegate> delegate;


@property (nonatomic, readonly, strong) NSURL *epubURL;

@property (nonatomic, readonly, strong) NSURL *destinationURL;

@property (nonatomic, readonly, strong) KFEpubContentModel *contentModel;


- (instancetype)initWithEpubURL:(NSURL *)epubURL andDestinationFolder:(NSURL *)destinationURL;

- (void)openAsynchronous:(BOOL)asynchronous;


@end
