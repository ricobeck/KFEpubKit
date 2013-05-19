//  KFEpubController.h
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

@property (nonatomic, readonly, strong) NSURL *epubContentBaseURL;

@property (nonatomic, readonly, strong) KFEpubContentModel *contentModel;


- (instancetype)initWithEpubURL:(NSURL *)epubURL andDestinationFolder:(NSURL *)destinationURL;

- (void)openAsynchronous:(BOOL)asynchronous;


@end
