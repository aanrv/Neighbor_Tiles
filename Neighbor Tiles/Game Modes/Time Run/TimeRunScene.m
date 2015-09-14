//
//  TimeRunScene.m
//  Pattern Matching
//
//  Created by Varan on 7/22/14.
//
//

#import "TimeRunScene.h"
#import "TimeRunGameOverScene.h"
#import "TileNode.h"
#import "SKButton.h"
#import "LevelMenuScene.h"
#import <sys/utsname.h>

#define INT(x) [NSNumber numberWithInt:x]

const unsigned int TIME_ALMOST_UP = 5;
const float timerAccuracy = 0.1f;

@implementation TimeRunScene

- (instancetype) initWithSize:(CGSize)size
                   levelumber:(int) levelNumber
               startingLayout:(NSArray *)startingLayout
                    timeLimit:(int) timeLimit
            previousHighScore:(unsigned int)phs
               viewController:(ViewController *)viewController{
    
    self = [super initWithSize:size levelNumber:levelNumber startingLayout:startingLayout viewController:viewController];
    
    if(self) {
        //member variables
        
        self.previousBestHighScore = phs;
        self.movesMade = 0;
        self.timeLimit = timeLimit;
        
        self.currentScore = self.levelNumber;
        
        //label nodes
        
        self.scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
        self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        self.scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.scoreLabel.position = self.levelScoreLoc;
        self.scoreLabel.fontColor = [SKColor whiteColor];
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %i",self.currentScore];
        self.scoreLabel.fontSize = self.levelScoreFontSize;
        
        
        //////////////
        
        self.bestScoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
        self.bestScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        self.bestScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.bestScoreLabel.position = self.bestLoc;
        self.bestScoreLabel.text = [NSString stringWithFormat:@"Best: %u",self.previousBestHighScore];
        self.bestScoreLabel.fontColor = [SKColor whiteColor];
        self.bestScoreLabel.fontSize = self.bestFontSize;
        
        
        
        ///////////
        
        self.timerLabel = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
        self.timerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        self.timerLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.timerLabel.position = self.timeLeftMovesLoc;
        [self setTimerText];
        self.timerLabel.fontColor = [SKColor whiteColor];
        self.timerLabel.fontSize = self.timeLeftMovesFontSize;
        
        [self addChild:self.scoreLabel];
        [self addChild:self.bestScoreLabel];
        [self addChild:self.timerLabel];
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey] &&
           self.levelNumber == 0) {
            [self runAction:[SKAction playSoundFileNamed:@"countdownBeepFinal.wav" waitForCompletion:NO]];
        }
        
        /////////// you thought you were good? ////////
        
        
        // there is not enough room on iPhone 4 and 4s to display message (if ads are enabled)
        NSArray* devicesToNotDisplayMessage = @[@"iPhone3,1", @"iPhone3,3", @"iPhone4,1"];
        NSString* currentDevice = [self deviceName];
        
        BOOL isSmallerDevice = NO;
        
        for(NSString* str in devicesToNotDisplayMessage) {
            if([currentDevice isEqualToString:str]) {
                isSmallerDevice = YES;
                break;
            }
        }
        
        // if it is a small device, message will show if ads are disabled so there will be enough room
        BOOL displayMessage = !isSmallerDevice || (![[NSUserDefaults standardUserDefaults] boolForKey:showAdsKey]);
        
        if(self.previousBestHighScore < levelNumberToPresentFourByFour &&
           self.levelNumber == levelNumberToPresentFourByFour &&
           displayMessage) {
            SKAction* fadeIn = [SKAction fadeInWithDuration:1];
            SKAction* fadeOut = [SKAction fadeOutWithDuration:1];
            
            SKLabelNode* youThoughtYouWereGood = [[SKLabelNode alloc] initWithFontNamed:@"Markerfelt-Thin"];
            youThoughtYouWereGood.fontSize = 16.0f;
            youThoughtYouWereGood.position = CGPointMake(self.size.width/2, ((self.backButton.position.y + self.backButton.size.height/2) + self.tilesGrid.position.y) / 2);
            youThoughtYouWereGood.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
            youThoughtYouWereGood.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
            youThoughtYouWereGood.fontColor = [SKColor redColor];
            youThoughtYouWereGood.text = @"You thought you were good?";
            
            SKLabelNode* thinkAgain = [[SKLabelNode alloc] initWithFontNamed:@"Markerfelt-Thin"];
            thinkAgain.fontSize = youThoughtYouWereGood.fontSize;
            thinkAgain.position = youThoughtYouWereGood.position;
            thinkAgain.verticalAlignmentMode = youThoughtYouWereGood.verticalAlignmentMode;
            thinkAgain.horizontalAlignmentMode = youThoughtYouWereGood.horizontalAlignmentMode;
            thinkAgain.fontColor = [SKColor redColor];
            thinkAgain.text = @"Well think again.";
            
            __weak TimeRunScene* weakSelf = self;
            
            id waitOneSecond = [SKAction waitForDuration:1];
            id youThoughtFadeIn = [SKAction runBlock:^{
                [weakSelf addChild:youThoughtYouWereGood];
            }];
            id waitFourSeconds = [SKAction waitForDuration:4.0f];
            id youThoughtFadeOut = [SKAction runBlock:^{
                [youThoughtYouWereGood runAction:fadeOut];
            }];
            
            id thinkAgainAddChild = [SKAction runBlock:^{
                [weakSelf addChild:thinkAgain];
            }];
            id waitTwoSeconds = [SKAction waitForDuration:2];
            id thinkAgainFadeOut = [SKAction runBlock:^{
                [thinkAgain runAction:fadeOut];
            }];
            id removeNodes = [SKAction runBlock:^{
                [youThoughtYouWereGood removeFromParent];
                [thinkAgain removeFromParent];
            }];
            
            SKLabelNode* standardMode = [[SKLabelNode alloc] initWithFontNamed:@"Markerfelt-Thin"];
            standardMode.fontSize = youThoughtYouWereGood.fontSize;
            standardMode.position = youThoughtYouWereGood.position;
            standardMode.verticalAlignmentMode = youThoughtYouWereGood.verticalAlignmentMode;
            standardMode.horizontalAlignmentMode = youThoughtYouWereGood.horizontalAlignmentMode;
            standardMode.fontColor = [SKColor greenColor];
            standardMode.text = @"\"Standard\" Mode: 4x4 puzzles unlocked!";
            
            id addStandardChild = [SKAction runBlock:^{
                standardMode.alpha = 0.0f;
                [standardMode runAction:fadeIn];
                [weakSelf addChild:standardMode];
            }];
            
            id fadeStandardChildOut = [SKAction runBlock:^{
                [standardMode runAction:fadeOut];
            }];
            
            [self runAction:[SKAction sequence:@[waitOneSecond,youThoughtFadeIn,waitFourSeconds,youThoughtFadeOut,waitOneSecond,thinkAgainAddChild,waitTwoSeconds,thinkAgainFadeOut,waitOneSecond,removeNodes,addStandardChild,waitFourSeconds,fadeStandardChildOut]]];
            
            
        }
        
        //timer
        
        __weak TimeRunScene* weakSelf = self;
        
        id waitTimerAccurace = [SKAction waitForDuration:timerAccuracy];
        id updateTheTimer = [SKAction runBlock:^{
            [weakSelf updateTimer];
        }];
        
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[waitTimerAccurace,updateTheTimer]]] withKey:@"updateTheTimer"];
        
        // to check if time is up every second, just to check text color and play sound
        
        id wait = [SKAction waitForDuration:1];
        id checkTimer = [SKAction runBlock:^{
            [weakSelf checkIfTimeIsAlmostUp];
        }];
        
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[wait,checkTimer]]] withKey:@"checkTimer"];
        
        if(self.levelNumber > [[NSUserDefaults standardUserDefaults] integerForKey:bestScoreKey]) {
            
            [[NSUserDefaults standardUserDefaults] setInteger:self.levelNumber forKey:bestScoreKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        // audio
        
        if(self.levelNumber == 0) {
            [self.viewController timeRunBackgroundMusicStart];
        }
    }
    return self;
}

// called every `timerAccuracy` seconds
- (void) updateTimer {
    if((int)self.timeLimit <= 0) {
        [self presentGameOverScene];
    }
    
    self.timeLimit -= timerAccuracy;
    
    // called in updateTimer instead of checkIfTimeIsAlmostUp because checkIfTimeIsAlmostUp works better if it waits an extra second before being called at the beginning of the scene, however, this will cause setTimerText to set the text with a delay (a second will be skipped)
    [self setTimerText];
}

// called every second
- (void) checkIfTimeIsAlmostUp {
    if((int)self.timeLimit <= TIME_ALMOST_UP) {
        
        if((int)self.timeLimit > 0 && [[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey])
            [self runAction:[SKAction playSoundFileNamed:@"timeAlmostUp.wav" waitForCompletion:NO]];
        
        __weak TimeRunScene* weakSelf = self;
        id waitHalfSecond = [SKAction waitForDuration:0.5f];
        id setTextRed = [SKAction runBlock:^{
            weakSelf.timerLabel.fontColor = [SKColor redColor];
        }];
        id setTextWhite = [SKAction runBlock:^{
            weakSelf.timerLabel.fontColor = [SKColor whiteColor];
        }];
        
        [self runAction:[SKAction sequence:@[setTextRed,waitHalfSecond,setTextWhite]]];
    }
}

- (void) setTimerText {
    int minutes = ((int)(self.timeLimit))/60;
    int seconds = ((int)(self.timeLimit))%60;
    
    self.timerLabel.text = [NSString stringWithFormat:@"%02i:%02i",minutes,seconds];
}

- (NSArray*) generateRandomLayoutWithRows:(int) rows columns:(int) columns {
    NSMutableArray* outArr = [[NSMutableArray alloc] initWithCapacity:rows];
    
    for(int i = 0; i < columns; i++) {
        NSMutableArray* rowArr = [[NSMutableArray alloc] initWithCapacity:columns];
        for(int r = 0; r < rows; r++) {
            int rand = arc4random_uniform(2);
            [rowArr addObject:[NSNumber numberWithInt:rand]];
        }
        
        [outArr addObject:rowArr];
    }
    
    NSArray* allBlack = @[@[INT(0),INT(0),INT(0)],
                          @[INT(0),INT(0),INT(0)],
                          @[INT(0),INT(0),INT(0)]];
    
    NSArray* allBlackFour = @[@[INT(0),INT(0),INT(0),INT(0)],
                              @[INT(0),INT(0),INT(0),INT(0)],
                              @[INT(0),INT(0),INT(0),INT(0)],
                              @[INT(0),INT(0),INT(0),INT(0)]];
    
    if([outArr isEqualToArray:allBlack] || [outArr isEqualToArray:allBlackFour]) {
        return [[self generateRandomLayoutWithRows:rows columns:columns] copy];
    }
    
    return outArr;
}

- (void) goBack {
    [super goBack];
    [self presentGameOverScene];
}

- (void) checkIfPuzzleSolved {
    [super checkIfPuzzleSolved];
    
    if([self.currentLayout isEqualToArray:self.solutions]) {
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey]) {
            if(self.levelNumber + 1 == levelNumberToPresentFourByFour){
                [self runAction:[SKAction playSoundFileNamed:@"perfectScoreSound.wav" waitForCompletion:NO]];
            }else {
                [self runAction:[SKAction playSoundFileNamed:@"ding.wav" waitForCompletion:NO]];
            }
        }
        
        [self removeActionForKey:@"updateTheTimer"];
        [self removeActionForKey:@"checkTimer"];
        
        float timeIncrementConst;
        
        if(self.levelNumber + 1 >= levelNumberToPresentFourByFour) {
            timeIncrementConst = 15.0f;
        }else {
            timeIncrementConst = 3.0f;
        }
        
        NSArray* nextStartingLayout = [self createNewPuzzle];
        
        TimeRunScene* nextScene = [[TimeRunScene alloc] initWithSize:self.size levelumber:self.levelNumber+1 startingLayout:nextStartingLayout timeLimit:self.timeLimit+timeIncrementConst previousHighScore:self.previousBestHighScore viewController:self.viewController];
        
        __weak TimeRunScene* weakSelf = self;
        
        id disableUserInteraction = [SKAction runBlock:^{
            weakSelf.userInteractionEnabled = NO;
        }];
        id wait = [SKAction waitForDuration:self.puzzleSolvedWaitDuration];
        id present = [SKAction runBlock:^{
            [weakSelf.view presentScene:nextScene transition:[weakSelf randomTransitionWithDuration:weakSelf.randomTransitionDuration]];
        }];
        
        [self runAction:[SKAction sequence:@[disableUserInteraction,wait,present]]];
    }
}

// doesn't work for 4x4 at the moment
- (NSArray*) createNewPuzzle {
    
    NSArray* nextStartingLayout;
    
    unsigned int nextRowCol;
    
    if(self.levelNumber + 1 >= levelNumberToPresentFourByFour) {
        nextRowCol = 4;
        return [self generateRandomLayoutWithRows:nextRowCol columns:nextRowCol];
    }else {
        nextRowCol = 3;
    }
    
    // progresively increase difficulty
    int levelsToProgressivelyIncreaseDifficulty = levelNumberToPresentFourByFour * 1/2;
    if(self.levelNumber < levelsToProgressivelyIncreaseDifficulty) {
        NSArray* s;
        
        NSArray* start0 = @[@[INT(0),INT(1),INT(1)],
                            @[INT(0),INT(1),INT(1)],
                            @[INT(0),INT(1),INT(1)]];
        
        NSArray* start2 = @[@[INT(1),INT(0),INT(1)],
                            @[INT(1),INT(0),INT(1)],
                            @[INT(1),INT(0),INT(1)]];
        
        NSArray* start5 = @[@[INT(1),INT(1),INT(0)],
                            @[INT(1),INT(1),INT(0)],
                            @[INT(0),INT(0),INT(0)]];
        
        NSArray* start7 = @[@[INT(0),INT(1),INT(1)],
                            @[INT(0),INT(0),INT(0)],
                            @[INT(0),INT(0),INT(0)]];
        
        NSArray* start8 = @[@[INT(0),INT(1),INT(1)],
                            @[INT(0),INT(1),INT(1)],
                            @[INT(1),INT(1),INT(1)]];
        
        NSArray* start9 = @[@[INT(1),INT(1),INT(0)],
                            @[INT(0),INT(0),INT(0)],
                            @[INT(1),INT(1),INT(0)]];
        
        NSArray* start10 = @[@[INT(0),INT(0),INT(0)],
                             @[INT(0),INT(1),INT(0)],
                             @[INT(0),INT(1),INT(0)]];
        
        NSArray* start11 = @[@[INT(1),INT(1),INT(1)],
                             @[INT(1),INT(0),INT(0)],
                             @[INT(1),INT(1),INT(1)]];
        
        NSArray* start12 = @[@[INT(1),INT(0),INT(0)],
                             @[INT(1),INT(1),INT(1)],
                             @[INT(0),INT(1),INT(1)]];
        
        NSArray* start13 = @[@[INT(0),INT(0),INT(1)],
                             @[INT(0),INT(1),INT(0)],
                             @[INT(1),INT(0),INT(0)]];
        
        NSArray* start14 = @[@[INT(0),INT(1),INT(1)],
                             @[INT(1),INT(1),INT(0)],
                             @[INT(0),INT(1),INT(1)]];
        
        NSArray* start15 = @[@[INT(0),INT(0),INT(1)],
                             @[INT(1),INT(0),INT(0)],
                             @[INT(1),INT(0),INT(0)]];
        
        NSArray* start16 = @[@[INT(0),INT(1),INT(1)],
                             @[INT(1),INT(0),INT(1)],
                             @[INT(1),INT(1),INT(0)]];
        
        NSArray* start17 = @[@[INT(0),INT(0),INT(1)],
                             @[INT(1),INT(0),INT(0)],
                             @[INT(0),INT(0),INT(1)]];
        
        NSArray* start18 = @[@[INT(1),INT(1),INT(0)],
                             @[INT(0),INT(0),INT(0)],
                             @[INT(1),INT(0),INT(1)]];
        
        NSArray* start20 = @[@[INT(0),INT(0),INT(0)],
                             @[INT(1),INT(0),INT(0)],
                             @[INT(0),INT(0),INT(0)]];
        
        NSArray* start23 = @[@[INT(0),INT(1),INT(0)],
                             @[INT(1),INT(1),INT(1)],
                             @[INT(0),INT(1),INT(0)]];
        
        NSArray* start25 = @[@[INT(1),INT(0),INT(0)],
                             @[INT(0),INT(0),INT(0)],
                             @[INT(0),INT(0),INT(0)]];
        
        NSArray* start26 = @[@[INT(1),INT(1),INT(1)],
                             @[INT(1),INT(0),INT(1)],
                             @[INT(1),INT(1),INT(1)]];
        
        NSArray* start27 = @[@[INT(1),INT(1),INT(0)],
                             @[INT(0),INT(1),INT(0)],
                             @[INT(0),INT(1),INT(0)]];
        
        NSArray* start28 = @[@[INT(0),INT(1),INT(0)],
                             @[INT(0),INT(1),INT(1)],
                             @[INT(1),INT(0),INT(0)]];
        
        NSArray* start29 = @[@[INT(1),INT(1),INT(0)],
                             @[INT(1),INT(0),INT(1)],
                             @[INT(0),INT(0),INT(0)]];
        
        NSArray* start30 = @[@[INT(0),INT(0),INT(0)],
                             @[INT(0),INT(1),INT(1)],
                             @[INT(0),INT(1),INT(0)]];
        
        NSArray* start31 = @[@[INT(1),INT(1),INT(1)],
                             @[INT(0),INT(1),INT(0)],
                             @[INT(1),INT(0),INT(1)]];
        
        NSArray* start32 = @[@[INT(0),INT(0),INT(1)],
                             @[INT(0),INT(1),INT(0)],
                             @[INT(0),INT(0),INT(0)]];
        
        NSArray* start33 = @[@[INT(1),INT(1),INT(0)],
                             @[INT(1),INT(1),INT(1)],
                             @[INT(1),INT(1),INT(0)]];
        
        NSArray* start34 = @[@[INT(1),INT(1),INT(1)],
                             @[INT(1),INT(1),INT(0)],
                             @[INT(0),INT(0),INT(0)]];
        
        NSArray* start35 = @[@[INT(1),INT(0),INT(0)],
                             @[INT(0),INT(0),INT(1)],
                             @[INT(0),INT(0),INT(0)]];
        
        s = @[start0,
              start2,
              start5,
              start7,
              start8,
              start9,
              start10,
              start11,
              start12,
              start13,
              start14,
              start15,
              start16,
              start17,
              start18,
              start20,
              start23,
              start25,
              start26,
              start27,
              start28,
              start29,
              start30,
              start31,
              start32,
              start33,
              start34,
              start35];
        
        int choiceFrameSize = 3;
        
        // levelLimit + 5
        int levelLimit = (int)[s count];
        
        int numberOfLevelsToMoveFrameAfter = (levelsToProgressivelyIncreaseDifficulty / (levelLimit - choiceFrameSize)) + 1;
        // move frame+1 every levelsToPref... / (20 - 5) = 4
        
        int lowerBound = self.levelNumber / numberOfLevelsToMoveFrameAfter;
        int upperBound = lowerBound + choiceFrameSize;
        
        // 1/choiceFramSize chance of a random puzzle showing up
        int levelToChoose = arc4random_uniform(upperBound - lowerBound + 1) + lowerBound;
        
        // 1/15 chance of a random puzzle
        if(arc4random_uniform(15) == 0) {
            nextStartingLayout = [self generateRandomLayoutWithRows:nextRowCol columns:nextRowCol];
            
            NSLog(@"Random");
        }else {
            NSArray* tempStartLayout = [s objectAtIndex:levelToChoose];
            nextStartingLayout = [self randomlyTransformPuzzle:tempStartLayout];
            
            NSLog(@"Bounds: [%i,%i]",lowerBound,upperBound);
        }
        
    }else {
        nextStartingLayout = [self generateRandomLayoutWithRows:nextRowCol columns:nextRowCol];
    }
    
    // to prevent repetition
    if([nextStartingLayout isEqualToArray:self.startingLayout]) {
        return [self createNewPuzzle];
    }else {
        return nextStartingLayout;
    }
}

- (void) presentGameOverScene {
    TimeRunGameOverScene* gameOver = [[TimeRunGameOverScene alloc] initWithSize:self.size score:self.levelNumber previousHighScore:self.previousBestHighScore viewController:self.viewController];
    
    [self.view presentScene:gameOver transition:[self randomTransitionWithDuration:0.2f]];
    
}

- (NSArray*) randomlyTransformPuzzle:(NSArray *)layout {
    // inverse
    // flip horizontal
    // flip vertical
    
    NSMutableArray* output = [[NSMutableArray alloc] initWithArray:layout];
    
    // invert
    if(arc4random_uniform(2)) {
        
        BOOL allWhite = YES;
        
        for(int r = 0; r < [output count]; r++) {
            for(int c = 0; c < [[output objectAtIndex:r] count]; c++) {
                if([[[output objectAtIndex:r] objectAtIndex:c] integerValue] == 0) {
                    allWhite = NO;
                    break;
                }
            }
            if(!allWhite)
                break;
        }
        
        if(!allWhite) {
            for(int r = 0; r < [output count]; r++) {
                
                NSMutableArray* row = [[NSMutableArray alloc] initWithArray:[output objectAtIndex:r]];
                
                for(int c = 0; c < [[output objectAtIndex:r] count]; c++) {
                    NSNumber* n = [row objectAtIndex:c];
                    n = [n integerValue] == 0 ? INT(1) : INT(0);
                    [row replaceObjectAtIndex:c withObject:n];
                }
                [output replaceObjectAtIndex:r withObject:row];
            }
        }
    }
    
    // flip horizontal
    if(arc4random_uniform(2)) {
        for(int r = 0; r < [output count]; r++) {
            NSMutableArray* row = [[NSMutableArray alloc] initWithArray:[output objectAtIndex:r]];
            NSArray* t = [[row reverseObjectEnumerator] allObjects];
            [output replaceObjectAtIndex:r withObject:t];
        }
    }
    
    // flip vertical (do this last) changes into array
    if(arc4random_uniform(2)) {
        NSArray* t = [[output reverseObjectEnumerator] allObjects];
        output = [t copy];
    }
    
    return output;
}

- (NSString*) deviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

@end
