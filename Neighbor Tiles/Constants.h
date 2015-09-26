//
//  Constants.h
//  Pattern Matching
//
//  Created by Varan on 11/22/14.
//
//

#ifndef Pattern_Matching_Constants_h
#define Pattern_Matching_Constants_h

/**
 * Key to determine whether or not app is opening for the first time.
 */
extern NSString* const previousDataKey;

/**
 * Key to determine whether or not sound effects are enabled.
 */
extern NSString* const soundEffectsKey;

/**
 * Key to determine whether or not background music is enabled.
 */
extern NSString* const backgroundMusicKey;

/**
 * Key to determine whether or not a level has been beaten with a perfect score (@"%@%i",key,lvlNum).
 */
extern NSString* const perfectScoresPartialKey;

/**
 * Key to determine best number of moves for particular level.
 */
extern NSString* const movesPartialKey;

/**
 * Key to determine whether or not particular level is unlocked.
 */
extern NSString* const unlockedPartialKey;

/**
 * Key that saves the best score from Challenge mode.
 */
extern NSString* const bestScoreKey;

/**
 * Key to find number of hints left.
 */
extern NSString* const numberOfHintsKey;

/**
 * Key to determine current "white" tile color.
 */
extern NSString* const tileColorKey;

/**
 * Key to determine whether or not tile colors are random.
 */
extern NSString* const makeTileColorRandomKey;

/**
 * Key to determine whether or not to show advertisements. NO if user has purchased an item.
 */
extern NSString* const showAdsKey;

/**
 * If user hasn't visited options yet, this key will by NO.
 */
extern NSString* const pressedOptionsBeforeKey;

/**
 * Number of Standard 3x3 levels.
 */
extern NSInteger const numberOfLevels;

/**
 * Number of Standard 4x4 levels.
 */
extern NSInteger const numberOfLevelsFourByFour;

/**
 * Level number at which to show the first 4x4 puzzle in Challenge mode.
 */
extern unsigned int const levelNumberToPresentFourByFour;

/**
 * Volume for background music.
 */
extern float const musicVolume;

/**
 * To keep font sizes uniform.
 */
extern float const FONT_SIZE;

/**
 * Radius from center of note to detected a touch event.
 */
extern float const tapRadius;

/**
 * Name of game.
 */
extern NSString* const gameName;

/**
 * Version number.
 */
extern NSString* const gameVersion;

/**
 * Email.
 */
extern NSString* const emailName;

/**
 * App store ID (for review app option)
 */
#define APP_STORE_ID 967807378

/**
 * 5 Hints pack in app purchase product ID.
 */
extern NSString* const productIDFiveHints;

/**
 * 15 Hints pack in app purchase product ID.
 */
extern NSString* const productIDFifteenHints;

/**
 * 25 Hints pack in app purchase product ID.
 */
extern NSString* const productIDTwentyFiveHints;

/**
 * Number of products available for purchase.
 */
extern unsigned int const numberOfStoreProducts;

#endif
