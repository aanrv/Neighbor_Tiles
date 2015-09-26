//
//  BasicScene.h
//  Pattern Matching
//
//  Created by Varan on 1/10/15.
//
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"

@class SKButton;
@class SKSwitch;
@class SKLabelButton;

@interface BasicScene : SKScene
@end

@interface BasicScene ()

/**
 * @property viewController
 * Current view controller. Necessary to manage background music.
 */
@property (nonatomic, weak) ViewController* viewController;

/**
 * @property backButton
 * Functions as back button. When tapped, returns user to previous scene.
 */
@property (nonatomic) SKButton* backButton;

/**
 * @property homeButton
 * Functions as home button. When tapped, returns user to MainMenuScene.
 */
@property (nonatomic) SKButton* homeButton;

/**
 * @property soundEffectSwitch
 * Toggles sound effects when tapped.
 */
@property (nonatomic) SKSwitch* soundEffectSwitch;

/**
 * @property musicSwitch
 * Toggles background music when tapped.
 */
@property (nonatomic) SKSwitch* musicSwitch;

/**
 * @property sceneTransitionAnimation
 * Default transition while navigating through scenes.
 */
@property (nonatomic) SKTransition* sceneTransitionAnimation;

/**
 * @property homeResetButtonLoc
 * Location for home and reset button. Locations will be the same because both will not be in the same scene.
 */
@property (nonatomic) CGPoint homeResetButtonLoc;

/**
 * @property buttonSize
 * Size of buttons.
 */
@property (nonatomic) CGSize buttonSize;

/**
 * @property selectedColor
 * Selected color for label nodes is based on current tile color.
 */
@property (nonatomic) SKColor* selectedColor;

/**
 * @property forwardTransitionDuration
 * Duration of forward transition while navigating through scenes.
 */
@property (nonatomic) NSTimeInterval forwardTransitionDuration;

/**
 * @property backwardTransitionDuration
 * Duration of transition when going back a scene.
 */
@property (nonatomic) NSTimeInterval backwardTransitionDuration;

/**
 * @property randomTransitionDuration
 * Duration for random transitions.
 */
@property (nonatomic) NSTimeInterval randomTransitionDuration;

/**
 * Scene initializer.
 * @param bb Determines whether a back button should be included in the scene or not.
 * @param hb Determines whether a home button should be included in the scene or not.
 * @param sfxb Determines whether a sound effects switch should be included in the scene or not.
 * @param mb Determines whether a background music switch should be included in the scene or not.
 * @param viewController Current view controller.
 * @return The basic parent scenes of all other scenes in this project.
 */
- (instancetype) initWithSize:(CGSize)size backButton:(BOOL) bb homeButton:(BOOL) hb sfxButton:(BOOL) sfxb musicButton:(BOOL) mb viewController:(ViewController*)viewController;

/**
 * Provides back button functionality in each scene.
 * @note This function MUST be overriden if derived children have a back button.
 */
- (void) goBack;

/**
 * Provides home button functionality in each scene.
 */
- (void) goHome;

/**
 * Adds animated tiles randomly for background effect. Tiles vary in color, size, movement speed, rotation speed, and initial location.
 * @param numTiles Determine the number of tiles to be presented with the single call of this method.
 */
- (void) addRandomTilesToBackground:(unsigned int)numTiles;

/**
 * Generate a random color from the 9 selected colors.
 * @param w Determines whether to include white as an option or not.
 * @return Returns the randomly generated color.
 */
- (SKColor*) generateRandomColorIncludingWhite:(BOOL)w;

/**
 * Returns the closest node within a given radius from a given point.
 * @param radius The acceptable distance from a node's anchor point to accpe the touch event.
 * @param loc Location of touch.
 * @return Node within radius closest to loc.
 * @note Ignores SKSpritenodes due to background floating nodes being SKSpriteNodes.
 */
- (SKSpriteNode*) nodeWithinRadius:(float) radius OfPoint:(CGPoint) loc;

/**
 * Repositions bottom hud buttons based on whether ads are enabled or disabled.
 */
- (void) refreshHomeButtonLoc;

@end
