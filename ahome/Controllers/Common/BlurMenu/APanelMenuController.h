//
//  APanelMenuController.h
//  demoe
//
//  Created by andson-dile on 15/3/6.
//  Copyright (c) 2015年 andson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABlurBaseController.h"


typedef enum {
    DefaultBlurViewType,    // 默认为分散式布局
    TableBlurViewType,      // TABLE格式布局
    CollectionBlurViewType  // 风格式布局
    
} BlurViewType;

@interface APanelMenuController : UIViewController {
    NSString *_closeStr;
    BlurViewType _blurViewType;
    
    ABlurBaseController *_baseBlurVC;
    float _blurMarginLeft;
}

@property (nonatomic,retain)NSArray *menus;

- (instancetype)initWithMenus:(NSArray*)menus CloseStr:(NSString*)colseStr;
- (instancetype)initWithBlurType:(BlurViewType)blurType CloseStr:(NSString*)colseStr;
- (instancetype)initWithMenus:(NSArray*)menus CloseStr:(NSString*)colseStr blurType:(BlurViewType)blurType;

- (void)closeMenu;
- (void)addToSuperView:(UIView*)superView;
@end
