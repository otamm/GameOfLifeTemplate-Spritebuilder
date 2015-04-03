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
                
                // make creatures visible to test this method, remove this once we know we have filled the grid properly; GRID WORKING!
                //creature.isAlive = YES;
                
                x += _cellWidth; // adds _cellWidth to 'x', which makes sure the next creature will be placed in a horizontal axis space that is <total cell widths> away from the origin.
                
            } // 2nd loop
            
            y += _cellHeight; // same as 'x', for the vertical axis.
            
        } //1st loop
        
    } // setupGrid

    - (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
    {
        //get the x,y coordinates of the touch
        CGPoint touchLocation = [touch locationInNode:self];
    
        //get the Creature at that location
        Creatures *creature = [self creatureForTouchPosition:touchLocation];
    
        //invert it's state - kill it if it's alive, bring it to life if it's dead.
        creature.isAlive = !creature.isAlive;
    }

    - (Creatures *)creatureForTouchPosition:(CGPoint)touchPosition
    {
        //get the row and column that was touched, return the Creature inside the corresponding cell
        int column = touchPosition.x / _cellWidth;
        int row = touchPosition.y / _cellHeight;
        
        return _gridArray[row][column];
    }

    - (void) evolveStep
    {
        //update each Creature's neighbor count
        [self countNeighbours];
        
        //update each Creature's state
        [self updateCreatures];
        
        //update the generation so the label's text will display the correct generation
        _generation++;
    }

    - (void) countNeighbours
    {
        // iterate through the rows
        // note that NSArray has a method 'count' that will return the number of elements in the array
        for (int i = 0; i < [_gridArray count]; i++)
        {
            // iterate through all the columns for a given row
            for (int j = 0; j < [_gridArray[i] count]; j++)
            {
                // access the creature in the cell that corresponds to the current row/column
                Creatures *currentCreature = _gridArray[i][j];
                
                // remember that every creature has a 'livingNeighbors' property that we created earlier
                currentCreature.livingNeighbors = 0;
                
                // now examine every cell around the current one
                
                // go through the row on top of the current cell, the row the cell is in, and the row past the current cell
                for (int x = (i-1); x <= (i+1); x++)
                {
                    // go through the column to the left of the current cell, the column the cell is in, and the column to the right of the current cell
                    for (int y = (j-1); y <= (j+1); y++)
                    {
                        // check that the cell we're checking isn't off the screen
                        BOOL isIndexValid;
                        isIndexValid = [self isIndexValidForX:x andY:y];
                        
                        // skip over all cells that are off screen AND the cell that contains the creature we are currently updating
                        if (!((x == i) && (y == j)) && isIndexValid) 
                        {
                            Creatures *neighbor = _gridArray[x][y];
                            if (neighbor.isAlive)
                            {
                                currentCreature.livingNeighbors += 1;
                            }
                        }
                    }
                }
            }
        }
    }

    - (BOOL)isIndexValidForX:(int)x andY:(int)y
    {
        BOOL isIndexValid = YES;
        if(x < 0 || y < 0 || x >= GRID_ROWS || y >= GRID_COLUMNS)
        {
            isIndexValid = NO;
        }
        return isIndexValid;
    }

    - (void) updateCreatures
    {
        // total living creatures
        int numAlive = 0;
        // executes the code here <# of elements in array, each one corresponding to a row> times
        for (int i = 0; i < [_gridArray count]; i++)
        {
            // iterate through all columns in a row
            for (int c = 0; c < [_gridArray[i] count]; c++)
            {
                // access the creature in row 'i' and column 'c'
                Creatures *this_creature = _gridArray[i][c];
                
                if (this_creature.livingNeighbors == 3)
                {
                    this_creature.isAlive = TRUE;
                    numAlive += 1;
                }
                else if (this_creature.livingNeighbors == 2)
                {
                    numAlive += 1;
                }
                else
                {
                    this_creature.isAlive = FALSE;
                }
                    
                    
            }
                
        }
        _totalAlive = numAlive;
    }

@end
