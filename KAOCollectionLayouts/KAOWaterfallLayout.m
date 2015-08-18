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

@end

@implementation KAOWaterfallLayout

- (void)prepareLayout {
    
    [self collectItemsSizes];
    
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
    return CGSizeZero;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
