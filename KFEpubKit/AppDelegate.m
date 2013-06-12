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
#import <KFToolbar/KFToolbar.h>


@interface AppDelegate ()<KFEpubControllerDelegate>


@property (nonatomic, strong) KFEpubController *epubController;
@property (nonatomic, strong) NSURL *libraryURL;
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet KFToolbar *bottomToolbar;

@property (nonatomic) NSUInteger spineIndex;
@property (nonatomic, strong) KFEpubContentModel *contentModel;


@end


@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    KFToolbarItem *previousSpine = [KFToolbarItem toolbarItemWithIcon:[NSImage imageNamed:NSImageNameGoLeftTemplate] tag:0];
    [previousSpine setToolTip:NSLocalizedString(@"Previous", nil)];
    previousSpine.keyEquivalent = @"a";
    previousSpine.keyEquivalentModifierMask = NSAlternateKeyMask;
    
    KFToolbarItem *nextSpine = [KFToolbarItem toolbarItemWithIcon:[NSImage imageNamed:NSImageNameGoRightTemplate] tag:1];
    [nextSpine setToolTip:NSLocalizedString(@"Next", nil)];
    nextSpine.keyEquivalent = @"s";
    nextSpine.keyEquivalentModifierMask = NSAlternateKeyMask;
    
    self.bottomToolbar.leftItems = @[previousSpine];
    self.bottomToolbar.rightItems = @[nextSpine];
    
    [self.bottomToolbar setItemSelectionHandler:^(KFToolbarItemSelectionType selectionType, KFToolbarItem *toolbarItem, NSUInteger tag) {
        switch (tag)
        {
            case 0:
                if (self.spineIndex > 1)
                {
                    self.spineIndex--;
                    [self updateContentForSpineIndex:self.spineIndex];
                }
                break;
            case 1:
                if (self.spineIndex < self.contentModel.spine.count)
                {
                    self.spineIndex++;
                    [self updateContentForSpineIndex:self.spineIndex];
                }
                break;
            default:
                break;
        }
    }];
    
    
    self.textView.textContainerInset = NSMakeSize(40.0f, 40.0f);
    
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


- (void)updateContentForSpineIndex:(NSUInteger)currentSpineIndex
{
    NSString *contentFile = self.contentModel.manifest[self.contentModel.spine[currentSpineIndex]][@"href"];
    NSURL *contentURL = [self.epubController.epubContentBaseURL URLByAppendingPathComponent:contentFile];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithURL:contentURL documentAttributes:nil];
    [self.textView.textStorage setAttributedString:attributedString];
}


#pragma mark KFEpubControllerDelegate Methods


- (void)epubController:(KFEpubController *)controller willOpenEpub:(NSURL *)epubURL
{
    NSLog(@"will open epub");
}


- (void)epubController:(KFEpubController *)controller didOpenEpub:(KFEpubContentModel *)contentModel
{
    self.window.title = contentModel.metaData[@"title"];
    self.contentModel = contentModel;
    self.spineIndex = 1;
    [self updateContentForSpineIndex:self.spineIndex];
}


- (void)epubController:(KFEpubController *)controller didFailWithError:(NSError *)error
{
    NSLog(@"epubController:didFailWithError: %@", error.description);
}

@end
