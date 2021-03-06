//
//  AHomePageController.h
//  ahome
//
//  Created by dilei liu on 15/1/27.
//  Copyright (c) 2015年 ushome. All rights reserved.
//

#import "ABaseHomeController.h"
#import "AHome.h"
#import "APanelMenuController.h"
#import "AHomeMember.h"
#import "AMergeHomeInfo.h"

typedef enum {
    MergeHomeStyle,
    MineHomeStyle,
    ParentHomeStyle
} LookHomeStyle;


@interface AHomePageController : ABaseHomeController {
    APanelMenuController *_panelMenu;
}


@property (nonatomic,assign)LookHomeStyle lookStyle;
@property (nonatomic,retain)id homeInfo;


- (void)reloadHomeInfo;

- (void)menuOperateAction:(OperateType)ot member:(AHomeMember*)member;

@end
