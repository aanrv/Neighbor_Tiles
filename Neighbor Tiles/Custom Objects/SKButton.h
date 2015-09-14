//
//  SKButton.h
//  Pattern Matching
//
//  Created by Varan on 7/14/14.
//
//

#import <SpriteKit/SpriteKit.h>

@interface SKButton : SKSpriteNode

/**
 * @property action
 * Action to be performed by parent class.
 */
@property (nonatomic) SKAction* action;
/**
 * @property soundEffect
 * Action to play a sound effect associated with this button.
 */
@property (nonatomic) SKAction* sound;

/**
 * @property isDisabled
 * Indicates whether button is enabled or disabled.
 */
@property (nonatomic) BOOL isDisabled;
/**
 * @property isSelected
 * Indicates whether or not button is selected.
 */
@property (nonatomic) BOOL isSelected;

/**
 * @property defaultTextureName
 * Name of default texture.
 */
@property (nonatomic) NSString* defaultTextureName;
/**
 * @property selectedTextureName
 * Name of texture when button is selected.
 */
@property (nonatomic) NSString* selectedTextureName;
/**
 * @property disabledTextureName
 * Name of texture when button is disabled.
 */
@property (nonatomic) NSString* disabledTextureName;

/**
 * Initializer.
 * @param defTex Name of button's default texture.
 * @param selTex Name of button's selected texture.
 * @param disTex Name of button's disabled texture.
 * @param dis Determines whether or not button is disabled.
 * @param n Name of button node.
 * @param action Provides functionality of button. Run's invocation when button is tapped.
 * @return Button instance.
 */
- (instancetype) initWithDefaultTextureNamed:(NSString*) defTex
                        selectedTextureNamed:(NSString*) selTex
                        disabledTextureNamed:(NSString*) disTex
                                    disabled:(BOOL) dis
                                        name:(NSString*) n
                                      action:(SKAction*) action;

/**
 * Initializer.
 * @param defTex Name of button's default texture.
 * @param selTex Name of button's selected texture.
 * @param disTex Name of button's disabled texture.
 * @param dis Determines whether or not button is disabled.
 * @param n Name of button node.
 * @param action Provides functionality of button. Run's invocation when button is tapped.
 * @param sfx Sound effect name.
 * @param sfxExtension Sound effect extension.
 * @return Button instance.
 */
- (instancetype) initWithDefaultTextureNamed:(NSString*) defTex
                        selectedTextureNamed:(NSString*) selTex
                        disabledTextureNamed:(NSString*) disTex
                                    disabled:(BOOL) dis
                                        name:(NSString*) n
                                      action:(SKAction*) action
                                 soundEffectName:(NSString*)sfx
                               withExtension:(NSString*)sfxExtension;

/**
 * Sets button to default (deselected) (called on touchesEnded)
 */
- (void) setToDefault;
/**
 * Sets button to selected (called on touchesBegan and touchesMoved)
 */
- (void) setToSelected;

/**
 * Disables button so it will not function when tapped.
 */
- (void) disable;
/**
 * Enables button so it will function when tapped.
 */
- (void) enable;

@end
