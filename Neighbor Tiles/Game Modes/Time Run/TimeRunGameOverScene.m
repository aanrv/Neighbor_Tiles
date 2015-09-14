//
//  TimeRunGameOverScene.m
//  Pattern Matching
//
//  Created by Varan on 7/22/14.
//
//

#import "TimeRunGameOverScene.h"
#import "GameModeMenu.h"
#import "SKButton.h"
#import "TapToBegin.h"
#import "CountdownScene.h"

@implementation TimeRunGameOverScene

- (instancetype) initWithSize:(CGSize) size score:(int)score  previousHighScore:(unsigned int)previousHighScore viewController:(ViewController *)viewController{
    
    self = [super initWithSize:size viewController:viewController];
    
    if(self) {
        self.finalScore = score;
        
        self.bestScore = previousHighScore;
        
        if(score > previousHighScore) {
            
            SKLabelNode* previousBest = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
            previousBest.text = [NSString stringWithFormat:@"Previous best: %i",previousHighScore];
            previousBest.position = self.bestLoc;
            previousBest.fontSize = FONT_SIZE;
            [self addChild:previousBest];
            
            self.bestScore = self.finalScore;
            
            SKLabelNode* newHighScore = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
            newHighScore.text = @"New high score!";
            newHighScore.position = self.newHighScoreLoc;
            newHighScore.fontSize = FONT_SIZE;
            [self addChild:newHighScore];
            NSLog(@"New high score");
        }else {
            SKLabelNode* bestLabel = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
            bestLabel.text = [NSString stringWithFormat:@"Best: %i",previousHighScore];
            bestLabel.position = self.bestLoc;
            bestLabel.fontSize = FONT_SIZE;
            [self addChild:bestLabel];
        }
        
        SKLabelNode* finalScoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
        finalScoreLabel.text = [NSString stringWithFormat:@"Score: %i",score];
        finalScoreLabel.position = self.scoreLoc;
        finalScoreLabel.fontSize = FONT_SIZE * 2;
        [self addChild:finalScoreLabel];
        
        /*
         SKLabelNode* tapToGoBack = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
         tapToGoBack.text = @"<Tap to go back>";
         tapToGoBack.position = CGPointMake(CGRectGetMidX(self.frame), self.homeResetButtonLoc.y + 50);
         tapToGoBack.fontSize = 20.0f;
         [self addChild:tapToGoBack];
         */
        
        [self.viewController regularBackgroundMusicStart];
        
        __weak TimeRunGameOverScene* weakSelf = self;
        
        SKAction* bigBackAction = [SKAction runBlock:^{
            GameModeMenu* menu = [[GameModeMenu alloc] initWithSize:weakSelf.size viewController:weakSelf.viewController];
            
            [weakSelf.view presentScene:menu transition:[SKTransition moveInWithDirection:(SKTransitionDirectionLeft) duration:weakSelf.backwardTransitionDuration]];
        }];
        self.bigBackButton.action = bigBackAction;
        
        SKAction* retryAction = [SKAction runBlock:^{
            CountdownScene* retry = [[CountdownScene alloc] initWithSize:weakSelf.size viewController:weakSelf.viewController];
            
            [weakSelf.view presentScene:retry];
        }];
        self.retryButton.action = retryAction;
        
    }
    return self;
    
}


@end
