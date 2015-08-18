//
//  KAORectReplacementBridge.h
//  KAOCollectionLayouts
//
//  Created by Andrey Kravchenko on 8/18/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAORectReplacementBridge : NSObject

+ (NSArray *)positionsForRectangles:(NSArray *)rectangles parentWidth:(CGFloat)parentWidth height:(CGFloat)parentHeight;

@end
