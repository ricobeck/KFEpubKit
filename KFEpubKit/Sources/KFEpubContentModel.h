//
//  KFEpubContentModel.h
//  KFEpubKit
//
//  Created by rick on 24.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFEpubContentModel : NSObject


@property (nonatomic, strong) NSMutableDictionary *manifest;
@property (nonatomic, strong) NSMutableArray *spine;


@end
