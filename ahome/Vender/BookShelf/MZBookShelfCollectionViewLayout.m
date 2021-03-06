//
//  BWBookShelfCollectionViewLayout.m
//  BookWhiz
//
//  Created by Michał Zaborowski on 13.06.2014.
//  Copyright (c) 2014 Michał Zaborowski. All rights reserved.
//
// This project is an rewritten version of grid layout by Mark Pospesel there: http://markpospesel.wordpress.com/2012/12/11/decorationviews/

#import "MZBookshelfCollectionViewLayout.h"

NSString *const MZBookshelfCollectionViewLayoutDecorationViewKind = @"MZBookshelfCollectionViewLayoutDecorationViewKind";

@interface MZBookshelfCollectionViewLayout ()
/// The delegate will point to collection view's delegate automatically.
@property (nonatomic, weak) id <MZBookshelfCollectionViewLayoutDelegate> delegate;
@property (nonatomic, strong) NSDictionary *bookShelfRectanges;
@end

@implementation MZBookshelfCollectionViewLayout

- (id<MZBookshelfCollectionViewLayoutDelegate>)delegate {
    return (id<MZBookshelfCollectionViewLayoutDelegate>)self.collectionView.delegate;
}

// Do all the calculations for determining where shelves go here
- (void)prepareLayout {
    [super prepareLayout];
    self.minimumLineSpacing = 20;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSUInteger sectionCount = [self.collectionView numberOfSections];
    
    CGFloat y = 0;
    CGFloat availableWidth = self.collectionViewContentSize.width - (self.sectionInset.left + self.sectionInset.right);
    int itemsAcross = floorf((availableWidth + self.minimumInteritemSpacing) / (self.itemSize.width + self.minimumInteritemSpacing));
    
    for (int section = 0; section < sectionCount; section++) {
        y += self.headerReferenceSize.height;
        y += self.sectionInset.top;

        NSUInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        int rows = ceilf(itemCount/(float)itemsAcross);
        
        for (int row = 0; row < rows; row++) {
            if (row == 0)y += self.itemSize.height - 20;
            else y += self.itemSize.height;
            
            CGSize bookShelfSize = CGSizeMake(self.itemSize.width, self.itemSize.height);
            dictionary[[NSIndexPath indexPathForItem:row inSection:section]] = [NSValue valueWithCGRect:CGRectMake(0, y, bookShelfSize.width, bookShelfSize.height)];
            
            y += self.minimumLineSpacing;
        }
        
        y += self.sectionInset.bottom;
        y += self.footerReferenceSize.height;
    }
    
    self.bookShelfRectanges = [NSDictionary dictionaryWithDictionary:dictionary];
}

#pragma mark Runtime Layout Calculations
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    // call super so flow layout can return default attributes for all cells, headers, and footers
    // NOTE: Flow layout has already taken care of the Cell view layout attributes! :)
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // create a mutable copy so we can add layout attributes for any shelfs that
    // have frames that intersect the rect the CollectionView is interested in
    NSMutableArray *newArray = [array mutableCopy];
    
    // Add any decoration views (shelves) who's rect intersects with the
    // CGRect passed to the layout by the CollectionView
    
    [self.bookShelfRectanges enumerateKeysAndObjectsUsingBlock:^(id key, id shelfRect, BOOL *stop) {
        
        if (CGRectIntersectsRect([shelfRect CGRectValue], rect)) {
            UICollectionViewLayoutAttributes *shelfAttributes =
            [self layoutAttributesForDecorationViewOfKind:MZBookshelfCollectionViewLayoutDecorationViewKind
                                              atIndexPath:key];
            [newArray addObject:shelfAttributes];
        }
    }];
    
    return [newArray copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    
    id shelfRect = self.bookShelfRectanges[indexPath];
    
    // this should never happen, but just in case...
    if (!shelfRect)
        return nil;
    
    UICollectionViewLayoutAttributes *attributes =
    [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind
                                                                withIndexPath:indexPath];
    attributes.frame = CGRectMake([shelfRect CGRectValue].origin.x, [shelfRect CGRectValue].origin.y, [UIScreen mainScreen].bounds.size.width, [shelfRect CGRectValue].size.height);
    attributes.zIndex = -20; // shelves go behind other views
    
    return attributes;
}

- (NSDictionary*)getBookShelfRectanges {
    return self.bookShelfRectanges;
}

@end
