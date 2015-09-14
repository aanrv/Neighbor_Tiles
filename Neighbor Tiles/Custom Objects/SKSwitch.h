//
//  SKSwitch.h
//  Pattern Matching
//
//  Created by Varan on 11/11/14.
//
//

#import <SpriteKit/SpriteKit.h>

@interface SKSwitch : SKSpriteNode

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
 * @property enabled
 * Indicates whether switch is enabled or disabled.
 */
@property (nonatomic) BOOL enabled;
/**
 * @property isSelected
 * Indicates whether swich is currently selected.
 */
@property (nonatomic) BOOL isSelected;

/**
 * @property enabledImageName
 * Name of image when switch is enabled.
 */
@property (nonatomic) NSString* enabledImageName;
/**
 * @property enabledImageSelectedName
 * Name of image when enabled switch is selected.
 */
@property (nonatomic) NSString* enabledImageSelectedName;
/**
 * @property disabledImageName
 * Name of image wen switch is disabled.
 */
@property (nonatomic) NSString* disabledImageName;
/**
 * @property disabledImageSelectedName
 * Name of image when disabled switch is selected.
 */
@property (nonatomic) NSString* disabledImageSelectedName;

/**
 * Initializer.
 * @param switchName Name of node.
 * @param switchSize Size of node.
 * @param enabledImageName Name of image when switch is enabled.
 * @param enabledImageSelectedName Name of image when switch is enabled and selected.
 * @param disabledImageName Name of image when switch is disabled.
 * @param disabledImageSelectedName Name of image when switch is disabled and selected.
 * @param enableFlag Determines whether switch is enabled or disabled. Enabled means the represented attribute is enabled (music, sound effects, animation, etc.)
 * @param action Functionality when switch is tapped.
 * @return SKSwitch instance.
 */
- (instancetype) initWithName:(NSString*) switchName
                         size:(CGSize) switchSize
            enabledImageNamed: (NSString*) enabledImageName
     enabledImageSelectedNamed:(NSString*) enabledImageSelectedName
           disabledImageNamed: (NSString*) disabledImageName
    disabledImageSelectedNamed:(NSString*) disabledImageSelectedName
                   enableFlag: (BOOL) enableFlag
                       action:(SKAction*) action;

/**
 * Initializer.
 * @param switchName Name of node.
 * @param switchSize Size of node.
 * @param enabledImageName Name of image when switch is enabled.
 * @param enabledImageSelectedName Name of image when switch is enabled and selected.
 * @param disabledImageName Name of image when switch is disabled.
 * @param disabledImageSelectedName Name of image when switch is disabled and selected.
 * @param enableFlag Determines whether switch is enabled or disabled. Enabled means the represented attribute is enabled (music, sound effects, animation, etc.)
 * @param action Functionality when switch is tapped.
 * @param sfxName Name of sound effect to be played on touchesEnded:withEvent.
 * @param sfxExtension Name of sound effect's extension.
 * @return SKSwitch instance.
 */
- (instancetype) initWithName:(NSString*) switchName
                         size:(CGSize) switchSize
            enabledImageNamed: (NSString*) enabledImageName
    enabledImageSelectedNamed:(NSString*) enabledImageSelectedName
           disabledImageNamed: (NSString*) disabledImageName
   disabledImageSelectedNamed:(NSString*) disabledImageSelectedName
                   enableFlag: (BOOL) enableFlag
                       action:(SKAction*) action
              soundEffectName:(NSString*)sfxName
                withExtension:(NSString*)sfxExtension;

/**
 * Toggles switch and attribute.
 */
- (void) toggle;
/**
 * Sets switch to default.
 * @see touchesMoved:withEvent:
 * @see touchesEnded:withEvent:
 */
- (void) setToDefault;
/**
 * Set switch to selected.
 * @see touchesBegan:withEvent:
 * @see touchesMoved:withEvent:
 */
- (void) setToSelected;

@end
