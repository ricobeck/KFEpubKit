//
//  KFEpubParser.h
//  KFEpubKit
//
//  Created by rick on 24.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KFEpubParser;
@class KFEpubContentModel;


@protocol KFEpubParserDelegate <NSObject>


@optional


- (void)epubParser:(KFEpubParser *)epubParser didFindRootPath:(NSString*)rootPath;

- (void)epubParser:(KFEpubParser *)epubParser didFinishParsingContent:(KFEpubContentModel *)content;

- (void)epubParser:(KFEpubParser *)epubPArser failedWithError:(NSError *)error;


@end


@interface KFEpubParser : NSObject


@property (nonatomic, strong) id<KFEpubParserDelegate> delegate;


- (instancetype)initWithBaseURL:(NSURL *)baseURL;

- (BOOL)startParsing;


@end
