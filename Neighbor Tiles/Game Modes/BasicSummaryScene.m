//
//  BasicSummaryScene.m
//  Pattern Matching
//
//  Created by Varan on 2/10/15.
//
//

#import "BasicSummaryScene.h"
#import "SKButton.h"

@implementation BasicSummaryScene

- (instancetype) initWithSize:(CGSize)size viewController:(ViewController *)viewController {
    self = [super initWithSize:size backButton:NO homeButton:NO sfxButton:NO musicButton:NO viewController:viewController];
    
    if(self) {
        self.scoreLoc = CGPointMake(CGRectGetMidX(self.frame), self.size.height * 15/20);
        self.bestLoc = CGPointMake(CGRectGetMidX(self.frame), self.size.height * 13/20);
        self.newHighScoreLoc = CGPointMake(self.size.width/2, self.size.height - 75);
        
        self.backLoc = CGPointMake(self.size.width * 8/20, self.size.height * 1/5);
        self.retryLoc = CGPointMake(self.size.width * 12/20, self.size.height * 1/5);
        
        CGSize bigButtonSize = CGSizeMake(40, 40);
        
        self.bigBackButton = [[SKButton alloc] initWithDefaultTextureNamed:@"bigBackButton" selectedTextureNamed:@"bigBackButtonSelected" disabledTextureNamed:nil disabled:NO name:@"bigBackButton" action:nil];
        self.bigBackButton.position = CGPointMake(self.size.width * 8/20, self.size.height * 1/5);
        self.bigBackButton.size = bigButtonSize;
        [self addChild:self.bigBackButton];
        
        self.retryButton = [[SKButton alloc] initWithDefaultTextureNamed:@"retryButton" selectedTextureNamed:@"retryButtonSelected" disabledTextureNamed:nil disabled:NO name:@"retryButton" action:nil];
        self.retryButton.position = CGPointMake(self.size.width * 12/20, self.size.height * 1/5);
        self.retryButton.size = bigButtonSize;
        [self addChild:self.retryButton];
    }
    
    return self;
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
