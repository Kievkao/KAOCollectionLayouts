//
//  KAOFallingLayout.m
//  KAOCollectionLayouts
//
//  Created by Andrey Kravchenko on 8/17/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "KAOFallingLayout.h"

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

@end
