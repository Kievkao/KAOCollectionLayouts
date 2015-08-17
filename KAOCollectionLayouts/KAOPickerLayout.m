//
//  KAOPickerLayout.m
//  KAOCollectionLayouts
//
//  Created by Andrey Kravchenko on 8/17/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "KAOPickerLayout.h"

@implementation KAOPickerLayout

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self customInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    CGFloat coeffAlpha = 1 / ((visibleRect.size.height - (self.sectionInset.top + self.sectionInset.bottom)) / 2);
    CGFloat coeffAngle = 150 / ((visibleRect.size.height - (self.sectionInset.top + self.sectionInset.bottom)) / 2);
    
    for (UICollectionViewLayoutAttributes* attributes in array)
    {
        if (CGRectIntersectsRect(attributes.frame, rect))
        {
            CGFloat distanceFromCenter = ABS(CGRectGetMidY(visibleRect) - attributes.center.y);
            
            attributes.alpha = 1 - distanceFromCenter * coeffAlpha;
            attributes.transform3D = CATransform3DMakeRotation(distanceFromCenter * coeffAngle * M_PI/360, 1, 0, 0);
        }
    }
    
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

@end
