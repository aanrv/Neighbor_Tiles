//
//  InstructionsSceneTwo.m
//  Pattern Matching
//
//  Created by Varan on 1/1/15.
//
//

#import "InstructionsSceneTwo.h"
#import "InstructionsSceneOne.h"
#import "InstructionsSceneThree.h"

@implementation InstructionsSceneTwo

- (instancetype) initWithSize:(CGSize)size viewController:(ViewController*)viewController{
    self = [super initWithSize:size page:InstructionsPageTwo viewController:viewController];
    
    if(self) {
        
        NSString* lineOne = @"Tap on a tile to change its color.";
        SKLabelNode* lOne = [[SKLabelNode alloc] initWithFontNamed:@"Markerfelt-Thin"];
        lOne.text = lineOne;
        lOne.fontSize = 18.0f;
        lOne.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - 50);
        [self addChild:lOne];
        
        NSString* lineTwo = @"However, this will also change the";
        NSString* lineThree = @"colors of its neighboring tiles!";
        
        SKLabelNode* lTwo = [[SKLabelNode alloc] initWithFontNamed:@"Markerfelt-Thin"];
        lTwo.text = lineTwo;
        lTwo.fontSize = 18.0f;
        lTwo.position = CGPointMake(CGRectGetMidX(self.frame), lOne.position.y - 30);
        [self addChild:lTwo];
        
        SKLabelNode* lThree = [[SKLabelNode alloc] initWithFontNamed:@"Markerfelt-Thin"];
        lThree.text = lineThree;
        lThree.fontSize = 18.0f;
        lThree.position = CGPointMake(CGRectGetMidX(self.frame), lTwo.position.y - 20);
        [self addChild:lThree];
        
        SKSpriteNode* centerArrow = [[SKSpriteNode alloc] initWithImageNamed:@"rightArrow"];
        centerArrow.size = CGSizeMake(35,25);
        centerArrow.position = CGPointMake(self.size.width / 2, self.size.height * 13/20);
        [self addChild:centerArrow];
        
        SKSpriteNode* imgOne = [[SKSpriteNode alloc] initWithImageNamed:@"instructionsImageTwo"];
        imgOne.size = CGSizeMake(self.size.width / 4 + 20, self.size.width / 4 + 20);
        imgOne.position = CGPointMake(self.size.width * 1/4, centerArrow.position.y);
        [self addChild:imgOne];
        
        SKSpriteNode* imgTwo = [[SKSpriteNode alloc] initWithImageNamed:@"instructionsImageThree"];
        imgTwo.size = CGSizeMake(self.size.width / 4 + 20, self.size.width / 4 + 20);
        imgTwo.position = CGPointMake(self.size.width * 3/4, centerArrow.position.y);
        [self addChild:imgTwo];
        
        SKSpriteNode* arrow = [[SKSpriteNode alloc] initWithImageNamed:@"hand"];
        arrow.size = self.handSize;
        arrow.anchorPoint = CGPointMake(0.3f, 1.0f);
        arrow.position = CGPointMake(imgOne.size.width * 1/4 + 8, -imgOne.size.height * 1/4 - 8);
        [imgOne addChild:arrow];
        
        SKSpriteNode* centerArrowTwo = [[SKSpriteNode alloc] initWithImageNamed:@"rightArrow"];
        centerArrowTwo.size = centerArrow.size;
        centerArrowTwo.position = CGPointMake(centerArrow.position.x, self.size.height * 7/20);
        [self addChild:centerArrowTwo];
        
        SKSpriteNode* imgSix = [[SKSpriteNode alloc] initWithImageNamed:@"instructionsImageSix"];
        imgSix.size = imgOne.size;
        imgSix.position = CGPointMake(imgOne.position.x, centerArrowTwo.position.y);
        [self addChild:imgSix];
        
        SKSpriteNode* imgSeven = [[SKSpriteNode alloc] initWithImageNamed:@"instructionsImageSeven"];
        imgSeven.size = imgTwo.size;
        imgSeven.position = CGPointMake(imgTwo.position.x, centerArrowTwo.position.y);
        [self addChild:imgSeven];
        
        SKSpriteNode* handTwo = [[SKSpriteNode alloc] initWithImageNamed:@"hand"];
        handTwo.size = self.handSize;
        handTwo.position = CGPointMake(-imgSix.size.width * 2/100, imgSix.size.height * 1/6 - imgSix.size.height/2);
        handTwo.anchorPoint = arrow.anchorPoint;
        [imgSix addChild:handTwo];
    }
    
    return self;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    SKNode* node = [self nodeWithinRadius:tapRadius OfPoint:loc];
    
    if(!([[node name] isEqualToString:@"homeButton"] || [[node name] isEqualToString:@"backButton"])) {
        InstructionsSceneThree* next = [[InstructionsSceneThree alloc] initWithSize:self.size viewController:self.viewController];
        [self.view presentScene:next];
    }
}

- (void) goBack {
    InstructionsSceneOne* back = [[InstructionsSceneOne alloc] initWithSize:self.size viewController:self.viewController];
    [self.view presentScene:back];
}

@end
