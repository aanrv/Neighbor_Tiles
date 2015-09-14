//
//  LevelButtonNode.m
//  Pattern Matching
//
//  Created by Varan on 1/15/15.
//
//

#import "LevelButtonNode.h"

@implementation LevelButtonNode

- (instancetype) initWithLevelNumber:(NSInteger)lvlNum unlocked:(BOOL)u defaultImageName:(NSString *)defImg selectedImageName:(NSString *)selImg defaultTextColor:(UIColor *)defColor selectedTextColor:(UIColor *)selColor size:(CGSize)s {
    self = [super initWithImageNamed:defImg];
    
    if(self) {
        self.size = s;
        self.defaultImageName = defImg;
        self.selectedImageName = selImg;
        
        self.defaultTextColor = defColor;
        self.selectedTextColor = selColor;
        
        self.lock = [[SKSpriteNode alloc] initWithImageNamed:@"lock"];
        self.lock.size = CGSizeMake(self.size.width /2, self.size.height / 2);
        self.lock.position = CGPointMake(0.0f, 0.0f);
        
        self.perfectStar = [[SKSpriteNode alloc] initWithImageNamed:@"perfectStar"];
        self.perfectStar.alpha = 1.0f;
        self.perfectStar.size = CGSizeMake(self.size.width * 8/10, self.size.height * 8/10);
        self.perfectStar.zPosition = -1.0f;
        self.perfectStar.position = self.lock.position;
        
        self.isUnlocked = u;
        self.isSelected = NO;
        
        self.levelNumber = lvlNum;
        
        self.levelLabel = [[SKLabelNode alloc] initWithFontNamed:@"Times New Roman Bold"];
        self.levelLabel.text = [NSString stringWithFormat:@"%i",(int)self.levelNumber];
        self.levelLabel.position = CGPointMake(0.0f, 0.0f);
        self.levelLabel.fontColor = self.defaultTextColor;
        self.levelLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.levelLabel.fontSize = 16.0f;
        
        BOOL perfectSc = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@%i",perfectScoresPartialKey,(int)self.levelNumber]];
        
        //NSAssert(!(perfectSc && !self.isUnlocked),@"LevelButtonNode: Level has perfect score but isn't unlocked.");
        if(!self.isUnlocked) {
            [self addChild:self.lock];
            self.alpha = 0.3f;
        }else {
            [self addChild:self.levelLabel];
            if(perfectSc) {
                [self addChild:self.perfectStar];
            }
        }
    }
    
    return self;
}

- (void) setToSelected {
    if(!self.isSelected && self.isUnlocked) {
        self.isSelected = YES;
        self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.selectedImageName]];
        self.levelLabel.fontColor = self.selectedTextColor;
    }
}

- (void) setToDefault {
    if(self.isSelected) {
        self.isSelected = NO;
        self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.defaultImageName]];
        self.levelLabel.fontColor = self.defaultTextColor;
    }
}

@end
