//
//  ViewController.h
//  Pattern Matching
//

//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>

@class LoadingViewController;

/**
 * @enum MusicStatus
 * Current music status.
 */
typedef enum {
    MusicStatusBackground = 0,
    MusicStatusTimeRun = 1,
    MusicStatusNoMusic = 2
} MusicStatus;

@class AVAudioPlayer;

@interface ViewController : UIViewController <ADBannerViewDelegate, MFMailComposeViewControllerDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver>

/**
 * @property skView
 * Current SKView* displaying SKScenes.
 */
@property (nonatomic) SKView* skView;

@property (nonatomic) LoadingViewController* loadingViewController;

/**
 * @property backgroundMusic
 * Regular background music.
 */
@property (nonatomic) AVAudioPlayer* backgroundMusic;
/**
 * @property timeRunMusic
 * Background music when in time run mode.
 */
@property (nonatomic) AVAudioPlayer* timeRunMusic;

/**
 * @property validProducts
 * SKProducts fetched from store.
 */
@property (nonatomic) NSArray* validProducts;

/**
 * @property currentGameMode
 * For applicationWillEnterForefround. Determines whether to play regular music, time run music, or no music at all (countdown).
 */
@property (nonatomic) MusicStatus currentMusicStatus;

/**
 * Shows advertisement banner.
 */
- (void) showAdBanner;
/**
 * Removes advertisement banner. Called in removeAdvertisements.
 */
- (void) removeAdBanner;

/**
 * Sets ad banner's visibility to YES.
 */
- (void) makeAdBannerVisible;
/**
 * Sets ad banner's visibility to NO.
 */
- (void) makeAdBannerInvisible;

/**
 * YES if ad is hidden, NO otherwise.
 */
- (BOOL) bannerAdIsHidden;

/**
 * Starts regular background music. Called after Survival is finished or back is pressed at countdown.
 */
- (void) regularBackgroundMusicStart;
/**
 * Stops regular background music. Called during countdown scene.
 */
- (void) regularBackgroundMusicStop;

/**
 * Starts Survival mode music.
 */
- (void) timeRunBackgroundMusicStart;
/**
 * Stops Survival mode music. Called at game over.
 */
- (void) timeRunBackgroundMusicStop;

/**
 * Fades in background music. Called when an ad click is closed.
 */
- (void) volumeFadeIn;
/**
 * Fades out background music. Called when an ad is clicked on.
 */
- (void) volumeFadeOut;

/**
 * Opens mail view controller.
 */
- (void) sendMail;

/**
 * Starts request for available products for purchase.
 */
- (void) fetchAvailableProducts;
/**
 * Determines whether purchases can be made or not. Usually based on restriction status of purchases on device.
 * @return YES if purchases can be made, NO otherwise.
 */
- (BOOL) canMakePurchases;
/**
 * Request a purchase for given product.
 * @param pid Product ID of item requested to be purchased.
 */
- (void) purchaseProductWithID:(NSString*)pid;
/**
 * Returns an SKProduct with given product id.
 * @param pID Product ID of SKProduct object being requested.
 * @return Product with pID.
 */
- (SKProduct*) productWithPID:(NSString*)pID;

/**
 * Removes advertisements. Called when a purchae is made.
 */
- (void) removeAdvertisements;
/**
 * Determines whether device is connected to internet.
 * @return YES if connected, NO otherwise.
 */
- (BOOL) isNetworkAvailable;
/**
 * Displays an alert to make sure internet is connected. Called when user tries to make a purchase without internet connection.
 */
- (void) displayCheckInternetMessage;
/**
 * Displays an alert when purchase has failed. Most likely due to validProducts count being 0 but internet being connected.
 */
- (void) displayUnabletoMakePurchaseMessage;

@end
