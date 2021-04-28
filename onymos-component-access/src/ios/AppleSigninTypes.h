@interface AppleSigninTypes: NSObject

+ (NSArray<ASAuthorizationScope> *)getAppleAuthScopes: (NSArray<NSNumber *> *)scopes;
+ (ASAuthorizationOpenIDOperation)getAppleAuthOperation: (NSNumber *)operation;

+ (NSDictionary *)getAppleAuthCredential: (ASAuthorizationAppleIDCredential *)credential;

@end
