//
//  OtherScene.m
//  Pattern Matching
//
//  Created by Varan on 2/5/15.
//
//

#import "OtherScene.h"
#import "MainMenuScene.h"
#import "SKLabelButton.h"
#import "CreditsScene.h"
#include <netdb.h>

@implementation OtherScene

- (instancetype) initWithSize:(CGSize)size viewController:(ViewController *)viewController{
    self = [super initWithSize:size backButton:YES homeButton:YES sfxButton:YES musicButton:YES viewController:viewController];
    
    if(self) {
        __weak OtherScene* weakSelf = self;
        
        SKAction* actionRate = [SKAction runBlock:^{            
            NSString* iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";
            NSString* iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d";
            
            NSURL* rateURL = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, APP_STORE_ID]];
            
            [[UIApplication sharedApplication] openURL:rateURL];
        }];
        SKLabelButton* rateButton = [[SKLabelButton alloc] initWithFontNamed:@"Menlo-bold" text:@"Review App" defaultColor:[SKColor whiteColor] selectedColor:self.selectedColor name:@"rateButton" action:actionRate];
        rateButton.position = CGPointMake(self.size.width/2, self.size.height * 4/10);
        
        SKAction* actionCredits = [SKAction runBlock:^{
            CreditsScene* scene = [[CreditsScene alloc] initWithSize:weakSelf.size viewController:weakSelf.viewController];
            [weakSelf.view presentScene:scene transition:weakSelf.sceneTransitionAnimation];
        }];
        SKLabelButton* credits = [[SKLabelButton alloc] initWithFontNamed:@"Menlo-Bold" text:@"About" defaultColor:[SKColor whiteColor] selectedColor:self.selectedColor name:@"creditsButton" action:actionCredits soundEffectName:@"buttonTapSound2" withExtension:@"wav"];
        credits.position = CGPointMake(self.size.width/2, self.size.height * 6/10);
        
        SKAction* actionContact = [SKAction runBlock:^{
            
            if([MFMailComposeViewController canSendMail])
                [weakSelf.viewController sendMail];
            else {
                if([self isNetworkAvailable]) {
                    UIAlertView* cannotSendMail = [[UIAlertView alloc] initWithTitle:@"Unable To Send Mail" message:@"Please make sure your email account is set up." delegate:weakSelf cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [cannotSendMail show];
                }else {
                    [weakSelf.viewController displayCheckInternetMessage];
                }
            }
        }];
        SKLabelButton* contactButton = [[SKLabelButton alloc] initWithFontNamed:@"Menlo-bold" text:@"Contact" defaultColor:[SKColor whiteColor] selectedColor:self.selectedColor name:@"contactButton" action:actionContact];
        contactButton.position = CGPointMake(self.size.width/2, self.size.height * 5/10);
        
        [self addChild:contactButton];
        [self addChild:rateButton];
        [self addChild:credits];
    }
    return self;
}

- (void) goBack {
    MainMenuScene* back = [[MainMenuScene alloc] initWithSize:self.size viewController:self.viewController];
    [self.view presentScene:back transition:self.sceneTransitionAnimation];
}

- (BOOL)isNetworkAvailable
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
        NSLog(@"-> active connection\n");
        return YES;
    }
}

@end
