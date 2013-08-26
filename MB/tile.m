//
//  tile.m
//  MB
//
//  Created by Mark Bellott on 4/30/13.
//  Copyright 2013 Mark Bellott. All rights reserved.
//

#import "tile.h"


@implementation tile

@synthesize hasBeenSelected, isTouched, mainPosition, title, shadow, normalTexture, selectedTexture;

-(NSString*) getTitle{
    return title;
}

-(void) setTitle:(NSString *)t{
    title = t;
}

-(void) setTexturesWithNormalTexture:(CCTexture2D*)nTex SelectedTexture:(CCTexture2D*)sTex{
    normalTexture = nTex;
    selectedTexture = sTex;
}

-(void) changeTextureToNormal{
    [self setTexture:normalTexture];
}

-(void) changeTextureToSelected{
    [self setTexture:selectedTexture];
}


@end
