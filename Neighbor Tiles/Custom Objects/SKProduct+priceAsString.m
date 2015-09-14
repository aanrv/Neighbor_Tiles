//
//  SKProduct+priceAsString.m
//  Neighbor Tiles
//
//  Created by Varan on 2/16/15.
//
//

#import "SKProduct+priceAsString.h"

@implementation SKProduct (priceAsString)

- (NSString *) priceAsString
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[self priceLocale]];
    
    NSString *str = [formatter stringFromNumber:[self price]];
    return str;
}

@end

