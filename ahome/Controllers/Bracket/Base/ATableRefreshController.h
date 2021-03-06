//
//  ATableRefreshController.h
//  demoe
//
//  Created by andson-dile on 15/3/19.
//  Copyright (c) 2015年 andson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APullRefreshView.h"
#import "ARootViewController.h"


typedef enum {
    PullToRefreshStateNormal,
    pullToRefreshStateDrawing,
    pullToRefreshStateLoading,
} PullToRefreshState;

typedef enum {
    ScrollDirectionDefalut,
    ScrollDirectionUp,
    ScrollDirectionDown,
} ScrollDirection;

@interface ATableRefreshController : ABaseViewController<UITableViewDataSource,UITableViewDelegate> {
    PullToRefreshState _pullState;
    BOOL _isLoading;
    BOOL _isTask;
    
    float _lastPosition;
    ScrollDirection _direction;
}

@property (nonatomic,retain)UITableView *tableView;

@property (strong, nonatomic) APullRefreshView *refreshImgView;


/**
 *  停止刷新状态
 */
-(void)stopLoading;
- (void)startLoading;

- (UIViewController*)getCurrentShowNavi;
- (APullRefreshView*)newPullRefreshView;
- (void)showRefreshControl;
- (void)hiddenRefreshControlByModel:(BOOL)model;

-(void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
