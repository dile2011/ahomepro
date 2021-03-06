//
//  ANewAtHomeDelegate.h
//  AtHomeApp
//
//  Created by dilei liu on 14-8-31.
//  Copyright (c) 2014年 ushome. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ANewAtHomeDelegate <NSObject>

- (void)doNextAction:(int)index;


- (void)doSelCommunity:(NSString*)cityCode districtCode:(NSString*)districtCode andRegion:(NSString *)region;


/**
 * 触发添加成员行为
 */
- (void)doInviteAction;
@end
