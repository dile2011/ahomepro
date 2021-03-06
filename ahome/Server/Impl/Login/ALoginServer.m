//
//  ALoginServer.m
//  Ahome
//
//  Created by dilei liu on 14/11/29.
//  Copyright (c) 2014年 ushome. All rights reserved.
//

#import "ALoginServer.h"
#import "NSHTTPCookieStorage+Info.h"

@implementation ALoginServer

- (void)doLoginByPhoneNo:(NSString*)phoneNo andPasswd:(NSString*)passwd
                callback:(void(^)(BOOL opBool))callback failureCallback:(void(^)(NSString *resp))failureCallback {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Login/login", serviceHost]];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    [item setPostValue:phoneNo forKey:@"phone"];
    [item setPostValue:passwd forKey:@"password"];

    [item setPostValue:[[AUtilities sharedInstance]getDeviceToken] forKey:@"token"];
    [item setPostValue:[[AUtilities sharedInstance]getAppVersionNo] forKey:@"version"];
    [item setPostValue:@"ios" forKey:@"system"];
    
    NSArray *objects = @[[callback copy] , [failureCallback copy]];
    NSArray *keys = @[kCompleteCallback, kFailureCallback];
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [requestInfo addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:DoLoginRequest],USER_INFO_KEY_TYPE, nil]];
    [item setUserInfo:requestInfo];
    [self.requestQueue addOperation:item];
    [self start];
    
}

- (void)doLogout:(void(^)(BOOL opBool))callback failureCallback:(void(^)(NSString *resp))failureCallback {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Login/loginOut", serviceHost]];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    NSArray *objects = @[[callback copy] , [failureCallback copy]];
    NSArray *keys = @[kCompleteCallback, kFailureCallback];
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [requestInfo addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:DoLogoutRequest],USER_INFO_KEY_TYPE, nil]];
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
    
    if ([[requestDictionary objectForKey:USER_INFO_KEY_TYPE]floatValue] == DoLoginRequest) {
        id callback  = [requestDictionary objectForKey:kCompleteCallback];
        ((void(^)(BOOL))callback)(YES);
    }
    
    if ([[requestDictionary objectForKey:USER_INFO_KEY_TYPE]floatValue] == DoLogoutRequest) {
        id callback  = [requestDictionary objectForKey:kCompleteCallback];
        ((void(^)(BOOL))callback)(YES);
    }
}


@end
