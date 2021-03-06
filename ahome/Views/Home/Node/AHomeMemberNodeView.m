//
//  AHomeMemberNodeView.m
//  demoe
//
//  Created by andson-dile on 15/3/11.
//  Copyright (c) 2015年 andson. All rights reserved.
//

#import "AHomeMemberNodeView.h"
#import "UIImageView+WebCache.h"
#import "AHomeMember.h"


@implementation AHomeMemberNodeView

- (instancetype)init {
    self = [super init];
    _seat = CGPointZero;
    _isAnimation = YES;
    
    _faceView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_member_face.png"]];
    _nodeSize = _faceView.image.size.width;
    
    [self addSubview:_faceView];
    [_faceView setBackgroundColor:[UIColor whiteColor]];
    _faceView.bounds = CGRectMake(0, 0, _nodeSize-25, _nodeSize-25);
    _faceView.center = CGPointMake(self.bounds.size.width/2., self.bounds.size.height/2.);
    _faceView.layer.cornerRadius = _faceView.bounds.size.width/2.;
    _faceView.layer.masksToBounds = YES;
    _faceView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    
    [self initCommont];
    return self;
}

- (void)initCommont {
    self.bounds = CGRectMake(0, 0, _nodeSize, _nodeSize);
    self.layer.cornerRadius = self.bounds.size.width/2.;
    self.layer.masksToBounds = YES;
    self.opaque = NO;
    self.transform = CGAffineTransformMakeScale(0.001, 0.001);
    self.translatesAutoresizingMaskIntoConstraints = YES;
    [self setBackgroundColor:[UIColor colorWithRed:0. green:0. blue:0. alpha:.2]];
    [self addTarget:self action:@selector(faceClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setMemberData:(id)member {
    [self showWithAnimation];
    _member = member;
    [_faceView setImageWithURL:[NSURL URLWithString:((AHomeMember*)member).avatar] placeholderImage:[UIImage imageNamed:((AHomeMember*)member).placeHolderImage]];
}


- (void)showWithAnimation {
    self.center = _seat;
    
    if (_isAnimation) {
        float time1 = 0.45;float time2 = 0.31;float time3 = 0.31;
        
        [UIView animateWithDuration:time1 animations:^{
            self.center = _seat;
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
            _faceView.center = CGPointMake(self.bounds.size.width/2., self.bounds.size.height/2.);
            _faceView.transform = CGAffineTransformMakeScale(.9, .9);
            
            [self startRotateFace:1 andDuration:2];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:time2 animations:^{
                self.transform = CGAffineTransformMakeScale(0.8, 0.8);
                _faceView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:time3 animations:^{
                    self.transform = CGAffineTransformMakeScale(1, 1);
                    _faceView.transform = CGAffineTransformMakeScale(1., 1.);
                    
                } completion:^(BOOL finished) {
                    _isAnimation = NO;
                }];
            }];
        }];
    } else {
        self.transform = CGAffineTransformMakeScale(1, 1);
        _faceView.transform = CGAffineTransformMakeScale(1., 1.);
        _faceView.center = CGPointMake(self.bounds.size.width/2., self.bounds.size.height/2.);
    }
}

- (void)startRotateFace:(int)rotations andDuration:(float)duration {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = NO;
    rotationAnimation.repeatCount = rotations;
    
    [_faceView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


- (void)setPositionByHeight:(float)height seat:(NSValue*)seat {
    float x = [UIScreen mainScreen].bounds.size.width/2;
    float y = height/2.;
    
    _seat = CGPointMake(seat.CGPointValue.x, seat.CGPointValue.y);
    self.center = CGPointMake(x, y);
    _faceView.center = CGPointMake(_nodeSize/2., _nodeSize/2.);
}

- (void)faceClicked {
    if (((AHomeMember*)_member).selected) {
        ((AHomeMember*)_member).selected();
    }
}

@end
