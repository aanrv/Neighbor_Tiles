//
//  StoreScene.m
//  Neighbor Tiles
//
//  Created by Varan on 2/15/15.
//
//

#import "StoreScene.h"
#import "MainMenuScene.h"
#import "SKLabelButton.h"
#import "SKButton.h"
#import "SKLabelButton.h"
#import <StoreKit/StoreKit.h>
#import "SKProduct+priceAsString.h"
#include <unistd.h>
#include <netdb.h>

@implementation StoreScene

- (instancetype) initWithSize:(CGSize)size viewController:(ViewController *)viewController {
    self = [super initWithSize:size backButton:YES homeButton:YES sfxButton:YES musicButton:YES viewController:viewController];
    
    if(self) {
        __weak StoreScene* weakSelf = self;
         
        SKLabelNode* removeAds = [[SKLabelNode alloc] initWithFontNamed:@"Times New Roman"];
        removeAds.text = @"Purchase something to disable ads!";
        removeAds.fontSize = 20.0f;
        removeAds.fontColor = [SKColor magentaColor];
        removeAds.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        removeAds.position = CGPointMake(self.size.width/2, self.size.height * 6/8);
        //[self addChild:removeAds];
         
        CGSize purchaseButtonSize = CGSizeMake(35, 35);
        
        float descriptionLabelXLoc = self.size.width * 1/25;
        float purchaseButtonXLoc = self.size.width * 9/10;
        
        /////////////////////////////////////////////
        
        SKProduct* five = [self.viewController productWithPID:productIDFiveHints];
        SKProduct* fifteen = [self.viewController productWithPID:productIDFifteenHints];
        SKProduct* thirty = [self.viewController productWithPID:productIDTwentyFiveHints];
        
        NSString* fiveHintsTitle;
        NSString* fifteenHintsTitle;
        NSString* thirtyHintsTitle;
        
        NSString* fiveHintsPriceStr;
        NSString* fifteenHintsPriceStr;
        NSString* thirtyHintsPriceStr;
        
        if(five == nil) {
            fiveHintsPriceStr = @"";
            fiveHintsTitle = @"5 Hints Pack";
        }else {
            fiveHintsTitle = [five localizedTitle];
            fiveHintsPriceStr = [five priceAsString];
        }
        
        if(fifteen == nil) {
            fifteenHintsPriceStr = @"";
            fifteenHintsTitle = @"15 Hints Pack";
        }else {
            fifteenHintsTitle = [fifteen localizedTitle];
            fifteenHintsPriceStr = [fifteen priceAsString];
        }
        
        if(thirty == nil) {
            thirtyHintsPriceStr = @"";
            thirtyHintsTitle = @"25 Hints Pack";
        }else {
            thirtyHintsTitle = [thirty localizedTitle];
            thirtyHintsPriceStr = [thirty priceAsString];
        }
            
        
        //////////////////////////////////////////////
        
        SKLabelNode* fiveHints = [[SKLabelNode alloc] initWithFontNamed:@"Menlo-bold"];
        fiveHints.text = fiveHintsTitle;
        fiveHints.fontSize = removeAds.fontSize * 0.8;
        fiveHints.position = CGPointMake(descriptionLabelXLoc, self.size.height * 11/20);
        fiveHints.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        fiveHints.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        fiveHints.fontColor = [SKColor orangeColor];
        [self addChild:fiveHints];
        
        SKAction* fiveHintsAction = [SKAction runBlock:^{
            
            if([weakSelf isNetworkAvailable]) {
                if([weakSelf.viewController canMakePurchases]) {
                    [weakSelf.viewController purchaseProductWithID:productIDFiveHints];
                }else
                    [weakSelf displayCannotMakePaymentsMessage];
            }else {
                [weakSelf.viewController displayCheckInternetMessage];
            }
        }];
        SKButton* fiveHintsButton = [[SKButton alloc] initWithDefaultTextureNamed:@"cart" selectedTextureNamed:@"cartSelected" disabledTextureNamed:nil disabled:NO name:@"fiveHintsButton" action:fiveHintsAction];
        fiveHintsButton.size = purchaseButtonSize;
        fiveHintsButton.position = CGPointMake(purchaseButtonXLoc,fiveHints.position.y);
        [self addChild:fiveHintsButton];
        
        //////////////////////////////////////////////
        
        SKLabelNode* thirtyHints = [[SKLabelNode alloc] initWithFontNamed:@"Menlo-bold"];
        thirtyHints.text = thirtyHintsTitle;
        thirtyHints.fontSize = removeAds.fontSize * 0.8;
        thirtyHints.position = CGPointMake(descriptionLabelXLoc, self.size.height * 7/20);
        thirtyHints.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        thirtyHints.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        thirtyHints.fontColor = [SKColor yellowColor];
        [self addChild:thirtyHints];
        
        SKAction* thirtyHintsAction = [SKAction runBlock:^{
            if([weakSelf isNetworkAvailable]) {
                if([weakSelf.viewController canMakePurchases]) {
                    [weakSelf.viewController purchaseProductWithID:productIDTwentyFiveHints];
                }else
                    [weakSelf displayCannotMakePaymentsMessage];
            }else {
                [weakSelf.viewController displayCheckInternetMessage];
            }
        }];
        SKButton* thirtyHintsButton = [[SKButton alloc] initWithDefaultTextureNamed:@"cart" selectedTextureNamed:@"cartSelected" disabledTextureNamed:nil disabled:NO name:@"thirtyHintsButton" action:thirtyHintsAction];
        thirtyHintsButton.size = purchaseButtonSize;
        thirtyHintsButton.position = CGPointMake(purchaseButtonXLoc, thirtyHints.position.y);
        [self addChild:thirtyHintsButton];
        
        ////////////////////////////////////////////
        
        SKLabelNode* fifteenHints = [[SKLabelNode alloc] initWithFontNamed:@"Menlo-bold"];
        fifteenHints.text = fifteenHintsTitle;
        fifteenHints.fontSize = removeAds.fontSize * 0.8;
        fifteenHints.position = CGPointMake(descriptionLabelXLoc, self.size.height * 9/20);
        fifteenHints.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        fifteenHints.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        fifteenHints.fontColor = [SKColor cyanColor];
        [self addChild:fifteenHints];
        
        SKAction* fifteenHintsAction = [SKAction runBlock:^{
            if([weakSelf isNetworkAvailable]) {
                if([weakSelf.viewController canMakePurchases]) {
                    [weakSelf.viewController purchaseProductWithID:productIDFifteenHints];
                }else
                    [weakSelf displayCannotMakePaymentsMessage];
            }else {
                [weakSelf.viewController displayCheckInternetMessage];
            }
        }];
        SKButton* fifteenHintsButton = [[SKButton alloc] initWithDefaultTextureNamed:@"cart" selectedTextureNamed:@"cartSelected" disabledTextureNamed:nil disabled:NO name:@"fifteenHintsButton" action:fifteenHintsAction];
        fifteenHintsButton.size = purchaseButtonSize;
        fifteenHintsButton.position = CGPointMake(purchaseButtonXLoc,fifteenHints.position.y);
        [self addChild:fifteenHintsButton];
        
        ///////////////////////////////////////////
        
        float distanceFromEdges = 5;
        
        self.numHintsLeft = [[SKLabelNode alloc] initWithFontNamed:@"Menlo"];
        self.numHintsLeft.text = [NSString stringWithFormat:@"Hints Remaining: %i",(int)[[NSUserDefaults standardUserDefaults] integerForKey:numberOfHintsKey]];
        self.numHintsLeft.position = CGPointMake(fiveHints.position.x, fiveHintsButton.position.y + fiveHintsButton.size.height);
        self.numHintsLeft.fontSize = removeAds.fontSize * 0.8;
        self.numHintsLeft.fontColor = [SKColor greenColor];
        self.numHintsLeft.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [self addChild:self.numHintsLeft];
        
        ////////////////////////////////////////////
        
        self.fivePriceDisplay = [[SKLabelNode alloc] initWithFontNamed:@"Times New Roman"];
        self.fivePriceDisplay.text = fiveHintsPriceStr;
        self.fivePriceDisplay.fontColor = fiveHints.fontColor;
        self.fivePriceDisplay.fontSize = removeAds.fontSize * 0.9f;
        self.fivePriceDisplay.position = CGPointMake(fiveHintsButton.position.x - fiveHintsButton.size.width - 5, fiveHintsButton.position.y);
        self.fivePriceDisplay.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        self.fivePriceDisplay.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addChild:self.fivePriceDisplay];
        
        self.fifteenPriceDisplay = [[SKLabelNode alloc] initWithFontNamed:@"Times New Roman"];
        self.fifteenPriceDisplay.text = fifteenHintsPriceStr;
        self.fifteenPriceDisplay.fontColor = fifteenHints.fontColor;
        self.fifteenPriceDisplay.fontSize = removeAds.fontSize * 0.9f;
        self.fifteenPriceDisplay.position = CGPointMake(fifteenHintsButton.position.x - fifteenHintsButton.size.width - 5, fifteenHintsButton.position.y);
        self.fifteenPriceDisplay.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        self.fifteenPriceDisplay.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addChild:self.fifteenPriceDisplay];
        
        self.thirtyPriceDisplay = [[SKLabelNode alloc] initWithFontNamed:@"Times New Roman"];
        self.thirtyPriceDisplay.text = thirtyHintsPriceStr;
        self.thirtyPriceDisplay.fontColor = thirtyHints.fontColor;
        self.thirtyPriceDisplay.fontSize = removeAds.fontSize * 0.9f;
        self.thirtyPriceDisplay.position = CGPointMake(thirtyHintsButton.position.x - thirtyHintsButton.size.width - 5, thirtyHintsButton.position.y);
        self.thirtyPriceDisplay.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        self.thirtyPriceDisplay.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addChild:self.thirtyPriceDisplay];
        
        /////////////////////////////////////////
        
        
        SKShapeNode* centerLine = [SKShapeNode node];
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, self.size.width - distanceFromEdges, (fiveHints.position.y + fifteenHints.position.y) / 2);
        CGPathAddLineToPoint(pathToDraw, NULL, distanceFromEdges, (fiveHints.position.y + fifteenHints.position.y) / 2);
        centerLine.path = pathToDraw;
        [centerLine setStrokeColor:[SKColor whiteColor]];
        [self addChild:centerLine];
        
        SKShapeNode* topLine = [SKShapeNode node];
        CGMutablePathRef pathToDrawTop = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDrawTop, NULL, self.size.width - distanceFromEdges, fiveHintsButton.position.y + fiveHintsButton.size.height/2 + distanceFromEdges);
        CGPathAddLineToPoint(pathToDrawTop, NULL, distanceFromEdges, fiveHintsButton.position.y + fiveHintsButton.size.height/2 + distanceFromEdges);
        topLine.path = pathToDrawTop;
        [topLine setStrokeColor:[SKColor whiteColor]];
        [self addChild:topLine];
        
        SKShapeNode* bottomLine = [SKShapeNode node];
        CGMutablePathRef pathToDrawBottom = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDrawBottom, NULL, self.size.width - distanceFromEdges, thirtyHintsButton.position.y - thirtyHintsButton.size.height/2 - distanceFromEdges);
        CGPathAddLineToPoint(pathToDrawBottom, NULL, distanceFromEdges, thirtyHintsButton.position.y - thirtyHintsButton.size.height/2 - distanceFromEdges);
        bottomLine.path = pathToDrawBottom;
        [bottomLine setStrokeColor:[SKColor whiteColor]];
        [self addChild:bottomLine];
        
        SKShapeNode* secondBottomLine = [SKShapeNode node];
        CGMutablePathRef pathToDrawSecondBottom = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDrawSecondBottom, NULL, distanceFromEdges, (fifteenHintsButton.position.y + thirtyHintsButton.position.y)/2);
        CGPathAddLineToPoint(pathToDrawSecondBottom, NULL, self.size.width - distanceFromEdges, (fifteenHintsButton.position.y + thirtyHintsButton.position.y)/2);
        secondBottomLine.path = pathToDrawSecondBottom;
        [secondBottomLine setStrokeColor:[SKColor whiteColor]];
        [self addChild:secondBottomLine];
        
        SKShapeNode* leftVerticalLine = [SKShapeNode node];
        CGMutablePathRef pathToDrawLeftVertical = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDrawLeftVertical, NULL, distanceFromEdges, thirtyHintsButton.position.y - thirtyHintsButton.size.height/2 - distanceFromEdges);
        CGPathAddLineToPoint(pathToDrawLeftVertical, NULL, distanceFromEdges, fiveHintsButton.position.y + fiveHintsButton.size.height/2 + distanceFromEdges);
        leftVerticalLine.path = pathToDrawLeftVertical;
        [leftVerticalLine setStrokeColor:[SKColor whiteColor]];
        [self addChild:leftVerticalLine];
        
        SKShapeNode* rightVerticalLine = [SKShapeNode node];
        CGMutablePathRef pathToDrawRightVertical = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDrawRightVertical, NULL, self.size.width - distanceFromEdges, fiveHintsButton.position.y + fiveHintsButton.size.height/2 + distanceFromEdges);
        CGPathAddLineToPoint(pathToDrawRightVertical, NULL, self.size.width - distanceFromEdges, thirtyHintsButton.position.y - thirtyHintsButton.size.height/2 - distanceFromEdges);
        rightVerticalLine.path = pathToDrawRightVertical;
        [rightVerticalLine setStrokeColor:[SKColor whiteColor]];
        [self addChild:rightVerticalLine];
    }
    return self;
}

- (void) goBack {
    [super goBack];
    //[self removeActionForKey:self.checkIfCanFetchProductsKey];
    MainMenuScene* back = [[MainMenuScene alloc] initWithSize:self.size viewController:self.viewController];
    [self.view presentScene:back transition:self.sceneTransitionAnimation];
}

/*
- (void) goHome {
    [self removeActionForKey:self.checkIfCanFetchProductsKey];
    [super goHome];
}
*/
 
- (void) displayCannotMakePaymentsMessage {
    UIAlertView* cannotMakePurchases = [[UIAlertView alloc] initWithTitle:@"Cannot Make Purchase" message:@"In-app purchases may be restricted. Please check your settings." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [cannotMakePurchases show];
}

-(BOOL)isNetworkAvailable
{
    char *hostname;
    struct hostent *hostinfo;
    hostname = "google.com";
    hostinfo = gethostbyname (hostname);
    if (hostinfo == NULL){
        NSLog(@"-> no connection\n");
        return NO;
    }
    else{
        NSLog(@"-> active established\n");
        return YES;
    }
}

- (void) updateNumHints{
    self.numHintsLeft.text = [NSString stringWithFormat:@"Hints Remaining: %i",(int)[[NSUserDefaults standardUserDefaults] integerForKey:numberOfHintsKey]];
}

- (void) updatePriceDisplays {
    
    NSString* fiveHintsPriceStr = [[self.viewController productWithPID:productIDFiveHints] priceAsString];
    NSString* fifteenHintsPriceStr = [[self.viewController productWithPID:productIDFifteenHints] priceAsString];
    NSString* thirtyHintsPriceStr = [[self.viewController productWithPID:productIDTwentyFiveHints] priceAsString];
    
    if(fiveHintsPriceStr == nil)
        fiveHintsPriceStr = @"";
    if(fifteenHintsPriceStr == nil)
        fifteenHintsPriceStr = @"";
    if(thirtyHintsPriceStr == nil)
        thirtyHintsPriceStr = @"";
    
    self.fivePriceDisplay.text = fiveHintsPriceStr;
    self.fifteenPriceDisplay.text = fifteenHintsPriceStr;
    self.thirtyPriceDisplay.text = thirtyHintsPriceStr;
}


@end
