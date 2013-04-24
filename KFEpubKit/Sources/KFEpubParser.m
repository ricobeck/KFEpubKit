//
//  KFEpubParser.m
//  KFEpubKit
//
//  Created by rick on 24.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import "KFEpubParser.h"
#import "KFEpubContentModel.h"


@interface KFEpubParser ()<NSXMLParserDelegate>


@property (strong) NSXMLParser *parser;
@property (strong) NSString *rootPath;
@property (strong) KFEpubContentModel *contentModel;
@property (strong) NSMutableDictionary *items;
@property (strong) NSMutableArray *spinearray;


@end


@implementation KFEpubParser


- (instancetype)initWithBaseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self)
    {
        NSURL *containerURL = [[baseURL URLByAppendingPathComponent:@"META-INF"] URLByAppendingPathComponent:@"container.xml"];
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL:containerURL];
        self.parser.delegate = self;
    }
    return self;
}


- (BOOL)startParsing
{
    if (self.parser)
    {
        [self.parser parse];
        return YES;
    }
    return NO;
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self.delegate epubParser:self failedWithError:parseError];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	
	if ([elementName isEqualToString:@"rootfile"])
    {
		self.rootPath = [attributeDict valueForKey:@"full-path"];
        
		if ([self.delegate respondsToSelector:@selector(epubParser:didFindRootPath:)])
        {
			[self.delegate epubParser:self didFindRootPath:self.rootPath];
		}
	}
	if ([elementName isEqualToString:@"package"])
    {
		self.contentModel = [[KFEpubContentModel alloc] init];
	}
	else if ([elementName isEqualToString:@"manifest"])
    {
		self.items = [[NSMutableDictionary alloc] init];
	}
	else if ([elementName isEqualToString:@"item"])
    {
		[self.items setValue:[attributeDict valueForKey:@"href"] forKey:[attributeDict valueForKey:@"id"]];
	}
	else if ([elementName isEqualToString:@"spine"])
    {
		self.spinearray=[[NSMutableArray alloc] init];
	}
	else if ([elementName isEqualToString:@"itemref"])
    {
        if (![attributeDict valueForKey:@"linear"] || ![[attributeDict valueForKey:@"linear"] isEqualToString:@"no"])
        {
            [self.spinearray addObject:[attributeDict valueForKey:@"idref"]];
        }
	}
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"manifest"])
    {
        self.contentModel.manifest = self.items;
    }
    else if ([elementName isEqualToString:@"spine"])
    {
        self.contentModel.spine = self.spinearray;
    }
    else if ([elementName isEqualToString:@"package"])
    {
        if ((self.delegate != nil) && ([self.delegate respondsToSelector:@selector(finishedParsing:)]))
        {
            [self.delegate epubParser:self didFinishParsingContent:self.contentModel];
        }
    }
    
}


@end
