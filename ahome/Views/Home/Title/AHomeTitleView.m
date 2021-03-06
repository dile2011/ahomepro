//
//  AHomeTitleView.m
//  ahome
//
//  Created by andson-dile on 15/6/16.
//  Copyright (c) 2015年 ushome. All rights reserved.
//

#import "AHomeTitleView.h"
#import "AHomeTitle.h"
#import "AMainRootController.h"
#import "ANaviTitleController.h"
#import "AHomeLevelController.h"

#define navi_size_height    35.

@implementation AHomeTitleView

- (instancetype)init {
    self = [super init];
    _isPullMenu = NO;
    [self initComment];
    return self;
}

- (instancetype)initWithTitleItems:(NSArray*)titleItems index:(int)index {
    self = [super init];
    _isPullMenu = YES;
    _titleItems = [[NSArray alloc]initWithArray:titleItems];
    
    [self initComment];
    
    AHomeTitle *homeTitle = [self getHomeTitleByIndex:index];
    [self setTitle:homeTitle.title image:homeTitle.titleimage];
    
    return self;
}

- (AHomeTitle*)getHomeTitleByIndex:(int)index {
    AHomeTitle *homeTitle = nil;
    
    if (index == 0) {
        homeTitle = [_titleItems firstObject];
        
    } else if (index == 1) {
        homeTitle = [_titleItems objectAtIndex:index];
        
    } else if (index == 2) {
        if (_titleItems.count <= 2) {
            homeTitle = [_titleItems objectAtIndex:1];
        } else {
            homeTitle = [_titleItems objectAtIndex:index];
        }
    }
    
    return homeTitle;
    
}

- (void)initComment {
    [self setBackgroundColor:[UIColor colorWithRed:20./255.0 green:136.0/255 blue:188.0/255. alpha:1.]];
    
    _titleLabel = [[UILabel alloc]init];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [_titleLabel setTextColor:[UIColor whiteColor]];
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 1;
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_titleLabel];
    
    _pullImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_navi_arrowUp.png"]];
    [self addSubview:_pullImageView];
    
    _titleImageView = [[UIImageView alloc]init];
    [self addSubview:_titleImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [self addGestureRecognizer:tap];
}

- (void)setTitle:(NSString*)title image:(NSString*)titleImage {
    [_titleLabel setText:title];
    UIImage *image = [UIImage imageNamed:titleImage];
    [_titleImageView setImage:image];
    
    CGSize titleSize = CGSizeMake(300, 20000.0f);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:_titleLabel.font, NSFontAttributeName,nil];
    titleSize =[_titleLabel.text boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    float w = titleSize.width;
    w += image.size.width + 10;
    if (_isPullMenu) w += _pullImageView.image.size.width+5;
    float h = navi_size_height;
    [self setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-w)/2., 5, w, h)];
    
    [_titleLabel setFrame:CGRectMake((self.frame.size.width-titleSize.width)/2., (self.frame.size.height-titleSize.height)/2., titleSize.width, titleSize.height)];
    
    if (_isPullMenu) {
        [_pullImageView setFrame:CGRectMake(self.frame.size.width-_pullImageView.image.size.width-5, _titleLabel.frame.origin.y, _pullImageView.image.size.width, _pullImageView.image.size.height)];
    } else {
        [_pullImageView setFrame:CGRectZero];
    }
    
    [_titleImageView setFrame:CGRectMake(3, _titleLabel.frame.origin.y-3, image.size.width, image.size.height)];
}

- (void)setTitle:(NSString*)title {
    [_titleLabel setText:title];
    
    CGSize titleSize = CGSizeMake(300, 20000.0f);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:_titleLabel.font, NSFontAttributeName,nil];
    titleSize =[_titleLabel.text boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    float w = titleSize.width;
    if (_isPullMenu) w += _pullImageView.image.size.width+10;
    float h = navi_size_height;
    [self setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-w)/2., 5, w, h)];
    
    [_titleLabel setFrame:CGRectMake(0, (self.frame.size.height-titleSize.height)/2., titleSize.width, titleSize.height)];
    
    if (_isPullMenu) {
        [_pullImageView setFrame:CGRectMake(self.frame.size.width-5-_pullImageView.image.size.width-5, _titleLabel.frame.origin.y, _pullImageView.image.size.width, _pullImageView.image.size.height)];
    } else {
        [_pullImageView setFrame:CGRectZero];
    }
}

- (void)tapHandler:(UITapGestureRecognizer *)recognizer {
    if ([self isPullMenu]) {
        AHomeLevelController *homeLevel = [AHomeLevelController sharedInstance];
        for (UIViewController *vc in homeLevel.childViewControllers) {
            if ([vc isKindOfClass:[ANaviTitleController class]]) {
                [((ANaviTitleController*)vc) closePullMenu];break;
            }
        }
        
        return;
    }
    
    ANaviTitleController *naviTitle = [[ANaviTitleController alloc]initWithItems:_titleItems];
    naviTitle.view.tag = 99999;
    
    AHomeLevelController *homeLevel = [AHomeLevelController sharedInstance];
    [homeLevel addChildViewController:naviTitle];
    [naviTitle didMoveToParentViewController:homeLevel];
    
    [homeLevel disableLeftBtn];
    [[AMainRootController sharedInstance]setOpenDrawerGesture:NO];
    UIBarButtonItem *rightBarButton = [homeLevel.navigationItem.rightBarButtonItems lastObject];
    rightBarButton.enabled = NO;
    
    [naviTitle.view setFrame:CGRectMake(0, 0, homeLevel.view.frame.size.width, homeLevel.view.frame.size.height)];
    [homeLevel.view addSubview:naviTitle.view];
    [self setpullImage:@"home_navi_arrowDown.png"];
}

- (BOOL)isPullMenu {
    AHomeLevelController *homeLevel = [AHomeLevelController sharedInstance];
    for (UIView *subView in homeLevel.view.subviews) {
        if (subView.tag == 99999) return YES;
    }
    
    return NO;
}

- (void)setpullImage:(NSString*)imageName {
    _pullImageView.image = [UIImage imageNamed:imageName];
    
}

@end
