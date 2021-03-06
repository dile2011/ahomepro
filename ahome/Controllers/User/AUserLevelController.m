//
//  AUserLevelController.m
//  Ahome
//
//  Created by dilei liu on 14/12/1.
//  Copyright (c) 2014年 ushome. All rights reserved.
//

#import "AUserLevelController.h"
#import "AUserInfoController.h"

#import "UIImageView+WebCache.h"
#import "ParallaxHeaderView.h"
#import "AstatisticsView.h"
#import "AFamilyViewCell.h"
#import "ALeftSideDrawerController.h"
#import "PAImageView.h"
#import "AHomeUserServer.h"
#import "AUserCookie.h"
#import "AUserHomePageController.h"

#define headerview_size_height  40
#define headerface_size_width   90
#define headerface_size_height  70

@implementation AUserLevelController

static AUserLevelController *sharedInstance = nil;
+ (id)sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[AUserLevelController alloc] initWithIsKenBlur:YES];
    }
    
    return sharedInstance;
}

+ (void)destroyDealloc {
    sharedInstance = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:1 green:1.0 blue:1.0 alpha:.2]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = YES;
    
    UIBarButtonItem *moreButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"auser_rightbutton.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace                                                                               target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, moreButtonItem];
    

    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithCGSize:CGSizeMake(self.tableView.frame.size.width, 200)];
    headerView.headerImage = [UIImage imageNamed:@"guide_background2.jpg"];
    [self.tableView setTableHeaderView:headerView];
    AUser *user = [AUser sharedInstance];
    headerView.headerTitleLabel.text = user.uname;
    
    //
    AstatisticsView *statisticsView = [[AstatisticsView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height-headerview_size_height,self.tableView.frame.size.width, headerview_size_height) andX:headerface_size_width+10];
    statisticsView.tag = 2;
    [headerView addSubview:statisticsView];
    
    // 头像
    CGRect rect = CGRectMake(10, headerView.frame.size.height-headerface_size_height, headerface_size_width, headerface_size_height);
    UIImageView *faceView = [[UIImageView alloc]initWithFrame:rect];
    faceView.tag = 1;
    [faceView setImage:[UIImage imageNamed:@"auser_upload_avatar.png"]];
    [faceView setImageWithURL:[NSURL URLWithString:user.avatar]];
    faceView.userInteractionEnabled = YES;
    faceView.contentMode = UIViewContentModeScaleAspectFill;
    faceView.clipsToBounds = YES;
    [faceView setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:faceView];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture)];
    tapGesture.numberOfTapsRequired=1;
    [faceView addGestureRecognizer:tapGesture];
    
    [self startLoading];
}

- (void)startLoading {
    [self reloadInfo];
    [super startLoading];
}


- (void)reloadInfo{
    AUserCookie *userCookie =[AUserCookie userCookie];
    [[AServerFactory getServerInstance:@"AHomeUserServer"]selectUserInfoByUid:userCookie.serverId callback:^(AUser *user) {
        AUser *localUser = [AUser sharedInstance];
        [localUser setAvatar:user.avatar];
        
        AstatisticsView *statisticsView = (AstatisticsView*)[self.tableView.tableHeaderView viewWithTag:2];
        [statisticsView setFamilyNo:(int)user.familys.count];
        UIImageView *faceView = (UIImageView*)[self.tableView.tableHeaderView viewWithTag:1];
        [faceView setImageWithURL:[NSURL URLWithString:user.avatar]];
        
        [self.tableView reloadData];
        [self stopLoading];
    } failureCallback:^(NSString *resp) {
        [self stopLoading];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = [NSString  stringWithFormat:@"auser_section_%i",(int)indexPath.section];
    NSString *CellIdentifier = @"ARelatedViewCell";
    if(indexPath.section == 1) CellIdentifier = @"AFamilyViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        Class controllerClass = NSClassFromString(CellIdentifier);
        cell = [[controllerClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    AUser *user = [AUser sharedInstance];
    if (indexPath.section == 0) {
        [((AUserBaseViewCell*)cell) setDataForCell:user];

    } else if (indexPath.section == 1){
        [((AUserBaseViewCell*)cell) setDataForCell:[user.familys objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AUser *user = [AUser sharedInstance];
    
    if (section == 0) return 1;
    else if (section == 1) return user.familys.count;
    
    return 0.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 0;
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) return nil;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 35)];
    [view setBackgroundColor:[UIColor colorWithRed:0. green:0. blue:0. alpha:.1]];
    
    NSString *title = @"家庭";
    UILabel *headerTitleLable = [[UILabel alloc]init];
    [headerTitleLable setText:title];
    [headerTitleLable setFont:[UIFont fontWithName:@"Heiti SC" size:15]];
    headerTitleLable.textAlignment = NSTextAlignmentCenter;
    [headerTitleLable setTextColor:[UIColor whiteColor]];
    headerTitleLable.lineBreakMode = NSLineBreakByWordWrapping;
    [headerTitleLable setBackgroundColor:[UIColor clearColor]];
    headerTitleLable.numberOfLines = 1;
    CGSize titleSize = CGSizeMake(100, 20000.0f);
    NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:headerTitleLable.font, NSFontAttributeName,nil];
    titleSize =[headerTitleLable.text boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    [headerTitleLable setFrame:CGRectMake(10, (view.frame.size.height-titleSize.height)/2., titleSize.width, titleSize.height)];
    [view addSubview:headerTitleLable];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return [AUserBaseViewCell heightForCell];
    if (indexPath.section == 1) return [AFamilyViewCell heightForCell];
    
    return 0.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return;
    AUserHomePageController *homePage = [[AUserHomePageController alloc]initWithLookStyle:(int)indexPath.row+1];
    [self.navigationController pushViewController:homePage animated:YES];
    
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
}

- (void)handleTapGesture {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"给自己换个全新的图像"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"打开相册",@"打开相机",nil];
    [actionSheet showInView:self.view];
}



- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2) return;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (buttonIndex == 0) sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if(![UIImagePickerController isSourceTypeAvailable:sourceType])sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = YES;
    
    [[AStarViewController sharedInstance]updateStatuBarColorByStyle:UIStatusBarStyleDefault];
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[AStarViewController sharedInstance]updateStatuBarColorByStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[AStarViewController sharedInstance]updateStatuBarColorByStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *resetimage = [[AUtilities sharedInstance]compressImage:image fixedWidth:200.];
    NSData *fileData = UIImageJPEGRepresentation(resetimage, 1.);
    
    [[AServerFactory getServerInstance:@"AHomeUserServer"]uploadFacePictureByFile:fileData callback:^(NSString *userFaceUrl) {
        
        //
        ParallaxHeaderView *headerView = (ParallaxHeaderView*)self.tableView.tableHeaderView;
        UIImageView *faceView = (UIImageView*)[headerView viewWithTag:1];
        faceView.contentMode = UIViewContentModeScaleAspectFill;
        faceView.clipsToBounds = YES;
        faceView.image = resetimage;
        
        AUser *user = [AUser sharedInstance];
        user.avatar = userFaceUrl;
    
        //
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMenuFaceNotification" object:userFaceUrl userInfo:nil];
        
    } failureCallback:^(NSString *resp) {
        
    }];
}

- (void)rightButtonAction {
    AUserInfoController *userInfoVC = [[AUserInfoController alloc]init];
    userInfoVC.isPush = NO;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:userInfoVC];
    [self.navigationController presentViewController:navi animated:YES completion:^{
        
    }];
}


@end
