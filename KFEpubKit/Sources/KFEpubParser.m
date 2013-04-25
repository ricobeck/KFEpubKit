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


@implementation KFEpubParser


- (NSURL *)rootFileForBaseURL:(NSURL *)baseURL
{
    NSURL *containerURL = [[baseURL URLByAppendingPathComponent:@"META-INF"] URLByAppendingPathComponent:@"container.xml"];
    NSError *error = nil;
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
        NSLog(@"no root file found");
    }
    else
    {
        NSLog(@"there are more than one root files. this seems odd");
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
            NSString *nodeName = xmlElement.name;
            NSArray *nodeNameComponents = [nodeName componentsSeparatedByString:@":"];
            
            if (nodeNameComponents.count > 1)
            {
                nodeName = nodeNameComponents[1];
            }
            metaData[nodeName] = xmlElement.stringValue;
        }
    }
    else
    {
        NSLog(@"no meta data found");
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
            [spine addObject:[[xmlElement attributeForName:@"idref"] stringValue]];
        }
    }
    else
    {
        NSLog(@"no spine data found");
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
    else
    {
        NSLog(@"no manifest data found");
        return nil;
    }
    return manifest;
}


@end
