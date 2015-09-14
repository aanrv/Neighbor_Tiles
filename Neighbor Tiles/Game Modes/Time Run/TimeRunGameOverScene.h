//
//  TimeRunGameOverScene.h
//  Pattern Matching
//
//  Created by Varan on 7/22/14.
//
//

#import "BasicSummaryScene.h"

@interface TimeRunGameOverScene : BasicSummaryScene
@end

@interface TimeRunGameOverScene ()

/**
 * @property bestScore
 * Previous high score value.
 */
@property (nonatomic) int bestScore;
/**
 * @property finalScore
 * Final score for current Challenge session.
 */
@property (nonatomic) int finalScore;

/**
 * Initializer.
 * @param size Size of scene.
 * @param score Final score in challenge mode.
 * @param previousHighScore Previous best score for Challenge mode.
 * @param viewController View controller.
 * @return Scene instance.
 */
- (instancetype) initWithSize:(CGSize)size score:(int) score previousHighScore:(unsigned int) previousHighScore viewController:(ViewController*)viewController;

@end
