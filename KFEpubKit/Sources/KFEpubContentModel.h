//
//  KFEpubContentModel.h
//  KFEpubKit
//
//  Created by rick on 24.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFEpubContentModel : NSObject


@property (nonatomic, strong) NSDictionary *metaData;
@property (nonatomic, strong) NSDictionary *manifest;
@property (nonatomic, strong) NSArray *spine;
@property (nonatomic, strong) NSArray *guide;


@end
