//
//  AHomeServer.m
//  Ahome
//
//  Created by dilei liu on 14/12/20.
//  Copyright (c) 2014年 ushome. All rights reserved.
//

#import "AHomeServer.h"
#import "AInviteMember.h"
#import "SBJsonWriter.h"

@implementation AHomeServer

- (void)uploadHomePictureByFile:(NSData*)file
                       callback:(void(^)(NSDictionary *homePictureInfo))callback
                failureCallback:(void(^)(NSString *resp))failureCallback {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Upload", serviceHost]];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    [item setPostValue:@"0" forKey:@"imgType"];
    [item setPostValue:@"0" forKey:@"uploadType"];
    [item addData:file withFileName:@"george.jpg" andContentType:@"image/jpeg" forKey:@"file"];
    

    NSArray *objects = @[[callback copy] , [failureCallback copy]];
    NSArray *keys = @[kCompleteCallback, kFailureCallback];
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [requestInfo addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:DoHomePictureRequest],USER_INFO_KEY_TYPE, nil]];
    [item setUserInfo:requestInfo];
    [self.requestQueue addOperation:item];
    [self start];
}

- (void)newAhomeByNewHomeForm:(ANewHomeForm*)newHomeForm callback:(void(^)(BOOL status))callback
              failureCallback:(void(^)(NSString *resp))failureCallback {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Family/add", serviceHost]];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    [item setPostValue:newHomeForm.part forKey:@"part"];
    [item setPostValue:newHomeForm.region forKey:@"region"];
    [item setPostValue:newHomeForm.region_name forKey:@"region_name"];
    [item setPostValue:newHomeForm.city_code forKey:@"city_code"];
    [item setPostValue:newHomeForm.region_code forKey:@"region_code"];
    
    // ---------家庭成员里自己的放置位置
    NSString *flag = @"0";
    if ([newHomeForm.part isEqualToString:@"家父"])flag = @"0";
    else if ([newHomeForm.part isEqualToString:@"家母"])flag = @"1";
    else if ([newHomeForm.part isEqualToString:@"家子"])flag = @"2";
    else if ([newHomeForm.part isEqualToString:@"家女"])flag = @"3";
    
    
    if ([flag intValue] > 2){
        [item setPostValue:@"2" forKey:@"mkey"]; // 我的位置关系
    } else {
        [item setPostValue:flag forKey:@"mkey"]; // 我的位置关系
    }
    [item setPostValue:flag forKey:@"flag"]; // 角色关系
    
    // ---------
    NSMutableArray *members = [NSMutableArray array];
    for (AInviteMember *inviteMember in newHomeForm.members) {
        NSDictionary *memberDic = [NSDictionary dictionaryWithObjectsAndKeys:inviteMember.rolename,@"part",inviteMember.phone,@"phone",[NSString stringWithFormat:@"%i",inviteMember.flag],@"flag", nil];
        [members addObject:memberDic];
    }
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:members];
    
    [item setPostValue:jsonString forKey:@"member"];
    [item setPostValue:newHomeForm.image_id forKey:@"image_id"];
    
    NSArray *objects = @[[callback copy] , [failureCallback copy]];
    NSArray *keys = @[kCompleteCallback, kFailureCallback];
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [requestInfo addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:DoNewHomeRequest],USER_INFO_KEY_TYPE, nil]];
    [item setUserInfo:requestInfo];
    [self.requestQueue addOperation:item];
    [self start];
}

- (void)getHomeByUid:(int)uid callback:(void(^)(NSDictionary *homeInfo))callback failureCallback:(void(^)(NSString *resp))failureCallback {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/family", serviceHost]];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    [item setPostValue:[NSString stringWithFormat:@"%i",uid] forKey:@"uid"];
    
    NSArray *objects = @[[callback copy] , [failureCallback copy]];
    NSArray *keys = @[kCompleteCallback, kFailureCallback];
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [requestInfo addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:DoGetHomeInfoRequest],USER_INFO_KEY_TYPE, nil]];
    [item setUserInfo:requestInfo];
    [self.requestQueue addOperation:item];
    [self start];
    
}

- (void)doAuthForHomeMember:(NSString*)phone andFamilyId:(long)familyId andMemberIndex:(int)index
                   callback:(void(^)(BOOL status))callback
            failureCallback:(void(^)(NSString *resp))failureCallback {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/family/setPhone", serviceHost]];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    [item setPostValue:phone forKey:@"phone"];
    [item setPostValue:[NSString stringWithFormat:@"%ld",familyId] forKey:@"family_id"];
    [item setPostValue:[NSString stringWithFormat:@"%i",index] forKey:@"mkey"];
    
    NSArray *objects = @[[callback copy] , [failureCallback copy]];
    NSArray *keys = @[kCompleteCallback, kFailureCallback];
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [requestInfo addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:DoAuthHomeMemberRequest],USER_INFO_KEY_TYPE, nil]];
    [item setUserInfo:requestInfo];
    [self.requestQueue addOperation:item];
    [self start];
}

- (void)doInviteForHomeMember:(NSString*)phone andFamilyId:(long)familyId callback:(void(^)(BOOL status))callback
              failureCallback:(void(^)(NSString *resp))failureCallback {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/family/invite", serviceHost]];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    [item setPostValue:phone forKey:@"phone"];
    [item setPostValue:[NSString stringWithFormat:@"%ld",familyId] forKey:@"family_id"];
    
    NSArray *objects = @[[callback copy] , [failureCallback copy]];
    NSArray *keys = @[kCompleteCallback, kFailureCallback];
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [requestInfo addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:DoInviteHomeMemberRequest],USER_INFO_KEY_TYPE, nil]];
    [item setUserInfo:requestInfo];
    [self.requestQueue addOperation:item];
    [self start];
}

- (void)doAddForHomeMember:(NSString*)phone andFamilyId:(long)familyId andPart:(NSString*)part
                  callback:(void(^)(BOOL status))callback
           failureCallback:(void(^)(NSString *resp))failureCallback {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/family/member", serviceHost]];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    [item setPostValue:phone forKey:@"phone"];
    [item setPostValue:[NSString stringWithFormat:@"%ld",familyId] forKey:@"family_id"];
    [item setPostValue:part forKey:@"part"];
    
    NSString *flag = @"0";
    if ([part isEqualToString:@"家父"])flag = @"0";
    else if ([part isEqualToString:@"家母"])flag = @"1";
    else if ([part isEqualToString:@"家子"])flag = @"2";
    else if ([part isEqualToString:@"家女"])flag = @"3";
    [item setPostValue:flag forKey:@"flag"];
    
    NSArray *objects = @[[callback copy] , [failureCallback copy]];
    NSArray *keys = @[kCompleteCallback, kFailureCallback];
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [requestInfo addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:DoAddHomeMemberRequest],USER_INFO_KEY_TYPE, nil]];
    [item setUserInfo:requestInfo];
    [self.requestQueue addOperation:item];
    [self start];
}

- (void)doDeleteForHomeMember:(NSString*)mkey andFamilyId:(long)familyId
                     callback:(void(^)(BOOL status))callback
              failureCallback:(void(^)(NSString *resp))failureCallback {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/family/delmember", serviceHost]];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    [item setPostValue:mkey forKey:@"mkey"];
    [item setPostValue:[NSString stringWithFormat:@"%ld",familyId] forKey:@"family_id"];
    
    NSArray *objects = @[[callback copy] , [failureCallback copy]];
    NSArray *keys = @[kCompleteCallback, kFailureCallback];
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [requestInfo addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:DoDeleteHomeMemberRequest],USER_INFO_KEY_TYPE, nil]];
    [item setUserInfo:requestInfo];
    [self.requestQueue addOperation:item];
    [self start];
}

- (void)doPagingHomeMemberBylatitude:(NSString*)latitude longitude:(NSString*)longitude
                            callback:(void(^)(BOOL status))callback
                     failureCallback:(void(^)(NSString *resp))failureCallback {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/family/setSite", serviceHost]];
    ASIFormDataRequest *item = [[ASIFormDataRequest alloc] initWithURL:url];
    [item setPostValue:latitude forKey:@"x"];
    [item setPostValue:longitude forKey:@"y"];
    
    NSArray *objects = @[[callback copy] , [failureCallback copy]];
    NSArray *keys = @[kCompleteCallback, kFailureCallback];
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [requestInfo addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:DoPagingHomeMemberRequest],USER_INFO_KEY_TYPE, nil]];
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
    
    if ([[requestDictionary objectForKey:USER_INFO_KEY_TYPE]floatValue] == DoHomePictureRequest) {
        NSArray *datas = [packData objectForKey:@"data"];
        NSDictionary *dataDic = [datas firstObject];
        
        id callback  = [requestDictionary objectForKey:kCompleteCallback];
        ((void(^)(NSDictionary *))callback)(dataDic);
    }
    
    if ([[requestDictionary objectForKey:USER_INFO_KEY_TYPE]floatValue] == DoNewHomeRequest) {
        id callback  = [requestDictionary objectForKey:kCompleteCallback];
        ((void(^)(BOOL))callback)(YES);
    }
    
    if ([[requestDictionary objectForKey:USER_INFO_KEY_TYPE]floatValue] == DoGetHomeInfoRequest) {
        NSMutableDictionary *homeInfoDict = [NSMutableDictionary dictionary];
        
        NSDictionary *mineHomeDic = [packData objectForKey:@"mine"];
        if (mineHomeDic != nil && mineHomeDic.count > 0) {
            AHome *mineHomeInfo = [[AHome alloc]initWithJsonDictionary:mineHomeDic];
            [homeInfoDict setObject:mineHomeInfo forKey:@"mine"];
        }
        
        NSDictionary *parentHomeDict = [packData objectForKey:@"parent"];
        if (parentHomeDict != nil && parentHomeDict.count>0) {
            AHome *parentHomeInfo = [[AHome alloc]initWithJsonDictionary:parentHomeDict];
            [homeInfoDict setObject:parentHomeInfo forKey:@"parent"];
        }
        
        id callback  = [requestDictionary objectForKey:kCompleteCallback];
        ((void(^)(NSDictionary*))callback)(homeInfoDict);
    }
    
    if ([[requestDictionary objectForKey:USER_INFO_KEY_TYPE]floatValue] == DoAuthHomeMemberRequest) {
        BOOL status = [[packData objectForKey:@"status"]boolValue];
        
        id callback  = [requestDictionary objectForKey:kCompleteCallback];
        ((void(^)(BOOL))callback)(status);
    }
    
    if ([[requestDictionary objectForKey:USER_INFO_KEY_TYPE]floatValue] == DoInviteHomeMemberRequest) {
        BOOL status = [[packData objectForKey:@"status"]boolValue];
        
        id callback  = [requestDictionary objectForKey:kCompleteCallback];
        ((void(^)(BOOL))callback)(status);
    }
    
    if ([[requestDictionary objectForKey:USER_INFO_KEY_TYPE]floatValue] == DoAddHomeMemberRequest) {
        BOOL status = [[packData objectForKey:@"status"]boolValue];
        
        id callback  = [requestDictionary objectForKey:kCompleteCallback];
        ((void(^)(BOOL))callback)(status);
    }
    
    if ([[requestDictionary objectForKey:USER_INFO_KEY_TYPE]floatValue] == DoDeleteHomeMemberRequest) {
        BOOL status = [[packData objectForKey:@"status"]boolValue];
        
        id callback  = [requestDictionary objectForKey:kCompleteCallback];
        ((void(^)(BOOL))callback)(status);
    }
    
    if ([[requestDictionary objectForKey:USER_INFO_KEY_TYPE]floatValue] == DoPagingHomeMemberRequest) {
        BOOL status = [[packData objectForKey:@"status"]boolValue];
        
        id callback  = [requestDictionary objectForKey:kCompleteCallback];
        ((void(^)(BOOL))callback)(status);
    }
    
}

@end
