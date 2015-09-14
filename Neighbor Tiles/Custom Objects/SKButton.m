//
//  SKButton.m
//  Pattern Matching
//
//  Created by Varan on 7/14/14.
//
//

#import "SKButton.h"

@implementation SKButton

- (instancetype) initWithDefaultTextureNamed:(NSString*) defTex selectedTextureNamed:(NSString*) selTex disabledTextureNamed:(NSString*) disTex disabled:(BOOL) dis name:(NSString *)n action:(SKAction *)action {
    if(dis) {
        self = [super initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:disTex]]];
    }else {
        self = [super initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:defTex]]];
    }
    
    if(self) {
        self.action = action;
        self.sound = nil;
        self.name = n;
        self.defaultTextureName = defTex;
        self.selectedTextureName = selTex;
        self.disabledTextureName = disTex;
        self.isDisabled = dis;
        self.isSelected = NO;
        //self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (instancetype) initWithDefaultTextureNamed:(NSString*) defTex selectedTextureNamed:(NSString*) selTex disabledTextureNamed:(NSString*) disTex disabled:(BOOL) dis name:(NSString *)n action:(SKAction *)action soundEffectName:(NSString *)sfx withExtension:(NSString *)sfxExtension{
    
    if(dis) {
        self = [super initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:disTex]]];
    }else {
        self = [super initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:defTex]]];
    }
    
    if(self) {
        self.action = action;
        
        self.sound = [SKAction playSoundFileNamed:[NSString stringWithFormat:@"%@.%@",sfx,sfxExtension] waitForCompletion:NO];
        self.name = n;
        self.defaultTextureName = defTex;
        self.selectedTextureName = selTex;
        self.disabledTextureName = disTex;
        self.isDisabled = dis;
        self.isSelected = NO;
        //self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /*
     UITouch* touch = [touches anyObject];
     CGPoint loc = [touch locationInNode:[self parent]] ;
     SKNode* node = [[self parent] nodeAtPoint:loc];
     
     if([node isKindOfClass:[SKButton class]]) {
     SKButton* b = (SKButton*)node;
     if(!b.isDisabled)
     [b setToSelected];
     }
     */
    
    if(!self.isDisabled)
        [self setToSelected];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!self.isDisabled) {
        /*
         UITouch* touch = [touches anyObject];
         CGPoint location = [touch locationInNode:[self parent]];
         SKNode* node = [[self parent] nodeAtPoint:location];
         
         
         for(SKNode* n in [[self parent] children]) {
         if([n isKindOfClass:[SKButton class]]) {
         SKButton* b = (SKButton*)n;
         [b setToDefault];
         }
         }
         
         
         if([node isKindOfClass:[SKButton class]]) {
         SKButton* b = (SKButton*)node;
         [b setToSelected];
         }
         */
        
        [self setToSelected];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!self.isDisabled) {
        
        /*
         for(SKNode* n in [[self parent] children]) {
         if([n isKindOfClass:[SKButton class]]) {
         SKButton* b = (SKButton*)n;
         [b setToDefault];
         }
         }
         
         UITouch* touch = [touches anyObject];
         CGPoint loc = [touch locationInNode:[self parent]];
         SKNode* node = [[self parent] nodeAtPoint:loc];
         
         // reset and hint buttons will play different sounds
         if([node isKindOfClass:[SKButton class]]) {
         SKButton* b = (SKButton*)node;
         
         if(b.sound &&
         [[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey]) {
         
         if([self.name isEqualToString:@"hintButton"]) {
         if([[NSUserDefaults standardUserDefaults] integerForKey:numberOfHintsKey] > 0) {
         [b runAction:b.sound];
         }else {
         [b runAction:[SKAction playSoundFileNamed:@"outOfHints.wav" waitForCompletion:NO]];
         }
         }else {
         [b runAction:b.sound];
         }
         }
         
         [b setToDefault];
         [[b parent] runAction:b.action];
         }
         */
        
        // playing sound
        if(self.sound && [[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey]) {
            if([self.name isEqualToString:@"hintButton"]) {
                
                //if out of hints, play a different sound
                if([[NSUserDefaults standardUserDefaults] integerForKey:numberOfHintsKey] > 0) {
                    [self runAction:self.sound];
                }else {
                    [self runAction:[SKAction playSoundFileNamed:@"outOfHints.wav" waitForCompletion:NO]];
                }
            }else {
                //otherwise just play self sound
                [self runAction:self.sound];
            }
        }
        
        [self setToDefault];
        [[self parent] runAction:self.action];
        
    }
}

- (void) setToDefault {
    if(self.isSelected) {
        [self setTexture:[SKTexture textureWithImage:[UIImage imageNamed:self.defaultTextureName]]];
        self.isSelected = NO;
    }
}

- (void) setToSelected {
    //NSAssert(![self isSelected],@"SKButton: setToSelected: being called on a button that is already set as selected.");
    if(![self isSelected] && [self selectedTextureName] != nil) {
        [self setTexture:[SKTexture textureWithImage:[UIImage imageNamed:self.selectedTextureName]]];
        self.isSelected = YES;
    }
}

- (void) enable {
    if([self isDisabled]) {
        self.isDisabled = NO;
        [self setTexture:[SKTexture textureWithImage:[UIImage imageNamed:self.defaultTextureName]]];
    }
}

- (void) disable {
    if(![self isDisabled]) {
        self.isDisabled = YES;
        
        if(self.disabledTextureName != nil) {
            [self setTexture:[SKTexture textureWithImage:[UIImage imageNamed:self.disabledTextureName]]];
        }
    }
}

@end
