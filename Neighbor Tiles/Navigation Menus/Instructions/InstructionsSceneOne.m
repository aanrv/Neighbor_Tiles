//
//  InstructionsSceneOne.m
//  Pattern Matching
//
//  Created by Varan on 9/6/14.
//
//

#import "InstructionsSceneOne.h"
#import "InstructionsSceneTwo.h"
#import "MainMenuScene.h"

@implementation InstructionsSceneOne

- (instancetype) initWithSize:(CGSize)size viewController:(ViewController *)viewController{
    self = [super initWithSize:size page:InstructionsPageOne viewController:viewController];
    
    if(self) {
        NSString* instructions = @"How To Play";
        SKLabelNode* instructLab = [[SKLabelNode alloc] initWithFontNamed:@"Markerfelt-thin"];
        instructLab.position = CGPointMake(self.size.width/2, self.size.height - 65);
        instructLab.text = instructions;
        instructLab.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
        [self addChild:instructLab];
        
        /*
        float distanceFromEdges = 120.0f;
        SKShapeNode* line = [SKShapeNode node];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, self.size.width - distanceFromEdges, instructLab.position.y - 10);
        CGPathAddLineToPoint(path, NULL, distanceFromEdges, instructLab.position.y - 10);
        line.path = path;
        [line setStrokeColor:instructLab.fontColor];
        [self addChild:line];
         */
        
        NSString* lineOne = @"Each tile is either black or white.";
        SKLabelNode* lOne = [[SKLabelNode alloc] initWithFontNamed:@"Markerfelt-Thin"];
        lOne.text = lineOne;
        lOne.fontSize = 18.0f;
        lOne.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 130);
        [self addChild:lOne];
        
        SKSpriteNode* imgOne = [[SKSpriteNode alloc] initWithImageNamed:@"instructionsImageOne"];
        float cSize = 100;
        imgOne.size = CGSizeMake(self.size.height / 2 - cSize, self.size.height / 2 - cSize);
        imgOne.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 10);
        imgOne.anchorPoint = CGPointMake(0.5f, 0.5f);
        [self addChild:imgOne];
        
        /*
        SKLabelNode* lineTwo = [[SKLabelNode alloc] initWithFontNamed:@"Markerfelt-Thin"];
        lineTwo.text = @"(You may customize colors in \"Options\")";
        lineTwo.fontSize = 18.0f;
        lineTwo.position = CGPointMake(CGRectGetMidX(self.frame), lOne.position.y - 25);
        [self addChild:lineTwo];
         */
        
    }
    return self;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    SKNode* node = [self nodeWithinRadius:tapRadius OfPoint:loc];
    
    // To prevent from presenting next scene when home button or back button is pressed
    if(!([[node name] isEqualToString:@"homeButton"] || [[node name] isEqualToString:@"backButton"])) {
        InstructionsSceneTwo* next = [[InstructionsSceneTwo alloc] initWithSize:self.size viewController:self.viewController] ;
        [self.view presentScene:next];
    }
}

- (void) goBack {
    [super goBack];
    MainMenuScene* back = [[MainMenuScene alloc] initWithSize:self.size viewController:self.viewController];
    [self.view presentScene:back transition:[SKTransition moveInWithDirection:(SKTransitionDirectionLeft) duration:self.backwardTransitionDuration]];
}

@end
