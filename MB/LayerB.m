//
//  LayerB.m
//  MB
//
//  Created by Mark Bellott on 4/30/13.
//  Copyright 2013 Mark Bellott. All rights reserved.
//

#import "LayerB.h"


@implementation LayerB

#pragma mark - Init Methods

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	
	LayerB *layer = [LayerB node];
    
	[scene addChild: layer];
	
	return scene;
}

-(id) init{
    self = [super init];
    
    if(self){
        [self initialSetup];
        [self animateIntialSetup];
    }
    return self;
}

-(void) initialSetup{
    winSize = [[CCDirector sharedDirector] winSize];
    
    backgroundSprite = [[CCSprite alloc] initWithFile:@"MB_Background.png"];
    backgroundSprite.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:backgroundSprite];
    
    contentSprite = [[CCSprite alloc] initWithFile:@"MB_BContent.png"];
    scrollView = [[MBScrollView alloc] initWithSprite:contentSprite];
    scrollView.position = ccp(0, -winSize.height);
    [self addChild:scrollView];
    
    topBarSprite = [[CCSprite alloc] initWithFile:@"MB_BTopBar.png"];
    topBarSprite.position = ccp(winSize.width/2, winSize.height + 50);
    [self addChild:topBarSprite];
    
    backButton = [CCMenuItemImage itemWithNormalImage:@"MB_BBackArrow.png" selectedImage:@"MB_BBackArrow.png" target:self selector:@selector(backPressed)];
    backMenu = [CCMenu menuWithItems:backButton, nil];
    [backMenu alignItemsVerticallyWithPadding:0];
    backMenu.position = ccp(37.5,winSize.height+60);
    [self addChild:backMenu];
}

#pragma mark - Animation Methods

-(void) animateIntialSetup{
    [topBarSprite runAction:[CCMoveTo actionWithDuration:.2 position:ccp(winSize.width/2, winSize.height - 43.75)]];
    [backMenu runAction:[CCMoveTo actionWithDuration:.2 position:ccp(37.5, winSize.height - 37.5)]];
    [scrollView runAction:[CCMoveTo actionWithDuration:.2 position:ccp(0, 0)]];
}

-(void) animateDismiss{
    [topBarSprite runAction:[CCMoveTo actionWithDuration:.2 position:ccp(winSize.width/2, winSize.height + 50)]];
    [backMenu runAction:[CCMoveTo actionWithDuration:.2 position:ccp(37.5, winSize.height + 60)]];
    [scrollView runAction:[CCMoveTo actionWithDuration:.2 position:ccp(0, -contentSprite.boundingBox.size.height)]];
}

#pragma mark - Input Handling Methods

-(void) backPressed{
    [self animateDismiss];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.5],[CCCallFuncN actionWithTarget:self selector:@selector(returnToMain)],nil]];
}

#pragma mark - Scene Handling Methods

-(void) returnToMain{
    [[CCDirector sharedDirector] replaceScene:[MainLayer scene]];
}

@end
