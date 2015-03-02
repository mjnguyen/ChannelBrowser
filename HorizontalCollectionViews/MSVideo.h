//
//  MSVideo.h
//  ChannelViewer
//
//  Created by Michael Nguyen on 3/1/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSVideo : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * videoDescription;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * thumbnail;

-(instancetype)initWithDictionary: (NSDictionary *)data;

@end
