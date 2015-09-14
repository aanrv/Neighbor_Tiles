//
//  BasicSummaryScene.h
//  Pattern Matching
//
//  Created by Varan on 2/10/15.
//
//

#import "BasicScene.h"

@interface BasicSummaryScene : BasicScene

/**
 * @property bigBackButton
 * Button to go back.
 */
@property (nonatomic) SKButton* bigBackButton;
/**
 * @property retryButton
 * To replay Standard level or restart Survival session.
 */
@property (nonatomic) SKButton* retryButton;

/**
 * @property scoreLoc
 * Location for final score label node.
 */
@property (nonatomic) CGPoint scoreLoc;
/**
 * @property bestLoc
 * Location for best score label node.
 */
@property (nonatomic) CGPoint bestLoc;
/**
 * @property newHighScoreLoc
 * Location for "New High Score!" label node.
 */
@property (nonatomic) CGPoint newHighScoreLoc;

/**
 * @property backLoc
 * Location for back button.
 * @note Standard summary has three buttons instead of two but still uses this location to determine its button locations.
 */
@property (nonatomic) CGPoint backLoc;
/**
 * @property retryLoc
 * Location for retry button.
 * @note Standard summary has three buttons instead of two but still uses this location to determine its button locations.
 */
@property (nonatomic) CGPoint retryLoc;

/**
 * Initializer.
 * @param size Size of scene.
 * @param viewController Pass ViewControlelr object. Used to manage background music.
 * @return BasicScene instance.
 */
- (instancetype) initWithSize:(CGSize)size viewController:(ViewController*)viewController;



/**
 * Creates a random transition object.
 * @param duration Duration of transition.
 * @return Randomely created transition object.
 */
- (SKTransition*) randomTransitionWithDuration:(float) duration;

@end
