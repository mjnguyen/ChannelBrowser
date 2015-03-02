//
//  URLManager.m
//  ChannelViewer
//
//  Created by Michael Nguyen on 3/1/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import "APIManager.h"
#import "AFNetworking.h"
#import "MSCategory.h"
#import "MSVideo.h"

@implementation APIManager

+ (instancetype)sharedManager {
    static APIManager *sharedSomeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSomeManager = [[self alloc] init];
    });

    return sharedSomeManager;
}


-(void)getCategoriesForChannel: (NSString *)channelUrl withCompletionBlock:(MSResponseBlock)completionBlock {
    NSURL *url = [NSURL URLWithString:channelUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        // 3 populate the domain objects using the json
        if (operation.response.statusCode == 200) {
            MSCategory *homeCategory = [self parseResponse: responseObject];

            if (completionBlock) {

                completionBlock(homeCategory, nil);
            }

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Channel Information"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];

    // 5
    [operation start];
}

- (MSCategory *)parseResponse: (NSDictionary *)responseObject {

    NSDictionary *baseCategory = [responseObject objectForKey:@"page"][@"category"];
    MSCategory *rootCategory = [[MSCategory alloc] initWithDictionary:baseCategory];

    return rootCategory;
}


@end
