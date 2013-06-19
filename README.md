KFEpubKit
=========

An Objective-C epub extracting and parsing framework for OSX and iOS.


![Alt Example Screenshots](/Images/KFEpubKitExamples.png "KFEpubKit on different plattform and devices")

#Usage

Load from a local URL …

	NSURL *epubURL = [[NSBundle mainBundle] URLForResource:@"tolstoy-war-and-peace" withExtension:@"epub"];
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    self.epubController = [[KFEpubController alloc] initWithEpubURL:epubURL andDestinationFolder:documentsURL];
    self.epubController.delegate = self;
    [self.epubController openAsynchronous:YES];
    
… and add delegate methods

	- (void)epubController:(KFEpubController *)controller didOpenEpub:(KFEpubContentModel *)contentModel
	{
    	NSLog(@"opened: %@", contentModel.metaData[@"title"]);
	}
In-depth usage is explained in the included examples for both OSX and iOS.