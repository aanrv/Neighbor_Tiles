//
//  StandardModeDifficultyScene.m
//  Pattern Matching
//
//  Created by Varan on 1/18/15.
//
//

#import "StandardModeDifficultyScene.h"
#import "SKLabelButton.h"
#import "GameModeMenu.h"
#import "LevelMenuScene.h"
#import "LevelMenuSceneFour.h"

@implementation StandardModeDifficultyScene

- (instancetype) initWithSize:(CGSize)size viewController:(ViewController *)viewController {
    self = [super initWithSize:size backButton:YES homeButton:YES sfxButton:YES musicButton:YES viewController:viewController];
    
    if(self) {
        CGPoint easyButtonPos = CGPointMake(self.size.width/2, self.size.height * 6/10);
        CGPoint notAsEasyButtonPos = CGPointMake(self.size.width/2, self.size.height * 5/10);
        
        __weak StandardModeDifficultyScene* weakSelf = self;
        
        // Button for 3x3 mode
        SKAction* actionEasy = [SKAction runBlock:^{
            LevelMenuScene* easyMenu = [[LevelMenuScene alloc] initWithSize:weakSelf.size viewController:weakSelf.viewController];
            [weakSelf.view presentScene:easyMenu transition:weakSelf.sceneTransitionAnimation];
        }];
        SKLabelButton* easy = [[SKLabelButton alloc] initWithFontNamed:@"Menlo-Bold" text:@"3x3" defaultColor:[SKColor whiteColor] selectedColor:self.selectedColor name:@"easy" action:actionEasy soundEffectName:@"buttonTapSound2" withExtension:@"wav"];
        easy.position = easyButtonPos;
        
        // Button for 4x4 mode
        SKAction* actionNotAsEasy = [SKAction runBlock:^{
            BOOL threeCompleted = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@%li",unlockedPartialKey,(long)numberOfLevels]];
            
            if(threeCompleted) {
                LevelMenuSceneFour* notAsEasyMenu = [[LevelMenuSceneFour alloc] initWithSize:weakSelf.size viewController:weakSelf.viewController];
                [weakSelf.view presentScene:notAsEasyMenu transition:weakSelf.sceneTransitionAnimation];
            }
        }];
        
        SKLabelButton* notAsEasy;
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@%li",unlockedPartialKey,(long)numberOfLevels]]) {
            notAsEasy = [[SKLabelButton alloc] initWithFontNamed:@"Menlo-Bold" text:@"4x4" defaultColor:[SKColor whiteColor] selectedColor:self.selectedColor name:@"notAsEasy" action:actionNotAsEasy soundEffectName:@"buttonTapSound2" withExtension:@"wav"];
        }else {
            notAsEasy = [[SKLabelButton alloc] initWithFontNamed:@"Menlo-Bold" text:@"4x4" defaultColor:[SKColor whiteColor] selectedColor:self.selectedColor name:@"notAsEasy" action:actionNotAsEasy];
        }
        notAsEasy.position = notAsEasyButtonPos;
        
        
        
        // If 3x3 levels haven't all been completed yet, keep 4x4 disabled and display a message
        if(![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@%li",unlockedPartialKey,(long)numberOfLevels]]) {
            notAsEasy.userInteractionEnabled = !notAsEasy.userInteractionEnabled;
            
            //this is so when user tries to press the button, it does not appear selected
            [notAsEasy setSelectedColor:[notAsEasy defaultColor]];
            notAsEasy.alpha = 0.5f;
            
            // Animate and display "First complete 3x3" message
            SKLabelNode* firstBeat3x3 = [[SKLabelNode alloc] initWithFontNamed:@"Markerfelt-Thin"];
            firstBeat3x3.position = CGPointMake(self.size.width/2, self.homeResetButtonLoc.y + 75);
            firstBeat3x3.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
            firstBeat3x3.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
            firstBeat3x3.fontSize = 16.0f;
            firstBeat3x3.text = [NSString stringWithFormat:@"Complete \"%@\" to unlock \"%@\"!",easy.text,notAsEasy.text];
            
            id fadeFirstBeatIn = [SKAction runBlock:^{
                SKAction* fadeIn = [SKAction fadeInWithDuration:2.0f];
                firstBeat3x3.alpha = 0.0f;
                [firstBeat3x3 runAction:fadeIn];
                [weakSelf addChild:firstBeat3x3];
            }];
            id waitFiveSeconds = [SKAction waitForDuration:5.0f];
            id fadeFirstBeatOut = [SKAction runBlock:^{
                SKAction* fadeOut = [SKAction fadeOutWithDuration:2.0f];
                [firstBeat3x3 runAction:fadeOut];
            }];
            
            [self runAction:[SKAction sequence:@[fadeFirstBeatIn,waitFiveSeconds,fadeFirstBeatOut]]];
            
        }
        
        [self addChild:easy];
        [self addChild:notAsEasy];
        
    }
    
    return self;
}

- (void) goBack {
    [super goBack];
    GameModeMenu* back = [[GameModeMenu alloc] initWithSize:self.size viewController:self.viewController];
    
    [self.view presentScene:back transition:[SKTransition moveInWithDirection:(SKTransitionDirectionLeft) duration:self.backwardTransitionDuration]];
}

@end
