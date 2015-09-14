//
//  AboutScene.m
//  Pattern Matching
//
//  Created by Varan on 2/5/15.
//
//

#import "CreditsScene.h"
#import "OtherScene.h"

@implementation CreditsScene

- (instancetype) initWithSize:(CGSize)size viewController:(ViewController *)viewController {
    self = [super initWithSize:size backButton:YES homeButton:YES sfxButton:NO musicButton:NO viewController:viewController];
    
    if(self) {
        NSString* title = [NSString stringWithFormat:@"%@ v%@",gameName,gameVersion];
        SKLabelNode* titleNode = [[SKLabelNode alloc] initWithFontNamed:@"Times New Roman"];
        titleNode.text = title;
        titleNode.position = CGPointMake(self.size.width/2, self.size.height * 37/40);
        titleNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        titleNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        titleNode.fontSize = 25.0f;
        titleNode.fontColor = [SKColor cyanColor];
        [self addChild:titleNode];
        
        SKLabelNode* createdBy = [[SKLabelNode alloc] initWithFontNamed:@"Times New Roman"];
        createdBy.text = @"Created by:";
        createdBy.position = CGPointMake(self.size.width/2, self.size.height * 16/20);
        createdBy.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        createdBy.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        createdBy.fontSize = 24.0f;
        createdBy.fontColor = [SKColor greenColor];
        [self addChild:createdBy];
        
        SKLabelNode* varanSharma = [[SKLabelNode alloc] initWithFontNamed:@"Times New Roman"];
        varanSharma.text = @"Varan Sharma";
        varanSharma.position = CGPointMake(self.size.width/2, self.size.height * 15/20);
        varanSharma.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        varanSharma.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        varanSharma.fontSize = 22.0f;
        varanSharma.fontColor = [SKColor whiteColor];
        [self addChild:varanSharma];
        
        SKLabelNode* email = [[SKLabelNode alloc] initWithFontNamed:@"Times New Roman"];
        email.text = emailName;
        email.position = CGPointMake(self.size.width/2, self.size.height * 14/20);
        email.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        email.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        email.fontSize = createdBy.fontSize * 3/5;
        email.fontColor = [SKColor whiteColor];
        [self addChild:email];
        
        SKLabelNode* musicBy = [[SKLabelNode alloc] initWithFontNamed:@"Times New Roman"];
        musicBy.text = @"Music:";
        musicBy.position = CGPointMake(self.size.width/2, self.size.height * 12/20);
        musicBy.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        musicBy.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        musicBy.fontSize = 20.0f;
        musicBy.fontColor = [SKColor magentaColor];
        [self addChild:musicBy];
        
        SKLabelNode* musicLineOne = [[SKLabelNode alloc] initWithFontNamed:@"Times New Roman"];
        musicLineOne.text = @"\"Ambler\", \"Move Forward\"";
        musicLineOne.position = CGPointMake(self.size.width/2, self.size.height * 22/40);
        musicLineOne.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        musicLineOne.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        musicLineOne.fontSize = 14.0f;
        musicLineOne.fontColor = [SKColor whiteColor];
        [self addChild:musicLineOne];
        
        SKLabelNode* musicLineTwo = [[SKLabelNode alloc] initWithFontNamed:@"Times New Roman"];
        musicLineTwo.text = @"Kevin MacLeod (incompetech.com)";
        musicLineTwo.position = CGPointMake(self.size.width/2, self.size.height * 21/40);
        musicLineTwo.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        musicLineTwo.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        musicLineTwo.fontSize = 14.0f;
        musicLineTwo.fontColor = [SKColor whiteColor];
        [self addChild:musicLineTwo];
        
        SKLabelNode* musicLineThree = [[SKLabelNode alloc] initWithFontNamed:@"Times New Roman"];
        musicLineThree.text = @"Licensed under Creative Commons: By Attribution 3.0";
        musicLineThree.position = CGPointMake(self.size.width/2, self.size.height * 20/40);
        musicLineThree.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        musicLineThree.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        musicLineThree.fontSize = 14.0f;
        musicLineThree.fontColor = [SKColor whiteColor];
        [self addChild:musicLineThree];
        
        SKLabelNode* musicLineFour = [[SKLabelNode alloc] initWithFontNamed:@"Times New Roman"];
        musicLineFour.text = @"http://creativecommons.org/licenses/by/3.0/";
        musicLineFour.position = CGPointMake(self.size.width/2, self.size.height * 19/40);
        musicLineFour.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        musicLineFour.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        musicLineFour.fontSize = 14.0f;
        musicLineFour.fontColor = [SKColor whiteColor];
        [self addChild:musicLineFour];
        
        SKLabelNode* tileLineOne = [[SKLabelNode alloc] initWithFontNamed:@"Times New Roman"];
        tileLineOne.text = @"Tile sound effect from http://www.freesfx.co.uk";
        tileLineOne.position = CGPointMake(self.size.width/2, self.size.height * 17/40);
        tileLineOne.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        tileLineOne.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        tileLineOne.fontSize = 14.0f;
        tileLineOne.fontColor = [SKColor whiteColor];
        [self addChild:tileLineOne];
    }
    
    return self;
}

- (void) goBack {
    [super goBack];
    OtherScene* back = [[OtherScene alloc] initWithSize:self.size viewController:self.viewController];
    [self.view presentScene:back transition:self.sceneTransitionAnimation];
}

@end
