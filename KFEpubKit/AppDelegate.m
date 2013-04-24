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


@end


@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSData *securityBookmark = [[NSUserDefaults standardUserDefaults] objectForKey:@"appDirectory"];
    if (!securityBookmark)
    {
        NSOpenPanel *panel = [NSOpenPanel openPanel];
        
        [panel setCanChooseFiles:NO];
        [panel setCanChooseDirectories:YES];
        [panel setAllowsMultipleSelection:NO];
        
        [panel beginWithCompletionHandler:^(NSInteger result)
        {
            if (result == NSFileHandlingPanelOKButton)
            {
                for (NSURL *fileURL in [panel URLs])
                {
                    
                }
                [self testEpubsInMainBundleResources];
            }
        }];
    }
    else
    {
        [self testEpubsInMainBundleResources];
    }
}


- (void)testEpubsInMainBundleResources
{
     self.epubController = [[KFEpubController alloc] init];
}

@end
