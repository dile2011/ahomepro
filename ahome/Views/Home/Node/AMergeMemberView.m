//
//  AMergeMemberView.m
//  ahome
//
//  Created by andson-dile on 15/6/18.
//  Copyright (c) 2015年 ushome. All rights reserved.
//

#import "AMergeMemberView.h"
#import "AMergeHomeMember.h"
#import "UIImageView+WebCache.h"
#import "AUserCookie.h"
#import "AHomeMergeCell.h"

@implementation AMergeMemberView

- (instancetype)init {
    self = [super init];
    [self initCommon];
    
    _faceImageView = [[UIImageView alloc]init];
    _faceImageView.userInteractionEnabled = YES;
    _faceImageView.layer.masksToBounds = YES;
    [_faceImageView setBackgroundColor:[UIColor clearColor]];
    [_faceImageView setBounds:CGRectMake(0, 0, self.bounds.size.width-30, self.bounds.size.height-30)];
    _faceImageView.center = CGPointMake(self.bounds.size.width/2., self.bounds.size.height/2.);
    [self addSubview:_faceImageView];
    
    [_faceImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doClickHomeMember:)]];
    
    return self;
}

- (void)initCommon {
    _isAnimation = NO;

    NSDictionary *dic = [[AUtilities sharedInstance]homeMergeMemberSize];
    int min = [[dic objectForKey:@"min"]intValue];
    int max = [[dic objectForKey:@"max"]intValue];
    
    int randNum = rand()%(max - min) + min;
    [self setBounds:CGRectMake(0, 0, randNum, randNum)];
    [self setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2., [AHomeMergeCell heightForCell:1]/2.)];
    
    
}

- (void)setData:(ARecord*)record {
    _member = record;
    
    AMergeHomeMember *mergeMember = (AMergeHomeMember*)record;
    AUserCookie *userCookie = [AUserCookie userCookie];
    [_faceImageView setImageWithURL:[NSURL URLWithString:mergeMember.avatar] placeholderImage:[UIImage imageNamed:mergeMember.placeHolderImage]];
    if (userCookie.serverId == mergeMember.uid)[_faceImageView setBounds:CGRectMake(0, 0, 70, 70)];
    _faceImageView.layer.cornerRadius = _faceImageView.frame.size.width/2.;
    
    if (userCookie.serverId == mergeMember.uid) return;
    
     float adius = 2*[AHomeMergeCell radiusSize];
     if (mergeMember.homeType == ParentHomeType) adius = 3*[AHomeMergeCell radiusSize];
    
     CGPoint point = [[AUtilities sharedInstance]pointByCircleAngleEast:mergeMember.angle adius:adius center:CGPointMake([UIScreen mainScreen].bounds.size.width/2., [AHomeMergeCell heightForCell:1]/2.)];
    
     [UIView animateKeyframesWithDuration:1. delay:.5 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
         if (!_isAnimation)self.center = point;

     } completion:^(BOOL finished) {
         if (!_isAnimation) {
             _isAnimation = YES;
             [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
         }
     }];
    
    
}

- (void)timerFired:(id)timer {
    self.frame = [[self.layer presentationLayer] frame];
}
     
- (void)doClickHomeMember:(UIGestureRecognizer*)recognizer {
    AHomeMergeCell *mergeHomeCell = (AHomeMergeCell*)self.superview;
    [mergeHomeCell stopAnimation];
    
    [UIView animateWithDuration:.1 animations:^{
        _faceImageView.transform = CGAffineTransformMakeScale(.9, .9);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 animations:^{
            _faceImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.1 animations:^{
                _faceImageView.transform = CGAffineTransformMakeScale(1., 1.);
                
            } completion:^(BOOL finished) {
                AMergeHomeMember *mergeMember = (AMergeHomeMember*)_member;
                mergeMember.selected();
            }];
        }];
    }];
}

@end
