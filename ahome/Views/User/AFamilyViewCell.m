//
//  AFamilyViewCell.m
//  ahome
//
//  Created by dilei liu on 15/1/17.
//  Copyright (c) 2015年 ushome. All rights reserved.
//

#import "AFamilyViewCell.h"
#import "UIImageView+WebCache.h"
#import "AHomeInfo.h"

#define phone_size_width    50
#define phone_size_height   50

@implementation AFamilyViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.backgroundColor = [UIColor clearColor];
    UIView *selectedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    [selectedView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.3]];
    [self setSelectedBackgroundView:selectedView];
    
    _faceimageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, phone_size_width, phone_size_height)];
    _faceimageview.contentMode = UIViewContentModeScaleAspectFill;
    _faceimageview.clipsToBounds = YES;
    [self.contentView addSubview:_faceimageview];
    
    _houseownerLabel = [[UILabel alloc]init];
    [_houseownerLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16]];
    _houseownerLabel.textAlignment = NSTextAlignmentLeft;
    [_houseownerLabel setTextColor:[UIColor whiteColor]];
    _houseownerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _houseownerLabel.numberOfLines = 1;
    [_houseownerLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_houseownerLabel];
    
    _shareEventLabel = [[UILabel alloc]init];
    [_shareEventLabel setFont:[UIFont systemFontOfSize:14]];
    _shareEventLabel.textAlignment = NSTextAlignmentLeft;
    [_shareEventLabel setTextColor:[UIColor whiteColor]];
    _shareEventLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _shareEventLabel.numberOfLines = 1;
    [_shareEventLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_shareEventLabel];
    
    _phoneLabel = [[UILabel alloc]init];
    [_phoneLabel setFont:[UIFont systemFontOfSize:14]];
    _phoneLabel.textAlignment = NSTextAlignmentLeft;
    [_phoneLabel setTextColor:[UIColor whiteColor]];
    _phoneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _phoneLabel.numberOfLines = 1;
    [_phoneLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_phoneLabel];
    
    _memberLabel = [[UILabel alloc]init];
    [_memberLabel setFont:[UIFont systemFontOfSize:14]];
    _memberLabel.textAlignment = NSTextAlignmentLeft;
    [_memberLabel setTextColor:[UIColor whiteColor]];
    _memberLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _memberLabel.numberOfLines = 1;
    [_memberLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_memberLabel];
    
    
    return self;
}

- (void)setDataForCell:(id)data {
    AHomeInfo *family = (AHomeInfo*)data;
    
    [_faceimageview setImageWithURL:[NSURL URLWithString:family.photo]];

    //
    [_houseownerLabel setText:[NSString stringWithFormat:@"户主名"]];
    CGSize titleSize = CGSizeMake(self.frame.size.width, 20000.0f);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:_houseownerLabel.font, NSFontAttributeName,nil];
    titleSize =[_houseownerLabel.text boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    [_houseownerLabel setFrame:CGRectMake(_faceimageview.frame.origin.x+_faceimageview.frame.size.width+15, _faceimageview.frame.origin.y+3, titleSize.width, titleSize.height)];
    
    //
    [_shareEventLabel setText:[NSString stringWithFormat:@"分享:%i",family.shareNo]];
    titleSize = CGSizeMake(self.frame.size.width, 20000.0f);
    tdic = [NSDictionary dictionaryWithObjectsAndKeys:_shareEventLabel.font, NSFontAttributeName,nil];
    titleSize =[_shareEventLabel.text boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    [_shareEventLabel setFrame:CGRectMake(_faceimageview.frame.origin.x+_faceimageview.frame.size.width+15, _houseownerLabel.frame.origin.y+_houseownerLabel.frame.size.height + 10, titleSize.width, titleSize.height)];
    
    //
    [_phoneLabel setText:[NSString stringWithFormat:@"家庭照片:%i",family.album]];
    titleSize = CGSizeMake(self.frame.size.width, 20000.0f);
    tdic = [NSDictionary dictionaryWithObjectsAndKeys:_phoneLabel.font, NSFontAttributeName,nil];
    titleSize =[_phoneLabel.text boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    [_phoneLabel setFrame:CGRectMake(_shareEventLabel.frame.origin.x+_shareEventLabel.frame.size.width+10, _houseownerLabel.frame.origin.y+_houseownerLabel.frame.size.height + 10, titleSize.width, titleSize.height)];
    
    //
    [_memberLabel setText:[NSString stringWithFormat:@"家庭照片:%i",family.memberNo]];
    titleSize = CGSizeMake(self.frame.size.width, 20000.0f);
    tdic = [NSDictionary dictionaryWithObjectsAndKeys:_memberLabel.font, NSFontAttributeName,nil];
    titleSize =[_memberLabel.text boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    [_memberLabel setFrame:CGRectMake(_phoneLabel.frame.origin.x+_phoneLabel.frame.size.width+10, _houseownerLabel.frame.origin.y+_houseownerLabel.frame.size.height + 10, titleSize.width, titleSize.height)];
    
}

+ (float)heightForCell {
    return 70;
}

@end
