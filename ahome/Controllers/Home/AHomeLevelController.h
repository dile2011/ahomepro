//
//  AHomeLevelController.h
//  AtHomeApp
//
//  Created by dilei liu on 14-8-23.
//  Copyright (c) 2014年 ushome. All rights reserved.
//

#import "ARootViewController.h"
#import "AHomeMemberNodeView.h"
#import "AHomePageController.h"
#import "AHomeMember.h"
#import "AHomeTitleView.h"

@interface AHomeLevelController : ARootViewController {
    APanelMenuController *_panelMenu;
    AHomeTitleView *_titleView;
}

@property (nonatomic,retain)AHomeTitleView *titleView;
@property (nonatomic,retain)AHomePageController *homePage;

+ (id)sharedInstance;
+ (void)destroyDealloc;

- (void)newHome;
- (void)updateHome;

- (void)afterMemberOpration;

- (void)phoneAuth:(AHomeMember*)member familyId:(long)familyId;
- (void)sendInvite:(AHomeMember*)member familyId:(long)familyId;
- (void)deleteMember:(AHomeMember*)member familyId:(long)familyId;

- (void)addTitleView:(NSDictionary*)homeInfos;

@end
