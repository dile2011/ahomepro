//
//  ABaseHomeController.m
//  ahome
//
//  Created by dilei liu on 15/1/27.
//  Copyright (c) 2015年 ushome. All rights reserved.
//

#import "AHomePageController.h"
#import "AHomeLevelController.h"
#import "ANewHomeController.h"
#import "UIImageView+WebCache.h"
#import "ParallaxHeaderView.h"
#import "AHomeServer.h"
#import "ABlurMenu.h"
#import "AHomeMemberCell.h"
#import "AHomeMergeCell.h"
#import "AHMAttributeMainController.h"
#import "AHomeTitle.h"
#import "AHomeTitleView.h"
#import "AMergeHomeInfo.h"
#import "AHomeHeaderView.h"
#import "AHomeHeader.h"

#import "AHomeDynamicController.h"
#import "AHomeFriendsController.h"
#import "AHomeCommunityController.h"
#import "AHomePedigreeController.h"
#import "AMainRootController.h"
#import "AUserCookie.h"

#define tool_size_height    45

@implementation AHomePageController

- (instancetype)init {
    self = [super initWithIsKenBlur:YES];
    _lookStyle = MergeHomeStyle;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLoading];
}

- (void)startLoading {
    [self reloadHomeInfo];
    [super startLoading];
}

- (void)reloadHomeInfo {
    
    [[AServerFactory getServerInstance:@"AHomeServer"]getHomeByUid:0 callback:^(NSDictionary *homeInfoDic) {
        [self ahomeByLookStyle:self.lookStyle homeInfos:homeInfoDic];
    
        [self.tableView reloadData];
        [self stopLoading];
        
        for (NSString *key in homeInfoDic) {
            AHome *homeInfo = [homeInfoDic objectForKey:key];
            ParallaxHeaderView *headerView = (ParallaxHeaderView*)self.tableView.tableHeaderView;
            [headerView.imageView setImageWithURL:[NSURL URLWithString:homeInfo.photo]];
        }
        
        AHomeLevelController *homeLevel = [AHomeLevelController sharedInstance];
        [homeLevel addTitleView:homeInfoDic];
        
    } failureCallback:^(NSString *resp) {
        [self stopLoading];
    }];
}

- (void)ahomeByLookStyle:(LookHomeStyle)lookStyle homeInfos:(NSDictionary*)homeInfoDic {
    if (lookStyle == MergeHomeStyle) {
        self.homeInfo = [[AMergeHomeInfo alloc]initWithHomeInfo:homeInfoDic];
        
        for (AMergeHomeMember *member in ((AMergeHomeInfo*)self.homeInfo).members) {
            __weak AMergeHomeMember *memberWeak = member;
            int index = (int)[((AHome*)_homeInfo).members indexOfObject:member];
            
            [member setSelected:^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                AHomeMergeCell *homeCell = (AHomeMergeCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                AMergeMemberView *nodeView = [homeCell.mergeHomeMembers objectAtIndex:index];
                CGPoint point = [homeCell convertPoint:nodeView.center toView:self.view.window];
                
                AHMAttributeMainController *menuPanel = [AHMAttributeMainController shareInstance:point member:memberWeak];
                [self.view.window addSubview:menuPanel.view];
                
                UINavigationController *selectedItem = (UINavigationController*)[[AMainRootController sharedInstance]getCurrentSelectedItem];
                ARootViewController *rootController = [selectedItem.viewControllers firstObject];
                [rootController updateLeftBtnStyle:YES];
            }];
            
            [member setMenuOperate:^(OperateType ot) {
                [self menuOperateAction:ot member:memberWeak];
            }];
        }
        
    } else {
        
        if (self.lookStyle == MineHomeStyle)self.homeInfo = [homeInfoDic objectForKey:@"mine"];
        else if (self.lookStyle == ParentHomeStyle)self.homeInfo = [homeInfoDic objectForKey:@"parent"];

        for (AHomeMember *member in ((AHome*)self.homeInfo).members) {
            __weak AHomeMember *memberWeak = member;
            int index = (int)[((AHome*)_homeInfo).members indexOfObject:member];
            
            [member setSelected:^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                AHomeMemberCell *homeCell = (AHomeMemberCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                AHomeMemberNodeView *nodeView = [homeCell.memberNodes objectAtIndex:index];
                CGPoint point = [homeCell convertPoint:nodeView.center toView:self.view.window];
                
                AHMAttributeMainController *menuPanel = [AHMAttributeMainController shareInstance:point member:memberWeak];
                [self.view.window addSubview:menuPanel.view];
                
                UINavigationController *selectedItem = (UINavigationController*)[[AMainRootController sharedInstance]getCurrentSelectedItem];
                ARootViewController *rootController = [selectedItem.viewControllers firstObject];
                [rootController updateLeftBtnStyle:NO];
            }];
            
            [member setMenuOperate:^(OperateType ot) {
                [self menuOperateAction:ot member:memberWeak];
            }];
        }
    }
}


- (void)menuOperateAction:(OperateType)ot member:(id)member {
    
    long familyId = 0;
    if (self.lookStyle == MergeHomeStyle) {
        familyId = ((AMergeHomeMember*)member).familyId;
    } else {
        familyId = ((AHome*)self.homeInfo).familyId;
    }
    
    switch (ot) {
        case AuthOperate: {
            [[AHomeLevelController sharedInstance]phoneAuth:member familyId:familyId];
            break;
        }
            
        case InviteOperate:
            [[AHomeLevelController sharedInstance]sendInvite:member familyId:familyId];
            break;
            
        case DeleteOperate:
            [[AHomeLevelController sharedInstance]deleteMember:member familyId:familyId];
            break;
            
        default:
            break;
    }
    
    [AHMAttributeMainController destroyInstance];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    NSString *CellIdentifier = @"AHomeMergeCell";
    if (self.lookStyle != MergeHomeStyle) CellIdentifier = @"AHomeMemberCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        Class controllerClass = NSClassFromString(CellIdentifier);
        cell = [[controllerClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [((ABaseHomeCell*)cell) setDataForCell:_homeInfo];
    
    return cell;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _homeInfo!=nil?1:0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _homeInfo!=nil?1:0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.lookStyle == MergeHomeStyle) return [AHomeMergeCell heightForCell:0];
    
    AHome *homeInfo = (AHome*)_homeInfo;
    return [AHomeMemberCell heightForCell:(int)homeInfo.members.count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    AHomeHeader *dynamicHeader = [[AHomeHeader alloc]initWithTitle:@"动态" imageName:@"" andSelect:^{
        AHomeDynamicController *dynamicController = [[AHomeDynamicController alloc]init];
        AHomeLevelController *homeLeve = [AHomeLevelController sharedInstance];
        [homeLeve.navigationController pushViewController:dynamicController animated:YES];
    }];
    
    AHomeHeader *friendsHeader = [[AHomeHeader alloc]initWithTitle:@"亲友" imageName:@"" andSelect:^{
        AHomeFriendsController *friendsController = [[AHomeFriendsController alloc]init];
        AHomeLevelController *homeLeve = [AHomeLevelController sharedInstance];
        [homeLeve.navigationController pushViewController:friendsController animated:YES];
    }];
    
    AHomeHeader *communityHeader = [[AHomeHeader alloc]initWithTitle:@"小区" imageName:@"" andSelect:^{
        AHomeCommunityController *communityController = [[AHomeCommunityController alloc]init];
        AHomeLevelController *homeLeve = [AHomeLevelController sharedInstance];
        [homeLeve.navigationController pushViewController:communityController animated:YES];
    }];
    
    AHomeHeader *pedigreeHeader = [[AHomeHeader alloc]initWithTitle:@"家谱" imageName:@"" andSelect:^{
        AHomePedigreeController *pedigreeController = [[AHomePedigreeController alloc]init];
        AHomeLevelController *homeLeve = [AHomeLevelController sharedInstance];
        [homeLeve.navigationController pushViewController:pedigreeController animated:YES];
    }];
    
    NSArray *models = @[dynamicHeader,friendsHeader,communityHeader,pedigreeHeader];
    
    AHomeHeaderView *headerView = [[AHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45.f) andModels:models];
    return headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
}

@end
