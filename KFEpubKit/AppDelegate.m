//
//  AppDelegate.m
//  KFEpubKit
//
//  Created by rick on 24.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import "AppDelegate.h"
#import "KFEpubController.h"
#import "KFEpubContentModel.h"


@interface AppDelegate ()<KFEpubControllerDelegate>


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
    
    panel.title = @"Select or create a library folder";
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
    NSURL *epubURL = [[NSBundle mainBundle] URLForResource:@"tolstoy-war-and-peace" withExtension:@"epub"];
    
    [self.libraryURL startAccessingSecurityScopedResource];
    self.epubController = [[KFEpubController alloc] initWithEpubURL:epubURL andDestinationFolder:self.libraryURL];
    self.epubController.delegate = self;
    [self.epubController openAsynchronous:YES];
}


#pragma mark KFEpubControllerDelegate Methods


- (void)epubController:(KFEpubController *)controller willOpenEpub:(NSURL *)epubURL
{
    NSLog(@"will open epub");
}


- (void)epubController:(KFEpubController *)controller didOpenEpub:(KFEpubContentModel *)contentModel
{
    self.window.title = contentModel.metaData[@"title"];
    NSLog(@"start: %@", contentModel.guide[0][@"href"]);
    //[self.libraryURL stopAccessingSecurityScopedResource];
}


- (void)epubController:(KFEpubController *)controller didFailWithError:(NSError *)error
{
    NSLog(@"epubController:didFailWithError: %@", error.description);
    //[self.libraryURL stopAccessingSecurityScopedResource];
}

@end
