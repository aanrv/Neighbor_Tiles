//
//  SettingsScene.m
//  Pattern Matching
//
//  Created by Varan on 11/11/14.
//
//

#import "SettingsScene.h"
#import "SKSwitch.h"
#import "MainMenuScene.h"
#import "SKButton.h"
#import "SKLabelButton.h"

@implementation SettingsScene

- (instancetype) initWithSize:(CGSize)size viewController:(ViewController *)viewController{
    self = [super initWithSize:size backButton:YES homeButton:YES sfxButton:NO musicButton:NO viewController:viewController];
    
    if(self) {
        
        // Determine current status of user preferences
        BOOL se = [[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey];
        BOOL bm = [[NSUserDefaults standardUserDefaults] boolForKey:backgroundMusicKey];
        
        /////////////////////////// ADD SWITCHES ///////////////////////////
        
        // Size of each switch
        CGSize switchSize = CGSizeMake(25.0f, 25.0f);
        
        __weak SettingsScene* weakSelf = self;
        
        // Run this block of code if sound effects is toggled
        SKAction* actionSFX = [SKAction runBlock:^{
            
            //determine current status of the switch (note, this is AFTER the button has been pressed so this value will be the new value to save)
            BOOL b = [weakSelf.toggleSoundEffectsSwitch enabled];
            
            [[NSUserDefaults standardUserDefaults] setBool:b forKey:soundEffectsKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey]) {
                [weakSelf runAction:[SKAction playSoundFileNamed:@"buttonTapSound.wav" waitForCompletion:NO]];
            }
            
        }];
        self.toggleSoundEffectsSwitch = [[SKSwitch alloc] initWithName:@"soundEffectSwitch" size:switchSize enabledImageNamed:@"greenCheck" enabledImageSelectedNamed:@"greenCheckSelected" disabledImageNamed:@"redCross" disabledImageSelectedNamed:@"redCrossSelected" enableFlag:se action:actionSFX soundEffectName:@"buttonTapSound" withExtension:@"wav"];
        
        // Run this block of code if background music is toggled
        SKAction* actionBGMusic = [SKAction runBlock:^{
            
            //determine current status of the switch (note, this is AFTER the button has been pressed so this value will be the new value to save)
            BOOL b = [weakSelf.toggleBackgroundMusicSwitch enabled];
            
            [[NSUserDefaults standardUserDefaults] setBool:(b ? YES : NO) forKey:backgroundMusicKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if(![[NSUserDefaults standardUserDefaults] boolForKey:backgroundMusicKey]) {
                weakSelf.viewController.backgroundMusic.volume = 0.0f;
                weakSelf.viewController.timeRunMusic.volume = 0.0f;
            }else {
                weakSelf.viewController.backgroundMusic.volume = musicVolume;
                weakSelf.viewController.timeRunMusic.volume = musicVolume;
            }
        }];
        self.toggleBackgroundMusicSwitch = [[SKSwitch alloc] initWithName:@"backgroundMusicSwitch" size:switchSize enabledImageNamed:@"greenCheck" enabledImageSelectedNamed:@"greenCheckSelected" disabledImageNamed:@"redCross" disabledImageSelectedNamed:@"redCrossSelected" enableFlag:bm action:actionBGMusic soundEffectName:@"buttonTapSound" withExtension:@"wav"];
        
        // Set switch positions to be at the bottom
        self.toggleSoundEffectsSwitch.position = CGPointMake(self.size.width * 5/6,self.size.height * 12/40);
        self.toggleBackgroundMusicSwitch.position = CGPointMake(self.size.width * 5/6,self.size.height * 9/40);
        
        
        [self addChild:self.toggleSoundEffectsSwitch];
        [self addChild:self.toggleBackgroundMusicSwitch];
        
        ////////////////////// ADD LABELS NEXT TO SWITCHES ///////////////////////
        
        // Text labels to associate with each switch
        NSString* sfx = @"Sound Effects";
        NSString* bgMusic = @"Background Music";
        
        SKLabelNode* soundEffectLabel = [[SKLabelNode alloc] initWithFontNamed:@"Markerfelt-Thin"];
        SKLabelNode* bgMusicLabel = [[SKLabelNode alloc] initWithFontNamed:@"Markerfelt-Thin"];
        
        soundEffectLabel.text = sfx;
        soundEffectLabel.fontSize = 18.0f;
        soundEffectLabel.position = CGPointMake(self.size.width * 1/10,self.toggleSoundEffectsSwitch.position.y);
        soundEffectLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        soundEffectLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [self addChild:soundEffectLabel];
        
        bgMusicLabel.text = bgMusic;
        bgMusicLabel.fontSize = 18.0f;
        bgMusicLabel.position = CGPointMake(self.size.width * 1/10,self.toggleBackgroundMusicSwitch.position.y);
        bgMusicLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        bgMusicLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [self addChild:bgMusicLabel];
        
        ////////////////////////// TILE COLORS /////////////////////////////
        
        SKLabelNode* chooseTileColor = [[SKLabelNode alloc] initWithFontNamed:@"Markerfelt-Thin"];
        chooseTileColor.position = CGPointMake(self.size.width/2, self.size.height * 37/40);
        chooseTileColor.text = @"Change tile color:";
        chooseTileColor.fontSize = 20.0f;
        
        [self addChild:chooseTileColor];
        
        CGSize tileColorButtonSize = CGSizeMake(30.0f, 30.0f);
        
        // 0 - White
        SKAction* actionZero = [SKAction runBlock:^{
            [weakSelf saveTileColor:0];
        }];
        SKButton* chooseWhite = [[SKButton alloc] initWithDefaultTextureNamed:@"whiteTile" selectedTextureNamed:@"whiteTileSelected" disabledTextureNamed:nil disabled:NO name:@"white" action:actionZero soundEffectName:@"resetButtonSound" withExtension:@"wav"];
        chooseWhite.size = tileColorButtonSize;
        chooseWhite.position = CGPointMake(self.size.width * 1/4, self.size.height * 6/10);
        
        [self addChild:chooseWhite];
        
        // 1 - Blue
        SKAction* actionOne = [SKAction runBlock:^{
            [weakSelf saveTileColor:1];
        }];
        SKButton* chooseBlue = [[SKButton alloc] initWithDefaultTextureNamed:@"blueTile" selectedTextureNamed:@"blueTileSelected" disabledTextureNamed:nil disabled:NO name:@"blue" action:actionOne soundEffectName:@"resetButtonSound" withExtension:@"wav"];
        chooseBlue.size = tileColorButtonSize;
        chooseBlue.position = CGPointMake(self.size.width * 2/4, self.size.height * 6/10);
        
        [self addChild:chooseBlue];
        
        // 2 - Yellow
        SKAction* actionTwo = [SKAction runBlock:^{
            [weakSelf saveTileColor:2];
        }];
        SKButton* chooseYellow = [[SKButton alloc] initWithDefaultTextureNamed:@"yellowTile" selectedTextureNamed:@"yellowTileSelected" disabledTextureNamed:nil disabled:NO name:@"yellow" action:actionTwo soundEffectName:@"resetButtonSound" withExtension:@"wav"];
        chooseYellow.size = tileColorButtonSize;
        chooseYellow.position = CGPointMake(self.size.width * 3/4, self.size.height * 6/10);
        
        [self addChild:chooseYellow];
        
        // 3 - Green
        SKAction* actionThree = [SKAction runBlock:^{
            [weakSelf saveTileColor:3];
        }];
        SKButton* chooseGreen = [[SKButton alloc] initWithDefaultTextureNamed:@"greenTile" selectedTextureNamed:@"greenTileSelected" disabledTextureNamed:nil disabled:NO name:@"green" action:actionThree soundEffectName:@"resetButtonSound" withExtension:@"wav"];
        chooseGreen.size = tileColorButtonSize;
        chooseGreen.position = CGPointMake(self.size.width * 1/4, self.size.height * 5/10);
        
        [self addChild:chooseGreen];
        
        // 4 - Cyan
        SKAction* actionFour = [SKAction runBlock:^{
            [weakSelf saveTileColor:4];
        }];
        SKButton* chooseCyan = [[SKButton alloc] initWithDefaultTextureNamed:@"cyanTile" selectedTextureNamed:@"cyanTileSelected" disabledTextureNamed:nil disabled:NO name:@"cyan" action:actionFour soundEffectName:@"resetButtonSound" withExtension:@"wav"];
        chooseCyan.size = tileColorButtonSize;
        chooseCyan.position = CGPointMake(self.size.width * 2/4, self.size.height * 5/10);
        
        [self addChild:chooseCyan];
        
        // 5 - Purple
        SKAction* actionFive = [SKAction runBlock:^{
            [weakSelf saveTileColor:5];
        }];
        SKButton* choosePurple = [[SKButton alloc] initWithDefaultTextureNamed:@"purpleTile" selectedTextureNamed:@"purpleTileSelected" disabledTextureNamed:nil disabled:NO name:@"purple" action:actionFive soundEffectName:@"resetButtonSound" withExtension:@"wav"];
        choosePurple.size = tileColorButtonSize;
        choosePurple.position = CGPointMake(self.size.width * 3/4, self.size.height * 5/10);
        
        [self addChild:choosePurple];
        
        // 6 - Orange
        SKAction* actionSix = [SKAction runBlock:^{
            [weakSelf saveTileColor:6];
        }];
        SKButton* chooseOrange = [[SKButton alloc] initWithDefaultTextureNamed:@"orangeTile" selectedTextureNamed:@"orangeTileSelected" disabledTextureNamed:nil disabled:NO name:@"orange" action:actionSix soundEffectName:@"resetButtonSound" withExtension:@"wav"];
        chooseOrange.size = tileColorButtonSize;
        chooseOrange.position = CGPointMake(self.size.width * 1/4, self.size.height * 4/10);
        
        [self addChild:chooseOrange];
        
        
        // 7 - Magenta
        SKAction* actionSeven = [SKAction runBlock:^{
            [weakSelf saveTileColor:7];
        }];
        SKButton* chooseMagenta = [[SKButton alloc] initWithDefaultTextureNamed:@"magentaTile" selectedTextureNamed:@"magentaTileSelected" disabledTextureNamed:nil disabled:NO name:@"magenta" action:actionSeven soundEffectName:@"resetButtonSound" withExtension:@"wav"];
        chooseMagenta.size = tileColorButtonSize;
        chooseMagenta.position = CGPointMake(self.size.width * 2/4, self.size.height * 4/10);
        
        [self addChild:chooseMagenta];
        
        // 8 - Red
        SKAction* actionEight = [SKAction runBlock:^{
            [weakSelf saveTileColor:8];
        }];
        SKButton* chooseRed = [[SKButton alloc] initWithDefaultTextureNamed:@"redTile" selectedTextureNamed:@"redTileSelected" disabledTextureNamed:nil disabled:NO name:@"red" action:actionEight soundEffectName:@"resetButtonSound" withExtension:@"wav"];
        chooseRed.size = tileColorButtonSize;
        chooseRed.position = CGPointMake(self.size.width * 3/4, self.size.height * 4/10);
        
        [self addChild:chooseRed];
        
        // Add tile that displays the currently chosen tile color
        int wtc = (int)[[NSUserDefaults standardUserDefaults] integerForKey:tileColorKey];
        self.colorDisplayTile = [[TileNode alloc] initWithState:TileStateWhite whiteTileColor:wtc row:0 col:0 size:CGSizeMake(50.0f, 50.0f)];
        self.colorDisplayTile.position = CGPointMake(self.size.width/2, self.size.height * 33/40);
        [self addChild:self.colorDisplayTile];
        
        // if user hits random, a this (a question mark image) is added to color display tile
        self.questionMark = [[SKSpriteNode alloc] initWithImageNamed:@"questionMark"];
        self.questionMark.position = self.colorDisplayTile.position;
        self.questionMark.size = CGSizeMake(self.colorDisplayTile.size.width/2, self.colorDisplayTile.size.height/2);
        
        // If random button is pressed, call enableRandom method
        SKAction* actionChooseRandom = [SKAction runBlock:^{
            [weakSelf enableRandom];
        }];
        self.chooseRandom = [[SKLabelButton alloc] initWithFontNamed:@"Markerfelt-Thin" text:@"Random" defaultColor:[SKColor whiteColor] selectedColor:[self generateRandomColorIncludingWhite:NO] name:@"chooseRandom" action:actionChooseRandom soundEffectName:@"resetButtonSound" withExtension:@"wav"];
        self.chooseRandom.position = CGPointMake(self.size.width / 2, self.size.height * 7/10);
        self.chooseRandom.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        self.chooseRandom.fontSize = 26.0f;
        [self addChild:self.chooseRandom];
        
        // Determine whether display tile is currently random or not
        BOOL randomColorForTile = [[NSUserDefaults standardUserDefaults] boolForKey:makeTileColorRandomKey];
        
        if(randomColorForTile) {
            [self enableRandom];
        }else {
            [self disableRandom];
        }
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:pressedOptionsBeforeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return self;
}

- (void) saveTileColor:(WhiteTileColor)enumKey {
    // Save new key for the current tile color
    [[NSUserDefaults standardUserDefaults] setInteger:enumKey forKey:tileColorKey];
    
    // Disable random when a tile is pressed
    [self disableRandom];
    // Change color of display tile
    [self setColorOfTile:self.colorDisplayTile toColor:enumKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) enableRandom {
    // Enable random tiles
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:makeTileColorRandomKey];
    
    // Gray out color display tile
    self.colorDisplayTile.alpha = 0.2f;
    
    // Only add question mark if it isn't already added
    if(![self.questionMark parent])
        [self addChild:self.questionMark];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) disableRandom {
    // Disable random tiles
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:makeTileColorRandomKey];
    
    // Reset display tile alpha
    self.colorDisplayTile.alpha = 1.0f;
    // Set new color for tile display
    [self setColorOfTile:self.colorDisplayTile toColor:(int)[[NSUserDefaults standardUserDefaults] integerForKey:tileColorKey]];
    
    // Remove from parent if it has a parent
    if([self.questionMark parent])
        [self.questionMark removeFromParent];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) setColorOfTile:(TileNode *)tile toColor:(WhiteTileColor)color {
    tile.whiteTileImageName = [tile.correspondingColoredTileNames objectAtIndex:color];
    tile.whiteTileSelectedImageName = [NSString stringWithFormat:@"%@Selected",tile.whiteTileImageName];
    
    tile.texture = [SKTexture textureWithImage:[UIImage imageNamed:tile.whiteTileImageName]];
}

- (void) goBack {
    [super goBack];
    MainMenuScene* mms = [[MainMenuScene alloc] initWithSize:self.size viewController:self.viewController];
    [self.view presentScene:mms transition:[SKTransition moveInWithDirection:SKTransitionDirectionLeft duration:self.backwardTransitionDuration]];
}

@end
