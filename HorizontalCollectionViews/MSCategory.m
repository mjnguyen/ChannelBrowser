//
//  MSCategory.m
//  ChannelViewer
//
//  Created by Michael Nguyen on 3/1/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import "MSCategory.h"
#import "MSVideo.h"

@interface MSCategory ()


@end


@implementation MSCategory

/*!
   @brief initializes new MSCategory with data contained in JSON with following format:
 category =             {
 "cat_type" = 0;
 data = "<null>";
 "has_subcats" = 0;
 id = 7487;
 label = PlayAll;
 name = PlayAll;
 "needs_export" = 0;
 next = "http://d1d0j1u9ayd8uc.cloudfront.net/channels/YIK8ILLV/categories/v2/category.7487.001.json";
 orientation = 1;
 parent = 0;
 prev = "";
 "sort_order" = 0;
 thumbnail = "http://d1d0j1u9ayd8uc.cloudfront.net/thumbs/647152.jpg";
 title = PlayAll;
 videos =                 (
 );
 visible = 1;
 };
 */
-(instancetype) initWithDictionary:(NSDictionary *)category {

    self = [self init];
    if (self != nil) {
        NSString *thumbnail = [category objectForKey:@"thumbnail"];
        NSString *title = [category objectForKey:@"label"];
        NSArray *videos = [category objectForKey:@"videos"];
        NSArray *subCategories = [category objectForKey:@"categories"];

        self.title = title;
        self.thumbnail = thumbnail;
        self.categoryId = [NSString stringWithFormat:@"%d", [[category objectForKey:@"id"] intValue]];
        if (videos != nil) {
            NSMutableArray *videoSet = [[NSMutableArray alloc] init];
            for (NSDictionary *videoDict in videos) {
                MSVideo *video = [[MSVideo alloc] initWithDictionary: [videoDict objectForKey:@"video"]];
                [videoSet addObject:video];
            }

            self.videos = videoSet;
        }

        NSString *nextLink = [category objectForKey:@"next"];
        if ([nextLink length] > 0) {
            MSVideo *showAllLink = [[MSVideo alloc] initWithDictionary:@{ @"title": @"",
                                                                          @"url": nextLink,
                                                                          @"thumbnail": @"http://www.kakocleaning.com.au/wp-content/uploads/2014/09/see-more-button.png",
                                                                          @"description": @""
                                                                          }];
            self.videos = [self.videos arrayByAddingObject:showAllLink];

        }

        if (subCategories != nil) {
            NSMutableArray *subCatArr = [[NSMutableArray alloc] init];
            for (NSDictionary *subcategory in subCategories) {
                MSCategory *subCat = [[MSCategory alloc] initWithDictionary:[subcategory objectForKey:@"category"]];
                if ([[subCat videos] count] > 0) {
                    [subCatArr addObject: subCat];
                }
            }
            self.subCategories = subCatArr;

        }
    }

    return self;
}
@end
