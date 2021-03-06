//
//  AUserAddMemberController.m
//  ahome
//
//  Created by andson-dile on 15/6/24.
//  Copyright (c) 2015年 ushome. All rights reserved.
//

#import "AUserAddMemberController.h"
#import "APhoneAuthButtonElement.h"
#import "ANextActionButtonElementView.h"
#import "ANewHomeInviteRoleElementView.h"
#import "AUserHomePageController.h"
#import "UIViewController+MJPopupViewController.h"

#import "AHomeServer.h"

@implementation AUserAddMemberController

- (instancetype)initWithDelegate:(id)delegate {
    self = [super init];
    self.delegate = delegate;
    
    return self;
}

- (void)doNextAction {
    APhoneAuthButtonElement *nextActionButtonElement = (APhoneAuthButtonElement*)[self.root elementWithKey:@"AddMemberAction"];
    ANextActionButtonElementView *nextActionButtonElementView = (ANextActionButtonElementView*)[self.quickDialogTableView cellForElement:nextActionButtonElement];
    [nextActionButtonElementView setButtonState:WorkState];
    
    APhoneAuthButtonElement *inviteEle =  (APhoneAuthButtonElement*)[self.root elementWithKey:@"AHomeInviteRoleElement"];
    ANewHomeInviteRoleElementView *eleView = (ANewHomeInviteRoleElementView*)[self.quickDialogTableView cellForElement:inviteEle];
    
    QEntryElement *phoneEle = (QEntryElement*)[self.root elementWithKey:@"phoneElement"];
    NSString *phoneText = phoneEle.textValue;
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [self.view.window addSubview:[ANotificationCenter shareInstanceByNotifiType:notifiRequest info:@"请求添加一个成员"].view];
    [[AServerFactory getServerInstance:@"AHomeServer"]doAddForHomeMember:phoneText andFamilyId:self.familyId andPart:eleView.roleName
                                                                callback:^(BOOL status) {
                                                                    
                                                                    self.navigationItem.leftBarButtonItem.enabled = YES;
                                                                    
                                                                    [nextActionButtonElementView setButtonState:EnableState];
                                                                    [[ANotificationCenter shareInstance]backCallByParam:@"添加成功:)"];
                                                                    
                                                                    [self.delegate afterMemberOpration];
                                                                    
                                                                } failureCallback:^(NSString *resp) {
                                                                    self.navigationItem.leftBarButtonItem.enabled = YES;
                                                                    [self verifyLoginAction:@"添加失败" andSection:@"basesection"];
                                                                    [nextActionButtonElementView setButtonState:EnableState];
                                                                    [[ANotificationCenter shareInstance]backCallByParam:@"添加失败:)"];
                                                                }];
}

@end
