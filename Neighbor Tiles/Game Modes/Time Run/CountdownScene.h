//
//  CountdownScene.h
//  Pattern Matching
//
//  Created by Varan on 2/13/15.
//
//

#import "BasicScene.h"

@interface CountdownScene : BasicScene

/**
 * @property countdownLabel
 * Label showing the countdown.
 */
@property (nonatomic) SKLabelNode* countdownLabel;

/**
 * @property countdown
 * Current countdown value.
 */
@property (nonatomic) int countdown;

/**
 * Initializer.
 * @param size Size of scene.
 * @param viewController Pass ViewControlelr object. Used to manage background music.
 * @return BasicScene instance.
 */
- (instancetype) initWithSize:(CGSize)size viewController:(ViewController*)viewController;

/**
 * Performs one count down after scene is tapped.
 */
- (void) countOneDown;

/**
 * Retrieve a random SKTransition object from selections.
 * @param duration Duration of randomly created transition.
 * @return A randomly created SKTransition object.
 */
- (SKTransition*) randomTransitionWithDuration:(float) duration;

@end
