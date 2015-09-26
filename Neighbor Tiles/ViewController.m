//
//  ViewController.m
//  Pattern Matching
//
//  Created by Varan on 7/11/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "MainMenuScene.h"
#import "InstructionsSceneOne.h"
#import "SKProduct+priceAsString.h"
#import "StoreScene.h"
#import <unistd.h>
#import <netdb.h>

@interface ViewController () {
    ADBannerView* bannerAd;
    BOOL adBannerCurrentlyOnScreen;
    
    ADInterstitialAd* fullscreenAd;
    BOOL fullScreenAdIsBeingRequested;
    
    MFMailComposeViewController* mailComposer;
    
    BOOL adContentAvailable;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"View Did Load");
    
    // Configure the view.
    self.skView = (SKView *)self.view;
    
    BasicScene* scene;
    
    // First time opening app
    if(![[NSUserDefaults standardUserDefaults] boolForKey:previousDataKey]) {
        NSLog(@"First time opening application.");
        
        // if first time opening, nothing would be bought
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:showAdsKey];
        
        // Indicate app has now been opened for the first time
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:previousDataKey];
        
        // Setting up user preferences
        
        // Preferences should all be NO if app is realy opened for the first time
        //NSAssert(![[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey],@"First time opening app but `soundEffecsKey != nil`.");
        //NSAssert(![[NSUserDefaults standardUserDefaults] objectForKey:backgroundMusicKey], @"First time opening app but `backgroundMusicKey != nil`.");
        
        // Sound effects enabled
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:soundEffectsKey];
        // Background muisc enabled
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:backgroundMusicKey];
        
        // Setting up StandardMode level data
        
        // Best number of moves for all 3x3 and 4x4 standard levels are 0
        for(int i = 0; i < numberOfLevelsFourByFour; i++) {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:[NSString stringWithFormat:@"%@%i",movesPartialKey,i]];
        }
        // Unlock level 1, and keep the rest unlocked
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@%i",unlockedPartialKey,0]];
        for(int i = 1; i < numberOfLevelsFourByFour; i++) {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:[NSString stringWithFormat:@"%@%i",unlockedPartialKey,i]];
        }
        
        // Set perfect score for all levels to 0
        for(int i = 0; i < numberOfLevelsFourByFour; i++) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"%@%i",perfectScoresPartialKey,i]];
        }
        
        //Set best time run score to 0
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:bestScoreKey];
        
        //Set white as default tile color
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:tileColorKey];
        
        //Set number of hints
        [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:numberOfHintsKey];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        scene = [[InstructionsSceneOne alloc] initWithSize:self.skView.bounds.size viewController:self];
    }else {
        // Create and configure the MainMenuScene scene if this is not the first time opening application
        scene = [[MainMenuScene alloc] initWithSize:self.skView.bounds.size viewController:self];
    }
    
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    adBannerCurrentlyOnScreen = NO;
    fullScreenAdIsBeingRequested = NO;

    // background music setup
    
    NSURL* URL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Ambler.m4a",[[NSBundle mainBundle] resourcePath]]];
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    self.backgroundMusic.volume = musicVolume;
    
    [self.backgroundMusic prepareToPlay];
    
    NSURL* urlChallenge = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/MoveForward.m4a",[[NSBundle mainBundle] resourcePath]]];
    self.timeRunMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:urlChallenge error:nil];
    self.timeRunMusic.numberOfLoops = -1;
    self.timeRunMusic.volume = musicVolume;
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:backgroundMusicKey]) {
        self.backgroundMusic.volume = musicVolume;
        self.timeRunMusic.volume = musicVolume;
    }else {
        self.backgroundMusic.volume = 0.0f;
        self.timeRunMusic.volume = 0.0f;
    }
    
    [self regularBackgroundMusicStart];
    // Present the scene.
    [self.skView presentScene:scene];
}

- (void) viewWillLayoutSubviews {
    NSLog(@"viewWillLayoutSubviews called.");
    
    //NEVER SHOW AD
    if(!adBannerCurrentlyOnScreen && [[NSUserDefaults standardUserDefaults] boolForKey:showAdsKey])
        [self showAdBanner];
}

- (void) showAdBanner {
    if([[NSUserDefaults standardUserDefaults] boolForKey:showAdsKey]) {
        adBannerCurrentlyOnScreen = YES;
        
        if(!bannerAd) {
            bannerAd = [[ADBannerView alloc] initWithFrame:CGRectZero];
            bannerAd.frame = CGRectMake(0, self.view.frame.size.height - bannerAd.frame.size.height, self.view.frame.size.width, 50);
            bannerAd.delegate = self;
            
            // init as hidden, only unhide after bannerViewLoadAd
            bannerAd.hidden = YES;
        }
        
        // remove NO to enable ads
        if(!bannerAd.superview && bannerAd != nil && NO) {
            [self.view addSubview:bannerAd];
        }
    }
}

- (void) removeAdBanner {
    if(bannerAd.superview != nil &&
       bannerAd != nil &&
       [[NSUserDefaults standardUserDefaults] boolForKey:showAdsKey]) {
        adBannerCurrentlyOnScreen = NO;
        [bannerAd setAlpha:0];
        [bannerAd removeFromSuperview];
        bannerAd = nil;
    }
}

- (void) makeAdBannerVisible {
    bannerAd.hidden = NO;
}
- (void) makeAdBannerInvisible {
    bannerAd.hidden = YES;
}

- (BOOL) bannerAdIsHidden {
    return bannerAd.hidden;
}

- (void) bannerViewDidLoadAd:(ADBannerView *)banner {
    NSLog(@"Banner view had loaded ad.");
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [bannerAd setAlpha:1];
    [UIView commitAnimations];
    
    adContentAvailable = YES;
    
    [self makeAdBannerVisible];
}
- (BOOL) bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    BOOL allow = YES;
    
    [self volumeFadeOut];
    self.skView.paused = YES;
    
    return allow;
}
- (void) bannerViewActionDidFinish:(ADBannerView *)banner {
    [self volumeFadeIn];
    self.skView.paused = NO;
}
- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Failed to recieve ad banner:\n%@",error);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [bannerAd setAlpha:0];
    [UIView commitAnimations];
    
    [self makeAdBannerInvisible];
    
    adContentAvailable = NO;
}
- (void)bannerViewWillLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad Banner will load ad.");
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void) regularBackgroundMusicStart {
    [self timeRunBackgroundMusicStop];
    self.currentMusicStatus = MusicStatusBackground;
    
    if(![self.backgroundMusic isPlaying]) {
        [self.backgroundMusic play];
    }
}

- (void) regularBackgroundMusicStop {
    if([self.backgroundMusic isPlaying]) {
        [self.backgroundMusic stop];
        self.backgroundMusic.currentTime = 0;
        [self.backgroundMusic prepareToPlay];
    }
    self.currentMusicStatus = MusicStatusNoMusic;
}

- (void) timeRunBackgroundMusicStart {
    [self regularBackgroundMusicStop];
    
    if(![self.timeRunMusic isPlaying]) {
        [self.timeRunMusic play];
    }
    self.currentMusicStatus = MusicStatusTimeRun;
}

- (void) timeRunBackgroundMusicStop {
    if([self.timeRunMusic isPlaying]) {
        [self.timeRunMusic stop];
        self.timeRunMusic.currentTime = 0;
        [self.timeRunMusic prepareToPlay];
    }
    self.currentMusicStatus = MusicStatusNoMusic;
}

- (void) volumeFadeIn {
    if(self.backgroundMusic.volume < musicVolume &&
       self.timeRunMusic.volume < musicVolume &&
       [[NSUserDefaults standardUserDefaults] boolForKey:backgroundMusicKey]) {
        
        if(self.currentMusicStatus == MusicStatusBackground) {
            [self.backgroundMusic play];
        }else if(self.currentMusicStatus == MusicStatusTimeRun) {
            [self.timeRunMusic play];
        }
        
        self.backgroundMusic.volume += 0.005;
        self.timeRunMusic.volume += 0.005;
        [self volumeFadeIn];
    }
}

- (void) volumeFadeOut {
    if(self.backgroundMusic.volume > 0 &&
       self.timeRunMusic.volume > 0 &&
       [[NSUserDefaults standardUserDefaults] boolForKey:backgroundMusicKey]) {
        self.backgroundMusic.volume -= 0.005;
        self.timeRunMusic.volume -= 0.005;
        [self volumeFadeOut];
    }else {
        
        if([self.backgroundMusic isPlaying]) {
            [self.backgroundMusic stop];
        }
        [self.backgroundMusic prepareToPlay];
        
        if([self.timeRunMusic isPlaying]) {
            [self.timeRunMusic stop];
        }
        [self.timeRunMusic prepareToPlay];
    }
}

- (void) sendMail {

    NSString* message = [NSString stringWithFormat:@"\n<%@, Version: %@>",gameName,gameVersion];
    NSArray* recipents = @[emailName];
    
    [self makeAdBannerInvisible];
    
    mailComposer = [[MFMailComposeViewController alloc]init];
    
    mailComposer.mailComposeDelegate = self;
    [mailComposer setMessageBody:message isHTML:NO];
    [mailComposer setToRecipients:recipents];
    
    [self presentViewController:mailComposer animated:YES completion:nil];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self makeAdBannerVisible];
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL) canMakePurchases {
    return [SKPaymentQueue canMakePayments];
}

// call productsRequest to store available products
- (void) fetchAvailableProducts {
    NSSet *productIdentifiers = [NSSet
                                 setWithObjects:productIDFiveHints,productIDFifteenHints, productIDTwentyFiveHints,nil];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    
    if([self isNetworkAvailable])
        [productsRequest start];
}

// store all products currently available in validProducts
- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{

    // if valid products have already been determined, don't reassign
    if([self.validProducts count] <= [response.products count] &&
       [response.products count] == numberOfStoreProducts)
        self.validProducts = response.products;
    
    if([self.validProducts count] > 0 &&
       [self.skView.scene isKindOfClass:[StoreScene class]]) {
        [(StoreScene*)self.skView.scene updatePriceDisplays];
    }
    
    /*
     NSArray* myProducts = response.products;
     
     for(SKProduct* product in myProducts) {
     NSLog(@"\n\nPRODUCT FOUND: %@ \nTITLE:%@ \nDESCRIPTON:%@ \nLOCAL PRICE:%@\n",
     product.productIdentifier,
     product.localizedTitle,
     product.localizedDescription,
     [product priceAsString]);
     }
     */
}

// called from store scene to indicate a product being purchased
- (void) purchaseProductWithID:(NSString *)pid {
    for(SKProduct* product in self.validProducts) {
        if([product.productIdentifier isEqualToString:pid]) {
            NSLog(@"Product with pID: %@ found.",pid);
            
            if ([self canMakePurchases]) {
                SKPayment *payment = [SKPayment paymentWithProduct:product];
                [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
                [[SKPaymentQueue defaultQueue] addPayment:payment];
            }else {
                NSLog(@"Can't make payments!");
            }
        }
    }
    
    if([self.validProducts count] < numberOfStoreProducts) {
        NSLog(@"No products available for purchase.");
        if(![self isNetworkAvailable])
            [self displayCheckInternetMessage];
        else {
            [self displayUnabletoMakePurchaseMessage];
        }
    }
}

// handle purchase
- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing");
                break;
            case SKPaymentTransactionStatePurchased: {
                NSLog(@"Purchased: %@",transaction.payment.productIdentifier);
                
                if ([transaction.payment.productIdentifier isEqualToString:productIDFiveHints]) {
                    
                    [self removeAdvertisements];
                    
                    NSUInteger currentNumberOfHints = [[NSUserDefaults standardUserDefaults] integerForKey:numberOfHintsKey];
                    
                    currentNumberOfHints += 5;
                    
                    [[NSUserDefaults standardUserDefaults] setInteger:currentNumberOfHints forKey:numberOfHintsKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }else if([transaction.payment.productIdentifier isEqualToString:productIDFifteenHints]) {
                    
                    [self removeAdvertisements];
                    
                    NSUInteger currentNumberOfHints = [[NSUserDefaults standardUserDefaults] integerForKey:numberOfHintsKey];
                    
                    currentNumberOfHints += 15;
                    
                    [[NSUserDefaults standardUserDefaults] setInteger:currentNumberOfHints forKey:numberOfHintsKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }else if([transaction.payment.productIdentifier isEqualToString:productIDTwentyFiveHints]) {
                    [self removeAdvertisements];
                    
                    NSUInteger currentNumberOfHints = [[NSUserDefaults standardUserDefaults] integerForKey:numberOfHintsKey];
                    
                    currentNumberOfHints += 25;
                    
                    [[NSUserDefaults standardUserDefaults] setInteger:currentNumberOfHints forKey:numberOfHintsKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }/*else {
                  NSAssert(NO,@"nope nope nope");
                  }*/
                
                // update the number of remaining hints after purchase
                if([self.skView.scene isKindOfClass:[StoreScene class]]) {
                    [(StoreScene*)self.skView.scene updateNumHints];
                }
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateRestored: {
                NSLog(@"Restored ");
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateFailed: {
                NSLog(@"Purchase failed ");
                
                
                // DO NOT uncomment displayunabletomakepurchasemessage, remember, purchase will fail even if user hits cancel button, only display a message if there is a network issue
                if(![self isNetworkAvailable]) {
                    [self displayCheckInternetMessage];
                }/*else {
                  [self displayUnabletoMakePurchaseMessage];
                  }*/
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
                break;
            default:
                break;
        }
    }
}

- (void) paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (SKProduct*) productWithPID:(NSString *)pID {
    SKProduct* ret = nil;
    for(SKProduct* product in self.validProducts) {
        if([product.productIdentifier isEqualToString:pID]) {
            ret = product;
            break;
        }
    }
    return ret;
}

- (void) removeAdvertisements{
    [self makeAdBannerInvisible];
    [self removeAdBanner];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:showAdsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (BOOL)isNetworkAvailable
{
    char *hostname;
    struct hostent *hostinfo;
    hostname = "google.com";
    hostinfo = gethostbyname (hostname);
    if (hostinfo == NULL){
        NSLog(@"-> no connection\n");
        return NO;
    }
    else{
        NSLog(@"-> valid connection\n");
        return YES;
    }
}

- (void) displayCheckInternetMessage {
    UIAlertView* connectWifi = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please make sure you are connected to the internet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [connectWifi show];
}

- (void) displayUnabletoMakePurchaseMessage {
    UIAlertView* connectWifi = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Try to reload the store." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [connectWifi show];
}

@end