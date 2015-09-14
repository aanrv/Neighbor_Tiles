//
//  SKSwitch.m
//  Pattern Matching
//
//  Created by Varan on 11/11/14.
//
//

#import "SKSwitch.h"

@implementation SKSwitch

- (instancetype) initWithName:(NSString *)switchName size:(CGSize)switchSize enabledImageNamed:(NSString *)enabledImageName enabledImageSelectedNamed:(NSString *)enabledImageSelectedName disabledImageNamed:(NSString *)disabledImageName disabledImageSelectedNamed:(NSString *)disabledImageSelectedName enableFlag:(BOOL)enableFlag action:(SKAction*)action {
    
    self = [super init];
    
    if(self) {
        // assign member variables
        self.action = action;
        self.sound = nil;
        
        self.name = switchName;
        self.size = switchSize;
        
        self.enabledImageName = enabledImageName;
        self.enabledImageSelectedName = enabledImageSelectedName;
        
        self.disabledImageName = disabledImageName;
        self.disabledImageSelectedName = disabledImageSelectedName;
        
        self.enabled = enableFlag;
        self.isSelected = NO;
        
        if(self.enabled) {
            self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.enabledImageName]];
            
        }else {
            self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.disabledImageName]];
        }
        //self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (instancetype) initWithName:(NSString*) switchName
                         size:(CGSize) switchSize
            enabledImageNamed: (NSString*) enabledImageName
    enabledImageSelectedNamed:(NSString*) enabledImageSelectedName
           disabledImageNamed: (NSString*) disabledImageName
   disabledImageSelectedNamed:(NSString*) disabledImageSelectedName
                   enableFlag: (BOOL) enableFlag
                       action:(SKAction*) action
              soundEffectName:(NSString*)sfxName
                withExtension:(NSString*)sfxExtension {
    self = [super init];
    
    if(self) {
        // assign member variables
        self.action = action;
        self.sound = [SKAction playSoundFileNamed:[NSString stringWithFormat:@"%@.%@",sfxName,sfxExtension] waitForCompletion:NO];
        
        self.name = switchName;
        self.size = switchSize;
        
        self.enabledImageName = enabledImageName;
        self.enabledImageSelectedName = enabledImageSelectedName;
        
        self.disabledImageName = disabledImageName;
        self.disabledImageSelectedName = disabledImageSelectedName;
        
        self.enabled = enableFlag;
        self.isSelected = NO;
        
        if(self.enabled) {
            self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.enabledImageName]];
            
        }else {
            self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.disabledImageName]];
        }
        
        //self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /*
     UITouch* touch = [touches anyObject];
     CGPoint loc = [touch locationInNode:[self parent]];
     SKNode* node = [[self parent] nodeAtPoint:loc];
     
     if([node isKindOfClass:[SKSwitch class]]) {
     SKSwitch* b = (SKSwitch*)node;
     [b setToSelected];
     }
     */
    [self setToSelected];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    /*
     for(SKNode* node in [[self parent] children]) {
     if([node isKindOfClass:[SKSwitch class]]) {
     SKSwitch* s = (SKSwitch*)node;
     [s setToDefault];
     }
     }
     
     UITouch* touch = [touches anyObject];
     CGPoint loc = [touch locationInNode:[self parent]];
     SKNode* node = [[self parent] nodeAtPoint:loc];
     
     if([node isKindOfClass:[SKSwitch class]]) {
     SKSwitch* b = (SKSwitch*)node;
     [b setToSelected];
     }else {
     [self setToDefault];
     }
     */
    
    [self setToSelected];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setToDefault];
    [self toggle];
    
    [[self parent] runAction:self.action];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:soundEffectsKey] &&
       ![self.name isEqualToString:@"soundEffectButton"] &&
       ![self.name isEqualToString:@"soundEffectSwitch"]) {
        [[self parent] runAction:self.sound];
    }
}

- (void) setToDefault {
    if(self.isSelected) {
        if(self.enabled) {
            self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.enabledImageName]];
        }else {
            self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.disabledImageName]];
        }
        
        self.isSelected = NO;
    }
}

- (void) setToSelected {
    if(!self.isSelected && self.enabledImageSelectedName != nil && self.disabledImageSelectedName != nil) {
        if(self.enabled) {
            self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.enabledImageSelectedName]];
        }else {
            self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.disabledImageSelectedName]];
        }
        
        self.isSelected = YES;
    }
}

- (void) toggle {
    if(self.enabled) {
        self.enabled = NO;
        self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.disabledImageName]];
    }else {
        self.enabled = YES;
        self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.enabledImageName]];
    }
}


@end
