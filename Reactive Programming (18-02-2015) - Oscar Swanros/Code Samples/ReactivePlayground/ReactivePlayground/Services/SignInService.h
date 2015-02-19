//
//  SignInService.h
//  ReactivePlayground
//
//  Created by Oscar Swanros on 17/02/15.
//  Copyright (c) 2015 MobileCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignInService : NSObject

+ (void)signInWithUsername:(NSString *)username andPassword:(NSString *)password withBlock:(void (^)(BOOL success))block;

@end
