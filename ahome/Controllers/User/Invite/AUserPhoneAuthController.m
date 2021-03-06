//
//  AUserPhoneAuthController.m
//  ahome
//
//  Created by andson-dile on 15/6/24.
//  Copyright (c) 2015年 ushome. All rights reserved.
//

#import "AUserPhoneAuthController.h"
#import "ANextActionButtonElement.h"
#import "APhoneAuthButtonElementView.h"
#import "AHomeServer.h"

@implementation AUserPhoneAuthController

- (id)initWithMemberInfo:(AHomeMember*)homeMember delegate:(id)delegate {
    self = [super initWithMemberInfo:homeMember];
    self.delegate = delegate;
    
    return self;
}

- (void)doNextAction {
    ANextActionButtonElement *actionButtionElement = (ANextActionButtonElement*)[self.root elementWithKey:@"ANextActionButtonElement"];
    APhoneAuthButtonElementView *accountButtonViewCell = (APhoneAuthButtonElementView*)[self.quickDialogTableView cellForElement:actionButtionElement];
    [accountButtonViewCell setButtonState:WorkState];
    
    QEntryElement *phoneElement = (QEntryElement*)[self.root elementWithKey:@"AHomePhoneAuth"];
    NSString *phoneText = phoneElement.textValue;
    
    if ([phoneText isMatchedByRegex:PhoneRegex]==NO) {
        [self verifyLoginAction:@"手机格式不符" andSection:@"baseSection"];
        return;
    }
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [self hiddenKeyBoard];
    
    [self.view.window addSubview:[ANotificationCenter shareInstanceByNotifiType:notifiRequest info:@"发送认证请求"].view];
    [[AServerFactory getServerInstance:@"AHomeServer"]doAuthForHomeMember:phoneText andFamilyId:self.familyId andMemberIndex:self.index
                                                                 callback:^(BOOL status) {
                                                                     [accountButtonViewCell setButtonState:EnableState];
                                                                     self.navigationItem.leftBarButtonItem.enabled = YES;
                                                                     
                                                                     [self.delegate afterMemberOpration];
                                                                     [[ANotificationCenter shareInstance]backCallByParam:@"认证成功!"];
                                                                     
                                                                 } failureCallback:^(NSString *resp) {
                                                                     [accountButtonViewCell setButtonState:EnableState];
                                                                     self.navigationItem.leftBarButtonItem.enabled = YES;
                                                                     [self verifyLoginAction:resp andSection:@"baseSection"];
                                                                     [[ANotificationCenter shareInstance]backCallByParam:@"认证失败"];
                                                                 }];
    
}

@end
