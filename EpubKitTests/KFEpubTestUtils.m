//
//  KFEpubTestUtils.m
//  KFEpubKit
//
//  Created by rick on 25.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import "KFEpubTestUtils.h"


@implementation KFEpubTestUtils


+ (NSURL *)tempDirectory
{
    NSString *tempDir = NSTemporaryDirectory();
    if (tempDir == nil)
    {
        tempDir = @"/tmp";
    }
    
    NSString *template = [tempDir stringByAppendingPathComponent: @"temp.XXXXXX"];
    const char *fsTemplate = [template fileSystemRepresentation];
    NSMutableData *bufferData = [NSMutableData dataWithBytes:fsTemplate length:strlen(fsTemplate)+1];
    char * buffer = [bufferData mutableBytes];
    mkdtemp(buffer);
    NSString *temporaryDirectory = [[NSFileManager defaultManager] stringWithFileSystemRepresentation: buffer length: strlen(buffer)];
    return [[NSURL alloc] initFileURLWithPath:temporaryDirectory];
}


+ (NSURL *)epubNamed:(NSString *)name
{
    NSURL *epubURL = [[NSBundle bundleForClass:self.class] URLForResource:[name stringByDeletingPathExtension] withExtension:[name pathExtension]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:epubURL.path];
    if (fileExists)
    {
        return epubURL;
    }
    else
    {
        return nil;
    }
}


@end
