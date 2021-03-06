//
//  AMainRootController.h
//  AtHomeApp
//
//  Created by dilei liu on 14-8-23.
//  Copyright (c) 2014年 ushome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMainBracketController.h"
#import "ABaseViewController.h"

@interface AMainRootController : ABaseViewController {
    AMainBracketController *_bracketController;
}

+ (id)sharedInstance;
+ (void)destroyDealloc;

/**
 * 进入用户中心
 */
- (void)entryUserCenterView;

- (UIViewController*)getCurrentSelectedItem;

- (void)setOpenDrawerGesture:(BOOL)isOpen;
- (void)setCloseDrawerGesture:(BOOL)isOpen;


@end
