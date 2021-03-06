//
//  APanelMenuController.m
//  demoe
//
//  Created by andson-dile on 15/3/6.
//  Copyright (c) 2015年 andson. All rights reserved.
//

#import "APanelMenuController.h"
#import "ABlurMeshController.h"
#import "ABlurTableController.h"
#import "ABlurCollectionController.h"
#import "ABlurToolView.h"

#define blur_top_margin         10
#define blur_bottom_margin      10

#define blur_mesh_size              75
#define blur_table_size             350
#define blur_collection_unitSize    110.

#define blur_close_size         60

@implementation APanelMenuController

- (instancetype)initWithMenus:(NSArray*)menus CloseStr:(NSString*)colseStr {
    self = [super init];
    _menus = menus;
    _closeStr = colseStr;
    _blurViewType = DefaultBlurViewType;
    
    return self;
}

- (instancetype)initWithBlurType:(BlurViewType)blurType CloseStr:(NSString*)colseStr {
    self = [super init];
    
    _closeStr = colseStr;
    _blurViewType = DefaultBlurViewType;
    
    return self;
}

- (instancetype)initWithMenus:(NSArray*)menus CloseStr:(NSString*)colseStr blurType:(BlurViewType)blurType {
    self = [super init];
    _menus = menus;
    _closeStr = colseStr;
    _blurViewType = blurType;
    
    return self;
}


- (float)computeBlurHeight {
    float blurH = 0;
    int rowNo = 0;

    blurH += blur_top_margin;
    blurH += blur_bottom_margin;
    blurH += blur_close_size;
    
    int width = self.view.frame.size.width;
    float msize = width%blur_mesh_size;
    
    if (msize > 0) {
        float meshsize = width - msize;
        _blurMarginLeft = msize/2.;
        
        int numbyrow = meshsize/blur_mesh_size;
        rowNo = (int)_menus.count/numbyrow;
        
        if ((int)_menus.count%numbyrow > 0) {
            rowNo += 1;
        }
    } else {
        float meshsize = width - msize;
        _blurMarginLeft = .0;
        
        int numbyrow = meshsize/blur_mesh_size;
        rowNo = (int)_menus.count/numbyrow;
        
        if ((int)_menus.count%numbyrow > 0) {
            rowNo += 1;
        }
    }
    
    blurH += rowNo*blur_mesh_size;
    
    return blurH;
}

- (UIView*)blurView {
    UIVisualEffectView *visualEffectView = nil;
    CGRect blurBounds = CGRectMake(0, 0, 0, 0);
    
    if (_blurViewType == DefaultBlurViewType)
        blurBounds = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, [self computeBlurHeight]);
    
    else if (_blurViewType == TableBlurViewType)
        blurBounds = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, blur_table_size);
    
    else if (_blurViewType == CollectionBlurViewType)
        blurBounds = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, blur_collection_unitSize*_menus.count+blur_close_size+5);
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = blurBounds;
    [self.view addSubview:visualEffectView];
    
    return visualEffectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *blurView = [self blurView];
    [self.view addSubview:blurView];
    
    // close button
    CGRect toolRect = CGRectMake(0, blurView.frame.size.height-blur_close_size, blurView.frame.size.width, blur_close_size);
    ABlurToolView *toolView = [[ABlurToolView alloc]initWithFrame:toolRect andTitle:_closeStr andSelect:^(void) {
        [self closeMenu];
    }];
    
    [blurView addSubview:toolView];
    
    float margin_top = blur_top_margin;
    float margin_bottom = blur_bottom_margin;
    
    // blur menu
    if (_blurViewType == DefaultBlurViewType) {
        _baseBlurVC = [[ABlurMeshController alloc]initWithMenus:_menus meshSize:blur_mesh_size];

    } else if (_blurViewType == TableBlurViewType) {
        _baseBlurVC = [[ABlurTableController alloc]initWithMenus:_menus];
        
    } else if (_blurViewType == CollectionBlurViewType) {
        _baseBlurVC = [[ABlurCollectionController alloc]initWithMenus:_menus];
        margin_top = 10.;margin_bottom = 10.;
    }
    
    _baseBlurVC.frame = CGRectMake(_blurMarginLeft, margin_top, blurView.frame.size.width-2*_blurMarginLeft, blurView.frame.size.height - blur_close_size-(margin_top+margin_top));
    [_baseBlurVC.view setFrame:CGRectMake(_blurMarginLeft, margin_top, blurView.frame.size.width-2*_blurMarginLeft, blurView.frame.size.height - blur_close_size-(margin_top+margin_bottom))];
    
    [blurView addSubview:_baseBlurVC.view];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self enableMenu];
}

- (void)enableMenu {
    [UIView animateWithDuration:.4 animations:^{
        [self.view setBackgroundColor:[UIColor colorWithRed:0. green:0. blue:0. alpha:.3]];
    }];
    
    [UIView animateWithDuration:.3 animations:^{
        UIView *blurView = [self.view.subviews lastObject];
        CGRect frame = blurView.frame;
        
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        blurView.frame = frame;
    }];
    
}

- (void)closeMenu {
    [UIView animateWithDuration:.4 animations:^{
        [self.view setBackgroundColor:[UIColor clearColor]];
    }];
    
    [UIView animateWithDuration:.3 animations:^{
        UIView *blurView = [self.view.subviews lastObject];
        CGRect frame = blurView.frame;
        
        frame.origin.y = self.view.frame.size.height;
        blurView.frame = frame;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    
}

- (void)addToSuperView:(UIView*)superView {
    [superView.window addSubview:self.view];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBlurMenu)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)closeBlurMenu {
    [self closeMenu];
}

@end
