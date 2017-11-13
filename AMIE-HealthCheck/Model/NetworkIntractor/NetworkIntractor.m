//
//  NetworkIntractor.m
//  MUtO
//
//  Created by Abilash Cumulations on 22/04/17.
//  Copyright © 2017 Abilash Cumulations. All rights reserved.
//

#import "NetworkIntractor.h"

#define BASEURL @"http://35.165.93.101/amie/"

@implementation NetworkIntractor

+ (NetworkIntractor *)sharedManager
{
    static NetworkIntractor *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [NetworkIntractor new];
        [manager configureSession];
    });
    return manager;
}

- (void)configureSession
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    config.URLCache = nil;
    config.timeoutIntervalForRequest = 5.0f;
    config.timeoutIntervalForResource =10.0f;
    self.session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
 
}



void call_getNetworkingAPI(NSString *api, SuccessBlock successBlock, FailureBlock failureBlock)
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURL,api]];
       NSURLSessionDataTask *task = [[NetworkIntractor sharedManager].session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict != nil) {
                successBlock(dict,response);
            }
        }else
        {
            failureBlock(error,response);
        }
    }];
    [task resume];
}


void call_PostNetworkingAPI(NSString *api, NSDictionary *param, SuccessBlock successBlock, FailureBlock failureBlock)
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURL,api]];

    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest *Req=[NSMutableURLRequest requestWithURL:url];
    [Req setHTTPMethod:@"POST"];
    [Req setHTTPBody:data];

    NSURLSessionDataTask *task = [[NetworkIntractor sharedManager].session dataTaskWithRequest:Req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict != nil) {
                successBlock(dict,response);
            }
        }else
        {
            failureBlock(error,response);
        }
    }];
    [task resume];
}


@end
