//
//  ARootTableRefreshController.m
//  ahome
//
//  Created by andson-dile on 15/6/24.
//  Copyright (c) 2015年 ushome. All rights reserved.
//

#import "ARootTableRefreshController.h"
#import "AHomeLevelController.h"
#import "AMainRootController.h"

#define refresh_width_size  250
#define RefreshControlHeight 109.0

#define CHGIFAnimationDict @[\
@{@"name":@"AHOME! Weather Style",@"pattern":@"sun_%05d.png",@"drawingStart":@0,@"drawingEnd":@42,@"loadingStart":@42,@"loadingEnd":@109},\
]

@implementation ARootTableRefreshController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.sideDrawer.menuTitle;
    _lastPosition = 0;
    _direction = ScrollDirectionDefalut;
    
    [self.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addRefreshImgView];
}

- (void)addRefreshImgView {
    NSMutableArray *drawingImgs = [NSMutableArray array];
    NSMutableArray *loadingImgs = [NSMutableArray array];
    
    NSUInteger drawingStart = [CHGIFAnimationDict[0][@"drawingStart"] intValue];
    NSUInteger drawingEnd = [CHGIFAnimationDict[0][@"drawingEnd"] intValue];
    
    NSUInteger laodingStart = [CHGIFAnimationDict[0][@"loadingStart"] intValue];
    NSUInteger loadingEnd = [CHGIFAnimationDict[0][@"loadingEnd"] intValue];
    
    for (NSUInteger i  = drawingStart; i <= drawingEnd; i++) {
        NSString *fileName = [NSString stringWithFormat:CHGIFAnimationDict[0][@"pattern"],i];
        [drawingImgs addObject:[UIImage imageNamed:fileName]];
    }
    
    for (NSUInteger i  = laodingStart; i <= loadingEnd; i++) {
        NSString *fileName = [NSString stringWithFormat:CHGIFAnimationDict[0][@"pattern"],i];
        [loadingImgs addObject:[UIImage imageNamed:fileName]];
    }
    
    _refreshImgView = [[APullRefreshView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-refresh_width_size)/2.,0, refresh_width_size, 44)];
    _refreshImgView.alpha = .0;
    _refreshImgView.drawImages = drawingImgs;
    _refreshImgView.loadImages = loadingImgs;
    
    UIViewController *selectedItem = [[AMainRootController sharedInstance]getCurrentSelectedItem];
    if ([selectedItem isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController*)selectedItem).navigationBar addSubview:self.refreshImgView];
    }
}

#pragma scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_isLoading || _isTask) return;
    _direction = ScrollDirectionDefalut;
    
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion > 0) _direction = ScrollDirectionUp;
    else if (currentPostion < 0) _direction = ScrollDirectionDown;
    if (_direction == ScrollDirectionUp) return;
    
    CGFloat offset = -scrollView.contentOffset.y;
    CGFloat percent = 0;  // 下拉距离大小值与RefreshControllerHeight高度的比例
    
    if (offset < 44) return;
    if (offset > (RefreshControlHeight+44))offset = RefreshControlHeight;
    else offset -= 44;
    
    percent = offset / (RefreshControlHeight);
    NSUInteger drawingIndex = percent * (_refreshImgView.drawImages.count-1);
    
    if (scrollView.isDragging && drawingIndex < (_refreshImgView.drawImages.count-1)) {
        _pullState = pullToRefreshStateDrawing;
        
    } else if(!scrollView.isDragging && drawingIndex == (_refreshImgView.drawImages.count-1)){
        _pullState = pullToRefreshStateLoading;
    }
    
    if (scrollView.dragging)[self showRefreshControl];
    switch (_pullState) {
        case pullToRefreshStateDrawing:
            [_refreshImgView drawLoadImage:(int)drawingIndex];
            
            break;
            
        case pullToRefreshStateLoading:
            [self startLoading];
            
            break;
            
        default:
            break;
    }
    
    if(!_isLoading && !scrollView.dragging) {
        [self hiddenRefreshControlByModel:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(!_isLoading) [self hiddenRefreshControlByModel:NO];
}

- (void)showRefreshControl {
    _refreshImgView.alpha = 1.;
}


- (void)hiddenRefreshControlByModel:(BOOL)model {
    float time = 0.;
    if (model) time = 1.;
    
    _isTask = YES;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _refreshImgView.alpha = .0;
        _isLoading = NO;
        _isTask = NO;
        
        [_refreshImgView resetRefreshLabel];
    });
    
}


-(void)stopLoading{
    if (_pullState == pullToRefreshStateLoading) {
        _pullState = PullToRefreshStateNormal;
        [_refreshImgView endAnimationLoad];
        [self hiddenRefreshControlByModel:YES];
    }
}

- (void)startLoading {
    _isLoading = YES;
    _pullState = pullToRefreshStateLoading;
    [_refreshImgView startAnimationLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10.;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    return cell;
}


@end

