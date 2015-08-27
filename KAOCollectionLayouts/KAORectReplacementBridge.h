//
//  KAORectReplacementBridge.h
//  KAOCollectionLayouts
//
//  Created by Andrey Kravchenko on 8/18/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct
{
    int n;
    int x;
    int y;
} KAORectPosition;

@interface KAORectReplacementBridge : NSObject

+ (NSArray *)positionsForRectangles:(NSArray *)rectangles parentSize:(CGSize)parentSize;

@end
