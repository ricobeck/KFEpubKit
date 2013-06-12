//
//  KFViewController.m
//  KFEpubKit iOS
//
//  Created by Rico Becker on 6/12/13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import "KFViewController.h"
#import "KFEpubController.h"
#import "KFEpubContentModel.h"

@interface KFViewController ()<KFEpubControllerDelegate, UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) KFEpubController *epubController;

@property (nonatomic, strong) KFEpubContentModel *contentModel;

@property (nonatomic) NSUInteger spineIndex;


@end


@implementation KFViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	NSURL *epubURL = [[NSBundle mainBundle] URLForResource:@"tolstoy-war-and-peace" withExtension:@"epub"];
    
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    self.epubController = [[KFEpubController alloc] initWithEpubURL:epubURL andDestinationFolder:documentsURL];
    self.epubController.delegate = self;
    [self.epubController openAsynchronous:YES];
    
    UISwipeGestureRecognizer *swipeRecognizer;
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRecognizer.delegate = self;
    [self.webView addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeRecognizer.delegate = self;
    [self.webView addGestureRecognizer:swipeRecognizer];
}


- (void)didSwipeRight:(UIGestureRecognizer *)recognizer
{
    if (self.spineIndex > 1)
    {
        self.spineIndex--;
        [self updateContentForSpineIndex:self.spineIndex];
    }
}


- (void)didSwipeLeft:(UIGestureRecognizer *)recognizer
{
    if (self.spineIndex < self.contentModel.spine.count)
    {
        self.spineIndex++;
        [self updateContentForSpineIndex:self.spineIndex];
    }
}


#pragma mark Epub Contents


- (void)updateContentForSpineIndex:(NSUInteger)currentSpineIndex
{
    NSString *contentFile = self.contentModel.manifest[self.contentModel.spine[currentSpineIndex]][@"href"];
    NSURL *contentURL = [self.epubController.epubContentBaseURL URLByAppendingPathComponent:contentFile];
    NSLog(@"content URL :%@", contentURL);
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:contentURL];
    [self.webView loadRequest:request];
}


#pragma mark KFEpubControllerDelegate Methods


- (void)epubController:(KFEpubController *)controller willOpenEpub:(NSURL *)epubURL
{
    NSLog(@"will open epub");
}


- (void)epubController:(KFEpubController *)controller didOpenEpub:(KFEpubContentModel *)contentModel
{
    NSLog(@"opened: %@", contentModel.metaData[@"title"]);
    self.contentModel = contentModel;
    self.spineIndex = 4;
    [self updateContentForSpineIndex:self.spineIndex];
}


- (void)epubController:(KFEpubController *)controller didFailWithError:(NSError *)error
{
    NSLog(@"epubController:didFailWithError: %@", error.description);
}


#pragma mark - UIGestureRecognizerDelegate Methods


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
