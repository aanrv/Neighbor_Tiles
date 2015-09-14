//
//  OtherScene.h
//  Pattern Matching
//
//  Created by Varan on 2/5/15.
//
//

#import "BasicScene.h"

@interface OtherScene : BasicScene

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
