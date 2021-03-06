//
//  AFamilyLevelController.m
//  ahome
//
//  Created by dilei liu on 15/6/20.
//  Copyright (c) 2015年 ushome. All rights reserved.
//

#import "AFamilyLevelController.h"

#define bottom_toolbar_size 55

@implementation AFamilyLevelController

static AFamilyLevelController *sharedInstance = nil;
+ (id)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[AFamilyLevelController alloc] initWithIsKenBlur:NO];
    }
    
    return sharedInstance;
}

+ (void)destroyDealloc {
    sharedInstance = nil;
}

- (ASideDrawer *)setSideDrawer {
    return [[ASideDrawer alloc]initWithTitle:@"家族圈" menuImage:@"Bracket_Family.png"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _homeCircle = [[AFamilyHomeCircleController alloc]init];
    
    CGRect theFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [_homeCircle setTheFrame:theFrame];
    
    [self.view addSubview:_homeCircle.view];
}

- (void)setDefaultNavigationStyle {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"family_navi_background.jpeg"]forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = NO;
}

@end
