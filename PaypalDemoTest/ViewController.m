//
//  ViewController.m
//  PaypalDemoTest
//
//  Created by 新雨 on 2017/8/31.
//  Copyright © 2017年 新雨. All rights reserved.
//

#import "ViewController.h"
#import "KIPayPal.h"

#define kDebug 0

#define kPayPalKeyFrorSandbox       @"YourPayPalKey"
#define kPayPalKeyFrorProduction    @"YourPayPalKey"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)paypalAction:(id)sender {
    
    [KIPayPal initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction: kPayPalKeyFrorProduction,PayPalEnvironmentSandbox: kPayPalKeyFrorSandbox}];
    [KIPayPal setPayPalEnvironment:PayPalEnvironmentSandbox];
#if kDebug
#else
    [KIPayPal setPayPalEnvironment:PayPalEnvironmentProduction];
#endif
    PayPalItem *item = [PayPalItem itemWithName:@"iPhone8s"
                                   withQuantity:1
                                      withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", 0.01]]
                                   withCurrency:@"USD"
                                        withSku:[self generateTradeNumber]];
    
    [KIPayPal payPalWithTarget:self
                  merchantName:@"某某公司"
             acceptCreditCards:YES
         shippingAddressOption:PayPalShippingAddressOptionNone
                   payPalItems:@[item]
                      currency:@"USD"
                      shipping:@"0"
                           tax:@"0"
              shortDescription:@"竞拍获得机会"
                         block:^(NSDictionary *result) {
                             if (result == nil) {
                                 return ;
                             }
                             NSDictionary *platform = [result objectForKey:@"response"];
                             NSString *transactionId = [platform objectForKey:@"id"];
                             NSLog(@"支付成功，下一步进行订单支付成功请求发送");
                         }];

}

- (NSString *)generateTradeNumber {
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
