//
//  LevelMenuScene.m
//  Pattern Matching
//
//  Created by Varan on 7/14/14.
//
//

#import "LevelMenuScene.h"
#import "StandardModeDifficultyScene.h"
#import "StandardGameScene.h"
#import "SKButton.h"
#import "LevelButtonNode.h"
#import "GameModeMenu.h"

#define INT(x) [NSNumber numberWithInt:x]

unsigned int const LEVELS_PER_ROW = 6;
unsigned int const ROWS = 6;

@implementation LevelMenuScene

- (instancetype) initWithSize:(CGSize)size viewController:(ViewController *)viewController{
    
    self = [super initWithSize:size backButton:YES homeButton:YES sfxButton:YES musicButton:YES viewController:viewController];
    
    if(self) {
        CGSize levelButtonSizes =  CGSizeMake(self.size.width / 10, self.size.width / 10);
        
        //////////////////////////  CREATE BUTTONS //////////////////////////
        
        NSString* levelButtonImage = @"levelButtonImage";
        NSString* levelButtonSelectedImage = @"levelButtonImageSelected";
        
        // Create buttons 0 to numberOfLevels-1 and manage positions, unlock statuses, etc.
        for(unsigned int i = 0; i < numberOfLevels; i++) {
            NSString* unlocked = [NSString stringWithFormat:@"%@%i",unlockedPartialKey,i];
            LevelButtonNode* level = [[LevelButtonNode alloc] initWithLevelNumber:i unlocked:[[NSUserDefaults standardUserDefaults] boolForKey:unlocked]  defaultImageName:levelButtonImage selectedImageName:levelButtonSelectedImage defaultTextColor:[SKColor whiteColor] selectedTextColor:[SKColor blackColor] size:levelButtonSizes];
            float xPos = self.size.width * (i%LEVELS_PER_ROW + 1.04f)/(LEVELS_PER_ROW+1.04f);
            float yPos = self.size.height - (self.size.height * ((i/LEVELS_PER_ROW) + 2.04f)/(ROWS+4));
            level.position = CGPointMake(xPos, yPos);
            [self addChild:level];
        }
        
        // Arrays of all 3x3 levels
        
        NSArray* start0 = @[@[INT(0),INT(1),INT(1)],
                            @[INT(0),INT(1),INT(1)],
                            @[INT(0),INT(1),INT(1)]];
        
        NSArray* start1 = @[@[INT(1),INT(1),INT(1)],
                            @[INT(1),INT(1),INT(1)],
                            @[INT(0),INT(0),INT(0)]];
        
        NSArray* start2 = @[@[INT(1),INT(0),INT(1)],
                            @[INT(1),INT(0),INT(1)],
                            @[INT(1),INT(0),INT(1)]];
        
        NSArray* start3 = @[@[INT(1),INT(1),INT(1)],
                            @[INT(1),INT(1),INT(1)],
                            @[INT(1),INT(1),INT(1)]];
        
        NSArray* start4 = @[@[INT(0),INT(1),INT(0)],
                            @[INT(0),INT(1),INT(0)],
                            @[INT(0),INT(1),INT(0)]];
        
        NSArray* start5 = @[@[INT(1),INT(1),INT(0)],
                            @[INT(1),INT(1),INT(0)],
                            @[INT(0),INT(0),INT(0)]];
        
        NSArray* start6 = @[@[INT(1),INT(1),INT(1)],
                            @[INT(1),INT(0),INT(0)],
                            @[INT(1),INT(0),INT(0)]];
        
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
        
        NSArray* start19 = @[@[INT(1),INT(0),INT(1)],
                             @[INT(0),INT(0),INT(0)],
                             @[INT(1),INT(0),INT(1)]];
        
        NSArray* start20 = @[@[INT(0),INT(0),INT(0)],
                             @[INT(1),INT(0),INT(0)],
                             @[INT(0),INT(0),INT(0)]];
        
        NSArray* start21 = @[@[INT(1),INT(0),INT(1)],
                             @[INT(0),INT(1),INT(0)],
                             @[INT(1),INT(0),INT(1)]];
        
        NSArray* start22 = @[@[INT(1),INT(1),INT(1)],
                             @[INT(1),INT(1),INT(0)],
                             @[INT(1),INT(1),INT(1)]];
        
        NSArray* start23 = @[@[INT(0),INT(1),INT(0)],
                             @[INT(1),INT(1),INT(1)],
                             @[INT(0),INT(1),INT(0)]];
        
        NSArray* start24 = @[@[INT(1),INT(1),INT(1)],
                             @[INT(0),INT(0),INT(0)],
                             @[INT(1),INT(0),INT(1)]];
        
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
        
        self.startingLayouts = @[start0,
                                 start1,
                                 start2,
                                 start3,
                                 start4,
                                 start5,
                                 start6,
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
                                 start19,
                                 start20,
                                 start21,
                                 start22,
                                 start23,
                                 start24,
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
        
        //NSAssert([self.startingLayouts count] == numberOfLevels && numberOfLevels <= (ROWS*LEVELS_PER_ROW),@"LevelMenuScene: [self.startingLayouts count] != numberOfLevels.");
    }
    
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    SKNode* node = [self nodeWithinRadius:tapRadius OfPoint:loc];
    
    // For touches began, sometimes SKLabelNode would be detected instead of LevelButtonNode, so this accounts for that
    if([node isKindOfClass:[LevelButtonNode class]] ||
       [[node parent] isKindOfClass:[LevelButtonNode class]]) {
        
        LevelButtonNode* b;
        
        if([node isKindOfClass:[LevelButtonNode class]]) {
            b = (LevelButtonNode*)node;
        }else{
            b = (LevelButtonNode*)[node parent];
        }
        
        [b setToSelected];
        
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    SKNode* node = [self nodeWithinRadius:tapRadius OfPoint:loc];
    
    // Sometimes, nodes stay selected when touches moves fast, this fixes that
    for(SKNode* node in [self children]) {
        if([node isKindOfClass:[LevelButtonNode class]]) {
            LevelButtonNode* b = (LevelButtonNode*)node;
            [b setToDefault];
        }
    }
    
    // If not a LevelButtonNode
    if(![node isKindOfClass:[LevelButtonNode class]] &&
       ![[node parent] isKindOfClass:[LevelButtonNode class]]) {
        for(SKNode* n in [self children]) {
            if([n isKindOfClass:[LevelButtonNode class]]) {
                LevelButtonNode* b = (LevelButtonNode*)n;
                [b setToDefault];
            }
        }
    }else {
        LevelButtonNode* b;
        
        if([node isKindOfClass:[LevelButtonNode class]]) {
            b = (LevelButtonNode*)node;
        }else {
            b = (LevelButtonNode*)[node parent];
        }
        
        [b setToSelected];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    SKNode* node = [self nodeWithinRadius:tapRadius OfPoint:loc];
    
    if([node isKindOfClass:[LevelButtonNode class]] || [[node parent] isKindOfClass:[LevelButtonNode class]]) {
        LevelButtonNode* button;
        
        if([node isKindOfClass:[LevelButtonNode class]]) {
            button = (LevelButtonNode*)node;
        }else {
            button = (LevelButtonNode*)[node parent];
        }
        
        [button setToDefault];
        
        // If unlocked, present scene
        if([button isUnlocked]) {
            
            int lvlNum = (int)[button levelNumber];
            
            StandardGameScene* gameScene = [[StandardGameScene alloc] initWithSize:self.size levelNumber:lvlNum startingLayout:[self.startingLayouts objectAtIndex:[button levelNumber]] viewController:self.viewController];
            self.userInteractionEnabled = NO;
            [self.view presentScene:gameScene transition:[self randomTransitionWithDuration:self.randomTransitionDuration]];
            
        }
    }
    
    for(SKNode* node in [self children]) {
        if([node isKindOfClass:[LevelButtonNode class]]) {
            LevelButtonNode* b = (LevelButtonNode*)node;
            [b setToDefault];
        }
    }
}

- (void) goBack {
    [super goBack];
    BasicScene* back;
    
    if([[NSUserDefaults standardUserDefaults] integerForKey:bestScoreKey] >= levelNumberToPresentFourByFour) {
        back = [[StandardModeDifficultyScene alloc] initWithSize:self.size viewController:self.viewController];
    }else {
        back = [[GameModeMenu alloc] initWithSize:self.size viewController:self.viewController];
    }
    
    [self.view presentScene:back transition:[SKTransition moveInWithDirection:SKTransitionDirectionLeft duration:self.backwardTransitionDuration]];
}

- (SKTransition*) randomTransitionWithDuration:(float) duration {
    NSMutableArray* transitions = [[NSMutableArray alloc] init];
    
    SKTransition* one = [SKTransition doorsCloseHorizontalWithDuration:duration];
    //SKTransition* two = [SKTransition doorsCloseVerticalWithDuration:duration];
    SKTransition* three = [SKTransition doorsOpenHorizontalWithDuration:duration];
    SKTransition* four = [SKTransition doorsOpenVerticalWithDuration:duration];
    SKTransition* five = [SKTransition doorwayWithDuration:duration];
    SKTransition* six = [SKTransition crossFadeWithDuration:duration];
    SKTransition* seven = [SKTransition fadeWithDuration:duration];
    SKTransition* eight = [SKTransition flipHorizontalWithDuration:duration];
    SKTransition* nine = [SKTransition flipVerticalWithDuration:duration];
    
    [transitions addObject:one];
    [transitions addObject:three];
    [transitions addObject:four];
    [transitions addObject:five];
    [transitions addObject:six];
    [transitions addObject:seven];
    [transitions addObject:eight];
    [transitions addObject:nine];
    
    int rand = arc4random_uniform((unsigned int)[transitions count]);
    return transitions[rand];
}

@end
