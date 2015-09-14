//
//  LevelMenuSceneFour.h
//  Pattern Matching
//
//  Created by Varan on 1/18/15.
//
//

#import "BasicScene.h"
@interface LevelMenuSceneFour : BasicScene
@end

@interface LevelMenuSceneFour ()

/**
 * @property startingLayouts
 * Array holding starting layouts for each level.
 */
@property (nonatomic) NSArray* startingLayouts;

/**
 * Initializer.
 * @param size Size of scene.
 * @param viewController Pass ViewControlelr object. Used to manage background music.
 * @return BasicScene instance.
 */
- (instancetype) initWithSize:(CGSize)size viewController:(ViewController*)viewController;

/**
 * Retrieve a random SKTransition object from selections.
 * @param duration Duration of randomly created transition.
 * @return A randomly created SKTransition object.
 */
- (SKTransition*) randomTransitionWithDuration:(float) duration;

@end
