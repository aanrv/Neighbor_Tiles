//
//  TapToBegin.m
//  Pattern Matching
//
//  Created by Varan on 7/26/14.
//
//

#import "TapToBegin.h"
#import "TimeRunScene.h"
#import "GameModeMenu.h"
#import "SKButton.h"
#import "SKSwitch.h"
#import "CountdownScene.h"

#define INT(x) [NSNumber numberWithInt:x]

@implementation TapToBegin

- (instancetype) initWithSize:(CGSize)size viewController:(ViewController *)viewController{
    self = [super initWithSize:size backButton:YES homeButton:YES sfxButton:YES musicButton:YES viewController:viewController];
    
    if(self) {
        __weak TapToBegin* weakSelf = self;
        SKAction* playAction = [SKAction runBlock:^{
            CountdownScene* next = [[CountdownScene alloc] initWithSize:weakSelf.size viewController:weakSelf.viewController];
            [weakSelf.view presentScene:next];
        }];
        SKButton* playButton = [[SKButton alloc] initWithDefaultTextureNamed:@"playButton" selectedTextureNamed:@"playButtonSelected" disabledTextureNamed:nil disabled:NO name:@"playButton" action:playAction];
        playButton.size = CGSizeMake(55,55);
        playButton.position = CGPointMake(self.size.width/2, self.size.height * 6/10);
        [self addChild:playButton];
        
        unsigned int b = (unsigned int)[[NSUserDefaults standardUserDefaults] integerForKey:bestScoreKey];
        
        SKLabelNode* best = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
        best.text = [NSString stringWithFormat:@"Best: %u",b];
        best.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height * 7/10);
        best.fontSize = 20.0f;
        
        [self addChild:best];
        
        ///////// RULES /////////////
        
        float rulesFontSize = 14.0f;
        float xPos = self.size.width/2;
        float yConst = 34/80.0f;
        
        SKLabelNode* rules = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
        rules.text = @"Rules:";
        //self.rules.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        rules.position = CGPointMake(xPos, self.size.height * yConst);
        rules.fontSize = rulesFontSize * 1.5;
        [self addChild:rules];
        
        SKLabelNode* ruleOne = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
        ruleOne.text = @"1) You will start with 10 seconds.";
        //self.ruleOne.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        ruleOne.position = CGPointMake(xPos, self.size.height * (yConst-(3.0f/80)));
        ruleOne.fontSize = rulesFontSize;
        [self addChild:ruleOne];
        
        SKLabelNode* ruleTwo = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
        ruleTwo.text = @"2) Complete a puzzle to get 3 more seconds.";
        //self.ruleTwo.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        ruleTwo.position = CGPointMake(xPos, self.size.height * (yConst-(6.0f/80)));
        ruleTwo.fontSize = rulesFontSize;
        [self addChild:ruleTwo];
        
        SKLabelNode* ruleThree = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
        ruleThree.text = @"Survive for as long as possible!";
        //self.ruleThree.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        ruleThree.position = CGPointMake(xPos, self.size.height * (yConst-(12.0f/80)));
        ruleThree.fontSize = rulesFontSize;
        [self addChild:ruleThree];
        
        // if 4x4 puzzles unlocked
        if([[NSUserDefaults standardUserDefaults] integerForKey:bestScoreKey] >= levelNumberToPresentFourByFour) {
            SKLabelNode* rule4x4 = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
            rule4x4.text = @"NOTE: Completing a 4x4 will give 15 seconds!";
            rule4x4.fontSize = rulesFontSize;
            rule4x4.position = CGPointMake(xPos, self.size.height * (yConst-(15.0f/80)));
            [self addChild:rule4x4];
        }
    }
    
    return self;
}

- (void) goBack {
    [super goBack];
    // just in case countdown had begun, the music will start again.
    // if music is already playing, this will have no effect
    [self.viewController regularBackgroundMusicStart];
    
    GameModeMenu* back = [[GameModeMenu alloc] initWithSize:self.size viewController:self.viewController];
    [self.view presentScene:back transition:[SKTransition moveInWithDirection:SKTransitionDirectionLeft duration:self.backwardTransitionDuration]];
}

@end
