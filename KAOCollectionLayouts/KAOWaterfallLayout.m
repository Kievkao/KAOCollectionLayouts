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

@property (nonatomic, strong) NSMutableArray *itemsSizes;
@property (nonatomic, strong) NSArray *itemsPositions;

@end

@implementation KAOWaterfallLayout

- (void)prepareLayout {
    
    [self collectItemsSizes];
    self.itemsPositions = [KAORectReplacementBridge positionsForRectangles:self.itemsSizes parentSize:self.collectionView.frame.size];
    
//    for (NSValue *posValue in positions) {
//        KAORectPosition itemPos;
//        [posValue getValue:&itemPos];
//        NSLog(@"value");
//    }
}

- (void)collectItemsSizes {

    NSInteger itemsNum = [self.collectionView numberOfItemsInSection:0];
    self.itemsSizes = [NSMutableArray new];
    
    for (NSInteger i = 0; i < itemsNum; i++) {
        CGSize itemSize = [self sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.itemsSizes addObject:[NSValue valueWithCGSize:itemSize]];
    }
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
    return CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    KAORectPosition itemPos;
    NSValue *posValue = self.itemsPositions[indexPath.row];
    [posValue getValue:&itemPos];
    
    CGRect attrFrame = attributes.frame;
    attrFrame.origin.x = itemPos.x;
    attrFrame.origin.y = itemPos.y;
    attributes.frame = attrFrame;
    
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.itemsPositions.count];
    
    for (NSValue *posValue in self.itemsPositions) {
        KAORectPosition itemPos;
        [posValue getValue:&itemPos];
        
        CGSize itemSize = [self sizeForItemAtIndex:itemPos.n];
        if (CGRectIntersectsRect(rect, CGRectMake(itemPos.x, itemPos.y, itemSize.width, itemSize.height))) {
            
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:itemPos.n inSection:0]];
            CGRect attrFrame = attributes.frame;
            attrFrame.origin.x = itemPos.x;
            attrFrame.origin.y = itemPos.y;
            attrFrame.size = [self sizeForItemAtIndex:itemPos.n];
            attributes.frame = attrFrame;
            [allAttributes addObject:attributes];
        }
    }
    return allAttributes;
}

- (CGSize)sizeForItemAtIndex:(NSUInteger)index {
    NSValue *sizeValue = self.itemsSizes[index];
    return [sizeValue CGSizeValue];
}

@end
