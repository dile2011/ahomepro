//
//  AHomeServer.h
//  Ahome
//
//  Created by dilei liu on 14/12/20.
//  Copyright (c) 2014年 ushome. All rights reserved.
//

#import "AHomeLocalServer.h"
#import "ANewHomeForm.h"
#import "AHome.h"

@interface AHomeServer : AHomeLocalServer

/**
 * 家庭图片上传
 */
- (void)uploadHomePictureByFile:(NSData*)file
                       callback:(void(^)(NSDictionary *homePictureInfo))callback
                failureCallback:(void(^)(NSString *resp))failureCallback;

/**
 * 创建家庭
 */
- (void)newAhomeByNewHomeForm:(ANewHomeForm*)newHomeForm callback:(void(^)(BOOL status))callback
              failureCallback:(void(^)(NSString *resp))failureCallback;

/**
 * 获取用户所在家庭
 */
- (void)getHomeByUid:(int)uid callback:(void(^)(NSDictionary *homeInfo))callback
     failureCallback:(void(^)(NSString *resp))failureCallback;

/**
 * 家庭成员手机认证
 */
- (void)doAuthForHomeMember:(NSString*)phone andFamilyId:(long)familyId andMemberIndex:(int)index
                   callback:(void(^)(BOOL status))callback
            failureCallback:(void(^)(NSString *resp))failureCallback;

/**
 * 家庭成员邀请激活
 */
- (void)doInviteForHomeMember:(NSString*)phone andFamilyId:(long)familyId callback:(void(^)(BOOL status))callback
            failureCallback:(void(^)(NSString *resp))failureCallback;

/**
 * 家庭成员添加
 */
- (void)doAddForHomeMember:(NSString*)phone andFamilyId:(long)familyId andPart:(NSString*)part
                  callback:(void(^)(BOOL status))callback
              failureCallback:(void(^)(NSString *resp))failureCallback;

/**
 * 家庭成员删除
 */
- (void)doDeleteForHomeMember:(NSString*)mkey andFamilyId:(long)familyId
                  callback:(void(^)(BOOL status))callback
           failureCallback:(void(^)(NSString *resp))failureCallback;

/**
 * 寻呼接口
 */
- (void)doPagingHomeMemberBylatitude:(NSString*)latitude longitude:(NSString*)longitude
                     callback:(void(^)(BOOL status))callback
              failureCallback:(void(^)(NSString *resp))failureCallback;

@end
