//
//  MainLayer.h
//  MB
//
//  Created by Mark Bellott on 4/30/13.
//  Copyright 2013 Mark Bellott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "tile.h"

@interface MainLayer : CCLayer {
    
    CGSize winSize;
    
    CGRect tileRect;
    
    CGPoint mPos, aPos, rPos, kPos, bPos, blankPos;
    
    CCSprite *backgroundSprite;
    
    CCTexture2D *mTexNorm, *mTexSelect,
    *aTexNorm, *aTexSelect,
    *rTexNorm, *rTexSelect,
    *kTexNorm, *kTexSelect,
    *bTexNorm, *bTexSelect,
    *blankTexNorm, *blankTexSelect;
    
    tile *tM, *tA, *tR, *tK, *tB, *tBlank;
    CCSprite *sM, *sA, *sR, *sK, *sB, *sBlank;
    
    NSMutableArray *tiles;
    
    NSUserDefaults *defaults;
}

+(CCScene *) scene;

@end
