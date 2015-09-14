//
//  StoreScene.h
//  Neighbor Tiles
//
//  Created by Varan on 2/15/15.
//
//

#import "BasicScene.h"

@interface StoreScene : BasicScene

/**
 * @property numHintsLeft
 * Label node indicating number of remaining hints.
 */
@property (nonatomic) SKLabelNode* numHintsLeft;

/**
 * @property fivePriceDisplay
 * Label node displaying prive of 5 Hints pack.
 */
@property (nonatomic) SKLabelNode* fivePriceDisplay;
/**
 * @property fifteenPriceDisplay
 * Label node displaying prive of 15 Hints pack.
 */
@property (nonatomic) SKLabelNode* fifteenPriceDisplay;
/**
 * @property thirtyPriceDisplay
 * Label node displaying prive of 25 Hints pack.
 */
@property (nonatomic) SKLabelNode* thirtyPriceDisplay;

/**
 * @property checkIfCanFetchProductsKey
 * SKAction that checks if products can be fetched every few seconds runs with this key. The key is then used to remove the SKAction from repeating forever if back or home buttons are pressed.
 */
//@property (nonatomic) NSString* checkIfCanFetchProductsKey;

/**
 * Initializer.
 * @param size Size of scene.
 * @param viewController Pass ViewControlelr object. Used to manage background music.
 * @return BasicScene instance.
 */
- (instancetype) initWithSize:(CGSize)size viewController:(ViewController*)viewController;

/**
 * An alert that is shown when user tries to make purchase but in app purchases may be disabled.
 */
- (void) displayCannotMakePaymentsMessage;
/**
 * Determines if network is available or not.
 * @return YES if internet is connected, NO otherwise.
 */
- (BOOL) isNetworkAvailable;

/**
 * Rewrites label indicating number of hints. Called after a purchase has been successfully made.
 */
- (void) updateNumHints;
/**
 * Rewrites labels indicating prices. Called if user was initially not connected to the internet but now is.
 */
- (void) updatePriceDisplays;

@end
