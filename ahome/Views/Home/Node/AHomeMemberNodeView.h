//
//  AHomeMemberNodeView.h
//  demoe
//
//  Created by andson-dile on 15/3/11.
//  Copyright (c) 2015年 andson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AHomeMemberNodeView : UIButton {
    BOOL _isAnimation;
    UIImageView *_faceView;
    
    id _member;
    CGPoint _seat;
}

@property (nonatomic,assign)float nodeSize;

- (void)setMemberData:(id)member;
- (void)setPositionByHeight:(float)height seat:(NSValue*)seat;
- (void)startRotateFace:(int)rotations andDuration:(float)duration;

@end
