//
//  KAORectReplacementBridge.m
//  KAOCollectionLayouts
//
//  Created by Andrey Kravchenko on 8/18/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "KAORectReplacementBridge.h"
#import "RectPlacement.h"

struct TSubRect: public CRectPlacement::TRect
{
    int n;      // Original index of this subrect, before sorting
    int nTex;   // Texture in which this subrect will be placed.
    
    TSubRect() { }
    TSubRect(int _w, int _h, int _n): TRect(0, 0, _w, _h), n(_n), nTex(0) { }
};

typedef std::vector<TSubRect>       CSubRectArray;
typedef std::vector<CRectPlacement> CTextureArray;

@implementation KAORectReplacementBridge

+ (NSArray *)positionsForRectangles:(NSArray *)rectangles parentSize:(CGSize)parentSize {
    
    NSMutableArray *positions = [NSMutableArray new];
    
    CTextureArray vecTextures;
    CSubRectArray vecSubRects;
    
    vecSubRects.clear();
    
    for (NSInteger i = 0; i < rectangles.count; i++) {
        NSValue *sizeValue = rectangles[i];
        CGSize itemSize = [sizeValue CGSizeValue];
        
        vecSubRects.push_back(TSubRect(itemSize.width, itemSize.height, i));
    }
    
    CreateTextures(vecTextures, vecSubRects, parentSize.width, parentSize.height);
    
    for (CSubRectArray::const_iterator it = vecSubRects.begin(); it != vecSubRects.end(); ++it)
    {
        KAORectPosition itemPos;
        itemPos.n = it->n;
        itemPos.x = it->x;
        itemPos.y = it->y;
        
        [positions addObject:[NSValue valueWithBytes:&itemPos objCType:@encode(KAORectPosition)]];
    }
    
    return positions;
}

void CreateTextures (CTextureArray &vecTextures, CSubRectArray &vecSubRects, int maxTexW, int maxTexH)
{
    // Sort the subRects based on dimensions, larger dimension goes first.
    std::sort(vecSubRects.begin(), vecSubRects.end(), CRectPlacement::TRect::Greater);
    
    // Generate the first texture
    vecTextures.clear();
    vecTextures.push_back(CRectPlacement());
    
    // Add all subrects
    for (CSubRectArray::iterator it = vecSubRects.begin();
         it != vecSubRects.end();
         ++it)
    {
        // We make sure we leave one pixel between subrects, so texels don't bleed with bilinear.
        CRectPlacement::TRect r(0, 0, it->w+1, it->h+1);
        
        // If an existing texture has actual space
        bool bPlaced = false;
        for (int i = 0; !bPlaced && i < vecTextures.size(); i++)
        {
            bPlaced = vecTextures[i].AddAtEmptySpotAutoGrow(&r, maxTexW, maxTexH);
            if (bPlaced)
                it->nTex = i;
        }
        
        // Try starting a new texture and fit the rect in there
        if (!bPlaced)
        {
            vecTextures.push_back(CRectPlacement());
            bPlaced = vecTextures[vecTextures.size()-1].AddAtEmptySpotAutoGrow(&r, maxTexW, maxTexH);
            if (bPlaced)
                it->nTex = vecTextures.size()-1;
            else
                NSLog(@"ERROR: Subrect is too big to fit in texture!");
        }
        
        // If correctly placed in a texture, the coords are returned in r.x and r.y
        // Store them.
        if (bPlaced)
        {
            it->x = r.x;
            it->y = r.y;
        }
    }
}

@end
