//
//  MBScrollView.h
//  MB
//
//  Created by Mark Bellott on 5/1/13.
//  Copyright 2013 Mark Bellott. All rights reserved.
//
//  A Scroll View written for support with Cocos2D 2.x
//  Assistance from SuperSu's code
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum{
	BounceDirectionGoingUp = 1,
	BounceDirectionStayingStill = 0,
	BounceDirectionGoingDown = -1,
	BounceDirectionGoingLeft = 2,
	BounceDirectionGoingRight = 3
} BounceDirection;

@interface MBScrollView : CCLayer {
    
    CCSprite *scrollSprite;
    
    BounceDirection direction;
	BOOL isDragging;
	float lastx;
	float yvel;
	float contentHeight, contentWidth;
}

-(id) initWithSprite:(CCSprite*)sprite;
//-(void) addScrollingSprite:(CCSprite*)sprite;

@end
