//
//  InstructionsSceneBasic.h
//  Pattern Matching
//
//  Created by Varan on 1/12/15.
//
//

#import "BasicScene.h"

@interface InstructionsSceneBasic : BasicScene
@end

@interface InstructionsSceneBasic ()

@property (nonatomic) CGSize handSize;

/**
 * @enum InstructionsPage
 * A value [0,2] indicating page number of instructions scene.
 */
typedef enum {
    InstructionsPageOne,
    InstructionsPageTwo,
    InstructionsPageThree
} InstructionsPage;

/**
 * Initializer.
 * @param p Enumerated value indicating the current Instructions page number.
 * @param viewController ViewController.
 * @return An initializes Instructions scene.
 */
- (instancetype) initWithSize:(CGSize)size page:(InstructionsPage) p viewController:(ViewController*)viewController;

@end
