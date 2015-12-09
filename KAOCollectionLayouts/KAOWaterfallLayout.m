//
//  KAOWaterfallLayout.m
//  KAOCollectionLayouts
//
//  Created by Andrey Kravchenko on 8/18/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "KAOWaterfallLayout.h"
#import "KAORectReplacementBridge.h"

@interface KAOWaterfallLayout()

@property (nonatomic, strong) NSArray *itemsSizes;
@property (nonatomic, strong) NSArray *itemsPositions;
@property (nonatomic, strong) NSArray *itemsAttributes;

@end

@implementation KAOWaterfallLayout

- (void)prepareLayout {
    self.itemsSizes = [self collectItemsSizes];
    self.itemsPositions = [KAORectReplacementBridge positionsForRectangles:self.itemsSizes parentSize:self.collectionView.frame.size];
    self.itemsAttributes = [self itemsAttributesFromSizes:self.itemsSizes positions:self.itemsPositions];
}

- (NSArray *)itemsAttributesFromSizes:(NSArray *)sizes positions:(NSArray *)positions {
    
    NSMutableArray *attrArray = [NSMutableArray new];
    
    positions = [positions sortedArrayUsingComparator:^NSComparisonResult(NSValue *posValue1, NSValue *posValue2) {
        
        KAORectPosition itemPos1;
        [posValue1 getValue:&itemPos1];
        
        KAORectPosition itemPos2;
        [posValue2 getValue:&itemPos2];
        
        if ((itemPos1.y < itemPos2.y) || ((itemPos1.y == itemPos2.y) && (itemPos1.x < itemPos2.x))) {
            return  NSOrderedAscending;
        }
        else if ((itemPos1.y > itemPos2.y) || ((itemPos1.y == itemPos2.y) && (itemPos1.x > itemPos2.x))) {
            return NSOrderedDescending ;
        }
        else {
            return NSOrderedSame;
        }
    }];
    
    [positions enumerateObjectsUsingBlock:^(NSValue *posValue, NSUInteger idx, BOOL *stop) {
        
        KAORectPosition itemPos;
        [posValue getValue:&itemPos];
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
        CGRect attrFrame = attributes.frame;
        attrFrame.origin.x = itemPos.x;
        attrFrame.origin.y = itemPos.y;
        attrFrame.size = [self.itemsSizes[itemPos.n] CGSizeValue];
        attributes.frame = attrFrame;
        
        [attrArray addObject:attributes];
    }];
    
    return attrArray;
}

- (NSArray *)collectItemsSizes {

    NSMutableArray *sizes = [NSMutableArray new];
    
    NSInteger itemsNum = [self.collectionView numberOfItemsInSection:0];
    self.itemsSizes = [NSMutableArray new];
    
    for (NSInteger i = 0; i < itemsNum; i++) {
        CGSize itemSize = [self sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [sizes addObject:[NSValue valueWithCGSize:itemSize]];
    }
    
    return sizes;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize itemSize = CGSizeZero;
    
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>) self.collectionView.delegate;
        itemSize = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    
    return itemSize;
}

- (CGSize)collectionViewContentSize {
#warning JUST FOR TEST
    UICollectionViewLayoutAttributes *lastAttribute = [self.itemsAttributes firstObject];
    return CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemsAttributes[indexPath.row];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *allAttributes = [NSMutableArray new];
    
    for (UICollectionViewLayoutAttributes *attr in self.itemsAttributes) {
        
        if (CGRectIntersectsRect(attr.frame, rect)) {
            [allAttributes addObject:attr];
        }
    }
    
    return allAttributes;
}

@end
