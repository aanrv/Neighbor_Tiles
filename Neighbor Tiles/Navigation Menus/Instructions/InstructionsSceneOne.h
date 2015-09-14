//
//  InstructionsSceneOne.h
//  Pattern Matching
//
//  Created by Varan on 9/6/14.
//
//

#import "InstructionsSceneBasic.h"

@interface InstructionsSceneOne : InstructionsSceneBasic

/**
 * Initializer.
 * @param size Size of scene.
 * @param viewController Pass ViewControlelr object. Used to manage background music.
 * @return BasicScene instance.
 */
- (instancetype) initWithSize:(CGSize)size viewController:(ViewController*)viewController;

@end
