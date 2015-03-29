//
//  Creatures.m
//  cocos2d
//
//  Created by Otavio Monteagudo on 3/29/15.
//
//

#import "Creatures.h"

@implementation Creatures

    - (instancetype)initCreature {
        
        // since we made Creature inherit from CCSprite (see Creatures.h), 'super' below refers to CCSprite
        
        // sets the class' image to "bubble.png"
        self = [super initWithImageNamed:@"GameOfLifeAssets/Assets/bubble.png"];
        
        // class initializes with the creature not alive
        
        if (self) {
            self.isAlive = NO;
        }
    
        return self;
    }

    - (void)setIsAlive:(BOOL)newState {
        //when you create an @property as we did in the .h, an instance variable with a leading underscore is automatically created for you
        _isAlive = newState;
    
        // 'visible' is a property of any class that inherits from CCNode. CCSprite is a subclass of CCNode, and Creature is a subclass of CCSprite, so Creatures have a visible property
        
        self.visible = _isAlive; // _isAlive is a boolean, therefore when _isAlive is true, creature is visible (and vice-versa)
    }

@end
