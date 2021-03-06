//
//  RequestDelegate.h
//  AtHomeApp
//
//  Created by dilei liu on 14-9-2.
//  Copyright (c) 2014年 ushome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

typedef enum {
    DefaultRequest, //
    DoVerifyPhoneUnique, // 注册时验证手机号是否唯一标识符
    DoGetVerifyCode, // 获取验证码
    DoRegisterUser, // 注册
    DoRegisterSetRegion, // 为用户设置地区
    DoSearchRegion, // 搜索地区
    DoNewRegionRequest,// 创建新的社区
    
    DoLoginRequest, // 登录
    DoLogoutRequest, // 退出登录 
    DoHomePictureRequest,
    DoUserPictureRequest,
    DoNewHomeRequest,
    
    DoGetUserInfoRequest,
    DoGetHomeInfoRequest,
    DoAuthHomeMemberRequest,
    DoInviteHomeMemberRequest,
    DoAddHomeMemberRequest,
    DoDeleteHomeMemberRequest,
    DoPagingHomeMemberRequest,
    
    DoGetFamilyHomeListRequest, // 用户家族家庭列表
}RequestType;


@protocol RequestDelegate <NSObject>
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL;

@end