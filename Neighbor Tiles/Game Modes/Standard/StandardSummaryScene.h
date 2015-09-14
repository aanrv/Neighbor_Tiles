//
//  StandardSummaryScene.h
//  Pattern Matching
//
//  Created by Varan on 11/22/14.
//
//

#import "BasicSummaryScene.h"

@interface StandardSummaryScene : BasicSummaryScene
@end

@interface StandardSummaryScene ()

/**
 * @property levelNum
 * Used to determine which level menu scene to go back to (3x3 or 4x4)
 */
@property (nonatomic) unsigned int levelNum;

/**
 * Initializer.
 * @param size Size of scene.
 * @param levelNumber Level number of completed puzzle scene.
 * @param numMoves Number of moves used to complete puzzle.
 * @param perfect Indicated whether the score is perfect or not.
 * @param viewController View Controller.
 * @return Scene instance.
 */
-(instancetype) initWithSize:(CGSize)size levelNumber:(int) levelNumber numberOfMoves:(NSInteger) numMoves perfectScore:(BOOL) perfect viewController:(ViewController*)viewController;

- (void) performStarAnimation;

@end
