//
//  ANewHomeBaseInfoController.m
//  AtHomeApp
//
//  Created by dilei liu on 14-8-31.
//  Copyright (c) 2014年 ushome. All rights reserved.
//

#import "ANewHomeBaseInfoController.h"
#import "ANewHomeImageElement.h"
#import "ANextActionButtonElement.h"
#import "ANewHomeRoleElement.h"
#import "ANewHomeController.h"
#import "ANewHomeImageElementView.h"
#import "ANewHomeInviteRoleElement.h"
#import "ANewHomeRoleElementView.h"
#import "ANextActionButtonElementView.h"
#import "AHomeServer.h"

@implementation ANewHomeBaseInfoController

- (id)init {
    self = [super init];
    
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    self.root = root;
    self.resizeWhenKeyboardPresented =YES;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    QSection *homeImageSection = [[QSection alloc]init];
    [homeImageSection setKey:@"homeImageSection"];
    [self.root addSection:homeImageSection];
    ANewHomeImageElement *homeImageElement = [[ANewHomeImageElement alloc]init];
    [homeImageElement setKey:@"ANewAtHomeImageElement"];
    [homeImageSection addElement:homeImageElement];
    
    QSection *roleSection = [[QSection alloc]initWithTitle:@"选择家庭角色"];
    [self.root addSection:roleSection];
    ANewHomeRoleElement *homeRoleElement = [[ANewHomeRoleElement alloc]init];
    [homeRoleElement setKey:@"HomeRoleElement"];
    [roleSection addElement:homeRoleElement];
    
    QSection *actionSection = [[QSection alloc]init];
    [self.root addSection:actionSection];
    ANextActionButtonElement *nextButtonElement = [[ANextActionButtonElement alloc]init];
    [nextButtonElement setKey:@"ANextActionButtonElement"];
    [actionSection addElement:nextButtonElement];
    
}

- (void)doNextAction {
    [self.delegate doNextAction:NewAtHomeAreaForm];
}

- (void)doUpHomeImage {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"上传家庭全家福"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"相册",@"相机",nil];
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
    [(ANewHomeController*)self.delegate presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [[AStarViewController sharedInstance]updateStatuBarColorByStyle:UIStatusBarStyleLightContent];
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *resetimage = [[AUtilities sharedInstance]compressImage:image fixedWidth:400];
    NSData *fileData = UIImageJPEGRepresentation(resetimage, 1.);
    
    ANewHomeImageElement *imageEle = (ANewHomeImageElement*)[self.root elementWithKey:@"ANewAtHomeImageElement"];
    ANewHomeImageElementView *imagecell = (ANewHomeImageElementView*)[self.quickDialogTableView cellForElement:imageEle];
    [imagecell setHomeImage:image];
    
    ANewHomeForm *newHomeForm = ((ANewHomeController*)self.delegate).createHomeForm;
    newHomeForm.imageData = fileData;
    
    [[AServerFactory getServerInstance:@"AHomeServer"]uploadHomePictureByFile:fileData
                                                                    callback:^(NSDictionary *homePictureInfo) {
                                                                        int imageId = [[homePictureInfo objectForKey:@"image_id"]intValue];
                                                                        newHomeForm.image_id = [NSString stringWithFormat:@"%i",imageId];
                                                                        
                                                                        [self checkFormValue];
                                                                    } failureCallback:^(NSString *resp) {
                                                                        [self verifyLoginAction:resp andSection:@"homeImageSection"];
                                                                    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [[AStarViewController sharedInstance]updateStatuBarColorByStyle:UIStatusBarStyleLightContent];
    }];
}

- (void)setRoleForNewHome:(int)roleIndex andRoleName:(NSString*)roleName{
    ANewHomeController *newHomeController = (ANewHomeController*)self.delegate;
    ANewHomeForm *newHomeForm = newHomeController.createHomeForm;
    newHomeForm.part = roleName;
    
    [self checkFormValue];
}

- (void)checkFormValue {
    BOOL checkValue = NO;
    
    ANewHomeController *newHomeController = (ANewHomeController*)self.delegate;
    ANewHomeForm *newHomeForm = newHomeController.createHomeForm;
    if(newHomeForm.image_id.length > 0 && newHomeForm.part.length > 0) checkValue = YES;
    
    ANextActionButtonElement *nextActionButtonElement = (ANextActionButtonElement*)[self.root elementWithKey:@"ANextActionButtonElement"];
    ANextActionButtonElementView *nextActionButtonElementView = (ANextActionButtonElementView*)[self.quickDialogTableView cellForElement:nextActionButtonElement];
    
    if (checkValue)[nextActionButtonElementView setButtonState:EnableState];
    else [nextActionButtonElementView setButtonState:DisableState];
}


@end
