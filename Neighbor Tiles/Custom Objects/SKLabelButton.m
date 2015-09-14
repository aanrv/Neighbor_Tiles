//
//  SKLabelButton.m
//  Pattern Matching
//
//  Created by Varan on 1/11/15.
//
//

#import "SKLabelButton.h"

@implementation SKLabelButton

- (instancetype) initWithFontNamed:(NSString *)fontName text:(NSString *)t defaultColor:(UIColor *)defColor selectedColor:(UIColor *)selColor name:(NSString *)n action:(SKAction*)action soundEffectName:(NSString *)sfxName withExtension:(NSString *)sfxExtension {
    self = [super initWithFontNamed:fontName];
    
    if(self) {
        self.action = action;
        self.sound = [SKAction playSoundFileNamed:[NSString stringWithFormat:@"%@.%@",sfxName,sfxExtension] waitForCompletion:NO];
        self.defaultColor = defColor;
        self.selectedColor = selColor;
        self.isSelected = NO;
        self.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        
        self.name = n;
        self.text = t;
        self.fontColor = self.defaultColor;
        self.fontSize = 28.0f;
        //self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (instancetype) initWithFontNamed:(NSString *)fontName text:(NSString *)t defaultColor:(UIColor *)defColor selectedColor:(UIColor *)selColor name:(NSString *)n action:(SKAction*)action{
    self = [super initWithFontNamed:fontName];
    
    if(self) {
        self.action = action;
        self.sound = nil;
        
        self.defaultColor = defColor;
        self.selectedColor = selColor;
        self.isSelected = NO;
        self.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        
        self.name = n;
        self.text = t;
        self.fontColor = self.defaultColor;
        self.fontSize = 28.0f;
        //self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /*
    UITouch* touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:[self parent]];
    SKNode* node = [[self parent] nodeAtPoint:loc];
    
    if([node isKindOfClass:[SKLabelButton class]]) {
        SKLabelButton* b = (SKLabelButton*)node;
        [b setToSelected];
    }
     */
    
    [self setToSelected];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    /*
    for(SKNode* node in [[self parent] children]) {
        if([node isKindOfClass:[SKLabelButton class]]) {
            SKLabelButton* b = (SKLabelButton*)node;
            [b setToDefault];
        }
    }
    
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:[self parent]];
    SKNode* node = [[self parent] nodeAtPoint:location];
    
    if([node isKindOfClass:[SKLabelButton class]]) {
        SKLabelButton* b = (SKLabelButton*)node;
        [b setToSelected];
    }else {
        [self setToDefault];
    }
     */
    
    [self setToSelected];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /*
    UITouch* touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:[self parent]];
    SKNode* node = [self nodeAtPoint:loc];
    
    if([node isKindOfClass:[SKLabelButton class]]) {
        SKLabelButton* b = (SKLabelButton*)node;
        
        if(b.sound && [[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey]) {
            [b runAction:b.sound];
        }

        [b setToDefault];
        [[b parent] runAction:b.action];
    }
     */
    
    if(self.sound && [[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey]) {
        [self runAction:self.sound];
    }
    
    [self setToDefault];
    [[self parent] runAction:self.action];
}

- (void) setToDefault {
    //no nsassert because sometimes, this method will be called when it is already default in the loop in touches moved
    if([self isSelected]) {
        [self setFontColor:self.defaultColor];
        self.isSelected = NO;
    }
}

- (void) setToSelected {
    NSAssert(![self isSelected],@"SKLabelButton: Setting to selected when it is already selected.");
    if(![self isSelected]) {
        [self setFontColor:self.selectedColor];
        self.isSelected = YES;
    }
}

@end
