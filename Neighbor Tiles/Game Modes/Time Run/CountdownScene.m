//
//  CountdownScene.m
//  Pattern Matching
//
//  Created by Varan on 2/13/15.
//
//

#import "CountdownScene.h"
#import "TimeRunScene.h"
#import "TapToBegin.h"

@implementation CountdownScene

#define INT(x) [NSNumber numberWithInt:x]

- (instancetype) initWithSize:(CGSize)size viewController:(ViewController *)viewController {
    self = [super initWithSize:size backButton:YES homeButton:YES sfxButton:NO musicButton:NO viewController:viewController];
    
    if(self) {
        self.countdown = 3;
        self.countdownLabel = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
        self.countdownLabel.fontColor = [SKColor whiteColor];
        [self addChild:self.countdownLabel];
        self.countdownLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        __weak CountdownScene* weakSelf = self;
        SKAction* wait = [SKAction waitForDuration:1.0f];
        SKAction* countdownPerform = [SKAction runBlock:^{
            [weakSelf countOneDown];
        }];
        
        [self runAction:[SKAction repeatAction:[SKAction sequence:@[countdownPerform,wait]] count:4]];
        
        [self.viewController regularBackgroundMusicStop];
    }
    
    return self;
}

- (void) countOneDown {
    
    if(self.countdown == 0) {
        
        /*if([[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey]) {
         [self runAction:[SKAction playSoundFileNamed:@"countdownBeepFinal.wav" waitForCompletion:NO]];
         }*/
        
        //create the next scene to be presented
        
        NSArray* start0 = @[@[INT(0),INT(1),INT(1)],
                            @[INT(0),INT(1),INT(1)],
                            @[INT(0),INT(1),INT(1)]];
        
        NSArray* start1 = @[@[INT(1),INT(1),INT(1)],
                            @[INT(1),INT(1),INT(1)],
                            @[INT(0),INT(0),INT(0)]];
        
        NSArray* start2 = @[@[INT(1),INT(0),INT(1)],
                            @[INT(1),INT(0),INT(1)],
                            @[INT(1),INT(0),INT(1)]];
        
        NSArray* start4 = @[@[INT(0),INT(1),INT(0)],
                            @[INT(0),INT(1),INT(0)],
                            @[INT(0),INT(1),INT(0)]];
        NSArray* options = @[start0,start1,start2,start4];
        
        NSInteger index = arc4random_uniform((int)[options count]);
        NSArray* firstLevelLayout = [options objectAtIndex:index];
        
        TimeRunScene* present = [[TimeRunScene alloc] initWithSize:self.size levelumber:0 startingLayout:firstLevelLayout timeLimit:10.0f previousHighScore:(unsigned int)[[NSUserDefaults standardUserDefaults] integerForKey:bestScoreKey] viewController:self.viewController];
        
        [self.view presentScene:present transition:[self randomTransitionWithDuration:0.5]];
    }else {
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey]) {
            [self runAction:[SKAction playSoundFileNamed:@"countdownBeep.wav" waitForCompletion:NO]];
        }
        
        //continue the countdown if it is still not 0
        self.countdownLabel.text = [NSString stringWithFormat:@"%i",self.countdown];
        self.countdown--;
    }
}

- (SKTransition*) randomTransitionWithDuration:(float) duration {
    NSMutableArray* transitions = [[NSMutableArray alloc] init];
    
    SKTransition* one = [SKTransition doorsCloseHorizontalWithDuration:duration];
    //SKTransition* two = [SKTransition doorsCloseVerticalWithDuration:duration];
    SKTransition* three = [SKTransition doorsOpenHorizontalWithDuration:duration];
    SKTransition* four = [SKTransition doorsOpenVerticalWithDuration:duration];
    SKTransition* five = [SKTransition doorwayWithDuration:duration];
    //SKTransition* six = [SKTransition crossFadeWithDuration:duration];
    //SKTransition* seven = [SKTransition fadeWithDuration:duration];
    SKTransition* eight = [SKTransition flipHorizontalWithDuration:duration];
    SKTransition* nine = [SKTransition flipVerticalWithDuration:duration];
    
    [transitions addObject:one];
    [transitions addObject:three];
    [transitions addObject:four];
    [transitions addObject:five];
    //[transitions addObject:six];
    //[transitions addObject:seven];
    [transitions addObject:eight];
    [transitions addObject:nine];
    
    int rand = arc4random_uniform((unsigned int)[transitions count]);
    return transitions[rand];
}

- (void) goBack {
    [super goBack];
    [self.viewController regularBackgroundMusicStart];
    
    TapToBegin* back = [[TapToBegin alloc] initWithSize:self.size viewController:self.viewController];
    [self.view presentScene:back transition:[SKTransition moveInWithDirection:(SKTransitionDirectionLeft) duration:self.backwardTransitionDuration]];
}

@end
