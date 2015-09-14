//
//  MyScene.h
//  Pattern Matching
//
//  Created by V.
//

#import "BasicScene.h"

@interface GameModeMenu : BasicScene

/**
 * Initializer.
 * @param size Size of scene.
 * @param viewController Pass ViewControlelr object. Used to manage background music.
 * @return BasicScene instance.
 */
- (instancetype) initWithSize:(CGSize)size viewController:(ViewController*)viewController;

@end

