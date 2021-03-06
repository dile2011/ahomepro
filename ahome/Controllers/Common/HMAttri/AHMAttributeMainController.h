//
//  AHMAttributeMainController.h
//  demoe
//
//  Created by andson-dile on 15/3/12.
//  Copyright (c) 2015年 andson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AHomeMember.h"
#import "ABaseMenuView.h"

typedef enum {
    DirectionDefault, // Defalut Right
    DirectionLeft,
    DirectionUp,
    DirectionDown,
    
}PanelDirection;

@interface AHMAttributeMainController : UIViewController {
    id _member;
    
    PanelDirection _direction;
    ABaseMenuView *_menuPanelView;
}

@property (nonatomic,assign)CGPoint startPoint;

+ (instancetype)shareInstance:(CGPoint)point member:(AHomeMember *)member;
+ (void)destroyInstance;

@end
