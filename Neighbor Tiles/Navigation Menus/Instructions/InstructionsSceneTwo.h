//
//  InstructionsSceneTwo.h
//  Pattern Matching
//
//  Created by Varan on 1/1/15.
//
//

#import "InstructionsSceneBasic.h"

@interface InstructionsSceneTwo : InstructionsSceneBasic

/**
 * Initializer.
 * @param size Size of scene.
 * @param viewController Pass ViewControlelr object. Used to manage background music.
 * @return BasicScene instance.
 */
- (instancetype) initWithSize:(CGSize)size viewController:(ViewController*)viewController;

@end
