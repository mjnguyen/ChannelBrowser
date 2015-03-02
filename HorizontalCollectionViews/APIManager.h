//
//  URLManager.h
//  ChannelViewer
//
//  Created by Michael Nguyen on 3/1/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSCategory.h"

typedef void(^MSResponseBlock)(id homeCategory, NSError *error);


@interface APIManager : NSObject

+(instancetype)sharedManager;

-(void)getCategoriesForChannel: (NSString *)channelUrl withCompletionBlock:(MSResponseBlock)completionBlock;

@end
