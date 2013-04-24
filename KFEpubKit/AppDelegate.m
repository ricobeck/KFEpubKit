//
//  AppDelegate.m
//  KFEpubKit
//
//  Created by rick on 24.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import "AppDelegate.h"
#import "KFEpubController.h"

@interface AppDelegate ()


@property (nonatomic, strong) KFEpubController *epubController;
@property (nonatomic, strong) NSURL *libraryURL;


@end


@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSData *securityBookmark = [[NSUserDefaults standardUserDefaults] objectForKey:@"appDirectory"];
    if (!securityBookmark)
    {
        [self requestLibraryURL];
    }
    else
    {
        NSError *error = nil;
        BOOL dataIsStale;
        self.libraryURL = [NSURL URLByResolvingBookmarkData:securityBookmark options:NSURLBookmarkResolutionWithSecurityScope relativeToURL:nil bookmarkDataIsStale:&dataIsStale error:&error];
        
        if (error)
        {
            [self requestLibraryURL];
        }
        else
        {
            [self testEpubsInMainBundleResources];
        }
    }
}


- (void)requestLibraryURL
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    panel.title = @"Select or create a Library Folder";
    panel.canChooseFiles = NO;
    panel.canCreateDirectories = YES;
    panel.canChooseDirectories = YES;
    panel.allowsMultipleSelection = NO;
        
    [panel beginWithCompletionHandler:^(NSInteger result)
     {
         if (result == NSFileHandlingPanelOKButton)
         {
             NSError *error = nil;
             for (NSURL *fileURL in [panel URLs])
             {
                 self.libraryURL = fileURL;
                 NSData *securityBookmark = [fileURL bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope includingResourceValuesForKeys:nil relativeToURL:nil error:&error];
                 [[NSUserDefaults standardUserDefaults] setValue:securityBookmark forKey:@"appDirectory"];
             }
             [self testEpubsInMainBundleResources];
         }
     }];
}


- (void)testEpubsInMainBundleResources
{
    NSURL *epubURL = [[NSBundle mainBundle] URLForResource:@"TDD-for-iOS" withExtension:@"epub"];
    
    [self.libraryURL startAccessingSecurityScopedResource];
    self.epubController = [[KFEpubController alloc] initWithEpubURL:epubURL andDestinationFolder:self.libraryURL];
}

@end
