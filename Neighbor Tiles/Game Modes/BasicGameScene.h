//
//  BasicGameScene.h
//  Pattern Matching
//
//  Created by Varan on 7/15/14.
//
//

#import "BasicScene.h"
#import "TileNode.h"

@class LevelMenuScene;
@class SKButton;

@interface BasicGameScene : BasicScene
@end

@interface BasicGameScene ()

/**
 * @enum TileType
 * Enumerated value [0,2] indicating tile type based on location and grid dimensions. This cannot be in TileNode class because a tile node would not know the dimensions of the grid it is in.
 */
typedef enum {
    TileTypeCenter,
    TileTypeEdge,
    TileTypeCorner
} TileType ;

/**
 * @property ding
 * A ding is played to celebrate the user's completion of the puzzle; hooray *cue party horn*.
 */
@property (nonatomic) SKAction* ding;

/**
 * @property startingLayout
 * 2d Array holding values for starting layout of tiles.
 */
@property (nonatomic) NSArray* startingLayout;
/**
 * @property currentLayout
 * 2d Array holding values of current layout of tiles.
 */
@property (nonatomic) NSMutableArray* currentLayout;
/**
 * @property solutions
 * 2d Array holding values for solutions.
 */
@property (nonatomic) NSArray* solutions;

/**
 * @property tilesGrid
 * Parent node of tiles.
 */
@property (nonatomic) SKSpriteNode* tilesGrid;
/**
 * @property
 * Stores references to all tiles.
 */
@property (nonatomic) NSMutableArray* tilesArray;

/**
 * @property tileHoldDown
 * Sound effect to be played when tile is pressed down.
 */
@property (nonatomic) SKAction* tileHoldDown;
/**
 * @property tileRelease
 * Sound effect to be played when tile is relased.
 */
@property (nonatomic) SKAction* tileRelease;

/**
 * @property resetButton
 * When tapped, resets tiles to starting layout.
 */
@property (nonatomic) SKButton* resetButton;
/**
 * @property hintButton
 * Shows hint when tapped.
 */
@property (nonatomic) SKButton* hintButton;
/**
 * @property numHintsLabel
 * Dispays number of remaining hints.
 */
@property (nonatomic) SKLabelNode* numHintsLabel;
/**
 * Enabled when the hint button has been pressed for this scene.
 */
@property (nonatomic) BOOL hintUsedOnThisLevel;

/**
 * @property levelNumber
 * Current level number.
 */
@property (nonatomic) int levelNumber;
/**
 * @property movesMade
 * Number of moves made.
 */
@property (nonatomic) int movesMade;
/**
 * @property minimumRequiredMoves
 * Minimum  number of moves required to solve puzzle.
 */
@property (nonatomic) NSInteger minimumRequiredMoves;

/**
 * @property levelScoreLoc
 * Location of level number and score labels.
 */
@property (nonatomic) CGPoint levelScoreLoc;
/**
 * @property timeLeftMovesLoc
 * Location of timeleft and moves labels.
 */
@property (nonatomic) CGPoint timeLeftMovesLoc;
/**
 * @property bestLoc
 * location of best score label
 */
@property (nonatomic) CGPoint bestLoc;
/**
 * @property levelScoreFontSize
 * Font size of level and score labels.
 */
@property (nonatomic) int levelScoreFontSize;
/**
 * @property timeLeftMovesFontSize
 * Font size of time left and moves labels.
 */
@property (nonatomic) int timeLeftMovesFontSize;
/**
 * @property bestFontSize
 * Font size of best score label.
 */
@property (nonatomic) int bestFontSize;

/**
 * @property rows
 * Number of rows in grid.
 */
@property (nonatomic) int rows;
/**
 * @property columns
 * Number of columns in grid.
 */
@property (nonatomic) int columns;
/**
 * @property spaceBetween
 * Space between each tile in tilesGrid.
 */
@property (nonatomic) float spaceBetween;

/**
 * @property puzzleSolvedWaitDuration
 * Number of seconds to wait before displaying next scene after solving a puzzle.
 */
@property (nonatomic) float puzzleSolvedWaitDuration;

/**
 * @property emphasizeHintButtonActionKey
 * Key for SKAction to highlight hint button. This key is used to stop the highlight if user presses the button while it is being highlighted.
 */
@property (nonatomic) NSString* emphasizeHintButtonActionKey;

/**
 * Initializer.
 * @param size Size of scene.
 * @param levelNumber Current puzzle's level number.
 * @param startingLayout An array indicating the starting layout of the puzzle.
 * @param viewController View controller (used for managing background music).
 * @return Scene instance.
 * @warning Having row-column dimensions other than 3x3 or 4x4 has not been accounted for. Will cause unexpected behavior.
 * @warning startingLayout must be a 2d array to represent rows and columns.
 * @warning startingLayout must only have NSNumber values of either 0 (black tile) or 1 (white tile). This is because NSNumber values will be used as enumerated values for TileState.
 */
- (instancetype) initWithSize:(CGSize)size
                  levelNumber:(int)levelNumber
               startingLayout:(NSArray*)startingLayout
               viewController:(ViewController*)viewController;

/**
 * Selects tiles that will change states if touch ends on at current tile.
 * @param tileTappedOn TileNode object that is being held down.
 */
- (void) changeNeighboringTilesToSelected: (TileNode*) tileTappedOn;
/**
 * Changes the states of the appropriate tiles.
 * @param tileTappedOn TileNode object where touch was released.
 */
- (void) changeNeighboringTileStates: (TileNode*) tileTappedOn;

/**
 * Returns an array indicating which tiles to tap to solve the puzzle.
 */
- (NSArray*) tilesToTapToSolvePuzzle;
/**
 * Determines tile type based on location and grid dimensions.
 * @param r Tile's row number.
 * @param c Tile's column number.
 * @return Enumerated value (TileType) to classify tile's type.
 * @warning Currently only works for 3x3 and 4x4 grids.
 */
- (TileType) tileTypeAtRow:(unsigned int) r column:(unsigned int) c;
/**
 * Calculate the minimum number of moves required to solve this puzzle.
 * @return The minimum number of moves required.
 */
- (unsigned int) calculateMinimumMovesRequiredToSolvePuzzle;
/**
 * Shows hint for current puzzle. Called when hint button is pressed and then at the end of updateCurrentLayout.
 * @warning Currently only works for 3x3 and 4x4 grids.
 */
- (void) showHint;

/**
 * Records current tile layout and updates tilesArray accordingly. Also manages methods like showHint and checkIfPuzzleSolved.
 */
- (void) updateCurrentLayout;
/**
 * Method to check if puzzle has been solved. Also implements what to do next based on whether it is a Standard level or a TimeRun level. Called at the end of updateCurrentLayout.
 * @warning Must be overriden in derived classes.
 */
- (void) checkIfPuzzleSolved;
/**
 * Functionality for reset button. Resets tile grid to starting layout.
 * @see updateCurrentLayout
 */
- (void) reset;

/**
 * For testing purposes: Logs current layout using `B` and `W`.
 */
- (void) logCurrentLayout;

/**
 * Generates a random white tile color. Called at the beginning of each game scene if random tiles option is enabled.
 * @return An enumerated value indicating the level's white tile color.
 */
- (WhiteTileColor) generateRandomWhiteTileColor;
/**
 * Retrieve a random SKTransition object from selections.
 * @param duration Duration of randomly created transition.
 * @return A randomly created SKTransition object.
 */
- (SKTransition*) randomTransitionWithDuration:(float) duration;

/**
 * Returns the closest node from point loc within a radius of half the diagonal of one square in a grid of tiles.
 * @param loc Location of touch.
 * @return TileNode closest to loc within a certain distance.
 */
- (TileNode*) closestTileNodeFromPoint:(CGPoint)loc;
/**
 * Calculates the distance between two points.
 * @param A First point.
 * @param B Second point.
 * @return Distance between A and B.
 */
- (float) distanceBetween:(CGPoint)A and:(CGPoint)B;

/**
 * Blinks the hint button if puzzle has not been solved after a certain amount of time.
 */
- (void) emphasizeHintButton;

@end
