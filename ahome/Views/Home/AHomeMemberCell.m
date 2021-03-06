//
//  AHomeMemberCell.m
//  demoe
//
//  Created by andson-dile on 15/3/11.
//  Copyright (c) 2015年 andson. All rights reserved.
//

#import "AHomeMemberCell.h"
#import "AHomeMemberNodeView.h"
#import "AHomeMember.h"
#import "AHome.h"

#define margin_node_distance        50
#define margin_top_distance         20
#define margin_bottom_distance      20


@implementation AHomeMemberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.memberNodes = [NSMutableArray array];
    [self initEmptyNode:20];
    _nodeLocations = [self nodeLocations];
    
    return self;
}

- (void)initEmptyNode:(int)num {
    for (int i=0; i<num; i++) {
        AHomeMemberNodeView *memberNodeView = [[AHomeMemberNodeView alloc]init];
        [_memberNodes addObject:memberNodeView];
    }
}


- (void)setDataForCell:(ARecord*)record {
    AHome *homeInfo = (AHome*)record;
    NSArray *members = homeInfo.members;
    for (AHomeMemberNodeView *nodeView in self.subviews)[nodeView removeFromSuperview];
    
    for (AHomeMember *member in members) {
        int index = (int)[members indexOfObject:member];
        
        AHomeMemberNodeView *memberNodeView = [_memberNodes objectAtIndex:index];
        memberNodeView.tag = index;
        [self addSubview:memberNodeView];
        
        [memberNodeView setPositionByHeight:[AHomeMemberCell heightForCell:(int)members.count] seat:[_nodeLocations objectAtIndex:index]];
        [memberNodeView setMemberData:member];
    }
}

- (NSArray*)nodeLocations {
    NSMutableArray *nodeLocations = [NSMutableArray array];
    for (AHomeMemberNodeView *nodeView in _memberNodes) {
        int index = (int)[_memberNodes indexOfObject:nodeView];
        
        float width = [UIScreen mainScreen].bounds.size.width;
        CGSize nodeSize = nodeView.bounds.size;
        NSValue *nodeLocationValue = nil;
        
        if (index == 0) {
            nodeLocationValue = [NSValue valueWithCGPoint:CGPointMake(margin_top_distance/2+nodeSize.width*.85, margin_top_distance+ nodeSize.height/2.)];
            
        } else if (index == 1) {
            nodeLocationValue = [NSValue valueWithCGPoint:CGPointMake(width-margin_top_distance/2-nodeSize.width*.85, margin_top_distance+nodeSize.height/2.)];
            
            
        } else {
            float y = (index-1)*(nodeSize.height+margin_node_distance)+nodeSize.height/2.+margin_top_distance;
            float x = width/2.;
            nodeLocationValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        }
        
        [nodeLocations addObject:nodeLocationValue];
    }
    
    return nodeLocations;
}

- (void)drawLine:(CGPoint)point toPoint:(CGPoint)toPoint {
    UIView *view = [self.subviews firstObject];
    CAShapeLayer *_chartLine = [CAShapeLayer layer];
    [view.layer addSublayer:_chartLine];
    _chartLine.lineCap = kCALineCapRound;
    _chartLine.lineJoin = kCALineJoinBevel;
    _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
    _chartLine.strokeColor = [UIColor whiteColor].CGColor;
    _chartLine.lineWidth   = 0.5;
    _chartLine.strokeEnd   = 0.0;
    
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    [progressline setLineWidth:2.0];
    [progressline setLineCapStyle:kCGLineCapRound];
    [progressline setLineJoinStyle:kCGLineJoinRound];
    [progressline moveToPoint:point];
    [progressline addLineToPoint:toPoint];
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    
    _chartLine.path = progressline.CGPath;
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    _chartLine.strokeEnd = 1.0;
}

+ (float)heightForCell:(int)nodes {
    float H = 1.2*margin_top_distance;
    
    float nodeSize = [UIImage imageNamed:@"home_member_face.png"].size.height;
    
    H += (nodes - 1)*nodeSize;
    H += (nodes - 2)*margin_node_distance;
    
    return H;
}

@end
