//
//  CreditCardControl.m
//  CreditCard
//
//  Created by Mohammed on 7/8/17.
//

#import "CreditCardControl.h"

#define kCardNumberTextFieldTag 1
#define kCardDateTextFieldTag   2
#define kCardCodeTextFieldTag   3

@interface CreditCardControl () <UITextFieldDelegate>

@property UITextField *numberField;
@property UITextField *expireDateField;
@property UITextField *cvcField;
@property UILabel *validLabel;
@property UIButton *validateButton;
@property UIButton *generateButton;

@end

@implementation CreditCardControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        _cvcField = [[UITextField alloc] init];
        _cvcField.tag = kCardCodeTextFieldTag;
        _cvcField.placeholder = @"CVC";
        _cvcField.delegate = self;
        _cvcField.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_cvcField];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_cvcField(==40)]-|" options:0 metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_cvcField)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_cvcField(==24)]" options:0 metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_cvcField)]];
        
        _expireDateField = [[UITextField alloc] init];
        _expireDateField.tag = kCardDateTextFieldTag;
        _expireDateField.placeholder = @"MM/YY";
        _expireDateField.delegate = self;
        _expireDateField.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_expireDateField];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_expireDateField(==60)]-[_cvcField]" options:0 metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_expireDateField, _cvcField)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_expireDateField(==24)]" options:0 metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_expireDateField)]];
        
        _numberField = [[UITextField alloc] init];
        _numberField.tag = kCardNumberTextFieldTag;
        _numberField.placeholder = @"1234 1234 1234 1234";
        _numberField.delegate = self;
        _numberField.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_numberField];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_numberField]-8-[_expireDateField]" options:0 metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_numberField, _expireDateField)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_numberField(==24)]" options:0 metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_numberField)]];
        
        _validLabel = [[UILabel alloc] init];
        _validLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _validLabel.textAlignment = NSTextAlignmentCenter;
        _validLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_validLabel];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_validLabel]-8-|" options:0 metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_validLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_numberField]-32-[_validLabel(==24)]" options:0 metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_numberField, _validLabel)]];
        
        _validateButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _generateButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _validateButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_validateButton setTitle:NSLocalizedString(@"Validate", @"") forState:UIControlStateNormal];
        [self addSubview:_validateButton];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_validateButton]-8-|" options:0 metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_validateButton)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_validLabel]-32-[_validateButton]" options:0 metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_validLabel, _validateButton)]];
        [_validateButton addTarget:self action:@selector(onValidate) forControlEvents:UIControlEventTouchUpInside];
        
        _generateButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_generateButton setTitle:NSLocalizedString(@"Generate", @"") forState:UIControlStateNormal];
        [self addSubview:_generateButton];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_generateButton]-8-|" options:0 metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_generateButton)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_validateButton]-8-[_generateButton]" options:0 metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_validateButton, _generateButton)]];
        [_generateButton addTarget:self action:@selector(onGenerate) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (BOOL) textField:(UITextField*) aTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*) aString
{
    switch (aTextField.tag)
    {
        case kCardNumberTextFieldTag:
        {
            // We're assuming 16 digit cards here, so MasterCard and VISA for example
            int actualDigitCount = [aTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length;
            if (actualDigitCount % 4 == 0 && ![aString isEqualToString:@""])
            {
                if (actualDigitCount >= 16) {
                    return NO;
                }
                
                NSString *appendedText = [aTextField.text stringByAppendingString:@" "];
                aTextField.text = appendedText;
            }
            break;
        }
        case kCardDateTextFieldTag:
        {
            if (aTextField.text.length >= 5 && ![aString isEqualToString:@""])
                return NO;
            break;
        }
        case kCardCodeTextFieldTag:
        {
            if (aTextField.text.length >= 3 && ![aString isEqualToString:@""])
                return NO;
            break;
        }
        default:
            break;
    }
    
    
    return YES;
}

- (void) onValidate
{
    [self validateCardNumberOnline:[_numberField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
}

- (void) onGenerate
{
    NSString *randomNumber = [self generateValidCardNumber];
    _numberField.text = randomNumber;
}

- (void) validateCardNumberOnline:(NSString*) aCardNumber
{
    NSString *serviceUrl = @"https://api.bincodes.com/cc/?format=json";
    NSString *apiKey = @"5232a9bca11e25c0f8eb4313ff2644be";
    
    NSString *url = [NSString stringWithFormat:@"%@&api_key=%@&cc=%@", serviceUrl, apiKey, aCardNumber];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                _validLabel.text = NSLocalizedString(@"Service Error", @"");
            });
        }
        else
        {
            NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@",json);
            if (json[@"error"] != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _validLabel.text = json[@"message"];
                });
            }
            else
            {
                // I'm unable to finish this because the provided API key is no longer valid, and I'm still waiting on mine 
                // TODO - Check the result and set "validLabel.text"
            }
        }
    }];
    [dataTask resume];
}

- (NSString*) generateValidCardNumber
{
    BOOL validNumberFound = false;
    while (!validNumberFound)
    {
        int randomFirst = arc4random() % 9000 + 1000;
        int randomSecond = arc4random() % 9000 + 1000;
        int randomThird = arc4random() % 9000 + 1000;
        int randomFourth = arc4random() % 9000 + 1000;
        
        if ([self validateCardNumberOffline:[NSString stringWithFormat:@"%d%d%d%d", randomFirst, randomSecond, randomThird, randomFourth]]) {
            return [NSString stringWithFormat:@"%d %d %d %d", randomFirst, randomSecond, randomThird, randomFourth];
        }
    }
    return nil;
}

// Luhn algorithm
// https://en.wikipedia.org/wiki/Luhn_algorithm
//
- (BOOL) validateCardNumberOffline:(NSString*) aCardNumber
{
    const int asciiZero = 48;
    int luhnSum = 0;
    
    for (int i=0; i < aCardNumber.length; i++)
    {
        int count = aCardNumber.length - 1;
        int doubled = [[NSNumber numberWithUnsignedChar:[aCardNumber characterAtIndex:count-i]] intValue] - asciiZero;
        if (i % 2) {
            doubled = doubled * 2;
        }
        
        NSString *twoDigits = [NSString stringWithFormat:@"%d", doubled];
        
        if ([NSString stringWithFormat:@"%d",doubled].length > 1)
        {   luhnSum = luhnSum + [[NSNumber numberWithUnsignedChar:[twoDigits characterAtIndex:0]] intValue] - asciiZero;
            luhnSum = luhnSum + [[NSNumber numberWithUnsignedChar:[twoDigits characterAtIndex:1]] intValue] - asciiZero;
        }
        else
        {
            luhnSum = luhnSum + doubled;
        }
    }
    
    // If the remainder of the sum is zero, then we have a valid (fake!) card number
    if (luhnSum % 10 == 0)
        return true;
    else
        return false;
}

@end
