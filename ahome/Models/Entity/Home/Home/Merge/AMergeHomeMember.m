//
//  AMergeHomeMember.m
//  ahome
//
//  Created by andson-dile on 15/6/18.
//  Copyright (c) 2015年 ushome. All rights reserved.
//

#import "AMergeHomeMember.h"

@implementation AMergeHomeMember

- (instancetype)initWithMember:(AHomeMember*)homeMember photo:(NSString*)photo familyId:(long)familyId {
    self = [super initWithOtherMember:homeMember];

    self.photo = photo;
    self.familyId = familyId;
    
    self.mkey = homeMember.mkey;
    self.selected = homeMember.selected;
    self.menuOperate = homeMember.menuOperate;
    
    return self;
}


@end
