//
//  SettingsScene.h
//  Pattern Matching
//
//  Created by Varan on 11/11/14.
//
//

#import "BasicScene.h"
#import "TileNode.h"

@interface SettingsScene : BasicScene
@end

@interface SettingsScene ()

/**
 * @property colorDisplayTile
 * Tile indiciating current white tile color.
 */
@property (nonatomic) TileNode* colorDisplayTile;
/**
 * @property questionMark
 * Question mark placed on display tile if Random option is selected.
 */
@property (nonatomic) SKSpriteNode* questionMark;
/**
 * @property chooseRandom
 * Enabled random tile colors when tapped.
 */
@property (nonatomic) SKLabelButton* chooseRandom;

/**
 * @property toggleSoundEffectsSwitch
 * Toggles sound effects.
 */
@property (nonatomic) SKSwitch* toggleSoundEffectsSwitch;
/**
 * @property toggleBackgroundSwitch
 * Toggles background music.
 */
@property (nonatomic) SKSwitch* toggleBackgroundMusicSwitch;

/**
 * Initializer.
 * @param size Size of scene.
 * @param viewController Pass ViewControlelr object. Used to manage background music.
 * @return BasicScene instance.
 */
- (instancetype) initWithSize:(CGSize)size viewController:(ViewController*)viewController;

/**
 * Enables random tile colors.
 */
- (void) enableRandom;
/**
 * Disables random tile colors.
 */
- (void) disableRandom;

/**
 * Changes the color of a TileNode object. Used primarily to change color of tile indicating the current tile color. Has no use outside of SettingsScene.
 * @param tile TileNode object which will change colors.
 * @param color Enumerated value indicating the new color.
 */
- (void) setColorOfTile:(TileNode*)tile toColor:(WhiteTileColor)color;
/**
 * Sets a new tile color as the current tile color to be accessed by BasicGameScene through NSUserDefaults.
 * @param enumKey An NSNumber representing the enum value of the new tile color.
 */
- (void) saveTileColor:(WhiteTileColor)enumKey;

@end
