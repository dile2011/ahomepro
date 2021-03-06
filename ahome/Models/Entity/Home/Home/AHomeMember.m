//
//  AHomeMember.m
//  ahome
//
//  Created by dilei liu on 15/1/26.
//  Copyright (c) 2015年 ushome. All rights reserved.
//

#import "AHomeMember.h"

@implementation AHomeMember


- (void)updateWithJSonDictionary:(NSDictionary *)dic {
    self.uid = (long)[[dic objectForKey:@"uid"]longLongValue];
    
    self.avatar = [dic objectForKey:@"avatar"];
    self.phone = [dic objectForKey:@"phone"];
    self.part = [dic objectForKey:@"part"];
    
    self.flag = [[dic objectForKey:@"flag"]intValue];
    self.uname = [dic objectForKey:@"uname"];
    self.placeHolderImage = [[AUtilities sharedInstance]roleImageByString:self.part];
    
    if (self.uid == 0) { // 未邀请
        NSString *phone = [self.phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        self.memberState = StateInvite;
        if ([phone isMatchedByRegex:PhoneRegex]==NO)self.memberState = StateAuth;
        
    } else { //StateOther
        self.memberState = StateSelf;
        AUser *me = [AUser sharedInstance];
        if (me.serverId == self.uid)self.memberState = StateSelf;
    }
}

- (instancetype)initWithOtherMember:(AHomeMember*)other {
    self = [super init];
    self.uid = other.uid;
    
    self.avatar = other.avatar;
    self.phone = other.phone;
    self.part = other.part;
    
    self.flag = other.flag;
    self.uname = other.uname;
    self.placeHolderImage = other.placeHolderImage;
    
    if (self.uid == 0) { // 未邀请
        NSString *phone = [self.phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        self.memberState = StateInvite;
        if ([phone isMatchedByRegex:PhoneRegex]==NO)self.memberState = StateAuth;
        
    } else { //StateOther
        self.memberState = StateSelf;
        AUser *me = [AUser sharedInstance];
        if (me.serverId == self.uid)self.memberState = StateSelf;
    }
    
    return self;
}


@end
