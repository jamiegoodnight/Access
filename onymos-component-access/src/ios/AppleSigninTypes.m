#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>

#import "AppleSigninTypes.h"


static inline id NilToNull(id value) { return value == nil ? [NSNull null] : value; }


@implementation AppleSigninTypes

+ (NSArray<ASAuthorizationScope> *)getAppleAuthScopes: (NSArray<NSNumber *> *)scopes
{
	NSMutableArray<ASAuthorizationScope> *appleScopes = [NSMutableArray array];
	
	for (NSNumber *scope in scopes) {

		ASAuthorizationScope appleScope = [self getAppleScope:scope];

		if (appleScope != nil) {
			[appleScopes addObject:appleScope];
		}
	}
	
	return appleScopes;
}

+ (ASAuthorizationScope)getAppleScope: (NSNumber *)scope
{
	switch (scope.integerValue) {

		case 0:
			return ASAuthorizationScopeEmail;

		case 1:
			return ASAuthorizationScopeFullName;

		default:
			return nil;
	}
}

+ (ASAuthorizationOpenIDOperation)getAppleAuthOperation: (NSNumber *)operation
{
	switch (operation.integerValue) {

		case 0:
			return ASAuthorizationOperationImplicit;

		case 1:
			return ASAuthorizationOperationLogin;

		case 2:
			return ASAuthorizationOperationLogout;

		case 3:
			return ASAuthorizationOperationRefresh;
			
		default:
			return nil;
	}
}

+ (NSDictionary *)getAppleAuthCredential: (ASAuthorizationAppleIDCredential *)credential
{
	return @{
		@"user": credential.user,
		@"authorizedScopes": [self convertAppleAuthScopesToNums:credential.authorizedScopes],
		@"state": NilToNull(credential.state),
		@"authorizationCode": [self getUTF8:credential.authorizationCode],
		@"identityToken": [self getUTF8:credential.identityToken],
		@"email": NilToNull(credential.email),
		@"fullName": NilToNull([AppleSigninTypes getNameDictionary:credential.fullName]),
		@"realUserStatus": @(credential.realUserStatus)
	};
}

+ (NSArray<NSNumber *> *)convertAppleAuthScopesToNums: (NSArray<ASAuthorizationScope> *)authorizedScopes
{
	NSMutableArray<NSNumber *> *scopeVals = [NSMutableArray array];
	
	for (ASAuthorizationScope authorizedScope in authorizedScopes) {

		NSNumber *scopeVal = [self getNumForAppleScope:authorizedScope];
		if (scopeVal != nil) {
			[scopeVals addObject:scopeVal];

		}
	}
	
	return scopeVals;
}

+ (NSNumber *)getNumForAppleScope: (ASAuthorizationScope)authorizedScope
{
	if (authorizedScope == ASAuthorizationScopeEmail) {
		return @0;

	} else if (authorizedScope == ASAuthorizationScopeFullName) {
		return @1;

	} else {
		return nil;
		
	}
}

+ (NSDictionary<NSString *, id> *)getNameDictionary:(NSPersonNameComponents *)name
{
	if (name == nil) return nil;
	
	return @{
		@"namePrefix": NilToNull(name.namePrefix),
		@"givenName": NilToNull(name.givenName),
		@"middleName": NilToNull(name.middleName),
		@"familyName": NilToNull(name.familyName),
		@"nameSuffix": NilToNull(name.nameSuffix),
		@"nickname": NilToNull(name.nickname)
	};
}

+ (NSString *)getUTF8: (NSData *)data
{
	if (data == nil) return nil;
	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
