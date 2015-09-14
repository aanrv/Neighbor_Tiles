//
//  TimeRunScene.h
//  Pattern Matching
//
//  Created by Varan on 7/22/14.
//
//

#import "BasicGameScene.h"

@interface TimeRunScene : BasicGameScene
@end

@interface TimeRunScene ()

/**
 * @property scoreLabel
 * Label showing current score.
 */
@property (nonatomic) SKLabelNode* scoreLabel;
/**
 * @property bestScoreLabel
 * Label showing best score.
 */
@property (nonatomic) SKLabelNode* bestScoreLabel;
/**
 * @property timerLabel
 * Label showing time left.
 */
@property (nonatomic) SKLabelNode* timerLabel;

/**
 * @property timeLimit
 * Time left.
 */
@property (nonatomic) float timeLimit;
/**
 * @property currentScore
 * Current score.
 */
@property (nonatomic) int currentScore;
/**
 * @property previousBestHighScore
 * this is necessary so each timeRunScene keeps track of what the high score was at the beginning of the round.  This value will be passed on to TimeRunGameOverScene. This is also necessary to have the game save high scores every round.
 */
@property (nonatomic) unsigned int previousBestHighScore;

/**
 * Initializer.
 * @param size Size of scene.
 * @param levelNumber Current puzzle's level number.
 * @param startingLayout An array indicating the starting layout of the puzzle.
 * @param timeLimit Time left for current puzzle.
 * @param phs High score before beginning this Challenge mode session. This is required because best score saves at the end of every level in Challenge mode to account for a disruption in the middle of the game that would, otherwise, not properly save the user's score.
 * @param viewController View Controller.
 * @warning Having row-column dimensions other than 3x3 or 4x4 has not been accounted for. May cause unexpected behavior.
 * @warning startingLayout must be a 2d array to represent rows and columns.
 * @warning startingLayout must only have NSNumber values of either 0 (black tile) or 1 (white tile). This is because NSNumber values will be used as enumerated values for TileState.
 */
- (instancetype) initWithSize:(CGSize)size
                   levelumber:(int) levelNumber
               startingLayout:(NSArray *)startingLayout
                    timeLimit:(int) timeLimit
            previousHighScore:(unsigned int) phs
               viewController:(ViewController*)viewController;

/**
 * Updates timer for current scene. Called every second to subtract 1 from time remaining. Displays new time and checks if time is remaining.
 */
- (void) updateTimer;
/**
 * Sets text for timer label based on time left. Called in updateTimer.
 */
- (void) setTimerText;
/**
 * Determines whether or not to change text red and play time almost up sfx.
 */
- (void) checkIfTimeIsAlmostUp;
/**
 * Presents next scene when game is over. Called in checkIfTimesUp.
 */
- (void) presentGameOverScene;

/**
 * Creates a new puzzle based on level using starting layouts from LevelMenuScene. Puzzles get more difficult as levels progress.
 * @return A 2d NSArray* representing a puzzle layout.
 * @note 4x4 puzzles are still handled completely randomely.
 */
- (NSArray*) createNewPuzzle;
/**
 * Generates a puzzle with a random layout every time.
 * @param rows Number of rows in the grid.
 * @param columns Number of columns in the grid.
 * @return A 2d array representing layout of grid. Should be used as a parameter for a game scene.
 * @warning Having row-column dimensions other than 3x3 or 4x4 has not been accounted for. May cause unexpected behavior.
 */
- (NSArray*) generateRandomLayoutWithRows:(int) rows columns:(int) columns;
/**
 * Randomely transforms a layout but inverting, flipping horizontally, or flipping vertically.
 * @param layout Layout to transform.
 * @return Transformed layout.
 */
- (NSArray*) randomlyTransformPuzzle:(NSArray*)layout;

/**
 * Determines current device model. Used to determine whether to show 4x4 first time message or not (iPhone 4 and 4s do not have enough space when ads are enabled.)
 * @return Device model.
 */
- (NSString*) deviceName;

@end
