//
//  SKProduct.h
//  Neighbor Tiles
//
//  Created by Varan on 2/16/15.
//
//

#ifndef Neighbor_Tiles_SKProduct_h
#define Neighbor_Tiles_SKProduct_h

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SKProduct (priceAsString)

/**
 * @property priceAsString
 * Localized price of current product.
 */
@property (nonatomic, readonly) NSString *priceAsString;
@end

#endif
