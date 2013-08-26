//
//  MBScrollView.m
//  MB
//
//  Created by Mark Bellott on 5/1/13.
//  Copyright 2013 Mark Bellott. All rights reserved.
//

#import "MBScrollView.h"

#define FRAME_RATE 60
#define BOUNCE_TIME 0.2f

@implementation MBScrollView

-(id) initWithSprite:(CCSprite*)sprite{
    self = [super init];
    
    if(self){
        self.isTouchEnabled = YES;
        isDragging = NO;
        lastx = 0.0;
        yvel = 0.0;
        contentHeight = sprite.contentSize.height;
        contentWidth = sprite.contentSize.width;
        direction = BounceDirectionStayingStill;
        [self scheduleUpdate];
        
        scrollSprite = sprite;
        scrollSprite.anchorPoint = ccp(0,0);
        scrollSprite.position = ccp(scrollSprite.position.x, scrollSprite.position.y - (scrollSprite.boundingBox.size.height)*2);
        [self addChild:scrollSprite];
        
    }
    return self;
}

#pragma mark - Update Scrolling Method

-(void) update:(ccTime)delta
{
	CGPoint pos = scrollSprite.position;
    
    float up = pos.y + [self boundingBox].origin.y + scrollSprite.contentSize.height;
	float down = pos.y + [self boundingBox].origin.y;
    
    float minY = [self boundingBox].origin.y;
	float maxY = [self boundingBox].origin.y + [self boundingBox].size.height;
    
	if(!isDragging) {
		static float friction = 0.96f;
		
		if(down > minY && direction != BounceDirectionGoingDown) {
			
			yvel = 0;
			direction = BounceDirectionGoingDown;
			
		}
		else if(up < maxY && direction != BounceDirectionGoingUp)	{
			
			yvel = 0;
			direction = BounceDirectionGoingUp;
		}
		
		if(direction == BounceDirectionGoingUp)
		{
			
			if(yvel >= 0)
			{
				float delta = (maxY - up);
				float yDeltaPerFrame = (delta / (BOUNCE_TIME * FRAME_RATE));
				yvel = yDeltaPerFrame;
			}
			
			if((yvel + 0.5f) == maxY)
			{
				
				pos.y = up -  scrollSprite.contentSize.width;
				yvel = 0;
				direction = BounceDirectionStayingStill;
			}
		}
		else if(direction == BounceDirectionGoingDown)
		{
			
			if(yvel <= 0)
			{
				float delta = (minY - down);
				float yDeltaPerFrame = (delta / (BOUNCE_TIME * FRAME_RATE));
				yvel = yDeltaPerFrame;
			}
			
			if((down + 0.5f) == minY) {
				
				pos.y = down - [self boundingBox].origin.y;
				yvel = 0;
				direction = BounceDirectionStayingStill;
			}
		}
		else
		{
			yvel *= friction;
		}
		
		pos.y += yvel;
		
		scrollSprite.position = pos;
	}
	else
	{
		if(down <= minY || up >= maxY) {
			
			direction = BounceDirectionStayingStill;
		}
		
		if(direction == BounceDirectionStayingStill) {
			yvel = (pos.y - lastx)/2;
			lastx = pos.y;
		}
	}
}


#pragma mark - Touch Handling Methods

-(void) registerWithTouchDispatcher{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event{
	isDragging = YES;
	
	return YES;
}

-(void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event{
	
	CGPoint preLocation = [touch previousLocationInView:[touch view]];
	CGPoint curLocation = [touch locationInView:[touch view]];
	
	CGPoint a = [[CCDirector sharedDirector] convertToGL:preLocation];
	CGPoint b = [[CCDirector sharedDirector] convertToGL:curLocation];
	
	CGPoint nowPosition = scrollSprite.position;
	nowPosition.y += ( b.y - a.y );
	scrollSprite.position = nowPosition;
}
-(void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event{
	isDragging = NO;
}

@end
