//
//  StandardModeDifficultyScene.h
//  Pattern Matching
//
//  Created by Varan on 1/18/15.
//
//

#import "BasicScene.h"

@interface StandardModeDifficultyScene : BasicScene

/**
 * Initializer.
 * @param size Size of scene.
 * @param viewController Pass ViewControlelr object. Used to manage background music.
 * @return BasicScene instance.
 */
- (instancetype) initWithSize:(CGSize)size viewController:(ViewController*)viewController;

@end