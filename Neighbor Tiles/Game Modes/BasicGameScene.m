//
//  BasicGameScene.m
//  Pattern Matching
//
//  Created by Varan on 7/15/14.
//
//

#import "BasicGameScene.h"
#import "SKButton.h"
#import "SKSwitch.h"
#import "SKLabelButton.h"

#define INT(x) [NSNumber numberWithInt:x]

@implementation BasicGameScene

- (instancetype) initWithSize:(CGSize)size levelNumber:(int)levelNumber startingLayout:(NSArray *)startingLayout viewController:(ViewController *)viewController {
    
    self = [super initWithSize:size backButton:YES homeButton:NO sfxButton:YES musicButton:YES viewController:viewController];
    
    if(self) {
        self.rows = (int)[startingLayout count];
        self.columns = (int)[[startingLayout objectAtIndex:0] count];
        self.levelNumber = levelNumber;
        self.movesMade = 0;
        self.startingLayout = startingLayout;
        
        // Solutions for 3x3 and 4x4
        
        NSArray* solThree =  @[@[INT(0),INT(0),INT(0)],
                               @[INT(0),INT(0),INT(0)],
                               @[INT(0),INT(0),INT(0)]];
        
        NSArray* solFour = @[@[INT(0),INT(0),INT(0),INT(0)],
                             @[INT(0),INT(0),INT(0),INT(0)],
                             @[INT(0),INT(0),INT(0),INT(0)],
                             @[INT(0),INT(0),INT(0),INT(0)]];
        
        if(self.rows == 3 && self.columns == 3) {
            self.solutions = solThree;
        }else if(self.rows == 4 && self.columns == 4) {
            self.solutions = solFour;
        }else {
            //NSAssert(NO,@"5 rows and/or columns not allowed");
        }
        
        self.spaceBetween = 15.0f;
        self.hintUsedOnThisLevel = NO;
        self.currentLayout = [[NSMutableArray alloc] initWithArray:startingLayout copyItems:YES];
        
        ///////////////////////// CREATING TILES /////////////////////////////
        
        self.tilesArray = [[NSMutableArray alloc] initWithCapacity:self.rows*self.columns];
        
        if(self.rows == 3 && self.columns == 3)
            self.tilesGrid = [[SKSpriteNode alloc] initWithImageNamed:@"tilesGridThree"];
        else if(self.rows == 4 && self.columns == 4) {
            self.tilesGrid = [[SKSpriteNode alloc] initWithImageNamed:@"tilesGridFour"];
        }else {
            //NSAssert(NO,@"BasicScene: Not 3x3 or 4x4 grid.");
        }
        
        self.tilesGrid.size = CGSizeMake(self.size.width - 65, self.size.width - 65);
        self.tilesGrid.position = CGPointMake(CGRectGetMidX(self.frame) - self.tilesGrid.size.width / 2, (CGRectGetMidY(self.frame) - self.tilesGrid.size.height / 2) * 73/80);
        self.tilesGrid.zPosition = -10.0f;
        self.tilesGrid.anchorPoint = CGPointMake(0.0f, 0.0f);
        [self addChild:self.tilesGrid];
        
        // width of the square is the smaller of the two (should almost always be width)
        float squareSide = MIN(self.tilesGrid.size.width, self.tilesGrid.size.height) /
        ((self.tilesGrid.size.height <= self.tilesGrid.size.width) ? self.rows : self.columns) - self.spaceBetween;
        
        CGSize squareSize = CGSizeMake(squareSide, squareSide);
        
        WhiteTileColor colorForTile;
        if([[NSUserDefaults standardUserDefaults] boolForKey:makeTileColorRandomKey]) {
            colorForTile = [self generateRandomWhiteTileColor];
        }else {
            colorForTile = (int)[[NSUserDefaults standardUserDefaults] integerForKey:tileColorKey];
        }
        
        // Creating and adding tiles while managing position, states, colors, etc.
        //Note: startingLayout[r][c] (string is row, each char is column), the tiles are initialized from left to right, bottom to top
        for(int r = 0; r < self.rows; r++) {
            for(int c = 0; c < self.columns; c++) {
                TileNode* tile = [TileNode alloc];
                
                if([startingLayout[r][c] integerValue] == TileStateWhite) {
                    tile = [tile initWithState:TileStateWhite whiteTileColor:colorForTile row:r col:c size:squareSize];
                }else {
                    tile = [tile initWithState:TileStateBlack whiteTileColor:colorForTile row:r col:c size:squareSize];
                }
                
                
                float positionConstant = MIN(self.tilesGrid.size.width, self.tilesGrid.size.height);
                tile.position = CGPointMake(tile.col*positionConstant/self.columns + positionConstant / (self.columns*2), tile.row*positionConstant/self.rows + positionConstant / (self.rows*2));
                
                [self.tilesGrid addChild:tile];
                [self.tilesArray addObject:tile];
            }
        }
        
        ////////////////////////////// BUTTONS ///////////////////////////
        
        //to prevent retain cycles
        __weak BasicGameScene* weakSelf = self;
        
        // Reset button will reset tiles layout when pressed
        
        SKAction* resetAction = [SKAction runBlock:^{
            [weakSelf reset];
        }];
        self.resetButton = [[SKButton alloc] initWithDefaultTextureNamed:@"resetButton" selectedTextureNamed:@"resetButtonSelected" disabledTextureNamed:nil disabled:NO name:@"resetButton" action:resetAction soundEffectName:@"tilePressDown" withExtension:@"wav"];
        self.resetButton.size = self.buttonSize;
        self.resetButton.position = self.homeResetButtonLoc;
        
        // Hint button will show hint when pressed
        SKAction* showHintAction = [SKAction runBlock:^{
            [weakSelf showHint];
        }];
        self.hintButton = [[SKButton alloc] initWithDefaultTextureNamed:@"hintButton" selectedTextureNamed:@"hintButtonSelected" disabledTextureNamed:nil disabled:NO name:@"hintButton" action:showHintAction soundEffectName:@"hintSound" withExtension:@"wav"];
        self.hintButton.size = self.buttonSize;
        self.hintButton.position = CGPointMake(self.size.width * 9/10, self.homeResetButtonLoc.y);
        
        // Display the number of hints available
        self.numHintsLabel = [[SKLabelNode alloc] initWithFontNamed:@"ArialRoundedMTBold"];
        self.numHintsLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.numHintsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        self.numHintsLabel.fontSize = 14.0f;
        self.numHintsLabel.position = CGPointMake(self.hintButton.position.x - self.hintButton.size.width * 3/4, self.hintButton.position.y);
        self.numHintsLabel.text = [NSString stringWithFormat:@"x%lu",(long)[[NSUserDefaults standardUserDefaults] integerForKey:numberOfHintsKey]];
        
        [self addChild:self.resetButton];
        [self addChild:self.hintButton];
        [self addChild:self.numHintsLabel];
        
        // hint button animation setup
        
        float hintSizeChangeRatio = 1.1f;
        id increaseHintSize = [SKAction runBlock:^{
            weakSelf.hintButton.size = CGSizeMake(weakSelf.hintButton.size.width*hintSizeChangeRatio, weakSelf.hintButton.size.height*hintSizeChangeRatio);
        }];
        id wait = [SKAction waitForDuration:0.2f];
        id decreaseHintSize = [SKAction runBlock:^{
            weakSelf.hintButton.size = CGSizeMake(weakSelf.hintButton.size.width/hintSizeChangeRatio, weakSelf.hintButton.size.height/hintSizeChangeRatio);
        }];
        SKAction* animateHintButton = [SKAction sequence:@[increaseHintSize,wait,decreaseHintSize,wait,increaseHintSize,wait,decreaseHintSize]];
        
        // Animate hint button every 60 seconds (user may be stuck on puzzle)
        id waitTime = [SKAction waitForDuration:60.0f];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[waitTime,animateHintButton]]]];
        
        /////////////////// DERIVED CLASS LABEL LOCATIONS //////////////////
        
        // Standard and TimeRun have different labels but they should be the same in locations and sizes
        self.timeLeftMovesLoc = CGPointMake(self.size.width * 13/20, self.tilesGrid.position.y + self.tilesGrid.size.height + 25);
        self.bestLoc = CGPointMake(self.timeLeftMovesLoc.x, self.tilesGrid.position.y + self.tilesGrid.size.height + 50);
        self.levelScoreLoc = CGPointMake(self.size.width * 1/10,(self.bestLoc.y + self.timeLeftMovesLoc.y) / 2);
        
        self.levelScoreFontSize = 1.6f * FONT_SIZE;
        self.timeLeftMovesFontSize = FONT_SIZE;
        self.bestFontSize = FONT_SIZE;
        
        ///////////////////////// AUDIO //////////////////////////
        
        self.tileHoldDown = [SKAction playSoundFileNamed:@"tilePressDown.wav" waitForCompletion:NO];
        self.tileRelease = [SKAction playSoundFileNamed:@"tileRelease.wav" waitForCompletion:NO];
        
        /////////////////// CALCULATE MINIMUM MOVES REQUIRED //////////////////
        
        self.minimumRequiredMoves = [self calculateMinimumMovesRequiredToSolvePuzzle];
        
        self.ding = [SKAction playSoundFileNamed:@"ding.wav" waitForCompletion:YES];
        
        id waitDur = [SKAction waitForDuration:(arc4random_uniform(20) + 15)];
        id perform = [SKAction runBlock:^{
            [weakSelf emphasizeHintButton];
        }];
        
        self.emphasizeHintButtonActionKey = @"emphasizeHintButtonActionKey";
        // in 40 - 70 seconds, emphasize the hint button if still on puzzle
        
        if([[NSUserDefaults standardUserDefaults] integerForKey:numberOfHintsKey] > 0)
            [self runAction:[SKAction sequence:@[waitDur, perform]]];
        
        self.puzzleSolvedWaitDuration = 0.1f;
    }
    return self;
}

- (NSArray*) tilesToTapToSolvePuzzle {
    // Array to document how many times a tile should be pressed
    int tilesToTapOnToSolvePuzzle[self.rows][self.columns];
    // Assign starting values to 0
    for(int r = 0; r < self.rows; r++) {
        for(int c = 0; c < self.columns; c++) {
            tilesToTapOnToSolvePuzzle[r][c] = 0;
        }
    }
    
    // Which tile to look for when iterating through tiles, by default, look to remove a white tile
    TileState tileStateToCheckFor = TileStateWhite;
    
    for(int r = 0; r < [self.currentLayout count]; r++) {
        // Current row
        NSArray* rowBeingChecked = [self.currentLayout objectAtIndex:r];
        
        // Current column (an individual tile)
        for(int c = 0; c < [rowBeingChecked count]; c++) {
            
            // If tile is in the state being checked (default: white), add the necessary calculations to tilesToTapOnToSolvePuzzle
            if([[rowBeingChecked objectAtIndex:c] integerValue] == tileStateToCheckFor) {
                
                // Determine what type of tile it is
                TileType currentTileType = [self tileTypeAtRow:r column:c];
                
                // If it is a 3x3 grid
                if(self.rows == 3 && self.columns == 3) {
                    switch (currentTileType) {
                        case TileTypeCorner: {
                            // Comments will describe tile assuming currentTile at [0,0]
                            
                            // [2,2]
                            int rFirst = r == 0 ? 2 : 0;
                            int cFirst = c == 0 ? 2 : 0;
                            
                            // [2,1]
                            int rSecond = 1;
                            int cSecond = c == 0 ? 2 : 0;
                            
                            // [1,2]
                            int rThird = r == 0 ? 2 : 0;
                            int cThird = 1;
                            
                            // [1,1]
                            int rFourth = 1;
                            int cFourth = 1;
                            
                            // Increment corresponding tile locatons by 1
                            tilesToTapOnToSolvePuzzle[rFirst][cFirst]++;
                            tilesToTapOnToSolvePuzzle[rSecond][cSecond]++;
                            tilesToTapOnToSolvePuzzle[rThird][cThird]++;
                            tilesToTapOnToSolvePuzzle[rFourth][cFourth]++;
                        }
                            break;
                            // increment for a tile at the edge
                        case TileTypeEdge: {
                            
                            // Tap all tiles in the rows other than this tile
                            if(c == 1) {
                                for(int a = 0; a < self.rows; a++) {
                                    for(int b = 0; b < self.columns; b++) {
                                        if(a != r) {
                                            tilesToTapOnToSolvePuzzle[a][b]++;
                                        }
                                    }
                                }
                                // Tap all tiles in the columns other than this tile
                            }else if(r == 1) {
                                for(int a = 0; a < self.rows; a++) {
                                    for(int b = 0; b < self.columns; b++) {
                                        if(b != c) {
                                            tilesToTapOnToSolvePuzzle[a][b]++;
                                        }
                                    }
                                }
                            }else {
                                //NSAssert(NO, @"BasicGameScene: showHint:, tileTypeEdge has neither r == 1 or c == 1, so it cannot be tyleTypeEdge!");
                            }
                        }
                            break;
                            // Increment all tiles to get rid of tile at center
                        default: {
                            for(int a = 0; a < self.rows; a++) {
                                for(int b = 0; b < self.columns; b++) {
                                    tilesToTapOnToSolvePuzzle[a][b]++;
                                }
                            }
                        }
                            break;
                    }
                    // 4x4 grid
                }else if(self.rows == 4 && self.columns == 4) {
                    switch (currentTileType) {
                        case TileTypeCorner: {
                            int rFirst = r;
                            int cFirst = c == 0 ? 2 : 1;
                            
                            int rSecond = r == 0 ? 2 : 1;
                            int cSecond = c;
                            
                            int rThird = r == 0 ? 2 : 1;
                            int cThird = c == 0 ? 2 : 1;
                            
                            int rFourth = r == 0 ? 2 : 1;
                            int cFourth = c == 0 ? 3 : 0;
                            
                            int rFifth = r == 0 ? 3 : 0;
                            int cFifth = c == 0 ? 2 : 1;
                            
                            tilesToTapOnToSolvePuzzle[rFirst][cFirst]++;
                            tilesToTapOnToSolvePuzzle[rSecond][cSecond]++;
                            tilesToTapOnToSolvePuzzle[rThird][cThird]++;
                            tilesToTapOnToSolvePuzzle[rFourth][cFourth]++;
                            tilesToTapOnToSolvePuzzle[rFifth][cFifth]++;
                            
                        }
                            break;
                        case TileTypeCenter: {
                            int rFirst = r == 1 ? 0 : 3;
                            int cFirst = c == 1 ? 0 : 3;
                            
                            int rSecond = r == 1 ? 0 : 3;
                            int cSecond = c == 1 ? 3 : 0;
                            
                            int rThird = r == 1 ? 2 : 1;
                            int cThird = c == 1 ? 2 : 1;
                            
                            int rFourth = r == 1 ? 2 : 1;
                            int cFourth = c == 1 ? 3 : 0;
                            
                            int rFifth = r == 1 ? 3 : 0;
                            int cFifth = c == 1 ? 0 : 3;
                            
                            int rSixth = r == 1 ? 3 : 0;
                            int cSixth = c == 1 ? 2 : 1;
                            
                            tilesToTapOnToSolvePuzzle[rFirst][cFirst]++;
                            tilesToTapOnToSolvePuzzle[rSecond][cSecond]++;
                            tilesToTapOnToSolvePuzzle[rThird][cThird]++;
                            tilesToTapOnToSolvePuzzle[rFourth][cFourth]++;
                            tilesToTapOnToSolvePuzzle[rFifth][cFifth]++;
                            tilesToTapOnToSolvePuzzle[rSixth][cSixth]++;
                            
                        }
                            break;
                        default: {
                            int one[4] = {0,0,3,3};
                            int two[4] = {0,2,1,3};
                            int three[4] = {2,2,1,1};
                            int four[4] = {2,3,0,1};
                            int five[4] = {3,0,3,0};
                            int six[4] = {3,2,1,0};
                            
                            int rFirst = one[r];
                            int cFirst = one[c];
                            
                            int rSecond = two[r];
                            int cSecond = two[c];
                            
                            int rThird = three[r];
                            int cThird = three[c];
                            
                            int rFourth = four[r];
                            int cFourth = four[c];
                            
                            int rFifth = five[r];
                            int cFifth = five[c];
                            
                            int rSixth = six[r];
                            int cSixth = six[c];
                            
                            tilesToTapOnToSolvePuzzle[rFirst][cFirst]++;
                            tilesToTapOnToSolvePuzzle[rSecond][cSecond]++;
                            tilesToTapOnToSolvePuzzle[rThird][cThird]++;
                            tilesToTapOnToSolvePuzzle[rFourth][cFourth]++;
                            tilesToTapOnToSolvePuzzle[rFifth][cFifth]++;
                            tilesToTapOnToSolvePuzzle[rSixth][cSixth]++;
                            
                        }
                            break;
                    }
                    
                    // Each algorithm for 4x4 solve by making all the tiles white, this cancels that out by negating the whole thing
                    tilesToTapOnToSolvePuzzle[0][0]++;
                    tilesToTapOnToSolvePuzzle[0][3]++;
                    tilesToTapOnToSolvePuzzle[3][0]++;
                    tilesToTapOnToSolvePuzzle[3][3]++;
                    
                }
            }
        }
    }
    
    // Tapping the same tile twice is the same as not tapping it at all, so mod all values by 2 to determine which tiles need to be tapped and which don't.
    // The number of moves required will be the sum of all values (either 0 or 1)
    int count = 0;
    for(int r = 0; r < self.rows; r++) {
        for(int c = 0; c < self.columns; c++) {
            tilesToTapOnToSolvePuzzle[r][c] %= 2;
            count += tilesToTapOnToSolvePuzzle[r][c];
        }
    }
    
    NSMutableArray* arr = [[NSMutableArray alloc] initWithCapacity:self.rows];
    
    for(int r = 0; r < self.rows; r++) {
        NSMutableArray* row = [[NSMutableArray alloc] initWithCapacity:self.columns];
        for(int c = 0; c < self.columns; c++) {
            NSNumber* currentNum = INT(tilesToTapOnToSolvePuzzle[r][c]);
            [row addObject:currentNum];
        }
        [arr addObject:row];
    }
    
    return arr;
}

- (unsigned int) calculateMinimumMovesRequiredToSolvePuzzle {
    NSArray* arr = [self tilesToTapToSolvePuzzle];
    int count = 0;
    for(int r = 0; r < [arr count]; r++) {
        for(int c = 0; c < [[arr objectAtIndex:r] count]; c++) {
            id obj = [[arr objectAtIndex:r] objectAtIndex:c];
            
            if([obj isKindOfClass:[NSNumber class]]) {
                NSNumber* num = (NSNumber*)obj;
                count += [num integerValue];
            }
        }
    }
    
    NSLog(@"Minimum Required Moves: %i",count);
    return count;
}

- (void) showHint {
    //NSAssert(self.rows < 5 && self.columns < 5, @"BasicGameScene: Check showHint: method.");
    
    if(self.hintUsedOnThisLevel ||
       [[NSUserDefaults standardUserDefaults] integerForKey:numberOfHintsKey] > 0) {
        
        for(TileNode* t in self.tilesArray) {
            for(SKNode* n in [t children]) {
                if([n isKindOfClass:[SKLabelNode class]]) {
                    SKLabelNode* node = (SKLabelNode*)n;
                    
                    if(t.currentState == TileStateWhite)
                        node.fontColor = [SKColor blackColor];
                    else
                        node.fontColor = [SKColor whiteColor];
                }
                
                SKAction* fadeOut = [SKAction fadeOutWithDuration:0.25];
                SKAction* remove = [SKAction runBlock:^{
                    [n removeFromParent];
                }];
                [n runAction:[SKAction sequence:@[fadeOut,remove]]];
            }
        }
        
        NSInteger numberOfHintsLeft = [[NSUserDefaults standardUserDefaults] integerForKey:numberOfHintsKey];
        
        //this prevents from wasting a hint if user presnts hint button again or if layout changes
        if(!self.hintUsedOnThisLevel) {
            numberOfHintsLeft--;
            self.numHintsLabel.text = [NSString stringWithFormat:@"x%lu",(long)numberOfHintsLeft];
        }
        
        [[NSUserDefaults standardUserDefaults] setInteger:numberOfHintsLeft forKey:numberOfHintsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.hintUsedOnThisLevel = YES;
        
        NSArray* numberOfTimesToTapOnTile = [self tilesToTapToSolvePuzzle];
        
        //NSLog all the tile locations that should be tapped
        
        for(int r = 0; r < self.rows; r++) {
            for(int c = 0; c < self.columns; c++) {
                id obj = [self.tilesArray objectAtIndex:(r*self.rows+c)];
                
                id n = numberOfTimesToTapOnTile[r][c];
                int x = -1;
                if([n isKindOfClass:[NSNumber class]]) {
                    NSNumber* num = (NSNumber*)n;
                    x = (int)[num integerValue];
                }
                
                if(x == 0) {
                    if([obj isKindOfClass:[TileNode class]]) {
                        /*TileNode* t = (TileNode*)obj;
                         SKAction* fadeAway = [SKAction fadeAlphaTo:0.1f duration:0.25f];
                         [t runAction:fadeAway];*/
                    }
                }else {
                    if([obj isKindOfClass:[TileNode class]]) {
                        TileNode* t = (TileNode*)obj;
                        t.alpha = 1.0f;
                        
                        SKLabelNode* tap = [[SKLabelNode alloc] initWithFontNamed:@"Menlo-Bold"];
                        tap.fontSize = t.size.width/5;
                        tap.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
                        tap.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
                        tap.text = [NSString stringWithFormat:@"Tap"];
                        tap.position = CGPointMake(0, t.size.height/8);
                        
                        SKLabelNode* me = [[SKLabelNode alloc] initWithFontNamed:@"Menlo-Bold"];
                        me.fontSize = t.size.width/5;
                        me.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
                        me.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
                        me.text = [NSString stringWithFormat:@"me!"];
                        me.position = CGPointMake(0, -tap.position.y);
                        
                        if(t.currentState == TileStateWhite) {
                            tap.fontColor = [SKColor blackColor];
                            me.fontColor = [SKColor blackColor];
                        }
                        
                        [t addChild:tap];
                        [t addChild:me];
                    }
                }
            }
        }
    }
}

-(SKTransition*) randomTransitionWithDuration:(float) duration {
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

- (void) changeNeighboringTileStates:(TileNode *)tileTappedOn {
    
    //iterate through neighboring tiles by row and column numbers
    for(int r = -1; r <= 1; r++) {
        for(int c = -1; c <=1; c++) {
            
            //row and column of current tile being worked on
            int currentRow = (int)tileTappedOn.row + r;
            int currentColumn = (int)tileTappedOn.col + c;
            
            //only continue if current tile is in bounds on the 3x3 or 4x4 grid
            if(currentRow >= 0 && currentRow < self.rows &&
               currentColumn >= 0 && currentColumn < self.columns) {
                
                //if it is, this is the index of the current tile in self.tilesArray
                int indexInTilesArray = (currentRow * self.columns) + currentColumn;
                
                id tile = [self.tilesArray objectAtIndex:indexInTilesArray];
                if([tile isKindOfClass:[TileNode class]]) {
                    TileNode* currentTile = (TileNode*)tile;
                    
                    [currentTile toggleTileState];
                    [currentTile setToDefault];
                }
            }
        }
    }
    [self updateCurrentLayout];
}

- (void) changeNeighboringTilesToSelected:(TileNode *)tileTappedOn {
    //iterate through neighboring tiles by row and column numbers
    for(int r = -1; r <= 1; r++) {
        for(int c = -1; c <=1; c++) {
            
            //row and column of current tile being worked on
            int currentRow = (int)tileTappedOn.row + r;
            int currentColumn = (int)tileTappedOn.col + c;
            
            //only continue if current tile is in bounds on the 3x3 or 4x4 grid
            if(currentRow >= 0 && currentRow < self.rows &&
               currentColumn >= 0 && currentColumn < self.columns) {
                
                //if it is, this is the index of the current tile in self.tilesArray
                int indexInTilesArray = (currentRow * self.columns) + currentColumn;
                
                id tile = [self.tilesArray objectAtIndex:indexInTilesArray];
                if([tile isKindOfClass:[TileNode class]]) {
                    TileNode* currentTile = (TileNode*)tile;
                    
                    [currentTile setToSelected];
                }
            }
        }
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    TileNode* node = [self closestTileNodeFromPoint:location];
    
    if(node) {
        if([[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey]) {
            [self runAction:self.tileHoldDown];
        }
        
        TileNode* tile = (TileNode*)node;
        [self changeNeighboringTilesToSelected:tile];
        
        // needed because supertouches began is in the else
        for(SKNode* n in [self children]) {
            if([n isKindOfClass:[SKButton class]]) {
                SKButton* b = (SKButton*)n;
                [b setToDefault];
            }else if([n isKindOfClass:[SKSwitch class]]) {
                SKSwitch* s = (SKSwitch*)n;
                [s setToDefault];
            }else if([n isKindOfClass:[SKLabelButton class]]) {
                SKLabelButton* b = (SKLabelButton*)n;
                [b setToDefault];
            }
        }
    }else
        [super touchesBegan:touches withEvent:event];
    /*
     if([node isKindOfClass:[TileNode class]]) {
     
     if([[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey]) {
     [self runAction:self.tileHoldDown];
     }
     
     TileNode* tile = (TileNode*)node;
     [self changeNeighboringTilesToSelected:tile];
     }
     */
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    //SKNode* node = [self nodeWithinRadius:self.spaceBetween/2 OfPoint:loc];
    
    TileNode* node = [self closestTileNodeFromPoint:loc];
    
    //If touches moves to another tile very quickly (detection in between is skipped), tiles remain selected. This fixes that
    for(TileNode* tile in [self tilesArray]) {
        [tile setToDefault];
    }
    
    if(node) {
        [self changeNeighboringTilesToSelected:node];
        
        // needed because super touchesmoved is in the else
        for(SKNode* n in [self children]) {
            if([n isKindOfClass:[SKButton class]]) {
                SKButton* b = (SKButton*)n;
                [b setToDefault];
            }else if([n isKindOfClass:[SKSwitch class]]) {
                SKSwitch* s = (SKSwitch*)n;
                [s setToDefault];
            }else if([n isKindOfClass:[SKLabelButton class]]) {
                SKLabelButton* b = (SKLabelButton*)n;
                [b setToDefault];
            }
        }
    }else
        [super touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    TileNode* n = [self closestTileNodeFromPoint:location];
    SKNode* node = [self nodeWithinRadius:tapRadius OfPoint:location];
    
    if([[node name] isEqualToString:[self.hintButton name]]) {
        [self removeActionForKey:self.emphasizeHintButtonActionKey];
    }
    
    if(n) {
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey]) {
            [self runAction:self.tileRelease];
        }
        
        self.movesMade++;
        
        [self changeNeighboringTileStates:n];
        
        for(TileNode* t in self.tilesArray) {
            [t setToDefault];
        }
        
        // needed because super touchesended is in the else
        for(SKNode* n in [self children]) {
            if([n isKindOfClass:[SKButton class]]) {
                SKButton* b = (SKButton*)n;
                [b setToDefault];
            }else if([n isKindOfClass:[SKSwitch class]]) {
                SKSwitch* s = (SKSwitch*)n;
                [s setToDefault];
            }else if([n isKindOfClass:[SKLabelButton class]]) {
                SKLabelButton* b = (SKLabelButton*)n;
                [b setToDefault];
            }
        }
    }else {
        // to prevent from accidentally tapping back button
        [super touchesEnded:touches withEvent:event];
        
        //sometimes, tiles would stay selected, probably because after setting tiles selected and moving, in a rare case touches would end on !tileNode and tiles would stay selected, this should solve that issue
        for(TileNode* n in self.tilesArray) {
            [n setToDefault];
        }
    }
    
}

// for testing purposes
- (void) logCurrentLayout {
    //NSAssert(self.rows == [self.currentLayout count],@"BasicGameScene: logCurrentLayout:");
    
    for(int r = 0; r < self.rows; r++) {
        NSArray* currentRow = [self.currentLayout objectAtIndex:r];
        NSMutableString* rowStr = [[NSMutableString alloc] initWithString:@""];
        for(int c = 0; c < self.columns; c++) {
            if([[currentRow objectAtIndex:c] integerValue] == TileStateBlack) {
                rowStr = [NSMutableString stringWithFormat:@"%@,%@",rowStr,@"B"];
            }else {
                rowStr = [NSMutableString stringWithFormat:@"%@,%@",rowStr,@"W"];
            }
        }
    }
}

- (void) reset {
    
    //NSAssert((self.rows * self.columns) == [self.tilesArray count],@"BasicGameScene: Check reset: method");
    
    // iterate through tiles
    for(int r = 0; r < self.rows; r++) {
        for(int c = 0; c < self.columns; c++) {
            NSInteger startingStateForCurrentTile = [[self.startingLayout objectAtIndex:r][c] integerValue];
            
            // if current tile does not match starting layout, toggle its state
            if([[self.tilesArray objectAtIndex:(self.rows*r + c)] currentState] != startingStateForCurrentTile) {
                [[self.tilesArray objectAtIndex:(self.rows*r + c)] toggleTileState];
            }
        }
    }
    
    // update layout
    [self updateCurrentLayout];
}

- (void) updateCurrentLayout {
    // iterate through tiles
    for(int i = 0; i < [self.tilesArray count]; i++) {
        int rIndex = i / self.rows;
        int cIndex = i % self.columns;
        
        NSNumber* nn;
        
        if([self.tilesArray[i] currentState] == TileStateWhite) {
            nn = [NSNumber numberWithInt:1];
        }else {
            nn = [NSNumber numberWithInt:0];
        }
        
        // retrieve current row's array
        NSMutableArray* rowBeingModified = [[NSMutableArray alloc] initWithArray:[self.currentLayout objectAtIndex:rIndex]];
        
        // modify current row's column
        [rowBeingModified replaceObjectAtIndex:cIndex withObject:nn];
        [self.currentLayout replaceObjectAtIndex:rIndex withObject:rowBeingModified];
    }
    
    // everytime layout is updated, check if puzzle is solved
    [self checkIfPuzzleSolved];
    
    // if hint button has been pressed, re calculate hint (this accounts for user tapping on different tiles after presing hint button and for user resetting)
    if(self.hintUsedOnThisLevel) {
        [self showHint];
    }
}

- (TileType) tileTypeAtRow:(unsigned int)r column:(unsigned int)c {
    TileType output = 0;
    
    // 3x3 grid
    if(self.rows == 3 && self.columns == 3) {
        if(r == 1 && c == 1) {
            output = TileTypeCenter;
        }else if((r == 0 && c == 0) ||
                 (r == 0 && c == 2) ||
                 (r == 2 && c == 0) ||
                 (r == 2 && c == 2)) {
            output = TileTypeCorner;
        }else {
            output = TileTypeEdge;
        }
        
        // 4x4 grid
    }else if(self.rows == 4 && self.columns == 4) {
        if(r >= 1 && r <= 2 && c >= 1 && c <= 2) {
            output = TileTypeCenter;
        }else if((r == 0 && c == 0) ||
                 (r == 0 && c == 3) ||
                 (r == 3 && c == 0) ||
                 (r == 3 && c == 3)) {
            output = TileTypeCorner;
        }else {
            output = TileTypeEdge;
        }
    }else {
        //NSAssert(NO, @"BasicGameScene: Handle tileType for 5x5");
    }
    
    return output;
}

- (void) checkIfPuzzleSolved {
    /*
    if([self.currentLayout isEqualToArray:self.solutions]) {
        if([[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey]) {
            if(self.movesMade <= self.minimumRequiredMoves) {
                [self runAction:[SKAction playSoundFileNamed:@"perfectScoreSound.wav" waitForCompletion:NO]];
            }else {
                [self runAction:self.ding];
            }
        }
    }
     */
}

- (WhiteTileColor) generateRandomWhiteTileColor {
    // Last element + 1 = total elements in enum
    int enumCount = WhiteTileColorRed + 1;
    
    return arc4random_uniform((unsigned int)enumCount);
}

- (TileNode*) closestTileNodeFromPoint:(CGPoint)loc {
    SKNode* nodeAtCurrentPoint = [self nodeAtPoint:loc];
    if([nodeAtCurrentPoint isKindOfClass:[TileNode class]]) {
        return (TileNode*)nodeAtCurrentPoint;
    }
    
    TileNode* test = [self.tilesArray objectAtIndex:0];
    
    float spaceBetweenHypotenuse = sqrtf(powf(self.spaceBetween/2,2.0f) +
                                         powf(self.spaceBetween/2,2.0f));
    
    float tileHypotenuse = sqrtf(powf(test.size.width/2,2.0f) +
                                 powf(test.size.height/2,2.0f));
    
    float distanceToCheck = tileHypotenuse + spaceBetweenHypotenuse;
    TileNode* output = nil;
    
    float shortestDistance = distanceToCheck;
    for(TileNode* ret in self.tilesArray) {
        
        // currentTileLoc is just the position of the current tile, but extra calculations must be done because this tile is positioned with respect to tilesGrid while we are working with respect to this scene
        CGPoint currentTileLoc = CGPointMake(ret.position.x + self.tilesGrid.position.x, ret.position.y + self.tilesGrid.position.y);
        
        float distanceBetweenCurrentTileAndTouch = [self distanceBetween:currentTileLoc and:loc];
        
        if(distanceBetweenCurrentTileAndTouch < shortestDistance) {
            output = ret;
            shortestDistance = distanceBetweenCurrentTileAndTouch;
        }
    }
    return output;
}

- (float) distanceBetween:(CGPoint)A and:(CGPoint)B {
    float x = fabs(A.x - B.x);
    float y = fabs(A.y - B.y);
    
    float out = sqrtf(powf(x, 2.0f) + powf(y, 2.0f));
    return out;
}

- (void) emphasizeHintButton {
    
    // only highlight if it is not already selected and if hints have not already been used
    if(![self.hintButton isSelected] && !self.hintUsedOnThisLevel) {
        __weak BasicGameScene* weakSelf = self;
        
        id wait = [SKAction waitForDuration:0.15f];
        id highlight = [SKAction runBlock:^{
            [weakSelf.hintButton setToSelected];
        }];
        id unselect = [SKAction runBlock:^{
            [weakSelf.hintButton setToDefault];
        }];
        
        [self runAction:[SKAction sequence:@[highlight,wait,unselect,wait,highlight,wait,unselect]] withKey:self.emphasizeHintButtonActionKey];
    }
}


@end
