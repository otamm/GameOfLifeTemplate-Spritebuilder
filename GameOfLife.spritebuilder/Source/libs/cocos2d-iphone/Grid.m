//
//  Grid.m
//  cocos2d
//
//  Created by Otavio Monteagudo on 3/29/15.
//
//

#import "Grid.h" // imports this own Grid interface methods
#import "Creatures.h" // imports Creatures' appearance and applies their interface methods on the Grid's implementation

// these are variables that cannot be changed

static const int GRID_ROWS = 8; // these two are constants (which they should be, as the Grid's appearence [and therefore its number of rows & columns] is already set)
static const int GRID_COLUMNS = 10;

@implementation Grid {
    
    NSMutableArray *_gridArray; // stores creatures in the grid (internal elements will be arrays storing creatures [one array for each row, one creature for each column])
    
    float _cellWidth; // these two will place the creature in a proper position inside the screen
    float _cellHeight;
} // Grid

    - (void)onEnter
    {
        [super onEnter]; // calls the 'onEnter' method of its superclass (that is, a native Obj-C method; onEnter is used to handle user touches) and adds the code below to it
        
        [self setupGrid]; // implemented just below
        
        // accept touches on the grid
        self.userInteractionEnabled = YES;
        
    } // onEnter
    
    - (void)setupGrid
    {
        // divide the grid's size by the number of columns/rows to figure out the right width and height of each cell
        _cellWidth = self.contentSize.width / GRID_COLUMNS;
        _cellHeight = self.contentSize.height / GRID_ROWS;
        
        float x = 0; // position in the row (array inside array)
        float y = 0; // position in the column (array space containing another array)
        
        // initialize the array as a blank NSMutableArray
        _gridArray = [NSMutableArray array];
        
        // initialize Creatures
        for (int i = 0; i < GRID_ROWS; i++) {
            // this is how you create two dimensional arrays in Objective-C. You put arrays into arrays.
            _gridArray[i] = [NSMutableArray array];
            x = 0;
            
            for (int j = 0; j < GRID_COLUMNS; j++) {
                
                Creatures *creature = [[Creatures alloc] initCreatures]; // assigns the '*creature' variable with a 'Creatures' object and initializes the object
                creature.anchorPoint = ccp(0, 0); // sets the creature's anchor point (attribute from CCSprite class)
                creature.position = ccp(x, y); // positions creature inside the grid
                [self addChild:creature]; // assigns a new creature for the grid (one per iteration)
                
                // this is shorthand to access an array inside an array; assigns a Creatures' instance to the specific space in the array
                _gridArray[i][j] = creature;
                
                // make creatures visible to test this method, remove this once we know we have filled the grid properly
                creature.isAlive = YES;
                
                x += _cellWidth; // adds _cellWidth to 'x', which makes sure the next creature will be placed in a horizontal axis space that is <total cell widths> away from the origin.
                
            } // 2nd loop
            
            y += _cellHeight; // same as 'x', for the vertical axis.
            
        } //1st loop
        
    } // setupGrid

@end
