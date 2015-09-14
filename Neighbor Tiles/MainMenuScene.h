//
//  MainMenuScene.h
//  Pattern Matching
//
//  Created by Varan on 9/6/14.
//
//

#import "BasicScene.h"

@interface MainMenuScene : BasicScene

/**
 * Initializer.
 * @param size Size of scene.
 * @param viewController Pass ViewControlelr object. Used to manage background music.
 * @return BasicScene instance.
 */
- (instancetype) initWithSize:(CGSize)size viewController:(ViewController*)viewController;

/**
 * Determines if network is available.
 * @return YES if device is connected to internet, NO otherwise.
 */
- (BOOL) isNetworkAvailable;

@end

