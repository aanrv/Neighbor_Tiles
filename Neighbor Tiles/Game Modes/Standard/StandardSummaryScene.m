//
//  StandardSummaryScene.m
//  Pattern Matching
//
//  Created by Varan on 11/22/14.
//
//

#import "StandardSummaryScene.h"
#import "LevelMenuScene.h"
#import "LevelMenuSceneFour.h"
#import "SKButton.h"
#import "StandardGameScene.h"

@implementation StandardSummaryScene

- (instancetype) initWithSize:(CGSize)size levelNumber:(int) levelNumber numberOfMoves:(NSInteger)numMoves perfectScore:(BOOL)perfect viewController:(ViewController *)viewController{
    self = [super initWithSize:size viewController:viewController];
    
    if(self) {
        self.levelNum = levelNumber;
        
        NSString* movesKey = [NSString stringWithFormat:@"%@%i",movesPartialKey,levelNumber];
        
        //First time beating the level
        if(![[NSUserDefaults standardUserDefaults] integerForKey:movesKey]) {
            NSLog(@"First time beating this level.");
            [[NSUserDefaults standardUserDefaults] setInteger:numMoves forKey:movesKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else {
            NSString* bestOrPreviousBest = @"Best";
            
            NSInteger previous = [[NSUserDefaults standardUserDefaults] integerForKey:movesKey];
            
            //Same level beaten in less moves than before
            if(numMoves < previous) {
                bestOrPreviousBest = @"Previous Best";
                [[NSUserDefaults standardUserDefaults] setInteger:numMoves forKey:movesKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                /*
                if(previous >= 0) {
                    SKLabelNode* newHighScore = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
                    newHighScore.text = @"New high score!";
                    newHighScore.position = self.newHighScoreLoc;
                    newHighScore.fontSize = FONT_SIZE;
                    [self addChild:newHighScore];
                }
                 */
            }
            
            SKLabelNode* previousBest = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
            previousBest.text = [NSString stringWithFormat:@"%@: %u",bestOrPreviousBest, (unsigned int)previous];
            previousBest.position = self.bestLoc;
            previousBest.fontSize = FONT_SIZE;
            [self addChild:previousBest];
        }
        
        SKLabelNode* finalMovesLabel = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
        finalMovesLabel.text = [NSString stringWithFormat:@"Moves: %u",(unsigned int)numMoves];
        finalMovesLabel.position = self.scoreLoc;
        finalMovesLabel.fontSize = FONT_SIZE * 2;
        [self addChild:finalMovesLabel];
        
        /*
         SKLabelNode* tapToGoBack = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
         tapToGoBack.text = @"<Tap to go back>";
         tapToGoBack.position = CGPointMake(CGRectGetMidX(self.frame), self.homeResetButtonLoc.y + 50);
         tapToGoBack.fontSize = 20.0f;
         [self addChild:tapToGoBack];
         */
        
        //////////////////////// CHECK IF PERFECT SCORE ///////////////////////
        
        if(perfect) {
            /*
            SKLabelNode* p = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
            p.text = @"Perfect!";
            p.position = CGPointMake(self.size.width/2, self.size.height * 5/10);
            p.fontSize = 20.0f;
            [self addChild:p];
             */
            
            [self performStarAnimation];
        }
        
        __weak StandardSummaryScene* weakSelf = self;
        
        SKAction* bigBackAction = [SKAction runBlock:^{
            [weakSelf goBack];
        }];
        
        SKAction* retryAction = [SKAction runBlock:^{
            if(weakSelf.levelNum < numberOfLevels) {
                LevelMenuScene* levelScene = [[LevelMenuScene alloc] initWithSize:weakSelf.size viewController:weakSelf.viewController];
                
                StandardGameScene* nextScene = [[StandardGameScene alloc] initWithSize:weakSelf.size levelNumber:weakSelf.levelNum startingLayout:[levelScene.startingLayouts objectAtIndex:weakSelf.levelNum] viewController:weakSelf.viewController];
                
                [weakSelf.view presentScene:nextScene transition:weakSelf.sceneTransitionAnimation];
                
            }else if(weakSelf.levelNum - numberOfLevels < numberOfLevelsFourByFour) {
                LevelMenuSceneFour* levelScene = [[LevelMenuSceneFour alloc] initWithSize:weakSelf.size viewController:weakSelf.viewController];
                
                StandardGameScene* nextScene = [[StandardGameScene alloc] initWithSize:weakSelf.size levelNumber:weakSelf.levelNum startingLayout:[levelScene.startingLayouts objectAtIndex:weakSelf.levelNum - numberOfLevels] viewController:weakSelf.viewController];
                
                [weakSelf.view presentScene:nextScene transition:weakSelf.sceneTransitionAnimation];
            }
        }];
        
        self.bigBackButton.action = bigBackAction;
        self.retryButton.action = retryAction;
        
        SKAction* nextAction = [SKAction runBlock:^{
            if(weakSelf.levelNum + 1 < numberOfLevels) {
                LevelMenuScene* levelScene = [[LevelMenuScene alloc] initWithSize:weakSelf.size viewController:weakSelf.viewController];
                
                StandardGameScene* nextScene = [[StandardGameScene alloc] initWithSize:weakSelf.size levelNumber:weakSelf.levelNum+1 startingLayout:[levelScene.startingLayouts objectAtIndex:weakSelf.levelNum+1] viewController:weakSelf.viewController];
                
                [weakSelf.view presentScene:nextScene transition:weakSelf.sceneTransitionAnimation];
                
            }else if(weakSelf.levelNum + 1 - numberOfLevels < numberOfLevelsFourByFour) {
                LevelMenuSceneFour* levelScene = [[LevelMenuSceneFour alloc] initWithSize:weakSelf.size viewController:weakSelf.viewController];
                
                StandardGameScene* nextScene = [[StandardGameScene alloc] initWithSize:weakSelf.size levelNumber:weakSelf.levelNum+1 startingLayout:[levelScene.startingLayouts objectAtIndex:weakSelf.levelNum+1 - numberOfLevels] viewController:weakSelf.viewController];
                
                [weakSelf.view presentScene:nextScene transition:weakSelf.sceneTransitionAnimation];
            }
        }];
        
        SKButton* nextButton = [[SKButton alloc] initWithDefaultTextureNamed:@"nextButton" selectedTextureNamed:@"nextButtonSelected" disabledTextureNamed:nil disabled:NO name:@"nextButton" action:nextAction];
        nextButton.size = self.bigBackButton.size;
        [self addChild:nextButton];
        
        [self.bigBackButton setTexture:[SKTexture textureWithImageNamed:@"bigMenuButton"]];
        [self.bigBackButton setDefaultTextureName:@"bigMenuButton"];
        [self.bigBackButton setSelectedTextureName:@"bigMenuButtonSelected"];
        
        // if another level is not available or if 4x4 is not unlocked, disable next button
        if((self.levelNum + 1 >= numberOfLevels && [[NSUserDefaults standardUserDefaults] integerForKey:bestScoreKey] < levelNumberToPresentFourByFour) || self.levelNum + 1 >= (numberOfLevels + numberOfLevelsFourByFour)) {
            nextButton.alpha = 0.5;
            [nextButton disable];
        }
        
        CGFloat avgX = (self.retryLoc.x - self.backLoc.x)/2;
        
        self.bigBackButton.position = CGPointMake(self.backLoc.x - avgX, self.backLoc.y);
        self.retryButton.position = CGPointMake(self.backLoc.x + avgX, self.backLoc.y);
        nextButton.position = CGPointMake(self.retryLoc.x + avgX, self.retryLoc.y);
        
        /*
         if(YES) {
         [self presentFullScreenAdAfterNumberOfSeconds:0.0f];
         }
         */
    }
    
    return self;
}

- (void) performStarAnimation {
    SKSpriteNode* star = [[SKSpriteNode alloc] initWithImageNamed:@"perfectStar"];
    star.position = CGPointMake(self.size.width/2, self.size.height/2 - 15);
    star.size = CGSizeMake(0, 0);
    star.anchorPoint = CGPointMake(0.5, 0.5);
    
    NSTimeInterval duration = 0.3;
    SKAction* zoomIn = [SKAction resizeByWidth:70 height:70 duration:duration];
    SKAction* rotate = [SKAction rotateByAngle:(M_PI*2) duration:duration];
    
    [star runAction:[SKAction group:@[zoomIn,rotate]]];
    
    [self addChild:star];
}

- (void) goBack {
    [super goBack];
    SKScene* back;
    if(self.levelNum < numberOfLevels) {
        back = [[LevelMenuScene alloc] initWithSize:self.size viewController:self.viewController];
    }else if(self.levelNum < numberOfLevels + numberOfLevelsFourByFour) {
        back = [[LevelMenuSceneFour alloc] initWithSize:self.size viewController:self.viewController];
    }
    
    [self.view presentScene:back transition:[SKTransition moveInWithDirection:SKTransitionDirectionLeft duration:self.backwardTransitionDuration]];
}

@end
