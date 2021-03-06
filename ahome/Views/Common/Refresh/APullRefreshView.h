//
//  APullRefreshView.h
//  demoe
//
//  Created by andson-dile on 15/3/19.
//  Copyright (c) 2015年 andson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APullRefreshView : UIImageView {
    
    UIImageView *_refreshImageView;
    UILabel *_descRefreshLabel;
}

@property (nonatomic,retain)NSArray *drawImages;
@property (nonatomic,retain)NSArray *loadImages;

- (void)drawLoadImage:(int)index;
- (void)startAnimationLoad;
- (void)endAnimationLoad;
- (void)resetRefreshLabel;

- (void)workBreakIn;



@end
