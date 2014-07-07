//
//  User.h
//  Twitter
//
//  Created by Li Li on 7/5/14.
//  Copyright (c) 2014 Li Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDBOAuth1RequestOperationManager.h"

@interface User : NSObject

+ (void) setAccessToken: (BDBOAuthToken*)token;
+ (BDBOAuthToken*) getAcessToken;

@end
