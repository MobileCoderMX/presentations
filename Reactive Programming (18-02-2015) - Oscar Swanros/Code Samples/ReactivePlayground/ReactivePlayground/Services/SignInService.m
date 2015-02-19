//
//  SignInService.m
//  ReactivePlayground
//
//  Created by Oscar Swanros on 17/02/15.
//  Copyright (c) 2015 MobileCoder. All rights reserved.
//

#import "SignInService.h"

static NSString *const kUserName = @"oscarswanros";
static NSString *const kPassword = @"123123123";

@implementation SignInService

+ (void)signInWithUsername:(NSString *)username andPassword:(NSString *)password withBlock:(void (^)(BOOL success))block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (block) {
            block([username isEqualToString:kUserName] && [password isEqualToString:kPassword]);
        }
    });
}

@end
