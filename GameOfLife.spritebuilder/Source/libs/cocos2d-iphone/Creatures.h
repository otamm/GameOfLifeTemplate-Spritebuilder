//
//  Creatures.h
//  cocos2d
//
//  Created by Otavio Monteagudo on 3/29/15.
//
//

#import "CCSprite.h" // imports CCSprite class interface

@interface Creatures : CCSprite // inherits from CCSprite implementation

// stores the current state of the creature
@property (nonatomic, assign) BOOL isAlive;

// stores the amount of living neighbors
@property (nonatomic, assign) NSInteger livingNeighbors;

- (id)initCreatures; // sets up creature with a 'creature' image and with 'isAlive' and 'livingNeighbors' attributes

@end
