//
//  MainLayer.m
//  MB
//
//  Created by Mark Bellott on 4/30/13.
//  Copyright 2013 Mark Bellott. All rights reserved.
//

#import "MainLayer.h"
#import "LayerM.h"
#import "LayerA.h"
#import "LayerR.h"
#import "LayerK.h"
#import "LayerB.h"

#define TILE_SPEED 0.2f

@implementation MainLayer

#pragma mark - Init Methods 

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	
	MainLayer *layer = [MainLayer node];
    
	[scene addChild: layer];
	
	return scene;
}

-(id) init{
    self = [super init];
    
    if(self){
        [self loadPositions];
        [self loadTextures];
        [self initialSetup];
        [self animateTilesIn];
        self.isTouchEnabled = YES;
    }
    
    return self;
}

-(void) loadPositions{
    mPos = ccp(80, 472.5);
    aPos = ccp(240, 472.5);
    rPos = ccp(80, 283.5);
    kPos = ccp(240, 283.5);
    bPos = ccp(80, 94.5);
    blankPos = ccp(240, 94.5);
}

-(void) loadTextures{
    mTexNorm = [[CCTextureCache sharedTextureCache] addImage:@"MB_MTileNormal.png"];
    mTexSelect = [[CCTextureCache sharedTextureCache] addImage:@"MB_MTileSelect.png"];
    aTexNorm = [[CCTextureCache sharedTextureCache] addImage:@"MB_ATileNormal.png"];
    aTexSelect = [[CCTextureCache sharedTextureCache] addImage:@"MB_ATileSelect.png"];
    rTexNorm = [[CCTextureCache sharedTextureCache] addImage:@"MB_RTileNormal.png"];
    rTexSelect = [[CCTextureCache sharedTextureCache] addImage:@"MB_RTileSelect.png"];
    kTexNorm = [[CCTextureCache sharedTextureCache] addImage:@"MB_KTileNormal.png"];
    kTexSelect = [[CCTextureCache sharedTextureCache] addImage:@"MB_KTileSelect.png"];
    bTexNorm = [[CCTextureCache sharedTextureCache] addImage:@"MB_BTileNormal.png"];
    bTexSelect = [[CCTextureCache sharedTextureCache] addImage:@"MB_BTileSelect.png"];
    blankTexNorm = [[CCTextureCache sharedTextureCache] addImage:@"MB_BlankTileNormal.png"];
    blankTexSelect = [[CCTextureCache sharedTextureCache] addImage:@"MB_BlankTileSelect.png"];
}

-(void) initialSetup{
    
    winSize = [[CCDirector sharedDirector] winSize];
    tileRect = CGRectMake(0, 0, 160, 189);
    defaults = [NSUserDefaults standardUserDefaults];
    
    tiles = [[NSMutableArray alloc] init];
    
    backgroundSprite = [[CCSprite alloc] initWithFile:@"MB_Background.png"];
    backgroundSprite.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:backgroundSprite];
    
    //Load Shadows
    sM = [[CCSprite alloc] initWithFile:@"MB_Shadow.png"];
    sA = [[CCSprite alloc] initWithFile:@"MB_Shadow.png"];
    sR = [[CCSprite alloc] initWithFile:@"MB_Shadow.png"];
    sK = [[CCSprite alloc] initWithFile:@"MB_Shadow.png"];
    sB = [[CCSprite alloc] initWithFile:@"MB_Shadow.png"];
    sBlank = [[CCSprite alloc] initWithFile:@"MB_Shadow.png"];
    
    [self addChild:sM];
    [self addChild:sA];
    [self addChild:sR];
    [self addChild:sK];
    [self addChild:sB];
    [self addChild:sBlank];
    
    //Load Tiles
    tM = [tile spriteWithTexture:mTexNorm rect:tileRect];
    tA = [tile spriteWithTexture:aTexNorm rect:tileRect];
    tR = [tile spriteWithTexture:rTexNorm rect:tileRect];
    tK = [tile spriteWithTexture:kTexNorm rect:tileRect];
    tB = [tile spriteWithTexture:bTexNorm rect:tileRect];
    tBlank = [tile spriteWithTexture:blankTexNorm rect:tileRect];
    
    [tM setTitle:@"M"];
    [tA setTitle:@"A"];
    [tR setTitle:@"R"];
    [tK setTitle:@"K"];
    [tB setTitle:@"B"];
    [tBlank setTitle:@"BLANK"];
    
    [tM setTexturesWithNormalTexture:mTexNorm SelectedTexture:mTexSelect];
    [tA setTexturesWithNormalTexture:aTexNorm SelectedTexture:aTexSelect];
    [tR setTexturesWithNormalTexture:rTexNorm SelectedTexture:rTexSelect];
    [tK setTexturesWithNormalTexture:kTexNorm SelectedTexture:kTexSelect];
    [tB setTexturesWithNormalTexture:bTexNorm SelectedTexture:bTexSelect];
    [tBlank setTexturesWithNormalTexture:blankTexNorm SelectedTexture:blankTexSelect];
    
    tM.mainPosition = mPos;
    tA.mainPosition = aPos;
    tR.mainPosition = rPos;
    tK.mainPosition = kPos;
    tB.mainPosition = bPos;
    tBlank.mainPosition = blankPos;
    
    tM.position = ccp(mPos.x - 500, mPos.y);
    tA.position = ccp(aPos.x - 500, aPos.y);
    tR.position = ccp(rPos.x - 500, rPos.y);
    tK.position = ccp(kPos.x - 500, kPos.y);
    tB.position = ccp(bPos.x - 500, bPos.y);
    tBlank.position = ccp(blankPos.x - 500, blankPos.y);
    
    sM.position = tM.position;
    sA.position = tA.position;
    sR.position = tR.position;
    sK.position = tK.position;
    sB.position = tB.position;
    sBlank.position = tBlank.position;
    
    //Set up the shadow pointers
    tM.shadow = sM;
    tA.shadow = sA;
    tR.shadow = sR;
    tK.shadow = sK;
    tB.shadow = sB;
    tBlank.shadow = sBlank;
    
    [tiles addObject:tM];
    [tiles addObject:tA];
    [tiles addObject:tR];
    [tiles addObject:tK];
    [tiles addObject:tB];
    [tiles addObject:tBlank];
    
    [self addChild:tM];
    [self addChild:tA];
    [self addChild:tR];
    [self addChild:tK];
    [self addChild:tB];
    [self addChild:tBlank];
    
    [self checkTilesSelected];
}

-(void) checkTilesSelected{
    
    NSInteger selectedCount = 0;
    BOOL selected;
    defaults = [NSUserDefaults standardUserDefaults];
    
    selected = [defaults boolForKey:@"MSelected"];
    if(selected){
        tM.hasBeenSelected = YES;
        [tM changeTextureToSelected];
        selectedCount++;
    }
    else{
        tM.hasBeenSelected = NO;
        [tM changeTextureToNormal];
    }
    
    selected = [defaults boolForKey:@"ASelected"];
    if(selected){
        tA.hasBeenSelected = YES;
        [tA changeTextureToSelected];
        selectedCount++;
    }
    else{
        tA.hasBeenSelected = NO;
        [tA changeTextureToNormal];
    }
    
    selected = [defaults boolForKey:@"RSelected"];
    if(selected){
        tR.hasBeenSelected = YES;
        [tR changeTextureToSelected];
        selectedCount++;
    }
    else{
        tR.hasBeenSelected = NO;
        [tR changeTextureToNormal];
    }
    
    selected = [defaults boolForKey:@"KSelected"];
    if(selected){
        tK.hasBeenSelected = YES;
        [tK changeTextureToSelected];
        selectedCount++;
    }
    else{
        tK.hasBeenSelected = NO;
        [tK changeTextureToNormal];
    }
    
    selected = [defaults boolForKey:@"BSelected"];
    if(selected){
        tB.hasBeenSelected = YES;
        [tB changeTextureToSelected];
        selectedCount++;
    }
    else{
        tB.hasBeenSelected = NO;
        [tB changeTextureToNormal];
    }
    
    if(selectedCount == 5){
        tBlank.hasBeenSelected = YES;
        [tBlank changeTextureToSelected];
    }
}

#pragma mark - Animation Methods

-(void) animateTilesIn{
    float gap = 0.1;
    float increment = 0.05;
    
    [self moveTileInLeft:tA WithDelay:gap];
    gap += increment;
    
    [self moveTileInLeft:tK WithDelay:gap];
    gap += increment;
    
    [self moveTileInLeft:tBlank WithDelay:gap];
    gap += increment;
    
    [self moveTileInLeft:tM WithDelay:gap];
    gap += increment;
    
    [self moveTileInLeft:tR WithDelay:gap];
    gap += increment;
    
    [self moveTileInLeft:tB WithDelay:gap];
    gap += increment;
    
}

-(void) moveTileInLeft:(tile*)t WithDelay:(float)gap{
    [t runAction:[CCSequence actions: [CCDelayTime actionWithDuration:gap],
                   [CCMoveTo actionWithDuration:TILE_SPEED position:t.mainPosition], nil]];
    [t.shadow runAction:[CCSequence actions: [CCDelayTime actionWithDuration:gap],
                   [CCMoveTo actionWithDuration:TILE_SPEED position:t.mainPosition], nil]];
}

-(void) animateTilesOutLeftWithSelectedTile:(tile*)t{
    float gap = 0.0;
    float increment = 0.05;
    
    if(t == tM){
        [self moveTileOutLeft:tM WithDelay:gap];
        gap += increment;
        [self moveTileOutLeft:tR WithDelay:gap];
        gap += increment;
        [self moveTileOutLeft:tB WithDelay:gap];
        gap += increment;
        [self moveTileOutLeft:tA WithDelay:gap];
        gap += increment;
        [self moveTileOutLeft:tK WithDelay:gap];
        gap += increment;
        [self moveTileOutLeft:tBlank WithDelay:gap];
        gap += increment;
    }
    else if(t == tR){
        [self moveTileOutLeft:tR WithDelay:gap];
        gap += increment;
        [self moveTileOutLeft:tM WithDelay:gap];
        gap += increment;
        [self moveTileOutLeft:tB WithDelay:gap];
        gap += increment;
        [self moveTileOutLeft:tK WithDelay:gap];
        gap += increment;
        [self moveTileOutLeft:tA WithDelay:gap];
        gap += increment;
        [self moveTileOutLeft:tBlank WithDelay:gap];
        gap += increment;
    }
    else if(t == tB){
        [self moveTileOutLeft:tB WithDelay:gap];
        gap += increment;
        [self moveTileOutLeft:tR WithDelay:gap];
        gap += increment;
        [self moveTileOutLeft:tM WithDelay:gap];
        gap += increment;
        [self moveTileOutLeft:tBlank WithDelay:gap];
        gap += increment;
        [self moveTileOutLeft:tK WithDelay:gap];
        gap += increment;
        [self moveTileOutLeft:tA WithDelay:gap];
        gap += increment;
    }
    
}

-(void) moveTileOutLeft:(tile*)t WithDelay:(float) gap{
    [t runAction:[CCSequence actions: [CCDelayTime actionWithDuration:gap],
                  [CCMoveTo actionWithDuration:TILE_SPEED position:ccp(t.mainPosition.x - 500, t.mainPosition.y)], nil]];
    [t.shadow runAction:[CCSequence actions: [CCDelayTime actionWithDuration:gap],
                  [CCMoveTo actionWithDuration:TILE_SPEED position:ccp(t.mainPosition.x - 500, t.mainPosition.y)], nil]];
}

-(void) animateTilesOutRightWithSelectedTile:(tile*)t{
    float gap = 0.0;
    float increment = 0.05;
    
    if(t == tA){
        [self moveTileOutRight:tA WithDelay:gap];
        gap += increment;
        [self moveTileOutRight:tK WithDelay:gap];
        gap += increment;
        [self moveTileOutRight:tBlank WithDelay:gap];
        gap += increment;
        [self moveTileOutRight:tM WithDelay:gap];
        gap += increment;
        [self moveTileOutRight:tR WithDelay:gap];
        gap += increment;
        [self moveTileOutRight:tB WithDelay:gap];
        gap += increment;
    }
    else if(t == tK){
        [self moveTileOutRight:tK WithDelay:gap];
        gap += increment;
        [self moveTileOutRight:tA WithDelay:gap];
        gap += increment;
        [self moveTileOutRight:tBlank WithDelay:gap];
        gap += increment;
        [self moveTileOutRight:tR WithDelay:gap];
        gap += increment;
        [self moveTileOutRight:tM WithDelay:gap];
        gap += increment;
        [self moveTileOutRight:tB WithDelay:gap];
        gap += increment;
    }
    else if(t == tBlank && tBlank.hasBeenSelected){
        [self moveTileOutRight:tBlank WithDelay:gap];
        gap += increment;
        [self moveTileOutRight:tK WithDelay:gap];
        gap += increment;
        [self moveTileOutRight:tA WithDelay:gap];
        gap += increment;
        [self moveTileOutRight:tB WithDelay:gap];
        gap += increment;
        [self moveTileOutRight:tR WithDelay:gap];
        gap += increment;
        [self moveTileOutRight:tM WithDelay:gap];
        gap += increment;
    }
    
}

-(void) moveTileOutRight:(tile*)t WithDelay:(float)gap{
    [t runAction:[CCSequence actions: [CCDelayTime actionWithDuration:gap],
                  [CCMoveTo actionWithDuration:TILE_SPEED position:ccp(t.mainPosition.x + 500, t.mainPosition.y)], nil]];
    [t.shadow runAction:[CCSequence actions: [CCDelayTime actionWithDuration:gap],
                  [CCMoveTo actionWithDuration:TILE_SPEED position:ccp(t.mainPosition.x + 500, t.mainPosition.y)], nil]];
}

#pragma mark - Input Handling Methods

-(void) registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace: touch];
    
    tile *t = [self getTileAtLocation:location];
    if(!t.hasBeenSelected && t != tBlank){
        t.isTouched = YES;
        [t changeTextureToSelected];
    }
    
    return YES;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [self convertTouchToNodeSpace: touch];
    
    tile *t = [self getTileAtLocation:location];
    t.isTouched = YES;
    if(!t.hasBeenSelected && t != tBlank){
        [t changeTextureToSelected];
    }
    
    for(tile* tmp in tiles){
        if(tmp.isTouched && tmp != t && !tmp.hasBeenSelected){
            [tmp changeTextureToNormal];
        }
    }
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint location = [self convertTouchToNodeSpace: touch];
    
    tile* t = [self getTileAtLocation:location];
    
    if(t == tM || t == tR || t == tB){
        [self animateTilesOutLeftWithSelectedTile:t];
        [self loadNewSceneWithSelectedTile:t];
    }
    else if (t == tA || t == tK || t == tBlank){
        [self animateTilesOutRightWithSelectedTile:t];
        [self loadNewSceneWithSelectedTile:t];
    }
}

-(tile*) getTileAtLocation:(CGPoint)location{
    CGRect touchRect = CGRectMake(location.x, location.y, 1, 1);
    
    for(tile *t in tiles){
        if(CGRectIntersectsRect(touchRect, t.boundingBox)){
            return t;
        }
    }
    
    return NULL;
}

#pragma mark - Scene Handling Methods

-(void) loadNewSceneWithSelectedTile:(tile*)t{
    float sceneChangeDelay = 0.5;
    defaults = [NSUserDefaults standardUserDefaults];
    if(t != tBlank || t.hasBeenSelected){
        self.isTouchEnabled = NO;
    }
    
    if(t == tM){
        [defaults setBool:YES forKey:@"MSelected"];
        [defaults synchronize];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:sceneChangeDelay], [CCCallFuncN actionWithTarget:self selector:@selector(loadLayerM)], nil]];
    }
    else if(t == tA){
        [defaults setBool:YES forKey:@"ASelected"];
        [defaults synchronize];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:sceneChangeDelay], [CCCallFuncN actionWithTarget:self selector:@selector(loadLayerA)], nil]];
    }
    else if(t == tR){
        [defaults setBool:YES forKey:@"RSelected"];
        [defaults synchronize];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:sceneChangeDelay], [CCCallFuncN actionWithTarget:self selector:@selector(loadLayerR)], nil]];
    }
    else if(t == tK){
        [defaults setBool:YES forKey:@"KSelected"];
        [defaults synchronize];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:sceneChangeDelay], [CCCallFuncN actionWithTarget:self selector:@selector(loadLayerK)], nil]];
    }
    else if(t == tB){
        [defaults setBool:YES forKey:@"BSelected"];
        [defaults synchronize];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:sceneChangeDelay], [CCCallFuncN actionWithTarget:self selector:@selector(loadLayerB)], nil]];
    }
    else if(t == tBlank && tBlank.hasBeenSelected){
        
        defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:NO forKey:@"MSelected"];
        [defaults setBool:NO forKey:@"ASelected"];
        [defaults setBool:NO forKey:@"RSelected"];
        [defaults setBool:NO forKey:@"KSelected"];
        [defaults setBool:NO forKey:@"BSelected"];
        [defaults synchronize];
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:sceneChangeDelay], [CCCallFuncN actionWithTarget:self selector:@selector(reloadMain)], nil]];
    }
}

-(void) reloadMain{
    [[CCDirector sharedDirector] replaceScene:[MainLayer scene]];
}

-(void) loadLayerM{
    [[CCDirector sharedDirector] replaceScene:[LayerM scene]];
}

-(void) loadLayerA{
    [[CCDirector sharedDirector] replaceScene:[LayerA scene]];
}

-(void) loadLayerR{
    [[CCDirector sharedDirector] replaceScene:[LayerR scene]];
}

-(void) loadLayerK{
    [[CCDirector sharedDirector] replaceScene:[LayerK scene]];
}

-(void) loadLayerB{
    [[CCDirector sharedDirector] replaceScene:[LayerB scene]];
}

@end
