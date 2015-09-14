//
//  StandardModeScene.h
//  Pattern Matching
//
//  Created by Varan on 7/12/14.
//
//

#import "BasicGameScene.h"

@interface StandardGameScene : BasicGameScene
@end

@interface StandardGameScene ()

/**
 * @property levelLabel
 * Label indicating current level.
 */
@property (nonatomic) SKLabelNode* levelLabel;
/**
 * @property bestLabel
 * Label indicating previous best moves.
 */
@property (nonatomic) SKLabelNode* bestLabel;
/**
 * @property movesLabel
 * Label indicating amount of moves used.
 */
@property (nonatomic) SKLabelNode* movesLabel;

/**
 * Initializer.
 * @param size Scene's size.
 * @param lvlNum Current puzzle's level number.
 * @param startingLayout An array indicating the starting layout of the puzzle.
 * @param viewController View controller.
 * @return Scene insance.
 * @warning Having row-column dimensions other than 3x3 or 4x4 has not been accounted for. May cause unexpected behavior.
 * @warning startingLayout must be a 2d array to represent rows and columns.
 * @warning startingLayout must only have NSNumber values of either 0 (black tile) or 1 (white tile). This is because NSNumber values will be used as enumerated values for TileState.
 */
- (instancetype) initWithSize:(CGSize)size
                  levelNumber:(int)lvlNum
               startingLayout:(NSArray *)startingLayout
               viewController:(ViewController *)viewController;

@end
