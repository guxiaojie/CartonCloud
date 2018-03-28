//
//  WeatherRequest.m
//  CartonCloudOC
//
//  Created by Guxiaojie on 28/03/2018.
//  Copyright © 2018 SageGu. All rights reserved.
//

#import "WeatherRequest.h"

@implementation WeatherRequest



+ (void)sendRequest:(void (^)(NSArray *elements, NSError *error))completionBlock {

    //format URL
    NSDate *yesterday = [[NSDate date] dateByAddingTimeInterval: -24*60*60];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd/"];
    NSString *yesterdayDateStr = [dateFormatter stringFromDate: yesterday];
    NSString *urlString = [NSString stringWithFormat:@"https://www.metaweather.com/api/location/1100661/%@", yesterdayDateStr];
    
    //send request
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString: urlString]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            
            //parse
            NSError *jsonError = nil;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            
            NSMutableArray *newArray = [NSMutableArray array];
            for(int i=0; i<array.count; i++) {
                
                NSDictionary *dictionary = array[i];
                
                NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
                
                //format date
                NSString *created = dictionary[@"created"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                NSDate *date = [dateFormatter dateFromString:created];
               
                //find yesterday
                if ([WeatherRequest isYesterday:date]) {
                    NSLog(@"date:%@", date);
                    NSString *icon = [NSString stringWithFormat:@"https://www.metaweather.com/static/img/weather/png/%@.png", dictionary[@"weather_state_abbr"]];
                    [newDict setObject:icon forKey:@"icon"];
                    [newDict setObject:[WeatherRequest time:date] forKey:@"date"];
                    NSString *maxTemp = dictionary[@"max_temp"];
                    [newDict setObject:[NSNumber numberWithInt:[maxTemp intValue]] forKey:@"max_temp"];
                    NSString *minTemp = dictionary[@"min_temp"];
                    [newDict setObject:[NSNumber numberWithInt:[minTemp intValue]] forKey:@"min_temp"];
                    [newDict setObject:dictionary[@"weather_state_name"] forKey:@"weather_state_name"];
                    
                    [newArray addObject:newDict];
                }
            }
            
            completionBlock(newArray, error);
            NSLog(@"-__%@",newArray);
        }
        else {
            completionBlock(nil, error);
        }
    }];
    
    [dataTask resume];

}

#pragma mark Helper

+ (NSDate *)dateWithYMD:(NSDate *)date {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:date];
    return [fmt dateFromString:selfStr];
}

+ (BOOL)isYesterday:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:[WeatherRequest dateWithYMD:date] toDate:[WeatherRequest dateWithYMD:[NSDate date]] options:0];
    return cmps.day == 1;
}

+ (NSString *)time:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    format.AMSymbol = @"am";
    format.PMSymbol = @"pm";
    format.dateFormat = @"haaa";
    
    NSString *timeStr = [format stringFromDate:date];
    return timeStr;
}

@end
