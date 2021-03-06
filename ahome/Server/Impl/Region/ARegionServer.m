//
//  ARegionServer.m
//  AtHomeApp
//
//  Created by dilei liu on 14-10-6.
//  Copyright (c) 2014年 ushome. All rights reserved.
//

#import "ARegionServer.h"

@implementation ARegionServer


- (void)doSearchRegionByCidyCode:(NSString*)cityCode andDistrictCode:(NSString*)districtCode andRegionName:(NSString *)regionName
                        callback:(void(^)(NSArray *data))callback
                 failureCallback:(void(^)(NSString *resp))failureCallback {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Region/search", serviceHost]];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    [item setPostValue:cityCode forKey:@"city_code"];
    [item setPostValue:districtCode forKey:@"region_code"];
    [item setPostValue:regionName forKey:@"region_name"];
    
    NSArray *objects = @[[callback copy] , [failureCallback copy]];
    NSArray *keys = @[kCompleteCallback, kFailureCallback];
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [requestInfo addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:DoSearchRegion],USER_INFO_KEY_TYPE, nil]];
    [item setUserInfo:requestInfo];
    [self.requestQueue addOperation:item];
    [self start];
}

- (void)newRegionByCityCode:(NSString*)cityCode andRegionName:(NSString*)regionName andRegionCode:(NSString*)regionCode
                   callback:(void(^)(NSString* region))callback
            failureCallback:(void(^)(NSString *resp))failureCallback {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/region/add", serviceHost]];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    [item setPostValue:cityCode forKey:@"city_code"];
    [item setPostValue:regionName forKey:@"region_name"];
    [item setPostValue:regionCode forKey:@"region_code"];
    
    NSArray *objects = @[[callback copy] , [failureCallback copy]];
    NSArray *keys = @[kCompleteCallback, kFailureCallback];
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [requestInfo addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:DoNewRegionRequest],USER_INFO_KEY_TYPE, nil]];
    [item setUserInfo:requestInfo];
    [self.requestQueue addOperation:item];
    [self start];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [super requestFinished:request];
    NSDictionary *requestDictionary = [request userInfo];
    NSDictionary *packData = [requestDictionary objectForKey:@"packedData"];
    
    if ([[packData objectForKey:@"status"]intValue] != 1) {
        NSString *error = [packData objectForKey:@"msg"];
        id failureCallback  = [requestDictionary objectForKey:kFailureCallback];
        ((void(^)(NSString *))failureCallback)(error);
        
        return;
    }
    
    if ([[requestDictionary objectForKey:USER_INFO_KEY_TYPE]floatValue] == DoSearchRegion) {
        NSArray *data = [packData objectForKey:@"data"];
        id callback  = [requestDictionary objectForKey:kCompleteCallback];
        ((void(^)(NSArray*))callback)(data);
    }
    
    if ([[requestDictionary objectForKey:USER_INFO_KEY_TYPE]floatValue] == DoNewRegionRequest) {
        NSDictionary *data = [packData objectForKey:@"data"];
        NSString *region_name = [data objectForKey:@"region_name"];
        
        id callback  = [requestDictionary objectForKey:kCompleteCallback];
        ((void(^)(NSString*))callback)(region_name);
    }
}

@end
