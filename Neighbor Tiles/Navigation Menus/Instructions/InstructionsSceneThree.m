//
//  InstructionsSceneThree.m
//  Pattern Matching
//
//  Created by Varan on 1/1/15.
//
//

#import "InstructionsSceneThree.h"
#import "InstructionsSceneTwo.h"
#import "MainMenuScene.h"

@implementation InstructionsSceneThree

- (instancetype) initWithSize:(CGSize)size viewController:(ViewController *)viewController{
    self = [super initWithSize:size page:InstructionsPageThree viewController:viewController];
    
    if(self) {
        
        NSString* lineOne = @"Make all tiles black";
        
        SKLabelNode* lOne = [[SKLabelNode alloc] initWithFontNamed:@"Markerfelt-Thin"];
        lOne.text = lineOne;
        lOne.fontSize = 18.0f;
        lOne.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - 60);
        [self addChild:lOne];
        
        NSString* lineTwo = @"to solve the puzzle!";
        
        SKLabelNode* lTwo = [[SKLabelNode alloc] initWithFontNamed:@"Markerfelt-Thin"];
        lTwo.text = lineTwo;
        lTwo.fontSize = 18.0f;
        lTwo.position = CGPointMake(CGRectGetMidX(self.frame), lOne.position.y - 20);
        [self addChild:lTwo];
        
        SKSpriteNode* centerArrow = [[SKSpriteNode alloc] initWithImageNamed:@"rightArrow"];
        centerArrow.size = CGSizeMake(35.0f,25.0f);
        centerArrow.position = CGPointMake(self.size.width / 2, self.size.height * 6/10);
        [self addChild:centerArrow];
        
        SKSpriteNode* imgOne = [[SKSpriteNode alloc] initWithImageNamed:@"instructionsImageFour"];
        imgOne.size = CGSizeMake(self.size.width / 4 + 20, self.size.width / 4 + 20);
        imgOne.position = CGPointMake(self.size.width * 1/4, centerArrow.position.y);
        imgOne.anchorPoint = CGPointMake(0.5f, 0.5f);
        [self addChild:imgOne];
        
        SKSpriteNode* arrow = [[SKSpriteNode alloc] initWithImageNamed:@"hand"];
        arrow.size = self.handSize;
        arrow.anchorPoint = CGPointMake(0.3f, 1.0f);
        arrow.position = CGPointMake(imgOne.size.width * 1/4 + 5, 0.0f);
        [imgOne addChild:arrow];
        
        SKSpriteNode* imgTwo = [[SKSpriteNode alloc] initWithImageNamed:@"instructionsImageFive"];
        imgTwo.size = CGSizeMake(self.size.width / 4 + 20, self.size.width / 4 + 20);
        imgTwo.position = CGPointMake(self.size.width * 3/4, imgOne.position.y);
        imgTwo.alpha = 0.7;
        [self addChild:imgTwo];
        
        SKSpriteNode* check = [[SKSpriteNode alloc] initWithImageNamed:@"check"];
        check.size = imgTwo.size;
        check.position = imgTwo.position;
        check.anchorPoint = imgTwo.anchorPoint;
        check.alpha = 0.5;
        [self addChild:check];
        
        ////////////////////////////
        
        SKLabelNode* standard = [[SKLabelNode alloc] initWithFontNamed:@"Markerfelt-thin"];
        standard.text = @"Sharpen your skills with \"Standard\".";
        standard.position = CGPointMake(self.size.width/2, (self.homeResetButtonLoc.y + imgTwo.position.y) / 2);
        standard.fontSize = lTwo.fontSize;
        standard.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addChild:standard];
        
        SKLabelNode* survival = [[SKLabelNode alloc] initWithFontNamed:@"Markerfelt-thin"];
        survival.text = @"Put them to the test in \"Survival\"!";
        survival.position = CGPointMake(self.size.width/2, standard.position.y - 20);
        survival.fontSize = standard.fontSize;
        survival.verticalAlignmentMode = standard.verticalAlignmentMode;
        [self addChild:survival];
        
        /////////////////////////////
        
        float distanceFromEdges = 20.0f;
        
        SKShapeNode* topLine = [SKShapeNode node];
        CGMutablePathRef pathToDrawTop = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDrawTop, NULL, self.size.width - distanceFromEdges,standard.position.y + distanceFromEdges);
        CGPathAddLineToPoint(pathToDrawTop, NULL, distanceFromEdges, standard.position.y + distanceFromEdges);
        topLine.path = pathToDrawTop;
        [topLine setStrokeColor:[SKColor greenColor]];
        [self addChild:topLine];
        
        SKShapeNode* bottomLine = [SKShapeNode node];
        CGMutablePathRef pathToDrawBottom = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDrawBottom, NULL, self.size.width - distanceFromEdges,survival.position.y - distanceFromEdges);
        CGPathAddLineToPoint(pathToDrawBottom, NULL, distanceFromEdges,survival.position.y - distanceFromEdges);
        bottomLine.path = pathToDrawBottom;
        [bottomLine setStrokeColor:[topLine strokeColor]];
        [self addChild:bottomLine];
        
        SKShapeNode* leftLine = [SKShapeNode node];
        CGMutablePathRef leftPath = CGPathCreateMutable();
        CGPathMoveToPoint(leftPath, NULL, distanceFromEdges, standard.position.y + distanceFromEdges);
        CGPathAddLineToPoint(leftPath, NULL, distanceFromEdges, survival.position.y - distanceFromEdges);
        leftLine.path = leftPath;
        [leftLine setStrokeColor:bottomLine.strokeColor];
        [self addChild:leftLine];
        
        SKShapeNode* rightLine = [SKShapeNode node];
        CGMutablePathRef rightPath = CGPathCreateMutable();
        CGPathMoveToPoint(rightPath, NULL, self.size.width - distanceFromEdges, standard.position.y + distanceFromEdges);
        CGPathAddLineToPoint(rightPath, NULL, self.size.width - distanceFromEdges, survival.position.y - distanceFromEdges);
        rightLine.path = rightPath;
        [rightLine setStrokeColor:leftLine.strokeColor];
        [self addChild:rightLine];
    }
    
    return self;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    SKNode* node = [self nodeWithinRadius:tapRadius OfPoint:loc];
    
    if(!([[node name] isEqualToString:@"homeButton"] || [[node name] isEqualToString:@"backButton"])) {
        MainMenuScene* next = [[MainMenuScene alloc] initWithSize:self.size viewController:self.viewController];
        [self.view presentScene:next];
    }
    
}

- (void) goBack {
    [super goBack];
    InstructionsSceneTwo* back = [[InstructionsSceneTwo alloc] initWithSize:self.size viewController:self.viewController];
    [self.view presentScene:back];
}

@end
