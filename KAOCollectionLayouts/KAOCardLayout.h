//
//  KAOCardLayout.h
//  CollectionTest
//
//  Created by Andrey Kravchenko on 8/14/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAOCardLayout : UICollectionViewFlowLayout

@property (nonatomic) IBInspectable CGFloat zoomIntensity;

- (instancetype)initWithZoomIntensity:(CGFloat)zoomIntensity;

@end
