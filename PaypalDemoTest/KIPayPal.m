//
//  KIPayPal.m
//  AlipayDemo
//
//  Created by apple on 15/4/9.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import "KIPayPal.h"

@interface KIPayPal () <PayPalPaymentDelegate>
@property (nonatomic, copy) KIPayCompletionBlock payCompletionBlock;
@end

@implementation KIPayPal

+ (KIPayPal *)sharedInstance {
    static KIPayPal *PAY_PAL = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PAY_PAL = [[KIPayPal alloc] init];
    });
    return PAY_PAL;
}

+ (void)setPayPalEnvironment:(NSString *)environment {
    [PayPalMobile preconnectWithEnvironment:environment];
}

+ (void)initializeWithClientIdsForEnvironments:(NSDictionary *)clientIdsForEnvironments {
    [PayPalMobile initializeWithClientIdsForEnvironments:clientIdsForEnvironments];
}

+ (void)payPalWithTarget:(UIViewController *)viewController
            merchantName:(NSString *)merchantName
       acceptCreditCards:(BOOL)acceptCreditCards
   shippingAddressOption:(PayPalShippingAddressOption)payPalShippingAddressOption
             payPalItems:(NSArray *)payPalItems
                currency:(NSString *)currency
                shipping:(NSString *)shipping
                     tax:(NSString *)tax
        shortDescription:(NSString *)shortDescription
                   block:(KIPayCompletionBlock)block {
    
    PayPalConfiguration *payPalConfiguration = [[PayPalConfiguration alloc] init];
    payPalConfiguration.acceptCreditCards = acceptCreditCards;
    payPalConfiguration.merchantName = merchantName;
    payPalConfiguration.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    payPalConfiguration.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    payPalConfiguration.languageOrLocale = [NSLocale preferredLanguages][0];
    payPalConfiguration.payPalShippingAddressOption = payPalShippingAddressOption;
    
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:payPalItems];
    
    // Optional: include payment details
    NSDecimalNumber *shippingNumber = [[NSDecimalNumber alloc] initWithString:shipping];
    NSDecimalNumber *taxNumber = [[NSDecimalNumber alloc] initWithString:tax];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shippingNumber
                                                                                    withTax:taxNumber];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shippingNumber] decimalNumberByAdding:taxNumber];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = currency;
    payment.shortDescription = shortDescription;
    payment.items = payPalItems;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails;
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }

    [[KIPayPal sharedInstance] setPayCompletionBlock:block];
    [[KIPayPal sharedInstance] showPaymentViewControllerWithTarget:viewController
                                                           payment:payment
                                                     configuration:payPalConfiguration];
}

+ (PayPalItem *)payPalItemWithName:(NSString *)name
                          quantity:(NSUInteger)quantity
                             price:(NSString *)price
                          currency:(NSString *)currency
                               sku:(NSString *)sku {
    PayPalItem *item = [PayPalItem itemWithName:name
                                   withQuantity:quantity
                                      withPrice:[NSDecimalNumber decimalNumberWithString:price]
                                   withCurrency:currency
                                        withSku:sku];
    return item;
}

- (void)showPaymentViewControllerWithTarget:(UIViewController *)target
                                    payment:(PayPalPayment *)payment
                              configuration:(PayPalConfiguration *)configuration {
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:configuration
                                                                                                     delegate:self];
    [target presentViewController:paymentViewController animated:YES completion:nil];
}

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    if (self.payCompletionBlock != nil) {
        self.payCompletionBlock(completedPayment.confirmation);
    }
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    if (self.payCompletionBlock != nil) {
        self.payCompletionBlock(nil);
    }
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
