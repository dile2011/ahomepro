//
//  AMainRootController.m
//  AtHomeApp
//
//  Created by dilei liu on 14-8-23.
//  Copyright (c) 2014年 ushome. All rights reserved.
//

#import "AMainRootController.h"
#import "ADrawerVisualStateManager.h"
#import "ABulletinLevelController.h"
#import "AHomeLevelController.h"
#import "ALeftSideDrawerController.h"
#import "AUserLevelController.h"
#import "AFamilyLevelController.h"
#import "AHumanLevelController.h"

@implementation AMainRootController

static AMainRootController *sharedManager = nil;

+ (id)sharedInstance {
    if (sharedManager == nil)sharedManager = [[AMainRootController alloc] init];

    return sharedManager;
}


+ (void)destroyDealloc {
    sharedManager = nil;
    
    [AHomeLevelController destroyDealloc];
    [AFamilyLevelController destroyDealloc];
    [AHumanLevelController destroyDealloc];
    [ABulletinLevelController destroyDealloc];
    [AUserLevelController destroyDealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    _bracketController = (AMainBracketController*)[self setBusinessController];
    [self.view addSubview:_bracketController.view];
    
    [[AStarViewController sharedInstance]updateStatuBarColorByStyle:UIStatusBarStyleLightContent];
}

- (void)entryUserCenterView {
    ALeftSideDrawerController *leftSide = (ALeftSideDrawerController*)_bracketController.leftDrawerViewController;
    [leftSide entryUserCenterController];
}

- (UIViewController*)getCurrentSelectedItem {
    return _bracketController.centerViewController;
}

- (UIViewController*)setBusinessController {
    NSMutableArray *levelControllers = [[NSMutableArray alloc]init];
    ALeftSideDrawerController *leftController = [[ALeftSideDrawerController alloc]init];
    
    AHomeLevelController *homeLevel = [AHomeLevelController sharedInstance];
    UINavigationController *navigationLevel = [[UINavigationController alloc] initWithRootViewController:homeLevel];
    [levelControllers addObject:navigationLevel];
    navigationLevel.navigationBar.translucent = NO;
    
    //
    AFamilyLevelController *familyLevel = [AFamilyLevelController sharedInstance];
    navigationLevel = [[UINavigationController alloc] initWithRootViewController:familyLevel];
    [levelControllers addObject:navigationLevel];
    navigationLevel.navigationBar.translucent = NO;
    
    //
    AHumanLevelController *humanLevel = [AHumanLevelController sharedInstance];
    navigationLevel = [[UINavigationController alloc] initWithRootViewController:humanLevel];
    [levelControllers addObject:navigationLevel];
    navigationLevel.navigationBar.translucent = NO;
    
    //
    ABulletinLevelController *bulletinLevel = [ABulletinLevelController sharedInstance];
    navigationLevel = [[UINavigationController alloc] initWithRootViewController:bulletinLevel];
    [levelControllers addObject:navigationLevel];
    navigationLevel.navigationBar.translucent = NO;
    
    AMainBracketController *bracketController = [[AMainBracketController alloc]initWithLevelControllers:levelControllers leftDrawerController:leftController];
    
    [bracketController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [bracketController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [bracketController setDrawerVisualStateBlock:
     ^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[ADrawerVisualStateManager sharedManager]drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block) block(drawerController, drawerSide, percentVisible);
     }];
    
    return bracketController;
}

- (void)setOpenDrawerGesture:(BOOL)isOpen {
    if (!isOpen) {
        [_bracketController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    } else {
        [_bracketController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    }
}

- (void)setCloseDrawerGesture:(BOOL)isOpen {
    if (!isOpen) {
        [_bracketController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    } else {
        [_bracketController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    }
}

@end
