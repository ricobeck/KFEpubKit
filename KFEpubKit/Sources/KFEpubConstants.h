//
//  KFEpubConstants.h
//  KFEpubKit
//
//  Created by rick on 25.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const KFEpubKitErrorDomain;


typedef NS_ENUM(NSUInteger, KFEpubKitBookType)
{
    KFEpubKitBookTypeUnknown,
    KFEpubKitBookTypeEpub2,
    KFEpubKitBookTypeEpub3,
    KFEpubKitBookTypeiBook
};


@interface KFEpubConstants : NSObject

@end
