//
//  CreditCardControl.h
//  CreditCard
//
//  Created by Mohammed on 7/8/17.
//

#import <UIKit/UIKit.h>

@interface CreditCardControl : UIView

- (NSString*) generateValidCardNumber;
- (BOOL) validateCardNumberOffline:(NSString*) aCardNumber;

@end
