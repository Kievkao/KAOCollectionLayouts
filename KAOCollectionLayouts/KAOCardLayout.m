//
//  KAOCardLayout.m
//  CollectionTest
//
//  Created by Andrey Kravchenko on 8/14/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "KAOCardLayout.h"

static CGFloat const kScaleMultiplierDivider = 0.5;

@implementation KAOCardLayout

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithZoomIntensity:(CGFloat)zoomIntensity {
    
    self = [super init];
    
    if (self) {
        [self customInit];
        _zoomIntensity = zoomIntensity;
    }
    return self;
}

- (void)setZoomIntensity:(CGFloat)zoomIntensity {
    _zoomIntensity = zoomIntensity;
}

- (void)customInit {
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.zoomIntensity = 1.0;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    CGFloat multiplier = kScaleMultiplierDivider / (CGRectGetWidth(visibleRect) / 2);
    
    for (UICollectionViewLayoutAttributes* attributes in array)
    {
        if (CGRectIntersectsRect(attributes.frame, rect))
        {
            CGFloat distanceFromCenter = ABS(CGRectGetMidX(visibleRect) - attributes.center.x);
            CGFloat adaptedDistance = distanceFromCenter / self.zoomIntensity;
            CGFloat scaleFactor = 1 - multiplier * ABS(adaptedDistance);

            attributes.transform3D = CATransform3DMakeScale(scaleFactor, scaleFactor, 1);
        }
    }
    
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

@end
