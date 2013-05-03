//
//  KFEpubParser.h
//  KFEpubKit
//
//  Created by rick on 24.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KFEpubConstants.h"

@class KFEpubParser;


@interface KFEpubParser : NSObject


- (KFEpubKitBookType)bookTypeForBaseURL:(NSURL *)baseURL;

- (KFEpubKitBookEncryption)contentEncryptionForBaseURL:(NSURL *)baseURL;

- (NSURL *)rootFileForBaseURL:(NSURL *)baseURL;

- (NSString *)coverPathComponentFromDocument:(NSXMLDocument *)document;

- (NSDictionary *)metaDataFromDocument:(NSXMLDocument *)document;

- (NSArray *)spineFromDocument:(NSXMLDocument *)document;

- (NSDictionary *)manifestFromDocument:(NSXMLDocument *)document;

- (NSArray *)guideFromDocument:(NSXMLDocument *)document;


@end
