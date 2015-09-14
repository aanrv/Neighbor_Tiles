//
//  AppDelegate.m
//  Pattern Matching
//
//  Created by Varan on 7/11/14.
//
//

#import "AppDelegate.h"
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "TimeRunScene.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"Application will resign active.");

    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"ENTEREDBACKGROUND");
    
    ViewController* vc = (ViewController*)self.window.rootViewController;
    
    if([vc.backgroundMusic isPlaying])
        [vc.backgroundMusic pause];
    else if([vc.timeRunMusic isPlaying])
        [vc.timeRunMusic pause];
    
    [[AVAudioSession sharedInstance] setActive:NO error:nil];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    ViewController* vc = (ViewController*)self.window.rootViewController;
    
    if([vc.skView.scene isKindOfClass:[TimeRunScene class]]) {
        [vc.timeRunMusic play];
    }else
        [vc.backgroundMusic play];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"Application did become active.");
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"MEMORY WARNING RECIEVED!!!");
}

@end
