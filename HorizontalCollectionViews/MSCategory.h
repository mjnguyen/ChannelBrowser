//
//  MSCategory.h
//  ChannelViewer
//
//  Created by Michael Nguyen on 3/1/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSCategory : NSObject


@property (nonatomic, copy) NSString * label;
@property (nonatomic, copy) NSString * categoryId;
@property (nonatomic, copy) NSString * thumbnail;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSArray * videos;
@property (nonatomic, copy) NSArray * subCategories;

-(instancetype) initWithDictionary:(NSDictionary *)jsonDict;

@end
