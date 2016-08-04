//
//  AHomeMergeCell.h
//  ahome
//
//  Created by andson-dile on 15/6/17.
//  Copyright (c) 2015年 ushome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABaseHomeCell.h"
#import "AMergeMemberView.h"


@interface AHomeMergeCell : ABaseHomeCell

@property (nonatomic,retain)NSMutableArray *mergeHomeMembers;

+ (float)radiusSize;

- (void)startAnimation;
- (void)stopAnimation;



@end
