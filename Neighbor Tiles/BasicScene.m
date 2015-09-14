//
//  BasicScene.m
//  Pattern Matching
//
//  Created by Varan on 1/10/15.
//
//

#import "BasicScene.h"
#import "MainMenuScene.h"
#import "SKButton.h"
#import "SKSwitch.h"
#import "SKLabelButton.h"
#import "TileNode.h"
#import "LevelButtonNode.h"

@implementation BasicScene

- (instancetype)initWithSize:(CGSize)size backButton:(BOOL)bb homeButton:(BOOL)hb sfxButton:(BOOL)sfxb musicButton:(BOOL)mb viewController:(ViewController *)viewController{
    self = [super initWithSize:size];
    
    if(self) {
        self.viewController = viewController;
        
        self.backgroundColor = [SKColor blackColor];
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:makeTileColorRandomKey]) {
            self.selectedColor = [self generateRandomColorIncludingWhite:NO];
        }else if([[NSUserDefaults standardUserDefaults] integerForKey:tileColorKey] == WhiteTileColorWhite) {
            self.selectedColor = [SKColor grayColor];
        }else {
            NSArray* correspondingColoredTileNames = @[[SKColor whiteColor],[SKColor blueColor],[SKColor yellowColor],[SKColor greenColor],[SKColor cyanColor],[SKColor purpleColor],[SKColor orangeColor],[SKColor magentaColor],[SKColor redColor]];
            
            self.selectedColor = [correspondingColoredTileNames objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:tileColorKey]];
        }
        
        [self addRandomTilesToBackground:5];
        
        __weak BasicScene* weakSelf = self;
        
        id waitOneSecond = [SKAction waitForDuration:1.0f];
        id addFiveRandomTiles = [SKAction runBlock:^{
            [weakSelf addRandomTilesToBackground:5];
        }];
        
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[waitOneSecond,addFiveRandomTiles]]]];
        
        self.buttonSize = CGSizeMake(30.0f, 30.0f);
        
        self.sceneTransitionAnimation = [SKTransition fadeWithDuration:0.4f];
        
        /*
        // if something has not been purchased, move back and home button up
        if([[NSUserDefaults standardUserDefaults] boolForKey:showAdsKey]) {
            NSLog(@"Show ads.");
            self.homeResetButtonLoc = CGPointMake(self.size.width * 24/40, self.size.height * 3/20);
        }else {
            NSLog(@"Don't show ads.");
            self.homeResetButtonLoc = CGPointMake(self.size.width * 24/40, self.size.height * 1.30f/20);
        }
         */
        
        [self refreshHomeButtonLoc];
        
        if(bb) {
            SKAction* goBackAction = [SKAction runBlock:^{
                [weakSelf goBack];
            }];
            self.backButton = [[SKButton alloc] initWithDefaultTextureNamed:@"backButton" selectedTextureNamed:@"backButtonSelected" disabledTextureNamed:nil disabled:NO name:@"backButton" action:goBackAction soundEffectName:@"backButtonSound" withExtension:@"wav"];
            
            //backButtonPos is dependant on homeResetButtonLoc, they will be equidistant from center x and the y values will be the same
            CGPoint backButtonPos = CGPointMake(self.size.width/2 - (self.homeResetButtonLoc.x - self.size.width/2), self.homeResetButtonLoc.y);
            
            self.backButton.size = self.buttonSize;
            self.backButton.position = backButtonPos;
            [self addChild:self.backButton];
        }
        
        if(hb) {
            SKAction* a = [SKAction runBlock:^{
                [weakSelf goHome];
            }];
            self.homeButton = [[SKButton alloc] initWithDefaultTextureNamed:@"homeButton" selectedTextureNamed:@"homeButtonSelected" disabledTextureNamed:nil disabled:NO name:@"homeButton" action:a soundEffectName:@"homeButtonSound" withExtension:@"wav"];
            self.homeButton.size = self.buttonSize;
            self.homeButton.position = self.homeResetButtonLoc;
            
            [self addChild:self.homeButton];
        }
        
        if(sfxb) {
            SKAction* actionSoundEffectSwitch = [SKAction runBlock:^{
                [[NSUserDefaults standardUserDefaults] setBool:weakSelf.soundEffectSwitch.enabled forKey:soundEffectsKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // Only for sfx switch. This makes sure the sfx plays after the button settings have been changed
                if([[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey]) {
                    [weakSelf runAction:[SKAction playSoundFileNamed:@"buttonTapSound.wav" waitForCompletion:NO]];
                }
            }];
            self.soundEffectSwitch = [[SKSwitch alloc] initWithName:@"soundEffectButton" size:self.buttonSize enabledImageNamed:@"soundEffectButton" enabledImageSelectedNamed:@"soundEffectButtonSelected" disabledImageNamed:@"soundEffectButtonOff" disabledImageSelectedNamed:@"soundEffectButtonOffSelected" enableFlag:[[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey] action:actionSoundEffectSwitch soundEffectName:@"buttonTapSound" withExtension:@"wav"];
            self.soundEffectSwitch.position = CGPointMake(self.size.width * 16/18, self.size.height * 11/12);
            self.soundEffectSwitch.size = self.buttonSize;
            
            [self addChild:self.soundEffectSwitch];
        }
        
        if(mb) {
            SKAction* actionMusicSwitch = [SKAction runBlock:^{
                [[NSUserDefaults standardUserDefaults] setBool:weakSelf.musicSwitch.enabled forKey:backgroundMusicKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if(![[NSUserDefaults standardUserDefaults] boolForKey:backgroundMusicKey]) {
                    weakSelf.viewController.backgroundMusic.volume = 0.0f;
                    weakSelf.viewController.timeRunMusic.volume = 0.0f;
                }else {
                    weakSelf.viewController.backgroundMusic.volume = musicVolume;
                    weakSelf.viewController.timeRunMusic.volume = musicVolume;
                }
            }];
            self.musicSwitch = [[SKSwitch alloc] initWithName:@"musicButton" size:self.buttonSize enabledImageNamed:@"musicButton" enabledImageSelectedNamed:@"musicButtonSelected" disabledImageNamed:@"musicButtonOff" disabledImageSelectedNamed:@"musicButtonOffSelected" enableFlag:[[NSUserDefaults standardUserDefaults] boolForKey:backgroundMusicKey] action:actionMusicSwitch soundEffectName:@"buttonTapSound" withExtension:@"wav"];
            self.musicSwitch.position = CGPointMake(self.size.width * 27/36, self.size.height * 11/12);
            self.musicSwitch.size = self.buttonSize;
            
            [self addChild:self.musicSwitch];
            
            self.forwardTransitionDuration = 0.1;
            self.backwardTransitionDuration = 0.1;
            self.randomTransitionDuration = 0.2;
        }
    }
    
    return self;
}

// The touches methods in BasicScene are were not necessary, but were overridden for a more comfortable UI. This way, when the user's touch moves from a scene to a button, the button will become selected.  If touches was only handled in each individual button, then this would not work.
// Also, if the touch event moves between two nodes of different types, (say SKButton to SKLabelNode), the next node would generally not become selected.  This allows movement between nodes of different classes.  This is not the canonical way but I wanted to try it out anyway.
// userInteractionEnabled = NO in SKButton, SKLabelButton, and SKSwitch. Although it is only necessary for touchesMoved to be handled by BasicScene for the UI feel described above, touchesBegan and touchesEnded are also handled in BasicScene for consistency. Otherwise having userInteractionEnabled = YES but touches also being handled by parent class may cause issues.
// tldr version - Touch events are handled by parent of button nodes (BasicScene) for a more comfortable and flexible UI.

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    SKNode* node = [self nodeWithinRadius:tapRadius OfPoint:loc];
    
    //each touches method will be called in the child's class, this is not necessary for touches begi
    if([node isKindOfClass:[SKButton class]]) {
        SKButton* b = (SKButton*)node;
        [b touchesBegan:touches withEvent:event];
    }else if([node isKindOfClass:[SKLabelButton class]]) {
        SKLabelButton* b = (SKLabelButton*)node;
        [b touchesBegan:touches withEvent:event];
    }else if([node isKindOfClass:[SKSwitch class]]) {
        SKSwitch* s = (SKSwitch*)node;
        [s touchesBegan:touches withEvent:event];
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    SKNode* node = [self nodeWithinRadius:tapRadius OfPoint:loc];
    
    //if touched has moved to a non SKButton node, then deselect all SKButton, SKLabelButton, and SKSwitch children
    for(SKNode* n in [self children]) {
        if([n isKindOfClass:[SKButton class]]) {
            
            SKButton* b = (SKButton*)n;
            [b setToDefault];
        }
    }
    
    for(SKNode* n in [self children]) {
        if([n isKindOfClass:[SKLabelButton class]]) {
            SKLabelButton* b = (SKLabelButton*)n;
            [b setToDefault];
        }
    }
    
    for(SKNode* n in [self children]) {
        if([n isKindOfClass:[SKSwitch class]]) {
            SKSwitch* b = (SKSwitch*)n;
            [b setToDefault];
        }
    }
    
    if([node isKindOfClass:[SKButton class]]) {
        SKButton* b = (SKButton*)node;
        [b touchesMoved:touches withEvent:event];
    }else if([node isKindOfClass:[SKLabelButton class]]) {
        SKLabelButton* b = (SKLabelButton*)node;
        [b touchesMoved:touches withEvent:event];
    }else if([node isKindOfClass:[SKSwitch class]]) {
        SKSwitch* s = (SKSwitch*)node;
        [s touchesMoved:touches withEvent:event];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    SKNode* node = [self nodeWithinRadius:tapRadius OfPoint:loc];
    
    //if node is skbutton or sklabelbutton or skswitch, go to touchesended of node class, this creates a better ui feel, just trust me future Varan
    if([node isKindOfClass:[SKButton class]]) {
        SKButton* b = (SKButton*)node;
        [b touchesEnded:touches withEvent:event];
    }else if([node isKindOfClass:[SKLabelButton class]]) {
        SKLabelButton* b = (SKLabelButton*)node;
        [b touchesEnded:touches withEvent:event];
    }else if([node isKindOfClass:[SKSwitch class]]) {
        SKSwitch* s = (SKSwitch*)node;
        [s touchesEnded:touches withEvent:event];
    }
    
    //if touched has moved to a non SKButton node, then deselect all SKButton, SKLabelButton, and SKSwitch children, this is for the rare case where touches ends and one of the below remain selected
    for(SKNode* n in [self children]) {
        if([n isKindOfClass:[SKButton class]]) {
            SKButton* b = (SKButton*)n;
            [b setToDefault];
        }
    }
    
    for(SKNode* n in [self children]) {
        if([n isKindOfClass:[SKLabelButton class]]) {
            SKLabelButton* b = (SKLabelButton*)n;
            [b setToDefault];
        }
    }
    
    for(SKNode* n in [self children]) {
        if([n isKindOfClass:[SKSwitch class]]) {
            SKSwitch* b = (SKSwitch*)n;
            [b setToDefault];
        }
    }
}

- (SKNode*) nodeWithinRadius:(float) radius OfPoint:(CGPoint) loc {
    
    SKNode* nodeAtCurrentPoint = [self nodeAtPoint:loc];
    if([nodeAtCurrentPoint isKindOfClass:[SKButton class]] ||
       [nodeAtCurrentPoint isKindOfClass:[SKLabelButton class]] ||
       [nodeAtCurrentPoint isKindOfClass:[SKSwitch class]] ||
       [nodeAtCurrentPoint isKindOfClass:[LevelButtonNode class]]) {
        return nodeAtCurrentPoint;
    }
    
    // used to calculate the node with the smallest distance
    float smallestDistance = radius;
    
    SKNode* closestNode = nil;
    
    for(SKNode* n in [self children]) {
        
        float currentNodeDistanceFromLoc = sqrtf(powf(fabs(loc.x - n.position.x),2) +
                                                 powf(fabs(loc.y - n.position.y),2));
        
        if(n.zPosition >= 0 &&
           currentNodeDistanceFromLoc <= radius &&
           currentNodeDistanceFromLoc < smallestDistance) {
            smallestDistance = currentNodeDistanceFromLoc;
            closestNode = n;
        }
    }
    
    return closestNode;
}

- (void) addRandomTilesToBackground:(unsigned int) numTiles {
    //int numTiles = (int)[numberOfTiles integerValue];
    
    if(numTiles > 0) {
        NSArray* tileImages = @[@"blackTile",@"blueTile",@"cyanTile",@"greenTile",@"magentaTile",@"orangeTile",@"purpleTile",@"redTile",@"whiteTile",@"yellowTile"];
        
        NSString* img = [tileImages objectAtIndex:(arc4random_uniform((unsigned int)[tileImages count]))];
        
        SKSpriteNode* tile = [[SKSpriteNode alloc] initWithImageNamed:img];
        
        unsigned int tileSideSize = arc4random_uniform(31) + 20;
        int tilePositionX = arc4random_uniform((unsigned int)(self.size.width * 7/8));
        int tilePositionY = arc4random_uniform((unsigned int)(self.size.height * 7/8));
        
        tile.size = CGSizeMake(tileSideSize, tileSideSize);
        tile.position = CGPointMake(tilePositionX, tilePositionY);
        tile.alpha = 0.0f;
        
        //this is so larger tiles appear on top of smaller tiles, the -00 is just to make the number more negative to keep it behind tilesGrid and in case I have to add a node with a zPosition in between tile.zPosition and 0 in the near future
        tile.zPosition = -1.0f/tileSideSize - 100;
        //NSAssert(tile.zPosition < -10.0f, @"BasicScene: tile zposition should be less than -10 (tilesGrid z position");
        
        int speedX = arc4random_uniform(50) + 50;
        int speedY = arc4random_uniform(50) + 50;
        
        speedX = arc4random_uniform(2) ? speedX : -speedX;
        speedY = arc4random_uniform(2) ? speedY : -speedY;
        
        SKAction* fadeIn = [SKAction fadeAlphaTo:0.5f duration:2.0f];
        
        float rotateDur = (arc4random_uniform(150) + 150) * 1.0f/100;
        
        SKAction* rotate = [SKAction rotateByAngle:-M_PI duration:rotateDur];
        SKAction* move = [SKAction moveByX:speedX y:speedY duration:(arc4random_uniform(1) + 1)];
        
        [tile runAction:[SKAction repeatActionForever:rotate]];
        [tile runAction:[SKAction repeatActionForever:move]];
        [tile runAction:fadeIn];
        
        [self addChild:tile];
        
        if(numTiles > 0) {
            [self addRandomTilesToBackground:numTiles-1];
        }
    }
}

- (SKColor*) generateRandomColorIncludingWhite:(BOOL)w{
    SKColor* white = [SKColor whiteColor];
    SKColor* blue = [SKColor blueColor];
    SKColor* yellow = [SKColor yellowColor];
    SKColor* green = [SKColor greenColor];
    SKColor* cyan = [SKColor cyanColor];
    SKColor* magenta = [SKColor magentaColor];
    SKColor* orange = [SKColor orangeColor];
    SKColor* purple = [SKColor purpleColor];
    SKColor* red = [SKColor redColor];
    
    
    NSMutableArray* colors = [[NSMutableArray alloc] initWithArray:@[blue, yellow, green, cyan, magenta, orange, purple, red]];
    
    if(w)
        [colors addObject:white];
    
    return [colors objectAtIndex:(arc4random_uniform((unsigned int)[colors count]))];
}

- (void) dealloc {
    NSLog(@"Dealloc: %@",[self class]);
}

- (void) goBack {
    //NSAssert(NO,@"BasicScene: goBack method must be overrided in all scenes with a back button.");
}

- (void) goHome {
    MainMenuScene* home = [[MainMenuScene alloc] initWithSize:self.size viewController:self.viewController];
    [self.view presentScene:home transition:self.sceneTransitionAnimation];
}

- (void) refreshHomeButtonLoc {
    // remove NO to enable ads
    if([[NSUserDefaults standardUserDefaults] boolForKey:showAdsKey] && NO) {
        self.homeResetButtonLoc = CGPointMake(self.size.width * 24/40, self.size.height * 3.0f/20);
    }else {
        self.homeResetButtonLoc = CGPointMake(self.size.width * 24/40, self.size.height * 1.30f/20);
    }
    
    self.homeButton.position = CGPointMake(self.homeButton.position.x, self.homeResetButtonLoc.y);
    self.backButton.position = CGPointMake(self.backButton.position.x, self.homeResetButtonLoc.y);
    
}

@end
