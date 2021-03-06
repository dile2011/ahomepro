//
//  AUserInfoController.m
//  ahome
//
//  Created by dilei liu on 15/1/17.
//  Copyright (c) 2015年 ushome. All rights reserved.
//

#import "AUserInfoController.h"
#import "QImageTableViewCell.h"
#import "ALoginServer.h"

@implementation AUserInfoController

- (id)init {
    self = [super init];
    
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    self.root = root;
    self.root.title = @"关于我";
    self.resizeWhenKeyboardPresented =YES;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AUser *user = [AUser sharedInstance];
    [[SDWebImageManager sharedManager]downloadWithURL:[NSURL URLWithString:user.avatar] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        QImageElement *faceElement = (QImageElement*)[self.root elementWithKey:@"FaceElement"];
        faceElement.imageValue = image;
    }];
    
    QSection *infoSection = [[QSection alloc]initWithTitle:@"我的信息"];
    [self.root addSection:infoSection];
    QImageElement *faceElement = [[QImageElement alloc]initWithTitle:@"头像" detailImage:nil];
    [faceElement setKey:@"FaceElement"];
    [infoSection addElement:faceElement];

    QLabelElement *unameElement = [[QLabelElement alloc]initWithTitle:@"姓名" Value:user.uname];
    [infoSection addElement:unameElement];
    
    NSString *gender = @"男";if (user.gender == 0) gender = @"女";
    QLabelElement *genderElement = [[QLabelElement alloc]initWithTitle:@"性别" Value:gender];
    [infoSection addElement:genderElement];
    
    QLabelElement *brithElement = [[QLabelElement alloc]initWithTitle:@"生日" Value:user.brithday];
    [infoSection addElement:brithElement];
    
    QSection *regionSection = [[QSection alloc]initWithTitle:@"我的地址"];
    [self.root addSection:regionSection];
    QLabelElement *regionElement = [[QLabelElement alloc]initWithTitle:@"所在地区" Value:user.region];
    [regionSection addElement:regionElement];
    
    
    QSection *actionSection = [[QSection alloc]init];
    [self.root addSection:actionSection];
    QButtonElement *logoutBtnEle = [[QButtonElement alloc]initWithTitle:@"退出登录"];
    [logoutBtnEle setControllerAction:@"doLogoutAction"];
    [actionSection addElement:logoutBtnEle];
}

- (void)doLogoutAction {
    
    [[AServerFactory getServerInstance:@"ALoginServer"]doLogout:^(BOOL opBool) {
        [self dismissViewControllerAnimated:YES completion:^{
            [[AStarViewController sharedInstance]switchEntry];
        }];
        
    } failureCallback:^(NSString *resp) {
        
    }];
    
    
}


@end
