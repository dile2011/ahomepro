//
//  ABlurCollectionController.m
//  ahome
//
//  Created by andson-dile on 15/6/12.
//  Copyright (c) 2015年 ushome. All rights reserved.
//

#import "ABlurCollectionController.h"
#import "ABlurCollectionView.h"
#import "ABlurCollectionHeaderView.h"
#import "ABlurMenu.h"

@implementation ABlurCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(70., 70.);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:
                  CGRectMake(0, 0, self.view.frame.size.width,
                             self.view.frame.size.height) collectionViewLayout:flowLayout];
    [_collectionView registerClass:NSClassFromString(@"ABlurCollectionView") forCellWithReuseIdentifier:@"Cell"];
    [_collectionView registerClass:NSClassFromString(@"ABlurCollectionHeaderView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _blurMenus.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *dic = [_blurMenus objectAtIndex:section];
    NSArray *datas = [dic objectForKey:@"data"];
    return datas.count>0?datas.count:0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ABlurCollectionView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *dic = [_blurMenus objectAtIndex:indexPath.section];
    NSArray *datas = [dic objectForKey:@"data"];
    ABlurMenu *blurMenu = [datas objectAtIndex:indexPath.row];
    [cell setDataForCell:blurMenu];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    NSDictionary *dic = [_blurMenus objectAtIndex:section];
    NSString *title = [dic objectForKey:@"title"];
    float H = 30.f;
    if (title.length == 0) H = 0.f;
    return CGSizeMake(self.view.frame.size.width, H);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        ABlurCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        NSDictionary *dic = [_blurMenus objectAtIndex:indexPath.section];
        NSString *title = [dic objectForKey:@"title"];
        UIColor *bgColor = [dic objectForKey:@"bgColor"];
        [headerView setTitle:title color:bgColor];
        reusableview = headerView;
    }
    
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
