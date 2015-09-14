//
//  StandardModeScene.m
//  Pattern Matching
//
//  Created by Varan on 7/12/14.
//
//

#import "StandardGameScene.h"
#import "TileNode.h"
#import "LevelMenuScene.h"
#import "LevelMenuSceneFour.h"
#import "StandardSummaryScene.h"
#import "SKSwitch.h"

@implementation StandardGameScene

- (instancetype) initWithSize:(CGSize)size levelNumber:(int)lvlNum startingLayout:(NSArray *)startingLayout viewController:(ViewController *)viewController
{
    
    self = [super initWithSize:size levelNumber:lvlNum startingLayout:startingLayout viewController:viewController];
    
    if(self) {
        self.levelLabel = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
        self.levelLabel.text = [NSString stringWithFormat:@"Level %i",self.levelNumber];
        self.levelLabel.fontColor = [SKColor whiteColor];
        self.levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        self.levelLabel.fontSize = self.levelScoreFontSize;
        self.levelLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.levelLabel.position = self.levelScoreLoc;
        
        NSString* movesKey = [NSString stringWithFormat:@"%@%i",movesPartialKey,self.levelNumber];
        int bestForLevel = (int)[[NSUserDefaults standardUserDefaults] integerForKey:movesKey];
        self.bestLabel = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
        self.bestLabel.text = [NSString stringWithFormat:@"Best: %i",bestForLevel];
        self.bestLabel.fontColor = [SKColor whiteColor];
        self.bestLabel.horizontalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.bestLabel.fontSize = self.bestFontSize;
        self.bestLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.bestLabel.position = self.bestLoc;
        
        self.movesLabel = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
        self.movesLabel.text = [NSString stringWithFormat:@"Moves: %i",self.movesMade];
        self.movesLabel.fontColor = [SKColor whiteColor];
        self.movesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        self.movesLabel.fontSize = self.timeLeftMovesFontSize;
        self.movesLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.movesLabel.position = self.timeLeftMovesLoc;
        
        [self addChild:self.levelLabel];
        [self addChild:self.bestLabel];
        [self addChild:self.movesLabel];
    }
    
    return self;
}

- (void) goBack {
    [super goBack];
    if(self.rows == 3 && self.columns == 3) {
        LevelMenuScene* back = [[LevelMenuScene alloc] initWithSize:self.size viewController:self.viewController];
        
        [self.view presentScene:back transition:[SKTransition moveInWithDirection:(SKTransitionDirectionLeft) duration:self.backwardTransitionDuration]];
    }else if(self.rows == 4 && self.columns == 4) {
        LevelMenuSceneFour* back = [[LevelMenuSceneFour alloc] initWithSize:self.size viewController:self.viewController];
        [self.view presentScene:back transition:[SKTransition moveInWithDirection:(SKTransitionDirectionLeft) duration:self.backwardTransitionDuration]];
    }
}

- (void) reset {
    [super reset];
    self.movesMade = 0;
    [self.movesLabel setText:[NSString stringWithFormat:@"Moves: %i",self.movesMade]];
}

- (void) checkIfPuzzleSolved {
    [super checkIfPuzzleSolved];
    
    self.movesLabel.text = [NSString stringWithFormat:@"Moves: %i",self.movesMade];
    
    if([self.currentLayout isEqualToArray:self.solutions]) {
        
        BOOL perfect = NO;
        
        NSAssert(self.movesMade >= self.minimumRequiredMoves,@"Level beat in less moves than minimum required moves. Varan you're a failure.");
        
        //check to see if level was beat perfectly.  If it was, save it in user defaults and set perfect to YES so that it can be passed to the summary scene to indicate a "Perfect!" message
        if(self.movesMade <= self.minimumRequiredMoves) {
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@%i",perfectScoresPartialKey,self.levelNumber]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            perfect = YES;
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey])
                [self runAction:[SKAction playSoundFileNamed:@"perfectScoreSound.wav" waitForCompletion:NO]];
        }else {
            if([[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey])
                [self runAction:self.ding];
        }
        
        ///////////////////// UNLOCK NEXT LEVEL //////////////////////
        
        NSString* key = [NSString stringWithFormat:@"%@%i",unlockedPartialKey,self.levelNumber+1];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        StandardSummaryScene* summary = [[StandardSummaryScene alloc] initWithSize:self.size levelNumber:self.levelNumber numberOfMoves:self.movesMade perfectScore:perfect viewController:self.viewController];
        
        __weak StandardGameScene* weakSelf = self;
        id disableInteraction = [SKAction runBlock:^{
            weakSelf.userInteractionEnabled = NO;
        }];
        id wait = [SKAction waitForDuration:self.puzzleSolvedWaitDuration*2];
        id present = [SKAction runBlock:^{
            [weakSelf.view presentScene:summary transition:[SKTransition moveInWithDirection:SKTransitionDirectionRight duration:weakSelf.forwardTransitionDuration]];
        }];
        
        [self runAction:[SKAction sequence:@[disableInteraction,wait,present]]];
    }
}

@end
