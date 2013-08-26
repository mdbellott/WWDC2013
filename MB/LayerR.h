//
//  LayerR.h
//  MB
//
//  Created by Mark Bellott on 4/30/13.
//  Copyright 2013 Mark Bellott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MainLayer.h"
#import "MBScrollView.h"

@interface LayerR : CCLayer {
    
    CGSize winSize;
    
    CCSprite *backgroundSprite;
    CCSprite *topBarSprite;
    CCSprite *contentSprite;
    
    MBScrollView *scrollView;
    
    CCMenuItem *backButton;
    CCMenu *backMenu;
}

+(CCScene *) scene;

@end
