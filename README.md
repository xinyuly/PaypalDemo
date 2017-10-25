# PaypalDemo
集成PayPal支付，快速接入使用

## 使用方法

1.在需要的地方导入：**#import "KIPayPal.h"**

2.使用

```
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

```