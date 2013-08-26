//
//  tile.h
//  MB
//
//  Created by Mark Bellott on 4/30/13.
//  Copyright 2013 Mark Bellott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface tile : CCSprite {
    
    @public
    
    BOOL hasBeenSelected, isTouched;
    CGPoint mainPosition;
    CCSprite *shadow;
    
    @private
    
    NSString *title;
    CCTexture2D *normalTexture;
    CCTexture2D *selectedTexture;
    
}

@property(nonatomic, readwrite) BOOL hasBeenSelected;
@property(nonatomic, readwrite) BOOL isTouched;
@property(nonatomic, readwrite) CGPoint mainPosition;
@property(nonatomic, strong) CCSprite *shadow;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) CCTexture2D *normalTexture;
@property(nonatomic, strong) CCTexture2D *selectedTexture;

-(NSString*)getTitle;
-(void) setTitle:(NSString *)title;
-(void) setTexturesWithNormalTexture:(CCTexture2D*)nTex SelectedTexture:(CCTexture2D*)sTex;
-(void) changeTextureToNormal;
-(void) changeTextureToSelected;

@end
