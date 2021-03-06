//
//  ABaseViewController.h
//  AtHomeApp
//
//  Created by dilei liu on 14-8-23.
//  Copyright (c) 2014年 ushome. All rights reserved.
//

#import "ABaseViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "FRDLivelyButton.h"

@implementation ABaseViewController

- (instancetype)init {
    self = [super init];
    _isPush = YES;
    _isKenBlur = NO;
    
    return self;
}


- (id)initWithPushStyle:(BOOL)isPush {
    self = [super init];
    _isPush = isPush;
    _isKenBlur = NO;
    
    return self;
}

- (id)initWithIsKenBlur:(BOOL)isKenBlur {
    self = [super init];
    _isPush = YES;
    _isKenBlur = isKenBlur;
    
    return self;
}

- (void)viewDidLoad {
    if (_isKenBlur)[self addKenBurnView];
    
    [super viewDidLoad];
    
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view setBackgroundColor:[UIColor colorWithRed:249./255 green:249.0/255 blue:249.0/255 alpha:1.0]];
    
    [self addLeftButtonItem];
    [self addRightButtonItem];
}

- (UIView*)blurView {
    UIVisualEffectView *visualEffectView = nil;
    CGRect blurBounds = CGRectMake(0, 0, 0, 0);

    blurBounds = CGRectMake(0, -1000, self.view.frame.size.width, self.view.frame.size.height+2000);
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = blurBounds;
    
    return visualEffectView;
}

- (void)addKenBurnView {
    _kenBurnsView = [[JSAnimatedImagesView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _kenBurnsView.delegate = self;
    [self setView:_kenBurnsView];
    [self.view addSubview:[self blurView]];
}

- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView {
    return 3;
}

- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index {
    return [UIImage imageNamed:[NSString stringWithFormat:@"guide_background2.jpg"]];
}

- (void)addRightButtonItem {

}

- (void)addLeftButtonItem {
    if (_isPush) {return;} //[leftButton setStyle:kFRDLivelyButtonStyleArrowLeft animated:NO];
    FRDLivelyButton *leftButton = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0,0,28,28)];;
    [leftButton setStyle:kFRDLivelyButtonStyleClose animated:NO];
    
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, buttonItem];
}

- (void)rightButtonAction {
    
}

- (void)leftButtonAction {
    if (_isPush) {
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setDefaultNavigationStyle];
    [_kenBurnsView startAnimating];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[_kenBurnsView stopAnimating];
}

- (void)setDefaultNavigationStyle {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:19.0], NSFontAttributeName, nil]];
    
    UIColor *navBgColor = [UIColor colorWithRed:20./255.0 green:136.0/255 blue:188.0/255. alpha:.05];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:navBgColor];
    self.navigationController.navigationBar.translucent = NO;
}

@end
