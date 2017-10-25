//
//  KIPayPal.h
//  AlipayDemo
//
//  Created by apple on 15/4/9.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayPalMobile.h"

typedef void(^KIPayCompletionBlock)(NSDictionary *result);

@interface KIPayPal : NSObject

// Production (default): Normal, live environment. Real money gets moved.
// This environment MUST be used for App Store submissions.
//extern NSString *const PayPalEnvironmentProduction;
// Sandbox: Uses the PayPal sandbox for transactions. Useful for development.
//extern NSString *const PayPalEnvironmentSandbox;
// NoNetwork: Mock mode. Does not submit transactions to PayPal. Fakes successful responses. Useful for unit tests.
//extern NSString *const PayPalEnvironmentNoNetwork;

+ (void)setPayPalEnvironment:(NSString *)environment;

+ (void)initializeWithClientIdsForEnvironments:(NSDictionary *)clientIdsForEnvironments;

+ (void)payPalWithTarget:(UIViewController *)viewController
            merchantName:(NSString *)merchantName
       acceptCreditCards:(BOOL)acceptCreditCards
   shippingAddressOption:(PayPalShippingAddressOption)payPalShippingAddressOption
             payPalItems:(NSArray *)payPalItems
                currency:(NSString *)currency
                shipping:(NSString *)shipping
                     tax:(NSString *)tax
        shortDescription:(NSString *)shortDescription
                   block:(KIPayCompletionBlock)block;

+ (PayPalItem *)payPalItemWithName:(NSString *)name
                          quantity:(NSUInteger)quantity
                             price:(NSString *)price
                          currency:(NSString *)currency
                               sku:(NSString *)sku;

@end
