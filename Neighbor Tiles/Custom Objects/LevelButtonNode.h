//
//  LevelButtonNode.h
//  Pattern Matching
//
//  Created by Varan on 1/15/15.
//
//

#import <SpriteKit/SpriteKit.h>

@interface LevelButtonNode : SKSpriteNode

/**
 * @property defaultImageName
 * Name of default image.
 */
@property (nonatomic) NSString* defaultImageName;

/**
 * @property selectedImageName
 * Name of image when button is selected.
 */
@property (nonatomic) NSString* selectedImageName;

/**
 * @property defaultTextColor
 * Default text color.
 */
@property (nonatomic) SKColor* defaultTextColor;

/**
 * @property selectedTextcolor
 * Text color when selected.
 */
@property (nonatomic) SKColor* selectedTextColor;

/**
 * @property lock
 * Image of lock.
 */
@property (nonatomic) SKSpriteNode* lock;

/**
 * @property perfectStar
 * Image of star.
 */
@property (nonatomic) SKSpriteNode* perfectStar;

/**
 * @property isUnlocked
 * Indicates whether or not associated level is unlocked.
 */
@property (nonatomic) BOOL isUnlocked;

/**
 * @property isSelected
 * Indicates whether or not button is selected.
 */
@property (nonatomic) BOOL isSelected;

/**
 * @property levelNumber
 * Associated level number.
 */
@property (nonatomic) NSInteger levelNumber;

/**
 * @property levelLabel
 * Label showing associated level's number.
 */
@property (nonatomic) SKLabelNode* levelLabel;

/**
 * Initializer.
 * @param lvlNum Level number of associated level.
 * @param u Whether associated level has been unlocked yet.
 * @param defImg Name of default image.
 * @param selImg Name of selected image.
 * @param defColor Color of default text.
 * @param selColor Color of text when selected.
 * @param s Size of node.
 * @return LevelButtonNode instance.
 */
- (instancetype) initWithLevelNumber:(NSInteger) lvlNum
                            unlocked:(BOOL) u
                    defaultImageName:(NSString*) defImg
                   selectedImageName:(NSString*) selImg
                    defaultTextColor:(SKColor*) defColor
                   selectedTextColor:(SKColor*) selColor
                                size:(CGSize) s;

/**
 * Set node to selected.
 */
- (void) setToSelected;

/**
 * Set node to default (deselected)
 */
- (void) setToDefault;

@end
