//
//  TapToBegin.h
//  Pattern Matching
//
//  Created by Varan on 7/26/14.
//
//

#import "BasicScene.h"

@interface TapToBegin : BasicScene
@end

@interface TapToBegin ()

/**
 * Initializer.
 * @param size Size of scene.
 * @param viewController Pass ViewControlelr object. Used to manage background music.
 * @return BasicScene instance.
 */
- (instancetype) initWithSize:(CGSize)size viewController:(ViewController*)viewController;

@end
