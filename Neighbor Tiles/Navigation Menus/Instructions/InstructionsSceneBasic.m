//
//  InstructionsSceneBasic.m
//  Pattern Matching
//
//  Created by Varan on 1/12/15.
//
//

#import "InstructionsSceneBasic.h"

@implementation InstructionsSceneBasic

- (instancetype) initWithSize:(CGSize)size page:(InstructionsPage)p viewController:(ViewController *)viewController{
    self = [super initWithSize:size backButton:YES homeButton:YES sfxButton:NO musicButton:NO viewController:viewController];
    
    if(self) {
        
        self.handSize = CGSizeMake(45.0f,54.0f);
        
        // Location of page indicator at bottom (three dots)
        CGPoint pageIndicatorLocation = CGPointMake(self.size.width/2, self.homeResetButtonLoc.y + 40);
        
        NSString* pageIndicatorName;
        
        // Determine which page indicator mage to display
        switch (p) {
            case InstructionsPageOne:
                pageIndicatorName = @"pageIndicatorFirst";
                break;
            case InstructionsPageTwo:
                pageIndicatorName = @"pageIndicatorSecond";
                break;
            default:
                pageIndicatorName = @"pageIndicatorThird";
                break;
        }
        
        SKSpriteNode* indicatorNode = [[SKSpriteNode alloc] initWithImageNamed:pageIndicatorName];
        indicatorNode.position = pageIndicatorLocation;
        // preserve 60x20 ration
        indicatorNode.size = CGSizeMake(60 * 0.8f, 20 * 0.8f);
        [self addChild:indicatorNode];
    }
    
    return self;
}

@end
