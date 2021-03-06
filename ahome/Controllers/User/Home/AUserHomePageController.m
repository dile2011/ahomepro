//
//  AUserHomePageController.m
//  ahome
//
//  Created by andson-dile on 15/6/24.
//  Copyright (c) 2015年 ushome. All rights reserved.
//

#import "UIViewController+MJPopupViewController.h"
#import "AUserHomePageController.h"
#import "AHomeMember.h"
#import "AHomeServer.h"
#import "ABlurMenu.h"
#import "APopupHandler.h"
#import "ANewHomeController.h"
#import "UIImageView+WebCache.h"
#import "AHMAttributeMainController.h"
#import "AHomeMemberCell.h"
#import "AHomeMemberNodeView.h"

#import "AUserAddMemberController.h"
#import "AUserPhoneAuthController.h"
#import "AUserInviteActiveController.h"
#import "AUserDeleteMemberController.h"

@implementation AUserHomePageController

- (instancetype)initWithLookStyle:(LookHomeStyle)lookStyle {
    self = [super init];
    self.lookStyle = lookStyle;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的家庭";
    
    UIBarButtonItem *moreButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home_tab_more.png"] style:UIBarButtonItemStylePlain target:self action:@selector(moreMenu)];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace                                                                               target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, moreButtonItem];
}

- (void)reloadHomeInfo {
    [[AServerFactory getServerInstance:@"AHomeServer"]getHomeByUid:0 callback:^(NSDictionary *homeInfoDict) {
        
        if (homeInfoDict.count == 1) {
            for (NSString *key in homeInfoDict) {
                if ([key isEqualToString:@"mine"]) self.lookStyle = MineHomeStyle;
                if ([key isEqualToString:@"parent"]) self.lookStyle = ParentHomeStyle;
            }
        }
        
        if (self.lookStyle == MineHomeStyle) {
            _homeInfo = [homeInfoDict objectForKey:@"mine"];
        } else if (self.lookStyle == ParentHomeStyle) {
            _homeInfo = [homeInfoDict objectForKey:@"parent"];
        }
        
        for (AHomeMember *member in _homeInfo.members) {
            __weak AHomeMember *memberWeak = member;
            [member setSelected:^{
                [self memberNodeAction:memberWeak];
            }];
            
            [member setMenuOperate:^(OperateType ot) {
                [self menuOperateAction:ot member:memberWeak];
            }];
        }
        
        ParallaxHeaderView *headerView = (ParallaxHeaderView*)self.tableView.tableHeaderView;
        [headerView.imageView setImageWithURL:[NSURL URLWithString:_homeInfo.photo]];
        
        [self.tableView reloadData];
        [self stopLoading];
        
    } failureCallback:^(NSString *resp) {
        [self stopLoading];
    }];
}

- (void)memberNodeAction:(AHomeMember*)member {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    AHomeMemberCell *homeCell = (AHomeMemberCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    int index = (int)[_homeInfo.members indexOfObject:member];
    AHomeMemberNodeView *nodeView = [homeCell.memberNodes objectAtIndex:index];
    
    CGPoint point = [homeCell convertPoint:nodeView.center toView:self.view.window];
    AHMAttributeMainController *menuPanel = [AHMAttributeMainController shareInstance:point member:member];
    
    [self.view.window addSubview:menuPanel.view];
}

- (void)addKenBurnView {
    _kenBurnsView = [[JSAnimatedImagesView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) isAnimatioin:NO];
    _kenBurnsView.delegate = self;
    [self setView:_kenBurnsView];
    [self.view addSubview:[self blurView]];
}

- (UIView*)blurView {
    UIVisualEffectView *visualEffectView = nil;
    CGRect blurBounds = CGRectMake(0, 0, 0, 0);
    
    blurBounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = blurBounds;
    
    return visualEffectView;
}

- (void)menuOperateAction:(OperateType)ot member:(AHomeMember*)member {
    switch (ot) {
        case AuthOperate: {
            [self phoneAuth:member];
            break;
        }
            
        case InviteOperate:
            [self sendInvite:member];
            
            break;
            
        case DeleteOperate:
            [self deleteMember:member];
            break;
            
        default:
            break;
    }
    
    [AHMAttributeMainController destroyInstance];
}

- (void)moreMenu {
    NSMutableArray *menus = [NSMutableArray array];
    
    // 不常规
    ABlurMenu *addMemberMesh = [[ABlurMenu alloc]initWithTitle:@"" menuImage:@"home_menu_addperson.png" andColor:[UIColor colorWithRed:59./255. green:71./255 blue:87/255. alpha:.5] andSelect:^{
        [self addMember];
    }];
    
    ABlurMenu *addHomeMesh = [[ABlurMenu alloc]initWithTitle:@"" menuImage:@"home_menu_addhome.png" andColor:[UIColor colorWithRed:59./255. green:71./255 blue:87/255. alpha:.5] andSelect:^{
        [self addHome];
    }];
    
    NSArray *halfwayData = @[addMemberMesh,addHomeMesh];
    NSDictionary *halfwayDic = @{@"data":halfwayData,@"title":@"",@"bgColor":[UIColor colorWithRed:59./255. green:71./255 blue:87/255. alpha:.5]};
    [menus addObject:halfwayDic];
    
    _panelMenu = [[APanelMenuController alloc]initWithMenus:menus CloseStr:@"关闭" blurType:CollectionBlurViewType];
    [_panelMenu addToSuperView:self.view];
}


/**
 * 手机认证
 */
- (void)phoneAuth:(AHomeMember*)member {
    
    AQuickPopupController *popVC = [[AUserPhoneAuthController alloc]initWithMemberInfo:member delegate:self];
    [APopupHandler sharedInstance].pageHeight = 260.;
    UINavigationController *navi = [[APopupHandler sharedInstance]genPopupNavigation:popVC];
    ((AHomePhoneAuthController*)popVC).width = navi.view.frame.size.width;
    
    ((AHomePhoneAuthController*)popVC).familyId = _homeInfo.familyId;
    ((AHomePhoneAuthController*)popVC).index = member.mkey;
    
    [self presentPopupViewController:navi animationType:MJPopupViewAnimationSlideBottomBottom];
    [popVC setOnSelected:^{
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    }];
}

/**
 * 发送邀请
 */
- (void)sendInvite:(AHomeMember*)member {
    AQuickPopupController *popVC = [[AUserInviteActiveController alloc]initWithMemberInfo:member delegate:self];
    UINavigationController *navi = [[APopupHandler sharedInstance]genPopupNavigation:popVC];
    ((AHomeInviteActiveController*)popVC).width = navi.view.frame.size.width;
    ((AHomeInviteActiveController*)popVC).familyId = _homeInfo.familyId;
    
    [self presentPopupViewController:navi animationType:MJPopupViewAnimationSlideBottomBottom];
    
    [popVC setOnSelected:^{
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    }];
}


/**
 * 删除一个成员
 */
- (void)deleteMember:(AHomeMember*)member {
    AQuickPopupController *popVC = [[AUserDeleteMemberController alloc]initWithMemberInfo:member delegate:self];
    UINavigationController *navi = [[APopupHandler sharedInstance]genPopupNavigation:popVC];
    ((AHomeDeleteMemberController*)popVC).width = navi.view.frame.size.width;
    
    ((AHomeDeleteMemberController*)popVC).familyId = _homeInfo.familyId;
    [self presentPopupViewController:navi animationType:MJPopupViewAnimationSlideBottomBottom];
    
    [popVC setOnSelected:^{
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    }];
}

- (void)addMember {
    [_panelMenu closeMenu];
    
    AQuickPopupController *popVC = [[AUserAddMemberController alloc]initWithDelegate:self];
    [APopupHandler sharedInstance].pageHeight = 290.;
    UINavigationController *navi = [[APopupHandler sharedInstance]genPopupNavigation:popVC];
    ((AHomeAddMemberController*)popVC).width = navi.view.frame.size.width;
    
    ((AHomeAddMemberController*)popVC).familyId = _homeInfo.familyId;
    [self presentPopupViewController:navi animationType:MJPopupViewAnimationSlideBottomBottom];
    
    [popVC setOnSelected:^{
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    }];
}

//==============================================
- (void)afterMemberOpration {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    [self reloadHomeInfo];
}

- (void)addHome {
    [_panelMenu closeMenu];
    
    ANewHomeController *newAtHomeCon = [[ANewHomeController alloc]initWithPushStyle:NO];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:newAtHomeCon];
    [self.navigationController presentViewController:navi animated:YES completion:^{
        
    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"AHomeMemberCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        Class controllerClass = NSClassFromString(CellIdentifier);
        cell = [[controllerClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [((ABaseHomeCell*)cell) setDataForCell:_homeInfo];
    
    int index = (int)_homeInfo.members.count - (int)cell.subviews.count;
    if (index == 1 && [cell isKindOfClass:[AHomeMemberCell class]]) {
        [tableView scrollRectToVisible:CGRectMake(0, tableView.contentSize.height - tableView.bounds.size.height, tableView.bounds.size.width, tableView.bounds.size.height) animated:YES];
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _homeInfo.members.count>0?1:0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AHomeMemberCell heightForCell:(int)_homeInfo.members.count];
}

@end
