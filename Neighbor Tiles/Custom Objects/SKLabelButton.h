//
//  SKLabelButton.h
//  Pattern Matching
//
//  Created by Varan on 1/11/15.
//
//

#import <SpriteKit/SpriteKit.h>

@interface SKLabelButton : SKLabelNode

/**
 * @property action
 * Action to be performed by parent class.
 */
@property (nonatomic) SKAction* action;

/**
 * @property sound
 * Sound effect to be played upon touchesEnded:withEvent:
 */
@property (nonatomic) SKAction* sound;

/**
 * @property defaultColor
 * Default color for label text.
 */
@property (nonatomic) SKColor* defaultColor;

/**
 * @property selectedColor
 * Text color when node is selected.
 */
@property (nonatomic) SKColor* selectedColor;

/**
 * @property isSelected
 * Indicates whether or not node is currently selected.
 */
@property (nonatomic) BOOL isSelected;

/**
 * Initializer.
 * @param fontName Name of label's font.
 * @param t Label's text.
 * @param defColor Label's default color.
 * @param selColor Label's color when selected.
 * @param randColorSelect Determines whether or not color should be random on selection.
 * @param n Name of node.
 * @param action Functionality of button.
 * @return SKLabelButton instance.
 */
- (instancetype) initWithFontNamed:(NSString *)fontName
                              text:(NSString*) t
                      defaultColor:(SKColor*) defColor
                     selectedColor:(SKColor*) selColor
                              name:(NSString*) n
                            action:(SKAction*) action;

/**
 * Initializer.
 * @param fontName Name of label's font.
 * @param t Label's text.
 * @param defColor Label's default color.
 * @param selColor Label's color when selected.
 * @param randColorSelect Determines whether or not color should be random on selection.
 * @param n Name of node.
 * @param action Functionality of button.
 * @param sfxName Name of sound effect to be played in touchesEnded:withEvent:
 * @param sfxExtension Extension of sound effect.
 * @return SKLabelButton instance.
 */
- (instancetype) initWithFontNamed:(NSString *)fontName
                              text:(NSString*) t
                      defaultColor:(SKColor*) defColor
                     selectedColor:(SKColor*) selColor
                              name:(NSString*) n
                            action:(SKAction*) action
                   soundEffectName:(NSString*) sfxName
                     withExtension:(NSString*) sfxExtension;

/**
 * Sets button to default (deselected). Called in touches ended and moved.
 * @see touchesMoved:withEvent:
 * @see touchesEnded:withEvent:
 */
- (void) setToDefault;

/**
 * Sets button to selected. Called in touches began and moved.
 * @see touchesBegan:withEvent:
 * @see touchesMoved:withEvent:
 */
- (void) setToSelected;

@end
