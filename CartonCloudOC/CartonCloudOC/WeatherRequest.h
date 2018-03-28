//
//  WeatherRequest.h
//  CartonCloudOC
//
//  Created by Guxiaojie on 28/03/2018.
//  Copyright © 2018 SageGu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherRequest : NSObject

+ (void)sendRequest:(void (^)(NSArray *elements, NSError *error))completionBlock;

@end
