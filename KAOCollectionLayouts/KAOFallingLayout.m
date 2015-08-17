//
//  KAOFallingLayout.m
//  KAOCollectionLayouts
//
//  Created by Andrey Kravchenko on 8/17/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "KAOFallingLayout.h"

@interface KAOFallingLayout()

@property (nonatomic) CGFloat previousContentOffsetX;

@end

@implementation KAOFallingLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array)
    {
        if (CGRectIntersectsRect(attributes.frame, rect))
        {
            CGFloat distanceFromCenter = CGRectGetMidX(visibleRect) - attributes.center.x;
            CGRect attrFrame = attributes.frame;
            CGFloat coeff = visibleRect.size.width / distanceFromCenter;
            
            if (self.backwardFalling) {
                if ((distanceFromCenter < 0) && (self.collectionView.contentOffset.x > self.previousContentOffsetX)) {
                    attrFrame.origin.y = visibleRect.size.height / coeff + self.sectionInset.top;
                }
                else if ((distanceFromCenter > 0) && (self.collectionView.contentOffset.x < self.previousContentOffsetX)) {
                    attrFrame.origin.y = - (visibleRect.size.height / coeff - self.sectionInset.top);
                }
            }
            else {
                if (distanceFromCenter < 0) {
                    attrFrame.origin.y = visibleRect.size.height / coeff + self.sectionInset.top;
                }
            }

            attributes.frame = attrFrame;
        }
    }
    
    self.previousContentOffsetX = self.collectionView.contentOffset.x;
    
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

@end
