//
//  KFEpubTestUtils.h
//  KFEpubKit
//
//  Created by rick on 25.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KFEpubTestUtils : NSObject


+ (NSURL *)tempDirectory;

+ (NSURL *)epubNamed:(NSString *)name;


@end
