//
//  KFEpubParser.m
//  KFEpubKit
//
//  Created by rick on 24.04.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import "KFEpubParser.h"
#import "KFEpubContentModel.h"


@interface KFEpubParser ()


@property (strong) NSXMLParser *parser;
@property (strong) NSString *rootPath;
@property (strong) KFEpubContentModel *contentModel;
@property (strong) NSMutableDictionary *items;
@property (strong) NSMutableArray *spinearray;


@end


#define kMimeTypeEpub @"application/epub+zip"
#define kMimeTypeiBooks @"application/x-ibooks+zip"


@implementation KFEpubParser


- (KFEpubKitBookType)bookTypeForBaseURL:(NSURL *)baseURL
{
    NSError *error = nil;
    KFEpubKitBookType bookType = KFEpubKitBookTypeUnknown;
    
    NSURL *mimetypeURL = [baseURL URLByAppendingPathComponent:@"mimetype"];
    NSString *mimetype = [[NSString alloc] initWithContentsOfURL:mimetypeURL encoding:NSASCIIStringEncoding error:&error];
    
    if (error)
    {
        return bookType;
    }
    
    NSRange mimeRange = [mimetype rangeOfString:kMimeTypeEpub];
    
    if (mimeRange.location == 0 && mimeRange.length == 20)
    {
        bookType = KFEpubKitBookTypeEpub2;
    }
    else if ([mimetype isEqualToString:kMimeTypeiBooks])
    {
        bookType = KFEpubKitBookTypeiBook;
    }
    
    return bookType;
}


- (NSURL *)rootFileForBaseURL:(NSURL *)baseURL
{
    NSError *error = nil;
    NSURL *containerURL = [[baseURL URLByAppendingPathComponent:@"META-INF"] URLByAppendingPathComponent:@"container.xml"];
    
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithContentsOfURL:containerURL options:kNilOptions error:&error];
    NSXMLElement *root  = [document rootElement];
    NSArray* objectElements = [root nodesForXPath:@"//container/rootfiles/rootfile" error:nil];
    
    NSUInteger count = 0;
    NSString *value = nil;
    for (NSXMLElement* xmlElement in objectElements)
    {
        value = [[xmlElement attributeForName:@"full-path"] stringValue];
        count++;
    }

    if (count == 1 && value)
    {
        return [baseURL URLByAppendingPathComponent:value];
    }
    else if (count == 0)
    {
        NSLog(@"no root file found.");
    }
    else
    {
        NSLog(@"there are more than one root files. this is odd.");
    }
    return nil;
}


- (NSDictionary *)metaDataFromDocument:(NSXMLDocument *)document
{
    NSMutableDictionary *metaData = [NSMutableDictionary new];
    NSXMLElement *root  = [document rootElement];
    NSArray *metaNodes = [root nodesForXPath:@"//package/metadata" error:nil];
    
    if (metaNodes.count == 1)
    {
        NSXMLElement *metaNode = metaNodes[0];
        NSArray *metaElements = metaNode.children;

        for (NSXMLElement* xmlElement in metaElements)
        {
            if ([self isValidNode:xmlElement])
            {
                metaData[xmlElement.localName] = xmlElement.stringValue;
            }
        }
    }
    else
    {
        NSLog(@"meta data invalid");
        return nil;
    }
    return metaData;
}


- (NSArray *)spineFromDocument:(NSXMLDocument *)document
{
    NSMutableArray *spine = [NSMutableArray new];
    NSXMLElement *root  = [document rootElement];
    NSArray *spineNodes = [root nodesForXPath:@"//package/spine" error:nil];
    
    if (spineNodes.count == 1)
    {
        NSXMLElement *spineElement = spineNodes[0];
        
        NSString *toc = [[spineElement attributeForName:@"toc"] stringValue];
        if (toc)
        {
            [spine addObject:toc];
        }
        else
        {
            [spine addObject:@""];
        }
        NSArray *spineElements = spineElement.children;
        for (NSXMLElement* xmlElement in spineElements)
        {
            if ([self isValidNode:xmlElement])
            {
                [spine addObject:[[xmlElement attributeForName:@"idref"] stringValue]];
            }
        }
    }
    else
    {
        NSLog(@"spine data invalid");
        return nil;
    }
    return spine;
}


- (NSDictionary *)manifestFromDocument:(NSXMLDocument *)document
{
    NSMutableDictionary *manifest = [NSMutableDictionary new];
    NSXMLElement *root  = [document rootElement];
    NSArray *manifestNodes = [root nodesForXPath:@"//package/manifest" error:nil];
    
    if (manifestNodes.count == 1)
    {
        NSArray *itemElements = ((NSXMLElement *)manifestNodes[0]).children;
        for (NSXMLElement* xmlElement in itemElements)
        {
            if ([self isValidNode:xmlElement] && xmlElement.attributes)
            {
                NSString *href = [[xmlElement attributeForName:@"href"] stringValue];
                NSString *itemId = [[xmlElement attributeForName:@"id"] stringValue];
                NSString *mediaType = [[xmlElement attributeForName:@"media-type"] stringValue];
                
                if (itemId)
                {
                    NSMutableDictionary *items = [NSMutableDictionary new];
                    if (href)
                    {
                        items[@"href"] = href;
                    }
                    if (mediaType)
                    {
                        items[@"media"] = mediaType;
                    }
                    manifest[itemId] = items;
                }
            }
        }
    }
    else
    {
        NSLog(@"manifest data invalid");
        return nil;
    }
    return manifest;
}


- (NSArray *)guideFromDocument:(NSXMLDocument *)document
{
    NSMutableArray *guide = [NSMutableArray new];
    NSXMLElement *root  = [document rootElement];
    NSArray *guideNodes = [root nodesForXPath:@"//package/guide" error:nil];
    
    if (guideNodes.count == 1)
    {
        NSXMLElement *guideElement = guideNodes[0];
        NSArray *referenceElements = guideElement.children;
        
        for (NSXMLElement* xmlElement in referenceElements)
        {
            if ([self isValidNode:xmlElement])
            {
                NSString *type = [[xmlElement attributeForName:@"type"] stringValue];
                NSString *href = [[xmlElement attributeForName:@"href"] stringValue];
                NSString *title = [[xmlElement attributeForName:@"title"] stringValue];
                
                NSMutableDictionary *reference = [NSMutableDictionary new];
                if (type)
                {
                    reference[type] = type;
                }
                if (href)
                {
                    reference[@"href"] = href;
                }
                if (title)
                {
                    reference[@"title"] = title;
                }
                [guide addObject:reference];
            }
        }
    }
    else
    {
        NSLog(@"guide data invalid");
        return nil;
    }
    
    return guide;
}


- (BOOL)isValidNode:(NSXMLElement *)node
{
    return node.kind != NSXMLCommentKind;
}


@end
