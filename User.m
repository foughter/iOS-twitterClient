//
//  User.m
//  Twitter
//
//  Created by Li Li on 7/5/14.
//  Copyright (c) 2014 Li Li. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

@implementation User

static BDBOAuthToken* accessToken = nil;

+ (void) setAccessToken: (BDBOAuthToken*)token{
    if (token == nil)
        return;
    
    NSLog(@"setting AccessToken");
    accessToken  = token;
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject: token];
    NSDictionary* currentUserDict = [NSDictionary dictionaryWithObject:data forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:currentUserDict];
}

+ (BDBOAuthToken*) getAcessToken{
    if (accessToken == nil){
        NSLog(@"access token empty");
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
        if (data){
            NSLog(@"getting new access token");
            accessToken = (BDBOAuthToken*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    else NSLog(@"access token already exists");
    return accessToken;
}

@end
