//
//  Grid.h
//  cocos2d
//
//  Created by Otavio Monteagudo on 3/29/15.
//
//

#import "CCSprite.h"

@interface Grid : CCSprite

    @property (nonatomic, assign) int totalAlive; // these update the two Label values
    @property (nonatomic, assign) int generation;

    - (void) evolveStep;

    - (void) countNeighbours;

    - (void) updateCreatures;

@end
