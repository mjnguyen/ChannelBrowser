//
//  MSVideo.m
//  ChannelViewer
//
//  Created by Michael Nguyen on 3/1/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import "MSVideo.h"

@implementation MSVideo

-(instancetype)initWithDictionary: (NSDictionary *)data {
    self = [super init];
    if (self != nil) {
        self.title = [data objectForKey:@"title"];
        self.url = [data objectForKey:@"url"];
        self.videoDescription = [data objectForKey:@"description"];
        self.thumbnail = [data objectForKey:@"thumbnail"];
    }

    return self;
}
@end
