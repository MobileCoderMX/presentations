//
//  LoginViewController.m
//  ReactivePlayground
//
//  Created by Oscar Swanros on 16/02/15.
//  Copyright (c) 2015 MobileCoder. All rights reserved.
//

#import "LoginViewController.h"

#import "SignInService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LoginViewController ()
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    
    RACSignal *usernameTextSignal = self.usernameTextField.rac_textSignal;
    RACSignal *passwordTextSignal = self.passwordTextField.rac_textSignal;
    
    RACSignal *validUsernameSignal = [[usernameTextSignal map:^id(NSString *username) {
        return @([self isValidUsername:username]);
    }] distinctUntilChanged];
    RACSignal *validPasswordSignal = [[passwordTextSignal map:^id(NSString *password) {
        return @([self isValidPassword:password]);
    }] distinctUntilChanged];
    
    RAC(self.usernameTextField, backgroundColor) = [validUsernameSignal map:^id(NSNumber *usernameValid) {
        return [usernameValid boolValue] ? [UIColor greenColor] : [UIColor redColor];
    }];
    RAC(self.passwordTextField, backgroundColor) = [validPasswordSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue] ? [UIColor greenColor] : [UIColor redColor];
    }];
    
    [[RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal]
                       reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
                           return @([usernameValid boolValue] == YES && [passwordValid boolValue] == YES);
                       }] subscribeNext:^(NSNumber *loginButtonActive) {
                           self.loginButton.enabled = [loginButtonActive boolValue];
                       }];
    

    [[[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        return [self signInSignal];
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (RACSignal *)signInSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [SignInService signInWithUsername:self.usernameTextField.text
                              andPassword:self.passwordTextField.text
                                withBlock:^(BOOL success) {
                                    [subscriber sendNext:@(success)];
                                    [subscriber sendCompleted];
                                }];
        
        return nil;
    }];
}

- (void)setUpUI
{
    self.title = @"Sign in";
    
    [self.view addSubview:self.usernameTextField];
    [self.view addConstraints:[self usernameTextFieldConstraints]];
    
    [self.view addSubview:self.passwordTextField];
    [self.view addConstraints:[self passwordTextFieldConstraints]];
    
    [self.view addSubview:self.loginButton];
    [self.view addConstraints:[self loginButtonConstraints]];
}


#pragma mark - Validations

- (BOOL)isValidUsername:(NSString *)username
{
    return username.length > 5;
}

- (BOOL)isValidPassword:(NSString *)password
{
    return [self isValidUsername:password];
}


#pragma mark - Getters

- (UITextField *)usernameTextField
{
    if (!_usernameTextField) {
        _usernameTextField = [[UITextField alloc] init];
        _usernameTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _usernameTextField.backgroundColor = [UIColor redColor];
        _usernameTextField.placeholder = @"Username";
        _usernameTextField.textAlignment = NSTextAlignmentCenter;
    }
    
    return _usernameTextField;
}

- (UITextField *)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _passwordTextField.backgroundColor = [UIColor redColor];
        _passwordTextField.placeholder = @"Password";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.textAlignment = NSTextAlignmentCenter;
    }
    
    return _passwordTextField;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        _loginButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_loginButton setTitle:@"Log in" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        [_loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    }
    
    return _loginButton;
}


#pragma mark - UI Constraints

- (NSArray *)usernameTextFieldConstraints
{
    NSMutableArray *constraints = [NSMutableArray new];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.usernameTextField
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:74]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.usernameTextField
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:50]];
    
    
    [constraints addObjectsFromArray:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:|-16-[_usernameTextField]-16-|"
                                      options:0
                                      metrics:nil
                                      views:NSDictionaryOfVariableBindings(_usernameTextField)]];
    
    return constraints;
}

- (NSArray *)passwordTextFieldConstraints
{
    NSMutableArray *constraints = [NSMutableArray new];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.passwordTextField
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.usernameTextField
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0
                                                         constant:10]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.passwordTextField
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.usernameTextField
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.0
                                                         constant:1.0]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[_passwordTextField]-16-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_passwordTextField)]];
    
    return constraints;
}

- (NSArray *)loginButtonConstraints
{
    NSMutableArray *constraints = [NSMutableArray new];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.loginButton
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.passwordTextField
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0
                                                         constant:30]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.loginButton
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:30]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_loginButton]-30-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_loginButton)]];
    
    return constraints;
}

@end
