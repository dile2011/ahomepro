//
//  AHMAttributeMainController.m
//  demoe
//
//  Created by andson-dile on 15/3/12.
//  Copyright (c) 2015年 andson. All rights reserved.
//

#import "AHMAttributeMainController.h"
#import "AMenuOpAuthView.h"
#import "AMenuOpInviteView.h"
#import "AMenuOpWaiteView.h"
#import "AHomeLevelController.h"
#import "AHomeMergeCell.h"
#import "UIImage+ImageEffects.h"
#import "AHMAttributeViewController.h"
#import "AMainRootController.h"

static AHMAttributeMainController *menuPanel;

@implementation AHMAttributeMainController

+ (instancetype)shareInstance:(CGPoint)point member:(AHomeMember *)member{
    if (menuPanel) {
        float oldx = menuPanel.startPoint.x;
        [AHMAttributeMainController destroyInstance];
        
        if (point.x == oldx && oldx != [UIScreen mainScreen].bounds.size.width/2.){
            return nil;
        }
    }
    
    if (menuPanel == nil) {
        menuPanel = [[AHMAttributeMainController alloc]initWithPoint:point andMember:member];
    }
    
    return menuPanel;
}

+ (void)destroyInstance {
    if (menuPanel) {
        [menuPanel offsetHidden];
    }
    
    menuPanel = nil;
}

- (instancetype)initWithPoint:(CGPoint)point andMember:(AHomeMember*)member {
    self = [super init];
    _startPoint = point;
    _member = member;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self menuPanelViewNew];
}

- (UIVisualEffectView*)newBlurrySegue:(UIViewController*)source {
    UIVisualEffectView *visualEffectView = nil;
    CGRect blurBounds = CGRectMake(0, 0, 0, 0);
    
    blurBounds = CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = blurBounds;

    return visualEffectView;
}


- (void)menuPanelViewNew {
    MemberState state = StateOther;
    
    if ([_member isKindOfClass:[AHomeMember class]]) {
        AHomeMember *member = (AHomeMember*)_member;
        state = member.memberState;
        
    } else {
        AMergeHomeMember *member = (AMergeHomeMember*)_member;
        state = member.memberState;
    }
    
    switch (state) {
        case StateAuth: {
            _menuPanelView = [[AMenuOpAuthView alloc]initWithHomeMember:_member];
            _menuPanelView.center = _startPoint;
            _menuPanelView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            [self.view addSubview:_menuPanelView];
            break;
        }
            
        case StateInvite: {
            _menuPanelView = [[AMenuOpInviteView alloc]initWithHomeMember:_member];
            _menuPanelView.center = _startPoint;
            _menuPanelView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            [self.view addSubview:_menuPanelView];
            break;
        }
            
        case StateWaitInvite: {
            _menuPanelView = [[AMenuOpWaiteView alloc]initWithHomeMember:_member];
            _menuPanelView.center = _startPoint;
            _menuPanelView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            [self.view addSubview:_menuPanelView];
            
            break;
        }
            
        case StateSelf:
            [self showMemberInfo];
            break;
            
        case StateOther:
            [self showMemberInfo];
            break;
            
        default:
            break;
    }
}

- (void)showMemberInfo {
    //
    AHomeLevelController *homeLevel = [AHomeLevelController sharedInstance];
    UIVisualEffectView *blurView = [self newBlurrySegue:homeLevel.homePage];
    blurView.tag = 666666;
    [self.view insertSubview:blurView atIndex:0];
    
    //
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    FRDLivelyButton *leftButton = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(7,28.3,28,28)];
    [leftButton setStyle:kFRDLivelyButtonStyleClose animated:NO];
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:leftButton];
    [self.view addSubview:headerView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.tag = 44444;
    [nameLabel setFont:[UIFont boldSystemFontOfSize:20.]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [headerView addSubview:nameLabel];
    nameLabel.alpha = 0.;
    
    UILabel *brithLabel = [[UILabel alloc]init];
    brithLabel.tag = 55555;
    [brithLabel setFont:ahomefontWithSize(12.)];
    [brithLabel setTextColor:[UIColor whiteColor]];
    brithLabel.textAlignment = NSTextAlignmentCenter;
    brithLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [headerView addSubview:brithLabel];
    brithLabel.alpha = 0.;
    
    headerView.tag = 11111;
    leftButton.tag = 22222;
    leftButton.alpha = 0.;
    
    NSString *uname;
    NSString *brith;
    if ([_member isKindOfClass:[AMergeHomeMember class]]) {
        AMergeHomeMember *mergeMember = (AMergeHomeMember*)_member;
        uname = mergeMember.uname;
        brith = @"1991/03/12";
        
    } else if ([_member isKindOfClass:[AHomeMember class]]) {
        AHomeMember *homeMember = (AHomeMember*)_member;
        uname = homeMember.uname;
        brith = @"1991/03/12";
    }
    
    [nameLabel setText:uname];
    CGSize titleSize = CGSizeMake(200, 20000.0f);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:nameLabel.font, NSFontAttributeName,nil];
    titleSize =[nameLabel.text boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    [nameLabel setFrame:CGRectMake((SCREEN_WIDTH-titleSize.width)/2., (64-titleSize.height)/2., titleSize.width, titleSize.height)];
    
    [brithLabel setText:brith];
    titleSize = CGSizeMake(200, 20000.0f);
    tdic = [NSDictionary dictionaryWithObjectsAndKeys:brithLabel.font, NSFontAttributeName,nil];
    titleSize =[brithLabel.text boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    [brithLabel setFrame:CGRectMake((SCREEN_WIDTH-titleSize.width)/2., nameLabel.frame.origin.y+nameLabel.frame.size.height, titleSize.width, titleSize.height)];
    
    AHMAttributeViewController *menuPanelAttri = [[AHMAttributeViewController alloc]initWithMember:_member];
    [menuPanelAttri.view setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    menuPanelAttri.view.tag = 33333;
    menuPanelAttri.view.alpha = 0.;
    [self addChildViewController:menuPanelAttri];
    [self.view addSubview:menuPanelAttri.tableView];
    [menuPanelAttri didMoveToParentViewController:self];
}

- (void)leftButtonAction {
    [self offsetHidden];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _direction = DirectionDefault;
    if (_startPoint.x > [UIScreen mainScreen].bounds.size.width/2.) {
        _direction = DirectionLeft;
    } else if (_startPoint.x == [UIScreen mainScreen].bounds.size.width/2.) {
        _direction = DirectionUp;
    }
    
    [self offsetShow];
}

- (void)offsetShow {
    float centerx = _startPoint.x;
    float centery = _startPoint.y;
    
    switch (_direction) {
        case DirectionLeft:
            centerx -= 2*_menuPanelView.getViewSize.width/3.;
            centery -= _menuPanelView.getViewSize.height/3.;
            break;
            
        case DirectionUp:
            centery -= 2*_menuPanelView.getViewSize.height/3.;
            centerx += 40;
            break;
            
        case DirectionDown:
            centery += _menuPanelView.getViewSize.height;
            break;
            
        default:
            centerx += _menuPanelView.getViewSize.width/2.;
            centery -= _menuPanelView.getViewSize.height/3.;
            break;
    }
    
    [UIView animateWithDuration:.4 animations:^{
        _menuPanelView.transform = CGAffineTransformMakeScale(1., 1.);
        _menuPanelView.center = CGPointMake(centerx, centery);
        
        UIView *attriView = [self.view viewWithTag:33333];
        attriView.alpha = 1.;
        
        UIView *blurView = [self.view viewWithTag:666666];
        CGRect frame = blurView.frame;
        frame.origin.x = 0.;
        
        blurView.frame = frame;
    } completion:^(BOOL finished) {
        UIView *headerView = [self.view viewWithTag:11111];
        UIButton *leftButton = (UIButton*)[headerView viewWithTag:22222];
        UILabel *nameLabel = (UILabel*)[headerView viewWithTag:44444];
        UILabel *brithLabel = (UILabel*)[headerView viewWithTag:55555];
        
        nameLabel.alpha  = 1.;
        brithLabel.alpha  = 1.;
        leftButton.alpha = 1.;
    }];
}

- (void)offsetHidden {
    UIView *headerView = [self.view viewWithTag:11111];
    UIButton *leftButton = (UIButton*)[headerView viewWithTag:22222];
    UILabel *nameLabel = (UILabel*)[headerView viewWithTag:44444];
    UILabel *brithLabel = (UILabel*)[headerView viewWithTag:55555];
    
    nameLabel.alpha  = 0.;
    brithLabel.alpha  = 0.;
    leftButton.alpha = 0.;

    [UIView animateWithDuration:.4 animations:^{
        _menuPanelView.transform = CGAffineTransformMakeScale(.001, .001);
        _menuPanelView.center = _startPoint;
        _menuPanelView.alpha = .0;
        
        UIView *attriView = [self.view viewWithTag:33333];
        CGRect frame = attriView.frame;
        frame.origin.x = 2*frame.size.width;
        attriView.frame = frame;
        attriView.alpha = 0.;
        
        UINavigationController *selectedItem = (UINavigationController*)[[AMainRootController sharedInstance]getCurrentSelectedItem];
        ARootViewController *rootController = [selectedItem.viewControllers firstObject];
        [rootController updateLeftBtnStyle:NO];
        
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        
        AHomeLevelController *homeLevel = [AHomeLevelController sharedInstance];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        AHomeMergeCell *homeCell = (AHomeMergeCell*)[homeLevel.homePage.tableView cellForRowAtIndexPath:indexPath];
        if ([homeCell isKindOfClass:[AHomeMergeCell class]]) {
            [homeCell startAnimation];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[_menuPanelView class]]) {
            [AHMAttributeMainController destroyInstance];
        }
    }
    
    AHomeLevelController *homeLevel = [AHomeLevelController sharedInstance];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    AHomeMergeCell *homeCell = (AHomeMergeCell*)[homeLevel.homePage.tableView cellForRowAtIndexPath:indexPath];
    if ([homeCell isKindOfClass:[AHomeMergeCell class]]) {
        [homeCell startAnimation];
    }
}

@end
