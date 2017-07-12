//
//  ViewController.m
//  CreditCard
//
//  Created by Mohammed on 7/8/17.
//

#import "ViewController.h"
#import "CreditCardControl.h"

@interface ViewController ()

@property CreditCardControl *testControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _testControl = [[CreditCardControl alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _testControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _testControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_testControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
