//
//  ABulletinLevelController.m
//  AtHomeApp
//
//  Created by dilei liu on 14-8-23.
//  Copyright (c) 2014年 ushome. All rights reserved.
//

#import "ABulletinLevelController.h"

@implementation ABulletinLevelController

static ABulletinLevelController *sharedInstance = nil;

+ (id)sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[ABulletinLevelController alloc] init];
    }
    
    return sharedInstance;
}

+ (void)destroyDealloc {
    sharedInstance = nil;
}

- (ASideDrawer *)setSideDrawer {
    return [[ASideDrawer alloc]initWithTitle:@"公告栏" menuImage:@"Bracket_Bulletin.png"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.sideDrawer.menuTitle;

}


@end
