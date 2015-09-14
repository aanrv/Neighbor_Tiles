//
//  MainMenuScene.m
//  Pattern Matching
//
//  Created by Varan on 9/6/14.
//
//

#import "MainMenuScene.h"
#import "GameModeMenu.h"
#import "InstructionsSceneOne.h"
#import "SettingsScene.h"
#import "SKLabelButton.h"
#import "OtherScene.h"
#import "StoreScene.h"
#include <netdb.h>

@implementation MainMenuScene

- (instancetype) initWithSize:(CGSize)size viewController:(ViewController*)viewController {
    self = [super initWithSize:size backButton:NO homeButton:NO sfxButton:YES musicButton:YES viewController:viewController];
    
    if(self) {
        
        SKColor* selectedColor;
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:makeTileColorRandomKey]) {
            selectedColor = [self generateRandomColorIncludingWhite:NO];
        }else if([[NSUserDefaults standardUserDefaults] integerForKey:tileColorKey] == WhiteTileColorWhite) {
            selectedColor = [SKColor grayColor];
        }else {
            NSArray* correspondingColoredTileNames = @[[SKColor whiteColor],[SKColor blueColor],[SKColor yellowColor],[SKColor greenColor],[SKColor cyanColor],[SKColor purpleColor],[SKColor orangeColor],[SKColor magentaColor],[SKColor redColor]];
            
            selectedColor = [correspondingColoredTileNames objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:tileColorKey]];
        }
        
        /////////////////////// CREATE SKLABELBUTTONS ///////////////////////
        
        __weak MainMenuScene* weakSelf = self;
        
        SKAction* actionPlay = [SKAction runBlock:^{
            GameModeMenu* gmm = [[GameModeMenu alloc] initWithSize:weakSelf.size viewController:viewController];
            [weakSelf.view presentScene:gmm transition:weakSelf.sceneTransitionAnimation];
        }];
        SKLabelButton* playButton = [[SKLabelButton alloc] initWithFontNamed:@"Menlo-Bold" text:@"Play" defaultColor:[SKColor whiteColor] selectedColor:selectedColor name:@"playButton" action:actionPlay soundEffectName:@"buttonTapSound2" withExtension:@"wav"];
        playButton.fontSize = 45.0f;
        
        // Instructions button will present instructions scenes
        SKAction* actionInstructions = [SKAction runBlock:^{
            id load = [SKAction runBlock:^{
                weakSelf.alpha = 0;
            }];
            id instructions = [SKAction runBlock:^{
                InstructionsSceneOne* is = [[InstructionsSceneOne alloc] initWithSize:weakSelf.size viewController:weakSelf.viewController];
                [weakSelf.view presentScene:is transition:weakSelf.sceneTransitionAnimation];
            }];
            [weakSelf runAction:[SKAction sequence:@[load,instructions]]];
        }];
        SKLabelButton* instructionsButton = [[SKLabelButton alloc] initWithFontNamed:@"Menlo-Bold" text:@"Instructions" defaultColor:[SKColor whiteColor] selectedColor:selectedColor name:@"instructionsButton" action:actionInstructions soundEffectName:@"buttonTapSound2" withExtension:@"wav"];
        
        // Settings button will present settings scene
        SKAction* actionSettings = [SKAction runBlock:^{
            
            id load = [SKAction runBlock:^{
                weakSelf.alpha = 0;
            }];
            id settings = [SKAction runBlock:^{
                SettingsScene* ss = [[SettingsScene alloc] initWithSize:weakSelf.size viewController:weakSelf.viewController];
                [weakSelf.view presentScene:ss transition:weakSelf.sceneTransitionAnimation];
            }];
            
            [weakSelf runAction:[SKAction sequence:@[load,settings]]];
        }];
        SKLabelButton* optionsButton = [[SKLabelButton alloc] initWithFontNamed:@"Menlo-Bold" text:@"Options" defaultColor:[SKColor whiteColor] selectedColor:selectedColor name:@"optionsButton" action:actionSettings soundEffectName:@"buttonTapSound2" withExtension:@"wav"];
        
        // Store button will present store scene
        SKAction* actionStore = [SKAction runBlock:^{
            
            if([weakSelf isNetworkAvailable]) {
                id load = [SKAction runBlock:^{
                    weakSelf.alpha = 0;
                }];
                id fetch = [SKAction runBlock:^{
                    if([[weakSelf.viewController validProducts] count] < numberOfStoreProducts &&
                       [weakSelf isNetworkAvailable]) {
                        [weakSelf.viewController fetchAvailableProducts];
                    }
                }];
                id store = [SKAction runBlock:^{
                    StoreScene* ss = [[StoreScene alloc] initWithSize:weakSelf.size viewController:weakSelf.viewController];
                    [weakSelf.view presentScene:ss transition:weakSelf.sceneTransitionAnimation];
                }];
                
                [weakSelf runAction:[SKAction sequence:@[load,fetch,store]]];
            }else {
                [weakSelf.viewController displayCheckInternetMessage];
            }
        }];
        SKLabelButton* storeButton = [[SKLabelButton alloc] initWithFontNamed:@"Menlo-Bold" text:@"Store" defaultColor:[SKColor whiteColor] selectedColor:selectedColor name:@"storeButton" action:actionStore soundEffectName:@"buttonTapSound2" withExtension:@"wav"];
        
        SKAction* actionOther = [SKAction runBlock:^{
            id load = [SKAction runBlock:^{
                weakSelf.alpha = 0;
            }];
            id other = [SKAction runBlock:^{
                OtherScene* scene = [[OtherScene alloc] initWithSize:weakSelf.size viewController:weakSelf.viewController];
                [weakSelf.view presentScene:scene transition:weakSelf.sceneTransitionAnimation];
            }];
            
            [weakSelf runAction:[SKAction sequence:@[load,other]]];
        }];
        SKLabelButton* otherButton = [[SKLabelButton alloc] initWithFontNamed:@"Menlo-Bold" text:@"Other" defaultColor:[SKColor whiteColor] selectedColor:selectedColor name:@"otherButton" action:actionOther soundEffectName:@"buttonTapSound2" withExtension:@"wav"];
        // Position of play button is at bottom of screen out of view so that the animation will bring it up
        playButton.position = CGPointMake(CGRectGetMidX(self.frame), -30.0f);
        instructionsButton.position = CGPointMake(self.size.width/2, self.size.height * 5/10);
        optionsButton.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height * 4/10);
        storeButton.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height * 3/10);
        otherButton.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height * 2/10);
        
        ///////////////////// ANIMATIONS ///////////////////////////
        
        SKAction* animatePlay = [SKAction runBlock:^{
            SKAction* movePlayButton = [SKAction moveToY:weakSelf.size.height * 6/10 duration:0.2f];
            [playButton runAction:movePlayButton];
        }];
        
        id wait = [SKAction waitForDuration:0.4f];
        
        // Set alpha to 0 because they will fade in
        instructionsButton.alpha = 0.0f;
        optionsButton.alpha = 0.0f;
        storeButton.alpha = 0.0f;
        otherButton.alpha = 0.0f;
        
        id animateOthers = [SKAction runBlock:^{
            float fadeInDuration = 0.3f;
            
            SKAction* fadeIn = [SKAction fadeInWithDuration:fadeInDuration];
            
            [instructionsButton runAction:fadeIn];
            [optionsButton runAction:fadeIn];
            [storeButton runAction:fadeIn];
            [otherButton runAction:fadeIn];
        }];
        
        [self runAction:[SKAction sequence:@[animatePlay,wait,animateOthers]]];
        
        ////////////////// ADD CHILDREN /////////////////
        
        [self addChild:playButton];
        [self addChild:instructionsButton];
        [self addChild:optionsButton];
        [self addChild:storeButton];
        [self addChild:otherButton];
        
        [self.viewController regularBackgroundMusicStart];
        
        // If options has never been pressed before, animate this
        if(![[NSUserDefaults standardUserDefaults] boolForKey:pressedOptionsBeforeKey]) {
            
            float sizeChangeRatio = 1.05f;
            
            SKColor* highlightColor = [optionsButton selectedColor];
            
            id waitOneSecond = [SKAction waitForDuration:1.25f];
            id challengeIncreaseSize = [SKAction runBlock:^{
                optionsButton.fontColor = highlightColor;
                optionsButton.fontSize = optionsButton.fontSize * sizeChangeRatio;
            }];
            id wait = [SKAction waitForDuration:0.15f];
            id challengeDecreaseSize = [SKAction runBlock:^{
                optionsButton.fontColor = [optionsButton defaultColor];
                optionsButton.fontSize = optionsButton.fontSize / sizeChangeRatio;
            }];
            id waitFiveSeconds = [SKAction waitForDuration:3.5f];
            
            id actionSequence = [SKAction sequence:@[waitOneSecond,challengeIncreaseSize,wait,challengeDecreaseSize,wait,challengeIncreaseSize,wait,challengeDecreaseSize,waitFiveSeconds]];
            [self runAction:[SKAction repeatActionForever:actionSequence]];
        }
    }
    
    return self;
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
        NSLog(@"-> active connection\n");
        return YES;
    }
}

@end
