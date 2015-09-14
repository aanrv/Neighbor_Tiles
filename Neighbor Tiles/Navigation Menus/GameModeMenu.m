//
//  MyScene.m
//  Pattern Matching
//
//  Created by Varan on 7/11/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GameModeMenu.h"
#import "StandardModeDifficultyScene.h"
#import "TapToBegin.h"
#import "MainMenuScene.h"
#import "SKLabelButton.h"
#import "LevelMenuScene.h"

@implementation GameModeMenu

-(instancetype)initWithSize:(CGSize)size viewController:(ViewController *)viewController {
    
    if (self = [super initWithSize:size backButton:YES homeButton:YES sfxButton:YES musicButton:YES viewController:viewController]) {
        
        CGPoint stdButtonPos = CGPointMake(self.size.width/2, self.size.height * 23/40);
        CGPoint challengeButtonPos = CGPointMake(self.size.width/2, self.size.height * 9/20);
        
        __weak GameModeMenu* weakSelf = self;
        
        // Standard mdoe will present LevelMenuScene (3x3) if Time Run has not gotten up to 4x4, otherwise, will present StandardModeDifficultyScene
        SKAction* actionStandard = [SKAction runBlock:^{
            BasicScene* nextScene;
            if([[NSUserDefaults standardUserDefaults] integerForKey:bestScoreKey] >= levelNumberToPresentFourByFour) {
                nextScene = [[StandardModeDifficultyScene alloc] initWithSize:weakSelf.size viewController:weakSelf.viewController];
            }else {
                nextScene = [[LevelMenuScene alloc] initWithSize:weakSelf.size viewController:weakSelf.viewController];
            }
            [weakSelf.view presentScene:nextScene transition:weakSelf.sceneTransitionAnimation];
        }];
        SKLabelButton* standardModeButton = [[SKLabelButton alloc] initWithFontNamed:@"Menlo-Bold" text:@"Standard" defaultColor:[SKColor whiteColor] selectedColor:self.selectedColor name:@"standardModeButton" action:actionStandard soundEffectName:@"buttonTapSound2" withExtension:@"wav"];
        standardModeButton.position = stdButtonPos;
        standardModeButton.fontSize = standardModeButton.fontSize * 1.2;
        // for animation
        standardModeButton.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
        [self addChild:standardModeButton];
        
        // Time run mode is presented when Challenge button is pressed
        SKAction* actionTimeRun = [SKAction runBlock:^{
            TapToBegin* ttbScene = [[TapToBegin alloc] initWithSize:weakSelf.size viewController:weakSelf.viewController];
            [weakSelf.view presentScene:ttbScene transition:weakSelf.sceneTransitionAnimation];
        }];
        SKLabelButton* timeRunModeButton = [[SKLabelButton alloc] initWithFontNamed:@"Menlo-Bold" text:@"Survival" defaultColor:[SKColor whiteColor] selectedColor:self.selectedColor name:@"timeRunModeButton" action:actionTimeRun soundEffectName:@"buttonTapSound2" withExtension:@"wav"];
        timeRunModeButton.position = challengeButtonPos;
        timeRunModeButton.fontSize = timeRunModeButton.fontSize * 1.2;
        // for animation
        timeRunModeButton.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
        [self addChild:timeRunModeButton];
        
        BOOL manyStandardCompleted = YES;
        // note <= instead of <, this is to check if all levels 3x3 have been completed, which means level `numberOfLevels` would be unlocked
        for(int i = 1; i <= (numberOfLevels * 3.0f/5) && manyStandardCompleted; i++) {
            if(![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@%i",unlockedPartialKey,i]]) {
                manyStandardCompleted = NO;
            }
        }
        
        // If all 3x3 levels are completed but challenge is <5, animate challenge button
        if((manyStandardCompleted && [[NSUserDefaults standardUserDefaults] integerForKey:bestScoreKey] < 5)) {
            
            float sizeChangeRatio = 1.05f;
            
            SKColor* highlightColor = [timeRunModeButton selectedColor];
            
            id waitOneSecond = [SKAction waitForDuration:0.3f];
            id challengeIncreaseSize = [SKAction runBlock:^{
                timeRunModeButton.fontColor = highlightColor;
                timeRunModeButton.fontSize = timeRunModeButton.fontSize * sizeChangeRatio;
            }];
            id wait = [SKAction waitForDuration:0.15f];
            id challengeDecreaseSize = [SKAction runBlock:^{
                timeRunModeButton.fontColor = [timeRunModeButton defaultColor];
                timeRunModeButton.fontSize = timeRunModeButton.fontSize / sizeChangeRatio;
            }];
            id waitFiveSeconds = [SKAction waitForDuration:5.0f];
            
            id actionSequence = [SKAction sequence:@[waitOneSecond,challengeIncreaseSize,wait,challengeDecreaseSize,wait,challengeIncreaseSize,wait,challengeDecreaseSize,waitFiveSeconds]];
            [self runAction:[SKAction repeatActionForever:actionSequence]];
        }
    }
    return self;
}

- (void) goBack {
    MainMenuScene* mms = [[MainMenuScene alloc] initWithSize:self.size viewController:self.viewController];
    [self.view presentScene:mms transition:[SKTransition moveInWithDirection:SKTransitionDirectionLeft duration:self.backwardTransitionDuration]];
}

@end
