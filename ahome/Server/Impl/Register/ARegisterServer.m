//
//  ARegisterServer.m
//  AtHomeApp
//
//  Created by dilei liu on 14-10-7.
//  Copyright (c) 2014年 ushome. All rights reserved.
//

#import "ARegisterServer.h"

@implementation ARegisterServer

- (void)doVerifyPhoneUnique:(NSString*)phoneNo callback:(void(^)(BOOL unique))callback
            failureCallback:(void(^)(NSString *resp))failureCallback {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Login/unique", serviceHost]];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    [item setPostValue:phoneNo forKey:@"phone"];
    
    NSArray *objects = @[[callback copy] , [failureCallback copy]];
    NSArray *keys = @[kCompleteCallback, kFailureCallback];
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [requestInfo addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:DoVerifyPhoneUnique],USER_INFO_KEY_TYPE, nil]];
    [item setUserInfo:requestInfo];
    [self.requestQueue addOperation:item];
    [self start];
}

- (void)doGetVerifyCode:(NSString*)phoneNo callback:(void(^)(NSString *code))callback
        failureCallback:(void(^)(NSString *resp))failureCallback {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Login/verifyCode", serviceHost]];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    [item setPostValue:@"18710180939" forKey:@"phone"];
    
    NSArray *objects = @[[callback copy] , [failureCallback copy]];
    NSArray *keys = @[kCompleteCallback, kFailureCallback];
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [requestInfo addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:DoGetVerifyCode],USER_INFO_KEY_TYPE, nil]];
    [item setUserInfo:requestInfo];
    [self.requestQueue addOperation:item];
    [self start];
}

- (void)doRegisterUser:(ARegisterForm*)registerForm callback:(void(^)(NSString *uid))callback
       failureCallback:(void(^)(NSString *uid))failureCallback {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Login/register", serviceHost]];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:registerForm.phone forKey:@"phone"];
    [item setPostValue:registerForm.password forKey:@"password"];
    [item setPostValue:registerForm.lastName forKey:@"surname"];
    [item setPostValue:registerForm.firstName forKey:@"name"];
    [item setPostValue:[NSString stringWithFormat:@"%i",registerForm.sex] forKey:@"gender"];
    [item setPostValue:registerForm.birth forKey:@"birthday"];
    [item setPostValue:registerForm.verifyCode forKey:@"verifyCode"];
    
    [item setPostValue:[[AUtilities sharedInstance]getDeviceToken] forKey:@"token"];
    [item setPostValue:[[AUtilities sharedInstance]getAppVersionNo] forKey:@"version"];
    [item setPostValue:@"ios" forKey:@"system"];
    
    
    NSArray *objects = @[[callback copy] , [failureCallback copy]];
    NSArray *keys = @[kCompleteCallback, kFailureCallback];
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [requestInfo addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:DoRegisterUser],USER_INFO_KEY_TYPE, nil]];
    [item setUserInfo:requestInfo];
    [self.requestQueue addOperation:item];
    [self start];
    
}

- (void)doSetRegionForRegister:(NSString*)region regionName:(NSString*)regionName
                      cityCode:(NSString*)cityCode regionCode:(NSString*)regionCode
                      callback:(void(^)(NSString *state))callback
               failureCallback:(void(^)(NSString *resp))failureCallback {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Login/setUser", serviceHost]];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [item setPostValue:region forKey:@"region"];
    [item setPostValue:regionName forKey:@"region_name"];
    [item setPostValue:cityCode forKey:@"city_code"];
    [item setPostValue:regionCode forKey:@"region_code"];
    
    NSArray *objects = @[[callback copy] , [failureCallback copy]];
    NSArray *keys = @[kCompleteCallback, kFailureCallback];
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [requestInfo addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:
                                           [NSNumber numberWithInt:DoRegisterSetRegion],
                                           USER_INFO_KEY_TYPE, nil]];
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
    
    if ([[requestDictionary objectForKey:USER_INFO_KEY_TYPE]floatValue] == DoVerifyPhoneUnique) {
        id callback  = [requestDictionary objectForKey:kCompleteCallback];
        ((void(^)(BOOL))callback)(YES);
    }
    
    if ([[requestDictionary objectForKey:USER_INFO_KEY_TYPE]floatValue] == DoGetVerifyCode) {
        NSDictionary *dict  = [requestDictionary objectForKey:@"packedData"];
        NSString *code = [[dict objectForKey:@"verifyCode"]stringValue];
        
        id callback  = [requestDictionary objectForKey:kCompleteCallback];
        ((void(^)(NSString*))callback)(code);
    }
    
    if ([[requestDictionary objectForKey:USER_INFO_KEY_TYPE]floatValue] == DoRegisterUser) {
        NSDictionary *dict  = [requestDictionary objectForKey:@"packedData"];
        NSString *uid = [dict objectForKey:@"uid"];
        
        id callback  = [requestDictionary objectForKey:kCompleteCallback];
        ((void(^)(NSString*))callback)(uid);
    }
    
    if ([[requestDictionary objectForKey:USER_INFO_KEY_TYPE]floatValue] == DoRegisterSetRegion) {
        NSDictionary *dict  = [requestDictionary objectForKey:@"packedData"];
        NSString *state = [dict objectForKey:@"msg"];
        
        id callback  = [requestDictionary objectForKey:kCompleteCallback];
        ((void(^)(NSString*))callback)(state);
    }

}

@end
