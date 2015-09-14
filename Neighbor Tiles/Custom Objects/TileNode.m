//
//  TileNode.m
//  Pattern Matching
//
//  Created by Varan on 7/11/14.
//
//

#import "TileNode.h"

@implementation TileNode

- (instancetype) initWithState:(TileState)state whiteTileColor:(WhiteTileColor)color row:(NSInteger)r col:(NSInteger)c size:(CGSize)size {
    self = [super init];
    
    if(self) {
        
        self.correspondingColoredTileNames = @[@"whiteTile",@"blueTile",@"yellowTile",@"greenTile",@"cyanTile",@"purpleTile",@"orangeTile",@"magentaTile",@"redTile"];
        
        self.currentState = state;
        self.tileColor = color;
        
        self.whiteTileImageName = [self.correspondingColoredTileNames objectAtIndex:self.tileColor];
        self.whiteTileSelectedImageName = [NSString stringWithFormat:@"%@Selected",self.whiteTileImageName];
        
        self.blackTileImageName = @"blackTile";
        self.blackTileSelectedImageName = @"blackTileSelected";
        
        self.col = c;
        self.row = r;
        self.isSelected = NO;
        self.size = size;
        self.anchorPoint = CGPointMake(0.5f, 0.5f);
        
        if(self.currentState == TileStateBlack) {
            self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.blackTileImageName]];
        }else {
            self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.whiteTileImageName]];
        }
    }
    
    return self;
}

- (void) toggleTileState {
    if(self.currentState == TileStateBlack) {
        self.currentState = TileStateWhite;
        self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.whiteTileImageName]];
    }else {
        self.currentState = TileStateBlack;
        self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.blackTileImageName]];
    }
}

- (void) setToSelected {
    if(!self.isSelected) {
        self.isSelected = YES;
        if(self.currentState == TileStateBlack) {
            self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.blackTileSelectedImageName]];
        }else {
            self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.whiteTileSelectedImageName]];
        }
    }
}

- (void) setToDefault {
    if(self.isSelected) {
        self.isSelected = NO;
        if(self.currentState == TileStateBlack) {
            self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.blackTileImageName]];
        }else {
            self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.whiteTileImageName]];
        }
    }
}

@end
