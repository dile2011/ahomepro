//
//  AHomeDeleteMemberController.h
//  ahome
//
//  Created by andson-dile on 15/6/4.
//  Copyright (c) 2015年 ushome. All rights reserved.
//

#import "AQuickPopupController.h"
#import "AHomeMember.h"

@interface AHomeDeleteMemberController : AQuickPopupController {
    AHomeMember *_homeMember;
}

@property (nonatomic,assign)float width;
@property (nonatomic,assign)long familyId;

- (id)initWithMemberInfo:(AHomeMember*)homeMember;

@end
